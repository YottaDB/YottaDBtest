V3FOR1 ;IW-KO-YS-TS,V3FOR,MVTS V9.10;15/6/96;PART-90
 ;COPYRIGHT MUMPS SYSTEMS LABORATORY 1990-1996
 W !!,"21---V3FOR1: argumentless FOR command -1-"
 ;
1 S ^ABSN="30298",^ITEM="III-298  Unconditional QUIT"
 S ^NEXT="2^V3FOR1,V3FOR2^V3FOR,V3HANG^VV3" D ^V3PRESET
 S ^VCOMP=""
 FOR  S ^VCOMP=1 QUIT  S ^VCOMP=^VCOMP_2
 S ^VCOMP=^VCOMP_3
 S ^VCORR="13" D ^VEXAMINE
 ;
2 S ^ABSN="30299",^ITEM="III-299  Postconditional QUIT"
 S ^NEXT="3^V3FOR1,V3FOR2^V3FOR,V3HANG^VV3" D ^V3PRESET
 S ^VCOMP="",N=1
 for  S ^VCOMP=^VCOMP_N,N=N+1 Q:N>4  S ^VCOMP=^VCOMP_N
 S ^VCOMP=^VCOMP_N
 S ^VCORR="12233445" D ^VEXAMINE
 ;
3 S ^ABSN="30300",^ITEM="III-300  FOR scope has DO command terminated by QUIT"
 S ^NEXT="4^V3FOR1,V3FOR2^V3FOR,V3HANG^VV3" D ^V3PRESET
 S ^VCOMP="",N=1,F=0
 F  S ^VCOMP=^VCOMP_N D V3GET1 Q:F  S ^VCOMP=^VCOMP_N,N=N+1
 S ^VCORR="1 12 23 34 45 " D ^VEXAMINE
 ;
4 S ^ABSN="30301",^ITEM="III-301  FOR scope has DO command terminated by EOR"
 S ^NEXT="5^V3FOR1,V3FOR2^V3FOR,V3HANG^VV3" D ^V3PRESET
 S ^VCOMP="",N=1,F=0
 F  S ^VCOMP=^VCOMP_N D V3GET2 Q:F  S ^VCOMP=^VCOMP_N,N=N+1
 S ^VCORR="1 12 23 34 45 " D ^VEXAMINE
 ;
5 S ^ABSN="30302",^ITEM="III-302  FOR scope has internal GOTO command"
 S ^NEXT="6^V3FOR1,V3FOR2^V3FOR,V3HANG^VV3" D ^V3PRESET
 S ^VCOMP="",N=1
 f  S ^VCOMP=^VCOMP_N  G:N>4 GOTO   S ^VCOMP=^VCOMP_N,N=N+1
 S ^VCOMP=^VCOMP_" ERROR"
GOTO S ^VCORR="112233445" D ^VEXAMINE
 ;
6 S ^ABSN="30303",^ITEM="III-303  FOR scope has external GOTO command"
 S ^NEXT="7^V3FOR1,V3FOR2^V3FOR,V3HANG^VV3" D ^V3PRESET
 S ^VCOMP="",N=2
 f  S ^VCOMP=^VCOMP_N  G:N>5 GOTO^V3FOREX   S ^VCOMP=^VCOMP_N,N=N+1
 S ^VCOMP=^VCOMP_" ERROR"
EXGOTO S ^VCORR="223344556" D ^VEXAMINE
 ;
7 S ^ABSN="30304",^ITEM="III-304  FOR scope has XECUTE command"
 S ^NEXT="V3FOR2^V3FOR,V3HANG^VV3" D ^V3PRESET
 S ^VCOMP=""
 S N=0 for  x "S N=N+1 s ^VCOMP=^VCOMP_N DO ^V3FOREX" quit:N=3
 S ^VCORR="1 V3FOREX2 V3FOREX3 V3FOREX" D ^VEXAMINE
 ;
END W !!,"End of 21 --- V3FOR1",!
 K  Q
 ;
V3GET1 ;
 S ^VCOMP=^VCOMP_" "
 IF N>4 S F=1 QUIT
 Q
 ;
SUM S SUM=0 F I=1:1 S L=$T(+I) Q:L=""  F K=1:1:$L(L) S SUM=SUM+$A(L,K)
 Q
 ;
V3GET2 ;
 S ^VCOMP=^VCOMP_" "
 IF N>4 S F=1
