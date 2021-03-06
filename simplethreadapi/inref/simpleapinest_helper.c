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

#include "libyottadb.h"
#include "libydberrors.h"	/* for YDB_ERR_SIMPLEAPINEST */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ERRBUF_SIZE	1024

#define BASEVAR "^basevar"
#define VALUE1	"value"

char		errbuf[ERRBUF_SIZE];
ydb_buffer_t	basevar, value1, badbasevar;

int simpleapinest_helper(void);

int simpleapinest_ci(void);

#define	CHECK_STATUS(status)					\
{								\
	YDB_ASSERT(YDB_ERR_SIMPLEAPINEST == status);		\
	if (YDB_OK != status)					\
	{							\
		ydb_zstatus(errbuf, ERRBUF_SIZE);		\
		printf("[Line %d]: %s\n", __LINE__, errbuf);	\
		fflush(stdout);					\
	}							\
}

int simpleapinest_helper(void)
{
	int		status;
	unsigned int	data_value;
	int		dst_used;

	printf("# In external call C program. Now try ydb_*_st() calls to try SIMPLEAPINEST error#\n"); fflush(stdout);

	YDB_LITERAL_TO_BUFFER(BASEVAR, &basevar);
	YDB_LITERAL_TO_BUFFER(VALUE1, &value1);

	status = ydb_set_st(YDB_NOTTP, NULL, &basevar, 0, NULL, &value1); CHECK_STATUS(status);
	status = ydb_get_st(YDB_NOTTP, NULL, &basevar, 0, NULL, &value1); CHECK_STATUS(status);
	status = ydb_data_st(YDB_NOTTP, NULL, &basevar, 0, NULL, &data_value); CHECK_STATUS(status);
	status = ydb_subscript_next_st(YDB_NOTTP, NULL, &basevar, 0, NULL, &value1); CHECK_STATUS(status);
	status = ydb_subscript_previous_st(YDB_NOTTP, NULL, &basevar, 0, NULL, &value1); CHECK_STATUS(status);
	status = ydb_node_next_st(YDB_NOTTP, NULL, &basevar, 0, NULL, &dst_used, &value1); CHECK_STATUS(status);
	status = ydb_node_previous_st(YDB_NOTTP, NULL, &basevar, 0, NULL, &dst_used, &value1); CHECK_STATUS(status);
	status = ydb_lock_decr_st(YDB_NOTTP, NULL, &basevar, 0, NULL); CHECK_STATUS(status);
	status = ydb_lock_incr_st(YDB_NOTTP, NULL, 1000000, &basevar, 0, NULL); CHECK_STATUS(status);
	status = ydb_lock_st(YDB_NOTTP, NULL, 1000000, 0); CHECK_STATUS(status);
	status = ydb_tp_st(YDB_NOTTP, NULL, (ydb_tp2fnptr_t)NULL, NULL, NULL, 0, NULL); CHECK_STATUS(status);
	status = ydb_delete_st(YDB_NOTTP, NULL, &basevar, 0, NULL, YDB_DEL_NODE); CHECK_STATUS(status);
	status = ydb_incr_st(YDB_NOTTP, NULL, &basevar, 0, NULL, NULL, &value1); CHECK_STATUS(status);
	status = ydb_delete_excl_st(YDB_NOTTP, NULL, 0, NULL); CHECK_STATUS(status);
	status = ydb_zwr2str_st(YDB_NOTTP, NULL, NULL, NULL); CHECK_STATUS(status);
	status = ydb_str2zwr_st(YDB_NOTTP, NULL, NULL, NULL); CHECK_STATUS(status);
	return status;
}

int simpleapinest_ci(void)
{
	int			status, n;
	ci_name_descriptor	callin;

	callin.rtn_name.address = ("simpleapinestci");
	callin.rtn_name.length = strlen(callin.rtn_name.address);
	callin.handle = NULL;

	printf("# In external call C program. Now randomly try ydb_ci_t() or ydb_cip_t() call #\n"); fflush(stdout);

	srand(time(NULL));
	n = rand() % 2;

	if (n == 0)
	{
		status = ydb_ci_t(YDB_NOTTP, NULL, "simpleapinestci");
		if (YDB_ERR_CIMAXLEVELS == status)
		{
			printf("Max CI levels reached\n");
			fflush(stdout);
			return status;
		}
	} else
	{
		status = ydb_cip_t(YDB_NOTTP, NULL, &callin);
		if (YDB_ERR_CIMAXLEVELS == status)
		{
			printf("Max CI levels reached\n");
			fflush(stdout);
			return status;
		}
	}
	return status;
}
