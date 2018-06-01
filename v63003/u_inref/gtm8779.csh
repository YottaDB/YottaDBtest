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
# Testing for DBFREEZEON/DBFREEZEOFF message when freeze state is changed
#

$gtm_tst/com/dbcreate.csh mumps 1 >>& create.out

$MUPIP FREEZE -ON DEFAULT
$DSE dump -file |& $grep -i "Freeze"
$MUPIP FREEZE -OFF DEFAULT
$DSE dump -file |& $grep -i "Freeze"

$gtm_tst/com/dbcheck.csh >>& check.out
