V4TPE21 ;IW-KO-YS-TS,VV4TP,MVTS V9.10;15/7/96;PART-94 Transaction
 ;COPYRIGHT MUMPS SYSTEMS LABORATORY 1994-1996
11 ;---1. TSTART ... TCOMMIT
 F  Q:$$^V4GETS1
 TSTART
 F I=1:1:20 L +^VV:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPS21 ;^VA^VB(1)VAVB(1)
 D ^V4TPCHK1
 TCOMMIT
 D ^V4TPCHK1
 L  H
 ;
12 ;---2. TSTART ... TCOMMIT
 F  Q:$$^V4GETS2
 TSTART
 F I=1:1:20 L +^VV:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPS22 ;^VC^VD(1)VCVD(1)
 D ^V4TPCHK2
 TCOMMIT
 D ^V4TPCHK2
 L  H
 ;==========================================
21 ;---1. TSTART ... TCOMMIT
 F  Q:$$^V4GETS1
 TSTART
 F I=1:1:20 L +^VV:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPS21 ;^VA^VB(1)VAVB(1)
 D ^V4TPCHK1
 TCOMMIT
 D ^V4TPCHK1
 L  H
 ;
22 ;---2. TSTART ... TROLLBACK
 F  Q:$$^V4GETS2
 TSTART
 F I=1:1:20 L +^VV:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPS22 ;^VC^VD(1)VCVD(1)
 D ^V4TPCHK2
 TROLLBACK
 D ^V4TPCHK2
 L  H
 ;
 ;==========================================
31 ;---1. TSTART ... TCOMMIT
 TSTART
 LOCK +^S1
 D ^V4TPS21 ;^VA^VB(1)VAVB(1)
 F  Q:$$^V4GETS1
 F I=1:1:20 L +^S2:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK1
 TCOMMIT
 D ^V4TPCHK1
 L  H
 ;
32 ;---2. TSTART ... HALT
 TSTART
 LOCK +^S2
 D ^V4TPS22 ;^VC^VD(1)VCVD(1)
 F  Q:$$^V4GETS2
 D ^V4TPCHK2
 LOCK -^S2
 F I=1:1:20 L +^S1:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 HALT
 HALT
 ;==========================================
41 ;---1. 1. TSTART ... TCOMMIT
 LOCK +^S1
 TSTART
 D ^V4TPS21 ;^VA^VB(1)VAVB(1)
 F  Q:$$^V4GETS1
 F I=1:1:20 L +^S2:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK1
 TCOMMIT
 D ^V4TPCHK1
 L  H
 ;
42 ;---2. non TP
 LOCK +^S2
 D ^V4TPS22 ;^VC^VD(1)VCVD(1)
 F  Q:$$^V4GETS2
 D ^V4TPCHK2
 LOCK -^S2
 F I=1:1:20 L +^S1:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK2
 L  H
 ;==========================================
51 ;---1. TSTART ... TROLLBACK
 TSTART
 LOCK +^S1
 D ^V4TPS21 ;^VA^VB(1)VAVB(1)
 F  Q:$$^V4GETS1
 F I=1:1:20 L +^S2:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK1
 TROLLBACK
 D ^V4TPCHK1
 L  H
 ;
52 ;---2. non TP
 LOCK +^S2
 D ^V4TPS22 ;^VC^VD(1)VCVD(1)
 F  Q:$$^V4GETS2
 LOCK -^S2
 F I=1:1:20 L +^S1:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK2
 L  H
 ;==========================================
61 ;---1. non TP
 LOCK +^S1
 D ^V4TPS22 ;^VC^VD(1)VCVD(1)
 F  Q:$$^V4GETS1
 D ^V4TPCHK1
 F I=1:1:20 L +^S2:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK1
 L  H
62 ;---2. TSTART ... TCOMMIT
 LOCK +^S2
 TSTART
 D ^V4TPS21 ;^VA^VB(1)VAVB(1)
 F  Q:$$^V4GETS2
 LOCK -^S2
 F I=1:1:20 L +^S1:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK2
 TCOMMIT
 D ^V4TPCHK2
 L  H
 ;
 ;==========================================
71 ;---1. non TP
 LOCK +^S1
 D ^V4TPS22 ;^VC^VD(1)VCVD(1)
 F  Q:$$^V4GETS1
 D ^V4TPCHK1
 F I=1:1:20 L +^S2:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK1
 L  H
 ;
72 ;---2. TSTART ... TROLLBACK
 LOCK +^S2
 TSTART
 D ^V4TPS21 ;^VA^VB(1)VAVB(1)
 F  Q:$$^V4GETS2
 LOCK -^S2
 F I=1:1:20 L +^S1:1 Q:$T  H 1 IF $D(^HALT)=1 L  HALT
 D ^V4TPCHK2
 TROLLBACK
 D ^V4TPCHK2
 L  H
 ;
 ;==========================================
SUM S SUM=0 F I=1:1 S L=$T(+I) Q:L=""  F K=1:1:$L(L) S SUM=SUM+$A(L,K)
 Q
