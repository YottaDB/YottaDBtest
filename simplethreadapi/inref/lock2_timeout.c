/****************************************************************
 *								*
 * Copyright (c) 2018-2019 YottaDB LLC and/or its subsidiaries. *
 * All rights reserved.						*
 *								*
 *	This source code contains the intellectual property	*
 *	of its copyright holder(s), and is made available	*
 *	under a license.  If you do not know the terms of	*
 *	the license, please stop and do not read further.	*
 *								*
 ****************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>	/* for "fork" */
#include <sys/wait.h>	/* for "waitpid" prototype */
#include <time.h>	/* for "time" prototype */
#include <errno.h>	/* for "errno" */

#include "libyottadb.h"
#include "libydberrors.h"       /* for YDB_LOCK_TIMEOUT */

#define LOCK2		"^lock2"
#define SUBS		"42"
#define	LOCK_TIMEOUT	(unsigned long long)1000000000	/* 1 * 10^9 nanoseconds == 1 second */

#define ERRBUF_SIZE	1024

ydb_buffer_t	lock2;

void	childfn(void);

int main()
{
	ydb_buffer_t	subs;
	int		status, stat, ret;
	char		errbuf[ERRBUF_SIZE];
	unsigned int	ret_dlrdata;
	pid_t		child_pid;
	time_t		begin, end;
	int		save_errno;

	YDB_LITERAL_TO_BUFFER(LOCK2, &lock2);
	YDB_LITERAL_TO_BUFFER(SUBS, &subs);

	printf("### Test timeout in ydb_lock_st() and ydb_lock_incr_st() works correctly ###\n"); fflush(stdout);

	printf("First lock ^lock2 in child\n"); fflush(stdout);
	child_pid = fork();
	YDB_ASSERT(0 <= child_pid);
	if (0 == child_pid)
	{
		childfn();	/* this is the child */
		return YDB_OK;
	}
	printf("Wait for child to have done LOCK ^lock2\n"); fflush(stdout);
	for ( ; ;)
	{
		status = ydb_data_st(YDB_NOTTP, NULL, &lock2, 0, NULL, &ret_dlrdata);
		if (ret_dlrdata)
			break;
		usleep(1);
	}

	printf("Attempt to lock ^lock2(42) in parent : Expect YDB_LOCK_TIMEOUT error\n"); fflush(stdout);
	begin = time(NULL);
	status = ydb_lock_st(YDB_NOTTP, NULL, LOCK_TIMEOUT, 1, &lock2, 0, &subs);
	end = time(NULL);
	YDB_ASSERT(YDB_LOCK_TIMEOUT == status);
	if (2 < (end - begin))
	{
		printf("Lock timeout test failed for ydb_lock_st() : Timeout expected = 1 or 2 seconds."
			" Actual timeout = %d seconds\n", (int)(end - begin)); fflush(stdout);
	} else
	{
		printf("Lock timeout test PASSED for ydb_lock_st() : Timeout expected = 1 or 2 seconds."
			" Actual timeout = 1 or 2 seconds\n"); fflush(stdout);
	}

	printf("Attempt to lock +^lock2(42) in parent : Expect YDB_LOCK_TIMEOUT error\n"); fflush(stdout);
	begin = time(NULL);
	status = ydb_lock_incr_st(YDB_NOTTP, NULL, LOCK_TIMEOUT, &lock2, 0, &subs);
	end = time(NULL);
	YDB_ASSERT(YDB_LOCK_TIMEOUT == status);
	if (2 < (end - begin))
	{
		printf("Lock timeout test failed for ydb_lock_incr_st() : Timeout expected = 1 or 2 seconds."
			" Actual timeout = %d seconds\n", (int)(end - begin)); fflush(stdout);
	} else
	{
		printf("Lock timeout test PASSED for ydb_lock_incr_st() : Timeout expected = 1 or 2 seconds."
			" Actual timeout = 1 or 2 seconds\n"); fflush(stdout);
	}

	/* Signal child to die */
	status = ydb_delete_st(YDB_NOTTP, NULL, &lock2, 0, NULL, YDB_DEL_NODE);
	YDB_ASSERT(YDB_OK == status);

	/* Wait for child to terminate */
	do
	{
		ret = waitpid(child_pid, &stat, 0);
		save_errno = errno;
	} while ((-1 == ret) && (EINTR == save_errno));
	YDB_ASSERT(-1 != ret);

	return YDB_OK;
}

void	childfn(void)
{
	int		status;
	unsigned int	ret_dlrdata;

	/* First lock ^lock2 */
	status = ydb_lock_st(YDB_NOTTP, NULL, LOCK_TIMEOUT, 1, &lock2, 0, NULL);
	YDB_ASSERT(YDB_OK == status);

	/* Next set ^lock2=1 so parent knows it can proceed to attempt lock ^lock2(42) */
	status = ydb_set_st(YDB_NOTTP, NULL, &lock2, 0, NULL, NULL);

	/* Wait for parent to be done */
	for ( ; ;)
	{
		status = ydb_data_st(YDB_NOTTP, NULL, &lock2, 0, NULL, &ret_dlrdata);
		if (!ret_dlrdata)
			break;
		usleep(1);
	}
	return;
}

