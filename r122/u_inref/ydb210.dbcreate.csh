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
	#some of these variables are form older tests and may be outdated
#setenv test_specific_gde $gtm_tst/$tst/inref/ydb210.gde

$gtm_tst/com/dbcreate.csh mumps 2 >& dbcreate.outx
if ($status) then
	echo "DB Create Failed, Output Below"
	cat dbcreate.outx
endif

echo "dbcreate complete"
