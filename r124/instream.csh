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
#---------------------------------------------------------------------------------------------------------------------------------------------------
# List of subtests of the form "subtestname [author] description"
#---------------------------------------------------------------------------------------------------------------------------------------------------
# readonly         [nars]  Test update on database with READ_ONLY flag through multiple global directories
# ydb275socketpass [nars]  Test that LISTENING sockets can be passed through JOB or WRITE /PASS and WRITE /ACCEPT
# ydb280socketwait [nars]  Test that WRITE /WAIT on a SOCKET device with no sockets does not spin loop
# ydb282srcsrvrerr [nars]  Test that source server clears backlog and does not terminate with FILEDELFAIL or RENAMEFAIL errors
# jnlunxpcterr     [nars]  Test that MUPIP JOURNAL -EXTRACT does not issue JNLUNXPCTERR error in the face of concurrent udpates
# ydb293	   [vinay] Tests the update process operates correctly with triggers and SET $ZGBLDIR
# ydb297	   [vinay] Demonstrates LOCK commands work correctly when there are more than 31 subscripts that hash to the same value
# ydb312_gtm8182a  [Jake]  Test that when Instance Freeze is disabled a process attaches a region to an instance at the first update to that region.
# ydb312_gtm8182b  [jake]  Test $zpeek of journal pool to ensure there is no longer a memory leak issue with jnlpool_init()
# ydb315	   [jake]  Tests that the ZCOMPILE operation will not display warning if $ZCOMPILE contains "-nowarnings"
#---------------------------------------------------------------------------------------------------------------------------------------------------

echo "r124 test starts..."

# List the subtests separated by spaces under the appropriate environment variable name
setenv subtest_list_common     ""
setenv subtest_list_non_replic ""
setenv subtest_list_non_replic "$subtest_list_non_replic readonly ydb275socketpass ydb280socketwait jnlunxpcterr ydb297 ydb315"
setenv subtest_list_replic     ""
setenv subtest_list_replic     "$subtest_list_replic ydb282srcsrvrerr ydb293 ydb312_gtm8182a ydb312_gtm8182b"

if ($?test_replic == 1) then
	setenv subtest_list "$subtest_list_common $subtest_list_replic"
else
	setenv subtest_list "$subtest_list_common $subtest_list_non_replic"
endif

setenv subtest_exclude_list    ""

# filter out white box tests that cannot run in pro
if ("pro" == "$tst_image") then
	setenv subtest_exclude_list "$subtest_exclude_list ydb282srcsrvrerr"
endif

if ("HOST_LINUX_ARMVXL" == $gtm_test_os_machtype) then
	# filter out below test on 32-bit ARM since it relies on hash collisions which happen only on Linux x86_64 currently
	setenv subtest_exclude_list "$subtest_exclude_list ydb297"
endif

# Submit the list of subtests
$gtm_tst/com/submit_subtest.csh

echo "r124 test DONE."
