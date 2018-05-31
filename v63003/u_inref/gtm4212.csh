#!/usr/local/bin/tcsh -f
#################################################################
#								#
# Copyright (c) 2018 YottaDB LLC. and/or its subsidiaries.	#
# All rights reserved.						#
#								#
#	This source code contains the intellectual property	#
#	of its copyright holder(s), and is made available	#
#	under a license.  If you do not know the terms of	#
#	the license, please stop and do not read further.	#
#								#
#################################################################
#
#
#

echo "# Generating a path 249 characters long"
$ydb_dist/mumps -run gtm4212
set p = `cat temp.out`
mkdir -p $p

echo "# Creating Directory"
$gtm_tst/com/dbcreate.csh mumps 1 >>& dbcreate1.out
echo "# Backing up Directory"
$MUPIP BACKUP "DEFAULT" $p

