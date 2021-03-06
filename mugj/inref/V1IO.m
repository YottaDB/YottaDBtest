V1IO	;I/O CONTROL;KO-MM-TS,V1IO,VALIDATION VERSION 7.1;31-AUG-1987;
	;COPYRIGHT MUMPS SYSTEM LABORATORY 1978
	S PASS=0,FAIL=0
	W !!,"V1IO: TEST OF VARIOUS I/O CONTROL"
	W !,"THIS ROUTINE TESTS OPEN, USE, $X, $Y, $IO AND $JOB"
	W !,"MODIFY 'U 0' IF NOT PROPER TO THE IMPLEMENTATION"
	W !,"NO ERROR MESSAGE IS EXPECTED TO APPEAR IN THIS ROUTINE"
	R !!,"WHEN YOU SEE THE '>' ENTER THE NUMBER OF"
	W !,"A SEPARATE DEVICE TO WHICH I/O MAY BE ROUTED"
	R !!,"ENTER A ZERO TO SKIP THIS TEST > ",X G:X=0 END ;exit if X=0
	;
	S JOB(0)=$JOB,IO(0)=$IO,XCOR(0)=$X,YCOR(0)=$Y
	OPEN X
	S JOB(532)=$JOB,IO(532)=$IO,XCOR(532)=$X,YCOR(532)=$Y ;= = = =
	USE X W #
	S JOB(533)=$JOB,IO(533)=$IO,XCOR(533)=$X,YCOR(533)=$Y ;= X 0 0
	CLOSE X
	S JOB(534)=$JOB,IO(534)=$IO,XCOR(534)=$X,YCOR(534)=$Y ;= = = =
	;
	O:0 X
	S JOB(5380)=$JOB,IO(5380)=$IO,XCOR(5380)=$X,YCOR(5380)=$Y ;= = = =
	O:1 X
	S JOB(5381)=$JOB,IO(5381)=$IO,XCOR(5381)=$X,YCOR(5381)=$Y ;= = = =
	U:0 X
	S JOB(5390)=$JOB,IO(5390)=$IO,XCOR(5390)=$X,YCOR(5390)=$Y ;= = = =
	U:1 X
	S JOB(5391)=$JOB,IO(5391)=$IO,XCOR(5391)=$X,YCOR(5391)=$Y ;= X 0 0
	C:0 X
	S JOB(5400)=$JOB,IO(5400)=$IO,XCOR(5400)=$X,YCOR(5400)=$Y ;= X 0 0
	C:2 X
	S JOB(5401)=$JOB,IO(5401)=$IO,XCOR(5401)=$X,YCOR(5401)=$Y ;= = = =
	;
	I 0
	OPEN X::10
	S JOB(5411)=$JOB,IO(5411)=$IO,XCOR(5411)=$X,YCOR(5411)=$Y,T(5411)=$TEST
	USE X
	S JOB(5412)=$J,IO(5412)=$I,XCOR(5412)=$X,YCOR(5412)=$Y,T(5412)=$T
	CLOSE X
	S JOB(5413)=$J,IO(5413)=$I,XCOR(5413)=$X,YCOR(5413)=$Y,T(5413)=$T
	;
	OPEN X
	S JOB(551)=$JOB,IO(548)=$IO
	W #!!,"THIS OUTPUT SHOULD BE ON THE PRINCIPAL DEVICE",!,"    "
	S XCOR(1)=$X,YCOR(1)=$Y ;4 3
	U X ;0 0
	S JOB(5521)=$JOB,IO(5491)=$IO
	W !!
	S XCOR(2)=$X,YCOR(2)=$Y ;0 2
	W !?10
	S XCOR(3)=$X,YCOR(3)=$Y ;10 3
	W "THIS LINE SHOULD BE ON THE OTHER DEVICE",!,"   "
	S XCOR(4)=$X,YCOR(4)=$Y ;3 4
	W ?11,"GRAPHICS"
	S XCOR(5)=$X,YCOR(5)=$Y ;19 4
	;
	U 0 S JOB(5520)=$JOB,IO(5490)=$IO
	U X S JOB(5522)=$JOB,IO(5492)=$IO
	S XCOR(6)=$X,YCOR(6)=$Y ;19 4
	W !,"ABC"
	S XCOR(7)=$X,YCOR(7)=$Y ;4 5
	;
	W !!,"END OF V1IO",!
	C X U 0
	S JOB(553)=$JOB,IO(550)=$IO
	S XCOR(8)=$X,YCOR(8)=$Y ;4 3
	;
	D ^V1IO1
	D ^V1IO2
END	U 0
	W !!,"END OF V1IO",!
	S ROUTINE="V1IO",TESTS=20,AUTO=20,VISUAL=0 D ^VREPORT
	K  Q
