#!/usr/local/bin/tcsh -f
#################################################################
#                                                               #
# Copyright (c) 2018 YottaDB LLC and/or its subsidiaries.       #
# All rights reserved.                                          #
#                                                               #
#       This source code contains the intellectual property     #
#       of its copyright holder(s), and is made available       #
#       under a license.  If you do not know the terms of       #
#       the license, please stop and do not read further.       #
#                                                               #
#################################################################
#
echo '# Test that $SELECT stops evaluating tvexprs or exprs once a true tvexpr is seen even in case later tvexprs or exprs contain a NUMOFLOW or INVDLRCVAL error.'
echo "# Previously a NUMOFLOW or INVDLRCVAL runtime error would be incorrectly issued."
echo ""

# Unset side effects and the boolean for ydb and gtm due to random test parameters.
unsetenv gtm_side_effects
source $gtm_tst/com/unset_ydb_env_var.csh ydb_boolean gtm_boolean

echo "# Generate and compile each m file."
echo ""
echo "# Generate true.m for specific test cases."
echo "test()" >> true.m
echo '	write "true",!' >> true.m
echo "	quit 1" >> true.m
cat true.m
echo ""
echo "# Generate echoAndRet.m for specific test cases."
echo "echoAndRet(A,B)" >> echoAndRet.m
echo "	write A,!" >> echoAndRet.m
echo "	quit B" >> echoAndRet.m
cat echoAndRet.m
echo "-----------------------------------------------"
$ydb_dist/mumps -run gentestfiles $gtm_tst/$tst/inref/ydb371
# For loop for 0 and 1 boolean settings
foreach bool ( 0 1 )
	source $gtm_tst/com/set_ydb_env_var_random.csh ydb_boolean gtm_boolean $bool
	echo "Running with ydb_boolean/gtm_boolean env var set to $bool"
	foreach subt ( tst*.m )
		echo "Subtest $subt"
		cat $subt
		echo "# Compile the m file"
		$ydb_dist/mumps $subt
		echo ""
		echo "# Run the m file using -run"
		$ydb_dist/mumps -run $subt:r
		echo ""
		echo "# Compile/Run the m file using mumps -direct"
		$ydb_dist/mumps -direct < $subt
		echo "-----------------------------------------------"
	end
end
