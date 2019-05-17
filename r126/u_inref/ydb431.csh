#!/usr/local/bin/tcsh -f
#################################################################
#								#
# Copyright (c) 2019 YottaDB LLC and/or its subsidiaries.	#
# All rights reserved.						#
#								#
#	This source code contains the intellectual property	#
#	of its copyright holder(s), and is made available	#
#	under a license.  If you do not know the terms of	#
#	the license, please stop and do not read further.	#
#								#
#################################################################
#
# Test of various SimpleAPI commands in multiple processes similar to the go/ydb431 subtest
#
unsetenv gtmdbglvl   # Disable storage debugging as that can turn this 1 minute job into an hour

echo '# Test of various SimpleAPI commands in multiple processes similar to the go/ydb431 subtest'

#SETUP of the driver C file
$gt_cc_compiler $gtt_cc_shl_options -I$gtm_tst/com -I$gtm_dist $gtm_tst/$tst/inref/ydb431.c
$gt_ld_linker $gt_ld_option_output ydb431 $gt_ld_options_common ydb431.o $gt_ld_sysrtns $ci_ldpath$gtm_dist -L$gtm_dist $tst_ld_yottadb $gt_ld_syslibs >& ydb431.map

$gtm_tst/com/dbcreate.csh mumps

# Run driver C
`pwd`/ydb431

$gtm_tst/com/dbcheck.csh
