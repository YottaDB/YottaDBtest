;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 2019 YottaDB LLC and/or its subsidiaries.	;
; All rights reserved.						;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GTM9093 Tests for sig11 on subsequent runs of $translate after
; calling $translate with an undefined variable by making 15 seconds
; worth of random calls to $translate. We have not been able to get
; this test to fail on GTM v6.3-006 but the issue exists in v6.3-006
; and v6.3-007 and was fixed in v6.3-008. It is included just to
; make sure that $translate is not throwing sig11s.
	set $etrap="do restart"
	set endtime=$ZUT+15000000 ;15 seconds after current time
	for  quit:$ZUT>endtime  do
	. set stcklvl=$zlevel
	. set x="xyz"
	. set y="young"
	. set z="zebra"
	. set r=$random(399)
	. if r=0 set ignore=$translate(x)
	. else  if r=1 set ignore=$translate(y)
	. else  if r=2 set ignore=$translate(z)
	. else  if r=3 set ignore=$translate("xyz")
	. else  if r=4 set ignore=$translate("young")
	. else  if r=5 set ignore=$translate("zebra")
	. else  if r=6 set ignore=$translate(abc)
	. else  if r=7 set ignore=$translate(x,x)
	. else  if r=8 set ignore=$translate(x,y)
	. else  if r=9 set ignore=$translate(x,z)
	. else  if r=10 set ignore=$translate(x,"xyz")
	. else  if r=11 set ignore=$translate(x,"young")
	. else  if r=12 set ignore=$translate(x,"zebra")
	. else  if r=13 set ignore=$translate(x,abc)
	. else  if r=14 set ignore=$translate(y,x)
	. else  if r=15 set ignore=$translate(y,y)
	. else  if r=16 set ignore=$translate(y,z)
	. else  if r=17 set ignore=$translate(y,"xyz")
	. else  if r=18 set ignore=$translate(y,"young")
	. else  if r=19 set ignore=$translate(y,"zebra")
	. else  if r=20 set ignore=$translate(y,abc)
	. else  if r=21 set ignore=$translate(z,x)
	. else  if r=22 set ignore=$translate(z,y)
	. else  if r=23 set ignore=$translate(z,z)
	. else  if r=24 set ignore=$translate(z,"xyz")
	. else  if r=25 set ignore=$translate(z,"young")
	. else  if r=26 set ignore=$translate(z,"zebra")
	. else  if r=27 set ignore=$translate(z,abc)
	. else  if r=28 set ignore=$translate("xyz",x)
	. else  if r=29 set ignore=$translate("xyz",y)
	. else  if r=30 set ignore=$translate("xyz",z)
	. else  if r=31 set ignore=$translate("xyz","xyz")
	. else  if r=32 set ignore=$translate("xyz","young")
	. else  if r=33 set ignore=$translate("xyz","zebra")
	. else  if r=34 set ignore=$translate("xyz",abc)
	. else  if r=35 set ignore=$translate("young",x)
	. else  if r=36 set ignore=$translate("young",y)
	. else  if r=37 set ignore=$translate("young",z)
	. else  if r=38 set ignore=$translate("young","xyz")
	. else  if r=39 set ignore=$translate("young","young")
	. else  if r=40 set ignore=$translate("young","zebra")
	. else  if r=41 set ignore=$translate("young",abc)
	. else  if r=42 set ignore=$translate("zebra",x)
	. else  if r=43 set ignore=$translate("zebra",y)
	. else  if r=44 set ignore=$translate("zebra",z)
	. else  if r=45 set ignore=$translate("zebra","xyz")
	. else  if r=46 set ignore=$translate("zebra","young")
	. else  if r=47 set ignore=$translate("zebra","zebra")
	. else  if r=48 set ignore=$translate("zebra",abc)
	. else  if r=49 set ignore=$translate(abc,x)
	. else  if r=50 set ignore=$translate(abc,y)
	. else  if r=51 set ignore=$translate("xyz",z)
	. else  if r=52 set ignore=$translate("xyz","xyz")
	. else  if r=53 set ignore=$translate("xyz","young")
	. else  if r=54 set ignore=$translate("xyz","zebra")
	. else  if r=55 set ignore=$translate("xyz",abc)
	. else  if r=56 set ignore=$translate(x,x,x)
	. else  if r=57 set ignore=$translate(x,x,y)
	. else  if r=58 set ignore=$translate(x,x,z)
	. else  if r=59 set ignore=$translate(x,x,"xyz")
	. else  if r=60 set ignore=$translate(x,x,"young")
	. else  if r=61 set ignore=$translate(x,x,"zebra")
	. else  if r=62 set ignore=$translate(x,x,abc)
	. else  if r=63 set ignore=$translate(x,y,x)
	. else  if r=64 set ignore=$translate(x,y,y)
	. else  if r=65 set ignore=$translate(x,y,z)
	. else  if r=66 set ignore=$translate(x,y,"xyz")
	. else  if r=67 set ignore=$translate(x,y,"young")
	. else  if r=68 set ignore=$translate(x,y,"zebra")
	. else  if r=69 set ignore=$translate(x,y,abc)
	. else  if r=70 set ignore=$translate(x,z,x)
	. else  if r=71 set ignore=$translate(x,z,y)
	. else  if r=72 set ignore=$translate(x,z,z)
	. else  if r=73 set ignore=$translate(x,z,"xyz")
	. else  if r=74 set ignore=$translate(x,z,"young")
	. else  if r=75 set ignore=$translate(x,z,"zebra")
	. else  if r=76 set ignore=$translate(x,z,abc)
	. else  if r=77 set ignore=$translate(x,"xyz",x)
	. else  if r=78 set ignore=$translate(x,"xyz",y)
	. else  if r=79 set ignore=$translate(x,"xyz",z)
	. else  if r=80 set ignore=$translate(x,"xyz","xyz")
	. else  if r=81 set ignore=$translate(x,"xyz","young")
	. else  if r=82 set ignore=$translate(x,"xyz","zebra")
	. else  if r=83 set ignore=$translate(x,"xyz",abc)
	. else  if r=84 set ignore=$translate(x,"young",x)
	. else  if r=85 set ignore=$translate(x,"young",y)
	. else  if r=86 set ignore=$translate(x,"young",z)
	. else  if r=87 set ignore=$translate(x,"young","xyz")
	. else  if r=88 set ignore=$translate(x,"young","young")
	. else  if r=89 set ignore=$translate(x,"young","zebra")
	. else  if r=90 set ignore=$translate(x,"young",abc)
	. else  if r=91 set ignore=$translate(x,"zebra",x)
	. else  if r=92 set ignore=$translate(x,"zebra",y)
	. else  if r=93 set ignore=$translate(x,"zebra",z)
	. else  if r=94 set ignore=$translate(x,"zebra","xyz")
	. else  if r=95 set ignore=$translate(x,"zebra","young")
	. else  if r=96 set ignore=$translate(x,"zebra","zebra")
	. else  if r=97 set ignore=$translate(x,"zebra",abc)
	. else  if r=98 set ignore=$translate(x,abc,x)
	. else  if r=99 set ignore=$translate(x,abc,y)
	. else  if r=100 set ignore=$translate(x,abc,z)
	. else  if r=101 set ignore=$translate(x,abc,"xyz")
	. else  if r=102 set ignore=$translate(x,abc,"young")
	. else  if r=103 set ignore=$translate(x,abc,"zebra")
	. else  if r=104 set ignore=$translate(x,abc,abc)
	. else  if r=105 set ignore=$translate(y,x,x)
	. else  if r=106 set ignore=$translate(y,x,y)
	. else  if r=107 set ignore=$translate(y,x,z)
	. else  if r=108 set ignore=$translate(y,x,"xyz")
	. else  if r=109 set ignore=$translate(y,x,"young")
	. else  if r=110 set ignore=$translate(y,x,"zebra")
	. else  if r=111 set ignore=$translate(y,x,abc)
	. else  if r=112 set ignore=$translate(y,y,x)
	. else  if r=113 set ignore=$translate(y,y,y)
	. else  if r=114 set ignore=$translate(y,y,z)
	. else  if r=115 set ignore=$translate(y,y,"xyz")
	. else  if r=116 set ignore=$translate(y,y,"young")
	. else  if r=117 set ignore=$translate(y,y,"zebra")
	. else  if r=118 set ignore=$translate(y,y,abc)
	. else  if r=119 set ignore=$translate(y,z,x)
	. else  if r=120 set ignore=$translate(y,z,y)
	. else  if r=121 set ignore=$translate(y,z,z)
	. else  if r=122 set ignore=$translate(y,z,"xyz")
	. else  if r=123 set ignore=$translate(y,z,"young")
	. else  if r=124 set ignore=$translate(y,z,"zebra")
	. else  if r=125 set ignore=$translate(y,z,abc)
	. else  if r=126 set ignore=$translate(y,"xyz",x)
	. else  if r=127 set ignore=$translate(y,"xyz",y)
	. else  if r=128 set ignore=$translate(y,"xyz",z)
	. else  if r=129 set ignore=$translate(y,"xyz","xyz")
	. else  if r=130 set ignore=$translate(y,"xyz","young")
	. else  if r=131 set ignore=$translate(y,"xyz","zebra")
	. else  if r=132 set ignore=$translate(y,"xyz",abc)
	. else  if r=133 set ignore=$translate(y,"young",x)
	. else  if r=134 set ignore=$translate(y,"young",y)
	. else  if r=135 set ignore=$translate(y,"young",z)
	. else  if r=136 set ignore=$translate(y,"young","xyz")
	. else  if r=137 set ignore=$translate(y,"young","young")
	. else  if r=138 set ignore=$translate(y,"young","zebra")
	. else  if r=139 set ignore=$translate(y,"young",abc)
	. else  if r=140 set ignore=$translate(y,"zebra",x)
	. else  if r=141 set ignore=$translate(y,"zebra",y)
	. else  if r=142 set ignore=$translate(y,"zebra",z)
	. else  if r=143 set ignore=$translate(y,"zebra","xyz")
	. else  if r=144 set ignore=$translate(y,"zebra","young")
	. else  if r=145 set ignore=$translate(y,"zebra","zebra")
	. else  if r=146 set ignore=$translate(y,"zebra",abc)
	. else  if r=147 set ignore=$translate(y,abc,x)
	. else  if r=148 set ignore=$translate(y,abc,y)
	. else  if r=149 set ignore=$translate(y,abc,z)
	. else  if r=150 set ignore=$translate(y,abc,"xyz")
	. else  if r=151 set ignore=$translate(y,abc,"young")
	. else  if r=152 set ignore=$translate(y,abc,"zebra")
	. else  if r=153 set ignore=$translate(y,abc,abc)
	. else  if r=154 set ignore=$translate(z,x,x)
	. else  if r=155 set ignore=$translate(z,x,y)
	. else  if r=156 set ignore=$translate(z,x,z)
	. else  if r=157 set ignore=$translate(z,x,"xyz")
	. else  if r=158 set ignore=$translate(z,x,"young")
	. else  if r=159 set ignore=$translate(z,x,"zebra")
	. else  if r=160 set ignore=$translate(z,x,abc)
	. else  if r=161 set ignore=$translate(z,y,x)
	. else  if r=162 set ignore=$translate(z,y,y)
	. else  if r=163 set ignore=$translate(z,y,z)
	. else  if r=164 set ignore=$translate(z,y,"xyz")
	. else  if r=165 set ignore=$translate(z,y,"young")
	. else  if r=166 set ignore=$translate(z,y,"zebra")
	. else  if r=167 set ignore=$translate(z,y,abc)
	. else  if r=168 set ignore=$translate(z,z,x)
	. else  if r=169 set ignore=$translate(z,z,y)
	. else  if r=170 set ignore=$translate(z,z,z)
	. else  if r=171 set ignore=$translate(z,z,"xyz")
	. else  if r=172 set ignore=$translate(z,z,"young")
	. else  if r=173 set ignore=$translate(z,z,"zebra")
	. else  if r=174 set ignore=$translate(z,z,abc)
	. else  if r=175 set ignore=$translate(z,"xyz",x)
	. else  if r=176 set ignore=$translate(z,"xyz",y)
	. else  if r=177 set ignore=$translate(z,"xyz",z)
	. else  if r=178 set ignore=$translate(z,"xyz","xyz")
	. else  if r=179 set ignore=$translate(z,"xyz","young")
	. else  if r=180 set ignore=$translate(z,"xyz","zebra")
	. else  if r=181 set ignore=$translate(z,"xyz",abc)
	. else  if r=182 set ignore=$translate(z,"young",x)
	. else  if r=183 set ignore=$translate(z,"young",y)
	. else  if r=184 set ignore=$translate(z,"young",z)
	. else  if r=185 set ignore=$translate(z,"young","xyz")
	. else  if r=186 set ignore=$translate(z,"young","young")
	. else  if r=187 set ignore=$translate(z,"young","zebra")
	. else  if r=188 set ignore=$translate(z,"young",abc)
	. else  if r=189 set ignore=$translate(z,"zebra",x)
	. else  if r=190 set ignore=$translate(z,"zebra",y)
	. else  if r=191 set ignore=$translate(z,"zebra",z)
	. else  if r=192 set ignore=$translate(z,"zebra","xyz")
	. else  if r=193 set ignore=$translate(z,"zebra","young")
	. else  if r=194 set ignore=$translate(z,"zebra","zebra")
	. else  if r=195 set ignore=$translate(z,"zebra",abc)
	. else  if r=196 set ignore=$translate(z,abc,x)
	. else  if r=197 set ignore=$translate(z,abc,y)
	. else  if r=198 set ignore=$translate(z,abc,z)
	. else  if r=199 set ignore=$translate(z,abc,"xyz")
	. else  if r=200 set ignore=$translate(z,abc,"young")
	. else  if r=201 set ignore=$translate(z,abc,"zebra")
	. else  if r=202 set ignore=$translate(z,abc,abc)
	. else  if r=203 set ignore=$translate("xyz",x,x)
	. else  if r=204 set ignore=$translate("xyz",x,y)
	. else  if r=205 set ignore=$translate("xyz",x,z)
	. else  if r=206 set ignore=$translate("xyz",x,"xyz")
	. else  if r=207 set ignore=$translate("xyz",x,"young")
	. else  if r=208 set ignore=$translate("xyz",x,"zebra")
	. else  if r=209 set ignore=$translate("xyz",x,abc)
	. else  if r=210 set ignore=$translate("xyz",y,x)
	. else  if r=211 set ignore=$translate("xyz",y,y)
	. else  if r=212 set ignore=$translate("xyz",y,z)
	. else  if r=213 set ignore=$translate("xyz",y,"xyz")
	. else  if r=214 set ignore=$translate("xyz",y,"young")
	. else  if r=215 set ignore=$translate("xyz",y,"zebra")
	. else  if r=216 set ignore=$translate("xyz",y,abc)
	. else  if r=217 set ignore=$translate("xyz",z,x)
	. else  if r=218 set ignore=$translate("xyz",z,y)
	. else  if r=219 set ignore=$translate("xyz",z,z)
	. else  if r=220 set ignore=$translate("xyz",z,"xyz")
	. else  if r=221 set ignore=$translate("xyz",z,"young")
	. else  if r=222 set ignore=$translate("xyz",z,"zebra")
	. else  if r=223 set ignore=$translate("xyz",z,abc)
	. else  if r=224 set ignore=$translate("xyz","xyz",x)
	. else  if r=225 set ignore=$translate("xyz","xyz",y)
	. else  if r=226 set ignore=$translate("xyz","xyz",z)
	. else  if r=227 set ignore=$translate("xyz","xyz","xyz")
	. else  if r=228 set ignore=$translate("xyz","xyz","young")
	. else  if r=229 set ignore=$translate("xyz","xyz","zebra")
	. else  if r=230 set ignore=$translate("xyz","xyz",abc)
	. else  if r=231 set ignore=$translate("xyz","young",x)
	. else  if r=232 set ignore=$translate("xyz","young",y)
	. else  if r=233 set ignore=$translate("xyz","young",z)
	. else  if r=234 set ignore=$translate("xyz","young","xyz")
	. else  if r=235 set ignore=$translate("xyz","young","young")
	. else  if r=236 set ignore=$translate("xyz","young","zebra")
	. else  if r=237 set ignore=$translate("xyz","young",abc)
	. else  if r=238 set ignore=$translate("xyz","zebra",x)
	. else  if r=239 set ignore=$translate("xyz","zebra",y)
	. else  if r=240 set ignore=$translate("xyz","zebra",z)
	. else  if r=241 set ignore=$translate("xyz","zebra","xyz")
	. else  if r=242 set ignore=$translate("xyz","zebra","young")
	. else  if r=243 set ignore=$translate("xyz","zebra","zebra")
	. else  if r=244 set ignore=$translate("xyz","zebra",abc)
	. else  if r=245 set ignore=$translate("xyz",abc,x)
	. else  if r=246 set ignore=$translate("xyz",abc,y)
	. else  if r=247 set ignore=$translate("xyz",abc,z)
	. else  if r=248 set ignore=$translate("xyz",abc,"xyz")
	. else  if r=249 set ignore=$translate("xyz",abc,"young")
	. else  if r=250 set ignore=$translate("xyz",abc,"zebra")
	. else  if r=251 set ignore=$translate("xyz",abc,abc)
	. else  if r=252 set ignore=$translate("young",x,x)
	. else  if r=253 set ignore=$translate("young",x,y)
	. else  if r=254 set ignore=$translate("young",x,z)
	. else  if r=255 set ignore=$translate("young",x,"xyz")
	. else  if r=256 set ignore=$translate("young",x,"young")
	. else  if r=257 set ignore=$translate("young",x,"zebra")
	. else  if r=258 set ignore=$translate("young",x,abc)
	. else  if r=259 set ignore=$translate("young",y,x)
	. else  if r=260 set ignore=$translate("young",y,y)
	. else  if r=261 set ignore=$translate("young",y,z)
	. else  if r=262 set ignore=$translate("young",y,"xyz")
	. else  if r=263 set ignore=$translate("young",y,"young")
	. else  if r=264 set ignore=$translate("young",y,"zebra")
	. else  if r=265 set ignore=$translate("young",y,abc)
	. else  if r=266 set ignore=$translate("young",z,x)
	. else  if r=267 set ignore=$translate("young",z,y)
	. else  if r=268 set ignore=$translate("young",z,z)
	. else  if r=269 set ignore=$translate("young",z,"xyz")
	. else  if r=270 set ignore=$translate("young",z,"young")
	. else  if r=271 set ignore=$translate("young",z,"zebra")
	. else  if r=272 set ignore=$translate("young",z,abc)
	. else  if r=273 set ignore=$translate("young","xyz",x)
	. else  if r=274 set ignore=$translate("young","xyz",y)
	. else  if r=275 set ignore=$translate("young","xyz",z)
	. else  if r=276 set ignore=$translate("young","xyz","xyz")
	. else  if r=277 set ignore=$translate("young","xyz","young")
	. else  if r=278 set ignore=$translate("young","xyz","zebra")
	. else  if r=279 set ignore=$translate("young","xyz",abc)
	. else  if r=280 set ignore=$translate("young","young",x)
	. else  if r=281 set ignore=$translate("young","young",y)
	. else  if r=282 set ignore=$translate("young","young",z)
	. else  if r=283 set ignore=$translate("young","young","xyz")
	. else  if r=284 set ignore=$translate("young","young","young")
	. else  if r=285 set ignore=$translate("young","young","zebra")
	. else  if r=286 set ignore=$translate("young","young",abc)
	. else  if r=287 set ignore=$translate("young","zebra",x)
	. else  if r=288 set ignore=$translate("young","zebra",y)
	. else  if r=289 set ignore=$translate("young","zebra",z)
	. else  if r=290 set ignore=$translate("young","zebra","xyz")
	. else  if r=291 set ignore=$translate("young","zebra","young")
	. else  if r=292 set ignore=$translate("young","zebra","zebra")
	. else  if r=293 set ignore=$translate("young","zebra",abc)
	. else  if r=294 set ignore=$translate("young",abc,x)
	. else  if r=295 set ignore=$translate("young",abc,y)
	. else  if r=296 set ignore=$translate("young",abc,z)
	. else  if r=297 set ignore=$translate("young",abc,"xyz")
	. else  if r=298 set ignore=$translate("young",abc,"young")
	. else  if r=299 set ignore=$translate("young",abc,"zebra")
	. else  if r=300 set ignore=$translate("young",abc,abc)
	. else  if r=301 set ignore=$translate("zebra",x,x)
	. else  if r=302 set ignore=$translate("zebra",x,y)
	. else  if r=303 set ignore=$translate("zebra",x,z)
	. else  if r=304 set ignore=$translate("zebra",x,"xyz")
	. else  if r=305 set ignore=$translate("zebra",x,"young")
	. else  if r=306 set ignore=$translate("zebra",x,"zebra")
	. else  if r=307 set ignore=$translate("zebra",x,abc)
	. else  if r=308 set ignore=$translate("zebra",y,x)
	. else  if r=309 set ignore=$translate("zebra",y,y)
	. else  if r=310 set ignore=$translate("zebra",y,z)
	. else  if r=311 set ignore=$translate("zebra",y,"xyz")
	. else  if r=312 set ignore=$translate("zebra",y,"young")
	. else  if r=313 set ignore=$translate("zebra",y,"zebra")
	. else  if r=314 set ignore=$translate("zebra",y,abc)
	. else  if r=315 set ignore=$translate("zebra",z,x)
	. else  if r=316 set ignore=$translate("zebra",z,y)
	. else  if r=317 set ignore=$translate("zebra",z,z)
	. else  if r=318 set ignore=$translate("zebra",z,"xyz")
	. else  if r=319 set ignore=$translate("zebra",z,"young")
	. else  if r=320 set ignore=$translate("zebra",z,"zebra")
	. else  if r=321 set ignore=$translate("zebra",z,abc)
	. else  if r=322 set ignore=$translate("zebra","xyz",x)
	. else  if r=323 set ignore=$translate("zebra","xyz",y)
	. else  if r=324 set ignore=$translate("zebra","xyz",z)
	. else  if r=325 set ignore=$translate("zebra","xyz","xyz")
	. else  if r=326 set ignore=$translate("zebra","xyz","young")
	. else  if r=327 set ignore=$translate("zebra","xyz","zebra")
	. else  if r=328 set ignore=$translate("zebra","xyz",abc)
	. else  if r=329 set ignore=$translate("zebra","young",x)
	. else  if r=330 set ignore=$translate("zebra","young",y)
	. else  if r=331 set ignore=$translate("zebra","young",z)
	. else  if r=332 set ignore=$translate("zebra","young","xyz")
	. else  if r=333 set ignore=$translate("zebra","young","young")
	. else  if r=334 set ignore=$translate("zebra","young","zebra")
	. else  if r=335 set ignore=$translate("zebra","young",abc)
	. else  if r=336 set ignore=$translate("zebra","zebra",x)
	. else  if r=337 set ignore=$translate("zebra","zebra",y)
	. else  if r=338 set ignore=$translate("zebra","zebra",z)
	. else  if r=339 set ignore=$translate("zebra","zebra","xyz")
	. else  if r=340 set ignore=$translate("zebra","zebra","young")
	. else  if r=341 set ignore=$translate("zebra","zebra","zebra")
	. else  if r=342 set ignore=$translate("zebra","zebra",abc)
	. else  if r=343 set ignore=$translate("zebra",abc,x)
	. else  if r=344 set ignore=$translate("zebra",abc,y)
	. else  if r=345 set ignore=$translate("zebra",abc,z)
	. else  if r=346 set ignore=$translate("zebra",abc,"xyz")
	. else  if r=347 set ignore=$translate("zebra",abc,"young")
	. else  if r=348 set ignore=$translate("zebra",abc,"zebra")
	. else  if r=349 set ignore=$translate("zebra",abc,abc)
	. else  if r=350 set ignore=$translate(abc,x,x)
	. else  if r=351 set ignore=$translate(abc,x,y)
	. else  if r=352 set ignore=$translate(abc,x,z)
	. else  if r=353 set ignore=$translate(abc,x,"xyz")
	. else  if r=354 set ignore=$translate(abc,x,"young")
	. else  if r=355 set ignore=$translate(abc,x,"zebra")
	. else  if r=356 set ignore=$translate(abc,x,abc)
	. else  if r=357 set ignore=$translate(abc,y,x)
	. else  if r=358 set ignore=$translate(abc,y,y)
	. else  if r=359 set ignore=$translate(abc,y,z)
	. else  if r=360 set ignore=$translate(abc,y,"xyz")
	. else  if r=361 set ignore=$translate(abc,y,"young")
	. else  if r=362 set ignore=$translate(abc,y,"zebra")
	. else  if r=363 set ignore=$translate(abc,y,abc)
	. else  if r=364 set ignore=$translate(abc,z,x)
	. else  if r=365 set ignore=$translate(abc,z,y)
	. else  if r=366 set ignore=$translate(abc,z,z)
	. else  if r=367 set ignore=$translate(abc,z,"xyz")
	. else  if r=368 set ignore=$translate(abc,z,"young")
	. else  if r=369 set ignore=$translate(abc,z,"zebra")
	. else  if r=370 set ignore=$translate(abc,z,abc)
	. else  if r=371 set ignore=$translate(abc,"xyz",x)
	. else  if r=372 set ignore=$translate(abc,"xyz",y)
	. else  if r=373 set ignore=$translate(abc,"xyz",z)
	. else  if r=374 set ignore=$translate(abc,"xyz","xyz")
	. else  if r=375 set ignore=$translate(abc,"xyz","young")
	. else  if r=376 set ignore=$translate(abc,"xyz","zebra")
	. else  if r=377 set ignore=$translate(abc,"xyz",abc)
	. else  if r=378 set ignore=$translate(abc,"young",x)
	. else  if r=379 set ignore=$translate(abc,"young",y)
	. else  if r=380 set ignore=$translate(abc,"young",z)
	. else  if r=381 set ignore=$translate(abc,"young","xyz")
	. else  if r=382 set ignore=$translate(abc,"young","young")
	. else  if r=383 set ignore=$translate(abc,"young","zebra")
	. else  if r=384 set ignore=$translate(abc,"young",abc)
	. else  if r=385 set ignore=$translate(abc,"zebra",x)
	. else  if r=386 set ignore=$translate(abc,"zebra",y)
	. else  if r=387 set ignore=$translate(abc,"zebra",z)
	. else  if r=388 set ignore=$translate(abc,"zebra","xyz")
	. else  if r=389 set ignore=$translate(abc,"zebra","young")
	. else  if r=390 set ignore=$translate(abc,"zebra","zebra")
	. else  if r=391 set ignore=$translate(abc,"zebra",abc)
	. else  if r=392 set ignore=$translate(abc,abc,x)
	. else  if r=393 set ignore=$translate(abc,abc,y)
	. else  if r=394 set ignore=$translate(abc,abc,z)
	. else  if r=395 set ignore=$translate(abc,abc,"xyz")
	. else  if r=396 set ignore=$translate(abc,abc,"young")
	. else  if r=397 set ignore=$translate(abc,abc,"zebra")
	. else  if r=398 set ignore=$translate(abc,abc,abc)
	quit

; We ignore the error and quit the current loop iteration so the next iteration occurs.

restart
	set $ecode=""
	quit