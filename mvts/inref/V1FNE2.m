V1FNE2 ;IW-YS-TS,V1FN,MVTS V9.10;15/6/96;FUNCTION $EXTRACT -2-
 ;COPYRIGHT MUMPS SYSTEMS LABORATORY 1978-1996
 W !!,"93---V1FNE2: $EXTRACT function -2-",! W:$Y>55 #
 ;
271 W !,"I-271  intexpr2 is string literal"
2711 S ^ABSN="11270",^ITEM="I-271.1  intexpr2=""A3BCD""",^NEXT="2712^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP="123" S ^VCOMP=$E(-456789.0,"A3BCD") S ^VCORR="" D ^VEXAMINE
2712 S ^ABSN="11271",^ITEM="I-271.2  intexpr2=""3.6BCD""",^NEXT="272^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP=$E(-456789.0,"3.6BCD") S ^VCORR="5" D ^VEXAMINE
 ;
272 W !,"I-272  intexpr2 is positive integer"
 S ^ABSN="11272",^ITEM="I-272  intexpr2 is positive integer",^NEXT="273^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP=$E("ABCDEFGHIJKLMNOPQRSTUVWXYZ",0.1E+2) S ^VCORR="J" D ^VEXAMINE
 ;
273 W !,"I-273  intexpr2 is negative integer"
 S ^ABSN="11273",^ITEM="I-273  intexpr2 is negative integer",^NEXT="274^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP="123" S ^VCOMP=$E(-456789.0,-1) S ^VCORR="" D ^VEXAMINE
 ;
274 W !,"I-274  intexpr2 is zero"
 S ^ABSN="11274",^ITEM="I-274  intexpr2 is zero",^NEXT="275^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP="123" S ^VCOMP=$E(456789.0,00) S ^VCORR="" D ^VEXAMINE
 ;
275 W !,"I-275  intexpr2>$L(expr1)"
2751 S ^ABSN="11275",^ITEM="I-275.1  (intexpr2+1)=$L(expr1)",^NEXT="2752^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP="123" S ^VCOMP=$E("-457.90E8",10) S ^VCORR="" D ^VEXAMINE
2752 S ^ABSN="11276",^ITEM="I-275.2  intexpr2>255",^NEXT="276^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP="123" S ^VCOMP=$E("-4567.890",999) S ^VCORR="" D ^VEXAMINE
 ;
276 W !,"I-276  intexpr2 is non-integer numeric literal"
 S ^ABSN="11277",^ITEM="I-276  intexpr2 is non-integer numeric literal",^NEXT="277^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP=$E("-457.90E8",3.9999) S ^VCORR="5" D ^VEXAMINE
 ;
277 W !,"I-277  intexpr2 is function"
 S ^ABSN="11278",^ITEM="I-277  intexpr2 is function",^NEXT="278^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP=$E("-457.90E8",$E("897647375475758",4)) S ^VCORR="9" D ^VEXAMINE
 ;
278 W !,"I-278  intexpr2 is a lvn"
 S ^ABSN="11279",^ITEM="I-278  intexpr2 is a lvn",^NEXT="279^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP="" F I=0:4:36 S ^VCOMP=^VCOMP_$E("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",I)
 S ^VCORR="DHLPTX260" D ^VEXAMINE
 ;
279 W !,"I-279  intexpr2 contains unary operator"
 S ^ABSN="11280",^ITEM="I-279  intexpr2 contains unary operator",^NEXT="280^V1FNE2,V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP=$E("987654321987654321",+"3.999 9") S ^VCORR="7" D ^VEXAMINE
 ;
280 W !,"I-280  intexpr2 contains binary operator"
 S ^ABSN="11281",^ITEM="I-280  intexpr2 contains binary operator",^NEXT="V1FNE3^V1FN,V1AC^VV1" D ^V1PRESET
 S ^VCOMP=$E("987654321987654321",.8+10/3) S ^VCORR="7" D ^VEXAMINE
 ;
END W !!,"End of 93---V1FNE2",!
 K  Q
SUM S SUM=0 F I=1:1 S L=$T(+I) Q:L=""  F K=1:1:$L(L) S SUM=SUM+$A(L,K)
 Q
