;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 2019-2020 YottaDB LLC and/or its subsidiaries.	;
; All rights reserved.						;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	write "Testing $ZYHASH from M code",!
	write "The hash of ""test"" with a salt of 0 is: ",$ZYHASH("test",0),!
	write "The hash of ""test"" with a salt of 5 is: ",$ZYHASH("test",5),!
	write "The hash of ""test"" with no salt specified is: ",$ZYHASH("test"),!
	write "The hash of ""YottaDB"" with a salt of 0 is: ",$ZYHASH("YottaDB",0),!
	write "The hash of ""This test was added in YottaDB version R1.30"" with a salt of 63008 is: ",$ZYHASH("This test was added in YottaDB version R1.30",63008),!
	write "The hash of ""YottaDB is a new kind of database company, delivering a proven database engine to your application, enhancing simplicity, security, stability and scalability."" with a salt of 6441898 is: ",$ZYHASH("YottaDB is a new kind of database company, delivering a proven database engine to your application, enhancing simplicity, security, stability and scalability.",6441898),!
	write "The hash of ""YottaDB compiles XECUTE <literal> at compile time when the literal is valid YottaDB code that has minimal impact on the M virtual machine"" with a hash of 1610 is: ",$ZYHASH("YottaDB compiles XECUTE <literal> at compile time when the literal is valid YottaDB code that has minimal impact on the M virtual machine",1610),!
	write "Finished test of hardcoded calls to $ZYHASH from M code",!
	write "Starting test of random calls to $ZYHASH from M code",!
	for i=1:1:1000 do
	. set strlen=$RANDOM(1048576)+1
	. set str=$$^%RANDSTR(strlen,.chset)
	. set salt=$RANDOM(2147483647)
	. set x=$ZYHASH(str,salt)
	write "Finished test of random calls to $ZYHASH from M code.",!
	write "Will now test an invalid string length. This should return an error.",!
	set x=$ZYHASH($$^%RANDSTR(1048577))
	quit
