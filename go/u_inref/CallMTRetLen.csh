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
# Test of CallMT() and CallMDescT() functions in Go Simple API
#
echo "# Test of CallMT() and CallMDescT() functions in Go Simple API"
# Use -gld_has_db_fullpath to ensure gld is created with full paths pointing to the database file
# (see comment before "setenv ydb_gbldir" done below for why).
if ($?test_replic) then
	# Need to use MSR framework whenever -gld_has_db_fullpath is in use (non-MSR replication does not work currently)
	$MULTISITE_REPLIC_PREPARE 2	# Create two instances INST1 (primary side) and INST2 (secondary side)
endif
$gtm_tst/com/dbcreate.csh mumps -gld_has_db_fullpath >>& dbcreate.out
if ($status) then
        echo "# dbcreate failed. Output of dbcreate.out follows"
        cat dbcreate.out
endif
if ($?test_replic) then
    $MSR START INST1 INST2 # Start replication servers
endif
#
# Set up the golang environment and sets up our repo
#
source $gtm_tst/com/setupgoenv.csh # Do our golang setup (sets $tstpath)
ln -s $gtm_tst/$tst/inref/CallMTRetLen.go .
if (0 != $status) then
    echo "TEST-E-FAILED : Unable to soft link go source file"
    exit 1
endif

setenv ydb_ci `pwd`/CallMTRetLen.tab
echo $ydb_ci
cat >> CallMTRetLen.tab << xx
testciret: ydb_string_t * ^testciret()
xx

echo "# Running Go program"
# Since there are many outputs, and more will come over time, just grep for problems after
$gobuild >& go_build.log
if (0 != $status) then
	echo "TEST-E-FAILED : Build of test failed"
	cat go_build.log
	exit 1
endif

cat >> testciret.m << xxx
testciret()
 quit "abcdefghijklmnopqrstuvwxyz"
xxx

`pwd`/CallMTRetLen

$gtm_tst/com/dbcheck.csh -extract >>& dbcheck.out
if ($status) then
        echo "# dbcheck failed. Output of dbcheck.out follows"
        cat dbcheck.out
endif

echo "# Done!"
