" Vim syntax file
" Language:	GNU Assembler
" Last Change:	2016 Feb 21

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
endif

let b:current_syntax = "asm"

syntax sync ccomment cComment minlines=50

syntax cluster	asmAll				contains=asmComment,asmDirective,asmCode,cPreProc,cPreProcBlock,cPreProcIf0

" comments
syntax match	asmComment			"//.*" contains=cTODO
syntax region	asmComment			start="/\*" end="\*/" contains=cTODO

" . directives
syntax match	asmDirective		"\.[a-z][a-z]\+"

" x86 keywords
syntax keyword	asmCode				mov movsx movzx lea lar xchg xadd call ret retf retn inc dec add adc sub sbb imul idiv mul div neg sal sar shl shld shr shrd rol ror rcl rcr not and or xor bt bts btr btc bsf bsr clc stc cmc cld std cli sti lahf sahf clts salc pushf pushfw pushfd popf popfw popfd aaa daa aas das aad aam cbw cwd cwde cdq bswap push pop pusha pushaw pushad popa popaw popad enter leave test cmp cmpsb cmpsw cmpsd cmpxchg cmpxchg486 cmpxchg8b jmp jcc je jne ja jna jb jnb jae jnae jbe jnbe jg jng jl jnl jge jnge jle jnle jz jnz js jns jc jnc jo jno jp jnp jpe jpo jcxz jump-reg jecxz jump-reg loop loope loopne loopz loopnz movsb movsd movsw lodsb lodsw lodsd stosb stosw stosd scasb scasw scasd lds les lfs lgs lsl lss ltr hlt nop wait in insb insw insd out outsb outsw outsd cpuid lmsw int int01 int1 int03 int3 interrupt into invd invlpg iret iretd iretw lgdt lidt lldt sgdt sidt sldt fadd faddp fsub fsubp fsubr fsubrp fmul fmulp fdiv fdivp fdivr fdivrp fprem1 fprem fiadd fisub fisubr fimul fidiv fidivr fsqrt f2xm1 operation berechnen fyl2x fyl2xp1 fabs fchs fxtract fscale frndint fxam fsin fcos fsincos fptan fpatan fldz in fld1 konstante in fldpi fldl2e konstante in fldl2t konstante also zur in fldln2 konstante also zur fldlg2 konstante also zur in fld fild fst fstp fist fistp fisttp fbld zahl fbstp bcd. ftst vergleichen fcom fcomp fcompp fcomi fcomip ficom ficomp fucom fucomp fucompp fucomi fucomip fwait fnop finit fninit fsetpm fclex fnclex fstenv fnstenv fstsw fnstsw fstcw fnstcw fldcw fldenv fdisi fndisi feni fneni fincstp fdecstp fxch fsave fnsave frstor ffree ffreep fcmove fcmovne fcmovb fcmovnb fcmovbe fcmovnbe fcmovu fcmovnu addpd addps addsd addss addsubpd addsubps andnpd andnps andpd andps arpl bound clflush cmovcc cmpeqpd cmpeqps cmpeqsd cmpeqss cmplepd cmpleps cmplesd cmpless cmpltpd cmpltps cmpltsd cmpltss cmpneqpd cmpneqps cmpneqsd cmpneqss cmpnlepd cmpnleps cmpnlesd cmpnless cmpnltpd cmpnltps cmpnltsd cmpnltss cmpordpd cmpordps cmpordsd cmpordss cmppd cmpps cmpss cmpunordpd cmpunordps cmpunordsd cmpunordss comisd comiss cvtdq2pd cvtdq2ps cvtpd2dq cvtpd2pi cvtpd2ps cvtpi2pd cvtpi2ps cvtps2dq cvtps2pd cvtps2pi cvtsd2si cvtsd2ss cvtsi2sd cvtsi2ss cvtss2sd cvtss2si cvttpd2dq cvttpd2pi cvttps2dq cvttps2pi cvttsd2si cvttss2si db dd divpd divps divsd divss dq dt dw emms equ femms fxrstor fxsave haddpd haddps hsubpd hsubps ibts icebp incbin lddqu ldmxcsr lfence loadall loadall286 lock maskmovdqu maskmovq maxpd maxps maxsd maxss mfence minpd minps minsd minss monitor movapd movaps movd movd movddup movdq2q movdqa movdqu movhlps movhpd movhps movlhps movlpd movlps movmskpd movmskps movntdq movnti movntpd movntps movntq movq movq movq2dq movsd movshdup movsldup movss movupd movups mulpd mulps mulsd mulss mwait orpd orps packssdw packssdw packsswb packsswb packuswb packuswb paddb paddb paddd paddd paddq paddsb paddsb paddsiw paddsw paddsw paddusb paddusb paddusw paddusw paddw paddw pand pand pandn pandn pause paveb pavgb pavgb pavgusb pavgw pavgw pcmpeqb pcmpeqb pcmpeqd pcmpeqd pcmpeqw pcmpeqw pcmpgtb pcmpgtb pcmpgtd pcmpgtd pcmpgtw pcmpgtw pdistib pextrw pextrw pf2id pf2iw pfacc pfadd pfcmpeq pfcmpge pfcmpgt pfmax pfmin pfmul pfnacc pfpnacc pfrcp pfrcpit1 pfrcpit2 pfrsqit1 pfrsqrt pfsub pfsubr pi2fd pi2fw pinsrw pinsrw pmachriw pmaddwd pmaddwd pmagw pmaxsw pmaxsw pmaxub pmaxub pminsw pminsw pminub pminub pmovmskb pmovmskb pmulhriw pmulhrwa pmulhrwc pmulhuw pmulhuw pmulhw pmulhw pmullw pmullw pmuludq pmvgezb pmvlzb pmvnzb pmvzb por por prefetch prefetchnta prefetcht0 prefetcht1 prefetcht2 prefetchw psadbw psadbw pshufd pshufhw pshuflw pshufw pslld pslld pslldq psllq psllq psllw psllw psrad psrad psraw psraw psrld psrld psrldq psrlq psrlq psrlw psrlw psubb psubb psubd psubd psubq psubsb psubsb psubsiw psubsw psubsw psubusb psubusb psubusw psubusw psubw psubw pswapd punpckhbw punpckhbw punpckhdq punpckhdq punpckhqdq punpckhwd punpckhwd punpcklbw punpcklbw punpckldq punpckldq punpcklqdq punpcklwd punpcklwd pxor pxor rcpps rcpss rdmsr rdpmc rdshr rdtsc resb resd resq rest resw rsdc rsldt rsm rsqrtps rsqrtss rsts setcc sfence shufpd shufps smi smint smintold smsw sqrtpd sqrtps sqrtsd sqrtss stmxcsr str subpd subps subsd subss svdc svldt svts syscall sysenter sysexit sysret ucomisd ucomiss ud0 ud1 ud2 umov unpckhpd unpckhps unpcklpd unpcklps verr verw wbinvd wrmsr wrshr xbts xlat xlatb xorpd xorps xstore

