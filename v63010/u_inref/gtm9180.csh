#!/usr/local/bin/tcsh
#################################################################
#                                                               #
# Copyright (c) 2021 YottaDB LLC and/or its subsidiaries.       #
# All rights reserved.                                          #
#                                                               #
#       This source code contains the intellectual property     #
#       of its copyright holder(s), and is made available       #
#       under a license.  If you do not know the terms of       #
#       the license, please stop and do not read further.       #
#                                                               #
#################################################################

echo "# Create a global directory with two regions -- DEFAULT, REGX"
$echoline
setenv gtm_test_mupip_set_version "disable"
setenv gtm_test_disable_randomdbtn
unsetenv gtmdbglvl # We need this because this environment variable changes the output of some of the dse -dump commands causing test failures.
$gtm_tst/com/dbcreate.csh mumps 2

echo "# Set some global variables - to fill some blocks"
$echoline

echo "# Test the dse -add and -dump commands with 64 bit block numbers"
echo "# Without the V7.0-000 changes, this should produce an error message."
$echoline

$ydb_dist/mumps -r gtm9180

# Verify if the above operations have not done any damage to the database
$gtm_tst/com/dbcheck.csh
