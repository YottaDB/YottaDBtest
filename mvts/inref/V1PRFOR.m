V1PRFOR ;IW-YS-TS,VV1,MVTS V9.10;15/6/96;PRELIMINARY TEST OF FOR COMMAND
 ;COPYRIGHT MUMPS SYSTEMS LABORATORY 1978-1996
 W !!,"11---V1PRFOR: Preliminary tests of FOR command",!
 W !,"FOR lvn=numexpr1:numexpr2:numexpr3",!
724 W !,"I-724  numexpr1<numexpr3 and numexpr2>0"
7241 S ^ABSN="10071",^ITEM="I-724.1  numexpr2=1",^NEXT="7242^V1PRFOR,V1NUM^VV1" D ^V1PRESET
 S VCOMP=""
 FOR I=1:1:10 SET VCOMP=VCOMP_I
 S ^VCOMP=VCOMP,^VCORR="12345678910" D ^VEXAMINE
 ;
7242 S ^ABSN="10072",^ITEM="I-724.2  numexpr2=3",^NEXT="725^V1PRFOR,V1NUM^VV1" D ^V1PRESET
 S ^VCOMP="" F I=1:3:15 SET ^VCOMP=^VCOMP_I
 S ^VCORR="1471013" D ^VEXAMINE
 ;
725 W !,"I-725  numexpr1>numexpr3 and numexpr2<0"
7251 S ^ABSN="10073",^ITEM="I-725.1  numexpr2=-1",^NEXT="7252^V1PRFOR,V1NUM^VV1" D ^V1PRESET
 S ^VCOMP=""
 FOR J=1:-1:-10 SET ^VCOMP=^VCOMP_J
 S ^VCORR="10-1-2-3-4-5-6-7-8-9-10" D ^VEXAMINE
 ;
7252 S ^ABSN="10074",^ITEM="I-725.2  numexpr2=-3",^NEXT="V1NUM^VV1" D ^V1PRESET
 S VCOMP=""
 F J=1:-3:-15 SET VCOMP=VCOMP_J
 S ^VCOMP=VCOMP,^VCORR="1-2-5-8-11-14" D ^VEXAMINE
 ;
END W !!,"End of 11---V1PRFOR",!
 K  Q
 Q
SUM S SUM=0 F I=1:1 S L=$T(+I) Q:L=""  F K=1:1:$L(L) S SUM=SUM+$A(L,K)
 Q
