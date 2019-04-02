;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 2019 YottaDB LLC. and/or its subsidiaries.	;
; All rights reserved.						;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
mmaxstr(str);;
	set length=$length(str)
	write "# Length of str: ",length,!
	set mstr="" for i=1:1:$length(str) set mstr=mstr_"A"
	if mstr=str write "M got the correct string",!
	else  write "M got the wrong string",!
	use $principal
	quit

citabcreate(numtables);
	for i=1:1:numtables  do
	. set file="citable"_i_".tab"
	. open file:newversion
	. use file
	. write "crtnname: void ^citable"_i_"()",!
	. close file
	. set file="citable"_i_".m"
	. open file:newversion
	. use file
	. write " write ""Inside M program citable"_i_".m (using call-in table [citable"_i_".tab])"",!",!
	. close file
	quit

citabtest	;
	write "In citabtest^utilfuncs (using call-in table [callin.tab])",!
	quit
