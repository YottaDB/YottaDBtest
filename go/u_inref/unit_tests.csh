#!/usr/local/bin/tcsh -f
#################################################################
#                                                               #
# Copyright (c) 2019 YottaDB LLC. and/or its subsidiaries.      #
# All rights reserved.                                          #
#                                                               #
#       This source code contains the intellectual property     #
#       of its copyright holder(s), and is made available       #
#       under a license.  If you do not know the terms of       #
#       the license, please stop and do not read further.       #
#                                                               #
#################################################################
#

echo "# Run the Go wrapper unit tests; if there is a failure, additional output will cause the test to fail"

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

set tstpath = `pwd`
setenv PKG_CONFIG_PATH $ydb_dist
setenv GOPATH $tstpath/go/
set go_repo="lang.yottadb.com/go/yottadb"

mkdir go

@ skip_go_test = 0
echo "# Running : go get -t $go_repo"
go get -t $go_repo
if ($status) then
	echo "TEST-E-FAILED : go get -t $go_repo returned failure status of $status"
	@ skip_go_test = 1
endif

if (0 == $skip_go_test) then
	echo "# Running : go test $go_repo"

	# We need to set the global directory to an absolute path because "go test" operates in a subdirectory
	# ($tstpath/go/src/lang.yottadb.com/go/yottadb) where the default test framework assignment of ydb_gbldir
	# to a relative path (i.e. mumps.gld) is no longer relevant.
	setenv ydb_gbldir $tstpath/mumps.gld
	# Set ydb_ci to the calltab for the Go routines, and ensure the ydb_routines
	#  path includes the folder housing the helper routines used by some go tests
	setenv ydb_ci "$GOPATH/src/$go_repo/calltab.ci"
	# We use gtmroutines here since the test framework still uses it, rather than ydb_routines
	setenv gtmroutines ".($GOPATH/src/$go_repo/m_routines/) $gtmroutines"

	if ($?test_replic) then
		# In case of replication tests, set replication instance env var too just like we did the gld above
		setenv ydb_repl_instance $tstpath/mumps.repl
	endif

	go test $go_repo
	if ($status) then
		echo "TEST-E-FAILED : go test $go_repo returned failure status of $status"
	endif

	if ($?test_replic) then
		unsetenv ydb_repl_instance
	endif
	unsetenv ydb_gbldir
endif

$gtm_tst/com/dbcheck.csh >>& dbcheck.out
if ($status) then
        echo "# dbcheck failed. Output of dbcheck.out follows"
        cat dbcheck.out
endif