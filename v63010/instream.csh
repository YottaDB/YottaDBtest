#!/usr/local/bin/tcsh -f
#################################################################
#								#
# Copyright (c) 2021 YottaDB LLC and/or its subsidiaries.	#
# All rights reserved.						#
#								#
#	This source code contains the intellectual property	#
#	of its copyright holder(s), and is made available	#
#	under a license.  If you do not know the terms of	#
#	the license, please stop and do not read further.	#
#								#
#################################################################
#
#----------------------------------------------------------------------------------------------------------------------------------------------------------------
# List of subtests of the form "subtestname [author] description"
#-------------------------------------------------------------------------------------
# gtm9206		[bdw]		 Test that MUPIP LOAD can correctly handle 64 bit values for -begin and -end
# gtm9188		[bdw]		 Test that $ZCMDLINE is set correctly for mumps -run and mumps -direct commands with extra spaces
# gtm9190		[estess]	 Test that eu-elflint approves of M generated object files
# gtm9183		[estess]	 Test that indirect exclusive NEW after FOR (on same line) does not cause sigsegv or other error
# gtm9180		[bdw]		 Look for error message if block number for DSE -add or -dump command doesn't fit in a 32 bit signed integer
#----------------------------------------------------------------------------------------------------------------------------------------------------------------


echo "v63010 test starts..."

# List the subtests seperated by sspaces under the appropriate environment variable name
setenv subtest_list_common	""
setenv subtest_list_non_replic "gtm9206 gtm9188 gtm9190 gtm9183 gtm9180"
setenv subtest_list_replic	""

if ($?test_replic == 1) then
	setenv subtest_list "$subtest_list_common $subtest_list_replic"
else
	setenv subtest_list "$subtest_list_common $subtest_list_non_replic"
endif

setenv subtest_exclude_list ""

# Use $subtest_exclude_list to remove subtests that are to be disabled on a particular host or OS
if ("pro" == "$tst_image") then
	setenv subtest_exclude_list "$subtest_exclude_list "
endif

if ("dbg" == "$tst_image") then
	setenv subtest_exclude_list "$subtest_exclude_list gtm9180"
endif

# Submit the list of subtests
$gtm_tst/com/submit_subtest.csh

echo "v63010 test DONE."