" powerpc keywords
syntax keyword	asmCode				lis mullw mtspr mfspr mtsrr mtmsr lwarx stwcx bne sync isync lwsync mbar mulli addi lwz stw cmpw dcbf li b stb bgt lbepx lbz stbepx dnh mr sc bl mflr mtlr mfmsr mtsrr0 mtsrr1 mfsrr0 mfsrr1 mtcsrr0 mtcsrr1 mfcsrr0 mfcsrr1 mtmcsrr0 mtmcsrr1 mfmcsrr0 mfmcsrr1 rfi tlbwe tlbsync tlbivax tlbsx msgsnd msgclr cmpwi slwi srwi divwu blrl ba mfcr beq mfpmr mtpmr mfctr mfxer mtxer mtctr mtcr stwu rlwinm blr

" atmega keywords
syntax keyword	asmCode				add adc adiw sub subi sbc sbci and andi or ori eor com neg sbr cbr inc dec tst clr ser mul mus musu fmul fmuls fmuls des rjmp ijmp eijmp jmp rcall icall eicall call ret reti cpse cp cpc cpi sbrc sbrs sbic sbis brbs brbc breq brne brcs brcc brsh brlo brm brpl brge brlt brhs brhc brt brtc brvs brvc brie brid mov movw ldi lds ld ldd sts st std lpm elpm spm in out push pop xch las lac lat lsl lsr rol ror ast swap bset bclr sbi cbi bst bld sec clc sen cln sez clz sei cli ses cls sev clv set clt seh clh break nop sleep wdr

" TODO
syntax keyword	cTodo				TODO FIXME XXX NOTE contained

" C preprocessor
syntax region	cPreProc			display matchgroup=cPreProc start="^\s*\(%:\|#\)\s*include" end="$" end="//"me=s-1 end="/\*"me=s-1 transparent contains=None,cPreProc
syntax region	cPreProc			start="^\s*\(%:\|#\)\s*\(define\|undef\)\>"	skip="\\$" end="$" end="//"me=s-1 end="/\*"me=s-1 keepend fold
syntax region	cPreProc			start="^\s*\(%:\|#\)\s*\(pragma\|line\|warning\|warn\|error\)" skip="\\$" end="$" keepend
syntax match	cPreProc			"^\s*\(%:\|#\)\s*\(if\s\+\|ifdef\s\+\|ifndef\s\+\)"
syntax match	cPreProc			"^\s*\(%:\|#\)\s*\(else\|elif.\+\|endif\)"

" #if | #ifdef | #ifndef macro blocks with first line not ending on '_H'
syntax region	cPreProcBlock		matchgroup=cPreProc start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+[ \ta-zA-Z0-9!<>|&=_()]\+\([^_]H\|[^H]\)$" matchgroup=cPreProc end="^\s*\(%:\|#\)\s*endif" transparent contains=@asmAll fold
syntax region	cNonePreProcBlock	matchgroup=cPreProc start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+\S\+_H$" matchgroup=cPreProc end="^\s*\(%:\|#\)\s*endif" transparent contains=@asmAll
syntax region	cPreProcIf0			start="^\s*\(%:\|#\)\s*if\s*0" end="^\s*\(%:\|#\)\s*\(endif\|else\|elif\)" contains=None fold

" colors
hi def link asmCode					mblue
hi def link asmComment				mgreen
hi def link asmDirective			mblue
hi def link cPreProc				PreProc
hi def link cPreProcIf				PreProc
hi def link cInclude				mblue
