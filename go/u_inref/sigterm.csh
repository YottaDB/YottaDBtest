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
#
# Create database threeenp1B1 needs:
#
echo '# New go/sigterm subtest to test that SIGTERM (SIG-15) cleanly shuts down YDBGo process with no cores'
echo '# This test uses the threeenp* subtests as sample processes'

# Use -gld_has_db_fullpath to ensure gld is created with full paths pointing to the database file
# (see comment before "setenv ydb_gbldir" done below for why).
#
# Set up the golang environment and sets up our repo
#
source $gtm_tst/com/setupgoenv.csh # Do our golang setup (sets $tstpath, $PKG_CONFIG_PATH, $GOPATH, $go_repo)
set status1 = $status
if ($status1) then
	echo "[source $gtm_tst/$tst/u_inref/setupgoenv.csh] failed with status [$status1]. Exiting..."
	exit 1
endif
# Note: We need to set the global directory to an absolute path because we are operating in a subdirectory
# ($tstpath/go/src/threeenp*) where the default test framework assignment of ydb_gbldir
# to a relative path (i.e. mumps.gld) is no longer relevant.

# we test on each one of the threenp* programs
foreach prog (threeenp1B1 threeenp1B2 threeenp1C2)
	setenv ydb_gbldir $tstpath/$prog.gld
	$gtm_tst/com/dbcreate.csh $prog -gld_has_db_fullpath >>& dbcreate.out
	if ($status) then
	       	 echo "# dbcreate failed. Output of dbcreate.out follows"
		cat dbcreate.out
	endif
	cd go/src
	mkdir $prog
	cd $prog
	ln -s $gtm_tst/$tst/inref/$prog.go .
	if (0 != $status) then
	    echo "TEST-E-FAILED : Unable to soft link threeenp1B1.go to current directory ($PWD)"
	    exit 1
	endif
	# Build our routine (must be built due to use of cgo).
	echo "# Building $prog"
	$gobuild >& go_build.log
	if (0 != $status) then
	    echo "TEST-E-FAILED : Unable to build threeenp1B1.go. go_build.log output follows."
	    cat go_build.log
	    exit 1
	endif
	# this number takes the longest to compute from all numbers [1, 100,000,000]
	# important so that the program doesn't finish before it can be killed
	cat >> seed.input << EOF
63728126
63728126
EOF
	foreach run (`seq 1 1 3`)
		echo "Terminating $prog; Run $run"
		(`pwd`/$prog < seed.input &) >&! $prog$run.outx
		sleep `shuf -i 1-5 -n 1` # give some time for database processes to occur
		# since threeenp1C2 creates multiple processes we need to loop through all the pids
		set goPID = ""
		set pathto = `pwd`
		# filter out "grep" because the first grep command will contain the string to match as an argument
		# the sed is because ps output is not left justifed; when the pid of the process is less than 5 characters
		# the cut command will just return the empty string ""
		foreach pid (`ps -x | grep $pathto/$prog | grep -v "grep" | sed 's/^ *//g' | cut -f 1 -d" "`)
			set goPID = "$goPID $pid"
		end
		echo "goPID $goPID"
		kill -15 $goPID
		$gtm_tst/com/wait_for_proc_to_die.csh $goPID
	end
	cd ../../.. # back up to the top of the test directory
	$gtm_tst/com/dbcheck.csh >& dbcheck$prog.outx
	if (0 != $status) then
		echo "# dbcheck failed. Output of dbcheck$prog.outx"
		cat dbcheck$prog.outx
	endif
end
