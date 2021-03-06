/****************************************************************
 *								*
 * Copyright (c) 2015 Fidelity National Information 		*
 * Services, Inc. and/or its subsidiaries. All rights reserved.	*
 *								*
 * Copyright (c) 2018-2020 YottaDB LLC and/or its subsidiaries.	*
 * All rights reserved.						*
 *								*
 *	This source code contains the intellectual property	*
 *	of its copyright holder(s), and is made available	*
 *	under a license.  If you do not know the terms of	*
 *	the license, please stop and do not read further.	*
 *								*
 ****************************************************************/

#include "mdef.h"

#include "gtm_stdio.h"
#include "gtm_stdlib.h"
#include "gtm_string.h"

#include "cli.h"
#include "compiler.h"
#include "nametabtyp.h"
#include "funsvn.h"

LITREF nametabent svn_names[];
LITREF unsigned char svn_index[];
LITREF svn_data_type svn_data[];

#define zysqlnull	"ZYSQLNULL"
#define zysqlnull_len	(sizeof(zysqlnull) - 1)

int main( int argc, char *argv[])
{
	int	i;
	int	totalsvns = (int)svn_index[26] - 1;		/* We don't want $ZYSQLNULL in this list */

	/* Setup the top label, insert sstep for debugging, define error count as zero */
	printf("svndump\n\tdo:0 ^sstep\n\tset error=0\n");
	/* Intentionally do a failing zcompile to set $zc */
	printf("\tdo\n\t. new $etrap set $etrap=\"set $ecode=\"\"\"\"\"\n\t. zcompile \"nosuchrtn.m\"\n");
	/* Setup ^incretrap without globals or it will fail while trying to accesss globals */
	printf("\tdo nogbls^incretrap\n\tset incretrap(\"INTRA\")=\"if $increment(error) set $ecode=\"\"\"\"\"\n");
	printf("\tset $etrap=\"do ^incretrap\"\n");
	/* Iterate over all the names and print them out */
	for (i = 0; i < totalsvns; i++)
	{
		if ((svn_names[i].len == zysqlnull_len) && (0 == memcmp(svn_names[i].name, zysqlnull, zysqlnull_len)))
			continue;				/* Ignoring $ZYSQLNULL as by definition it has no value */
		if (svn_data[i].os_syst & UNIX_OS)
		{
			printf("\tset svn=$$strip(\"$%s\"),val=$$pull(svn) write svn,\"=\",$$enq(val),?48 zwrite @svn\n",
					svn_names[i].name);
		}
	}
	printf("\twrite !\tzhalt error\n");
	/* svn_names[] entries (as defined in expritem.c) may have a trailing asterisk, strip that in MUMPS */
	printf("strip(svn)\n quit $translate(svn,\"*\")\n");
	/* op_svget the ISV */
	printf("pull(svn)\n xecute \"set val=\"_svn\n quit val\n");
	/* Place val in quotation marks if necessary */
	printf("enq(val)\n quit:+val val\n quit:\"0\"=val val\n quit $char(34)_val_$char(34)\n");
	exit(0);
}
