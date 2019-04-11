#!/usr/local/bin/tcsh -f
#################################################################
#								#
# Copyright (c) 2017-2018 YottaDB LLC and/or its subsidiaries.	#
# All rights reserved.						#
#								#
#	This source code contains the intellectual property	#
#	of its copyright holder(s), and is made available	#
#	under a license.  If you do not know the terms of	#
#	the license, please stop and do not read further.	#
#								#
#################################################################
#
# Test that ydb_init() does not hang when called from ydb_tp_s()
#
unsetenv gtmdbglvl   # Disable storage debugging as that can turn this 1 minute job into an hour

echo '# Test that ydb_init() issues YDB_OK when called inside ydb_tp_s()'

#SETUP of the driver C file
$gt_cc_compiler $gtt_cc_shl_options -I$gtm_tst/com -I$gtm_dist $gtm_tst/$tst/inref/initFromTp.c
$gt_ld_linker $gt_ld_option_output initFromTp $gt_ld_options_common initFromTp.o $gt_ld_sysrtns $ci_ldpath$gtm_dist -L$gtm_dist $tst_ld_yottadb $gt_ld_syslibs >& initFromTp.map

$gtm_tst/com/dbcreate.csh mumps

# Run driver C
`pwd`/initFromTp

$gtm_tst/com/dbcheck.csh
