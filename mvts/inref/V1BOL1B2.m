V1BOL1B2 ;IW-YS-TS,V1BOL,MVTS V9.10;15/6/96;BINARY OPERATORS LOGICAL: '& -2-
 ;COPYRIGHT MUMPS SYSTEMS LABORATORY 1978-1996
 W !!,"87---V1BOL1B2: Binary operators  logical: '& -2-",!
147 W !,"I-147  expratoms are strlit"
1471 S ^ABSN="11190",^ITEM="I-147.1  ""A""'&""B""",^NEXT="14711^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S ^VCOMP="A"'&"B",^VCORR="1" D ^VEXAMINE
14711 S ^ABSN="11191",^ITEM="I-147.1.1  '(""A""&""B"")",^NEXT="1472^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S ^VCOMP='("A"&"B"),^VCORR="1" D ^VEXAMINE ;Test added in V7.4;16/9/89
1472 S ^ABSN="11192",^ITEM="I-147.2  ""-0.0A""'&""2B""",^NEXT="14721^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S ^VCOMP="-0.0A"'&"2B",^VCORR="1" D ^VEXAMINE
14721 S ^ABSN="11193",^ITEM="I-147.2.1  '(""-0.0A""&""2B"")",^NEXT="148^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S ^VCOMP='("-0.0A"&"2B"),^VCORR="1" D ^VEXAMINE ;Test added in V7.4;16/9/89
 ;
148 W !,"I-148  expratoms are empty strings"
1481 S ^ABSN="11194",^ITEM="I-148.1  """"'&""""",^NEXT="14811^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S ^VCOMP=""'&"" S C="1" D ^VEXAMINE ;Number changed in V7.4;16/9/89
14811 S ^ABSN="11195",^ITEM="I-148.1.1  '(""""&"""")",^NEXT="149^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S ^VCOMP='(""&"") S C="1" D ^VEXAMINE ;Test added in V7.4;16/9/89
 ;
149 W !,"I-149  expratoms are lvn"
1491 S ^ABSN="11196",^ITEM="I-149.1  C'&D",^NEXT="14911^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S %A=0,B="B",C=2,D="3Z"
 S ^VCOMP=C'&D,^VCORR="0" D ^VEXAMINE
14911 S ^ABSN="11197",^ITEM="I-149.1.1  '(C&D)",^NEXT="1492^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S %A=0,B="B",C=2,D="3Z"
 S ^VCOMP='(C&D),^VCORR="0" D ^VEXAMINE ;Test added in V7.4;16/9/89
1492 S ^ABSN="11198",^ITEM="I-149.2  D'&%A",^NEXT="14921^V1BOL1B2,V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S %A=0,B="B",C=2,D="3Z"
 S ^VCOMP=D'&%A,^VCORR="1" D ^VEXAMINE
14921 S ^ABSN="11199",^ITEM="I-149.2.1  '(D&%A)",^NEXT="V1BOL2A^V1BOL,V1BOC^VV1" D ^V1PRESET
 S %A=0,B="B",C=2,D="3Z"
 S ^VCOMP='(D&%A),^VCORR="1" D ^VEXAMINE ;Test added in V7.4;16/9/89
 ;
END W !!,"End of 87---V1BOL1B2",!
 K  Q
SUM S SUM=0 F I=1:1 S L=$T(+I) Q:L=""  F K=1:1:$L(L) S SUM=SUM+$A(L,K)
 Q
