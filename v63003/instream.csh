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
#-------------------------------------------------------------------------------------
# List of subtests of the form "subtestname [author] description"
#-------------------------------------------------------------------------------------
# gtm8788           [nars]  Test that BLKTOODEEP error lines are excluded from object file (GTM-8788 fixed in GT.M V6.3-003)
# gtm7986	    [vinay] Test that a line of over 8192 bytes produces an LSINSERTED warning
# gtm8186	    [vinay] Test DO, GOTO and ZGOTO can take offset without a label
# gtm8804	    [vinay] Test zshow "t" produces only a summary of zshow "g" and "l"
# gtm8832	    [vinay] Test string literal evaluating to >=1E47 produces a NUMOFLOW error
# gtm8617	    [vinay] Tests MUPIP SET command of STDNULLCOLL and NULL_SUBSCRIPTS
#-------------------------------------------------------------------------------------

echo "v63003 test starts..."

# List the subtests separated by spaces under the appropriate environment variable name
setenv subtest_list_common     ""
setenv subtest_list_non_replic "gtm8788 gtm7986 gtm8186 gtm8804 gtm8832 gtm8617"
setenv subtest_list_replic     ""

if ($?test_replic == 1) then
	setenv subtest_list "$subtest_list_common $subtest_list_replic"
else
	setenv subtest_list "$subtest_list_common $subtest_list_non_replic"
endif

# Use $subtest_exclude_list to remove subtests that are to be disabled on a particular host or OS
setenv subtest_exclude_list	""

# Submit the list of subtests
$gtm_tst/com/submit_subtest.csh

echo "v63003 test DONE."
