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
# Test of ydb_tp_st() after TPTOODEEP error still finishes transactions
#
#

echo '# Test of ydb_tp_st() after TPTOODEEP error still finishes transactions'

#SETUP of the driver C file
$gt_cc_compiler $gtt_cc_shl_options -I$gtm_tst/com -I$gtm_dist $gtm_tst/$tst/inref/tpnestto127.c
$gt_ld_linker $gt_ld_option_output tpnestto127 $gt_ld_options_common tpnestto127.o $gt_ld_sysrtns $ci_ldpath$gtm_dist -L$gtm_dist $tst_ld_yottadb $gt_ld_syslibs >& tpnestto127.map

$gtm_tst/com/dbcreate.csh mumps

# Run driver C
`pwd`/tpnestto127

$gtm_tst/com/dbcheck.csh
