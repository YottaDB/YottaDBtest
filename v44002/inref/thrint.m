thrint
	s $zint="w ""interrupt occurred at : "",$stack($stack-1,""PLACE""),! s $zte=1"
	w "$zint = ",$zint,!
	w "delivering interrupt",!
	i '$zsigproc($j,$ztrnlnm("sigusrval")) w "interrupt sent to process",!
	s p=0
loop  s p=p+1
	i $zte=0 g loop
	q
