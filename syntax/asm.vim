" Vim syntax file
" Language:	GNU Assembler
" Maintainer:	Kevin Dahlhausen <kdahlhaus@yahoo.com>
" Last Change:	2002 Sep 19

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
endif

syn case ignore


" storage types
syn match asmType "\.long"
syn match asmType "\.ascii"
syn match asmType "\.asciz"
syn match asmType "\.byte"
syn match asmType "\.double"
syn match asmType "\.float"
syn match asmType "\.hword"
syn match asmType "\.int"
syn match asmType "\.octa"
syn match asmType "\.quad"
syn match asmType "\.short"
syn match asmType "\.single"
syn match asmType "\.space"
syn match asmType "\.string"
syn match asmType "\.word"

syn match asmLabel		"[a-z_][a-z0-9_]*:"he=e-1
syn match asmIdentifier		"[a-z_][a-z0-9_]*"

" Various #'s as defined by GAS ref manual sec 3.6.2.1
" Technically, the first decNumber def is actually octal,
" since the value of 0-7 octal is the same as 0-7 decimal,
" I prefer to map it as decimal:
syn match decNumber		"0\+[1-7]\=[\t\n$,; ]"
syn match decNumber		"[1-9]\d*"
syn match octNumber		"0[0-7][0-7]\+"
syn match hexNumber		"0[xX][0-9a-fA-F]\+"
syn match binNumber		"0[bB][0-1]*"


syn match asmSpecialComment	";\*\*\*.*"
syn match asmComment		";.*"
syn match asmComment		"//.*"
syn region asmComment	start="/\*" end="\*/"

syn match asmInclude	"\.include"
syn match asmCond		"\.if"
syn match asmCond		"\.else"
syn match asmCond		"\.endif"
syn match asmMacro		"\.macro"
syn match asmMacro		"\.endm"
syn match asmMacro		"#define.*"
syn match asmMacro		"#include"

syn match asmDirective		"\.[a-z][a-z]\+"
syn keyword asmCode mov movsx movzx lea lar xchg xadd call ret retf retn inc dec add adc sub sbb imul idiv mul div neg sal sar shl shld shr shrd rol ror rcl rcr not and or xor bt bts btr btc bsf bsr clc stc cmc cld std cli sti lahf sahf clts salc pushf pushfw pushfd popf popfw popfd aaa daa aas das aad aam cbw cwd cwde cdq bswap push pop pusha pushaw pushad popa popaw popad enter leave test cmp cmpsb cmpsw cmpsd cmpxchg cmpxchg486 cmpxchg8b jmp jcc je jne ja jna jb jnb jae jnae jbe jnbe jg jng jl jnl jge jnge jle jnle jz jnz js jns jc jnc jo jno jp jnp jpe jpo jcxz jump-reg jecxz jump-reg loop loope loopne loopz loopnz movsb movsd movsw lodsb lodsw lodsd stosb stosw stosd scasb scasw scasd lds les lfs lgs lsl lss ltr hlt nop wait in insb insw insd out outsb outsw outsd cpuid lmsw int int01 int1 int03 int3 interrupt into invd invlpg iret iretd iretw lgdt lidt lldt sgdt sidt sldt fadd faddp fsub fsubp fsubr fsubrp fmul fmulp fdiv fdivp fdivr fdivrp fprem1 fprem fiadd fisub fisubr fimul fidiv fidivr fsqrt f2xm1 operation berechnen fyl2x fyl2xp1 fabs fchs fxtract fscale frndint fxam fsin fcos fsincos fptan fpatan fldz in fld1 konstante in fldpi fldl2e konstante in fldl2t konstante also zur in fldln2 konstante also zur fldlg2 konstante also zur in fld fild fst fstp fist fistp fisttp fbld zahl fbstp bcd. ftst vergleichen fcom fcomp fcompp fcomi fcomip ficom ficomp fucom fucomp fucompp fucomi fucomip fwait fnop finit fninit fsetpm fclex fnclex fstenv fnstenv fstsw fnstsw fstcw fnstcw fldcw fldenv fdisi fndisi feni fneni fincstp fdecstp fxch fsave fnsave frstor ffree ffreep fcmove fcmovne fcmovb fcmovnb fcmovbe fcmovnbe fcmovu fcmovnu addpd addps addsd addss addsubpd addsubps andnpd andnps andpd andps arpl bound clflush cmovcc cmpeqpd cmpeqps cmpeqsd cmpeqss cmplepd cmpleps cmplesd cmpless cmpltpd cmpltps cmpltsd cmpltss cmpneqpd cmpneqps cmpneqsd cmpneqss cmpnlepd cmpnleps cmpnlesd cmpnless cmpnltpd cmpnltps cmpnltsd cmpnltss cmpordpd cmpordps cmpordsd cmpordss cmppd cmpps cmpss cmpunordpd cmpunordps cmpunordsd cmpunordss comisd comiss cvtdq2pd cvtdq2ps cvtpd2dq cvtpd2pi cvtpd2ps cvtpi2pd cvtpi2ps cvtps2dq cvtps2pd cvtps2pi cvtsd2si cvtsd2ss cvtsi2sd cvtsi2ss cvtss2sd cvtss2si cvttpd2dq cvttpd2pi cvttps2dq cvttps2pi cvttsd2si cvttss2si db dd divpd divps divsd divss dq dt dw emms equ femms fxrstor fxsave haddpd haddps hsubpd hsubps ibts icebp incbin lddqu ldmxcsr lfence loadall loadall286 lock maskmovdqu maskmovq maxpd maxps maxsd maxss mfence minpd minps minsd minss monitor movapd movaps movd movd movddup movdq2q movdqa movdqu movhlps movhpd movhps movlhps movlpd movlps movmskpd movmskps movntdq movnti movntpd movntps movntq movq movq movq2dq movsd movshdup movsldup movss movupd movups mulpd mulps mulsd mulss mwait orpd orps packssdw packssdw packsswb packsswb packuswb packuswb paddb paddb paddd paddd paddq paddsb paddsb paddsiw paddsw paddsw paddusb paddusb paddusw paddusw paddw paddw pand pand pandn pandn pause paveb pavgb pavgb pavgusb pavgw pavgw pcmpeqb pcmpeqb pcmpeqd pcmpeqd pcmpeqw pcmpeqw pcmpgtb pcmpgtb pcmpgtd pcmpgtd pcmpgtw pcmpgtw pdistib pextrw pextrw pf2id pf2iw pfacc pfadd pfcmpeq pfcmpge pfcmpgt pfmax pfmin pfmul pfnacc pfpnacc pfrcp pfrcpit1 pfrcpit2 pfrsqit1 pfrsqrt pfsub pfsubr pi2fd pi2fw pinsrw pinsrw pmachriw pmaddwd pmaddwd pmagw pmaxsw pmaxsw pmaxub pmaxub pminsw pminsw pminub pminub pmovmskb pmovmskb pmulhriw pmulhrwa pmulhrwc pmulhuw pmulhuw pmulhw pmulhw pmullw pmullw pmuludq pmvgezb pmvlzb pmvnzb pmvzb por por prefetch prefetchnta prefetcht0 prefetcht1 prefetcht2 prefetchw psadbw psadbw pshufd pshufhw pshuflw pshufw pslld pslld pslldq psllq psllq psllw psllw psrad psrad psraw psraw psrld psrld psrldq psrlq psrlq psrlw psrlw psubb psubb psubd psubd psubq psubsb psubsb psubsiw psubsw psubsw psubusb psubusb psubusw psubusw psubw psubw pswapd punpckhbw punpckhbw punpckhdq punpckhdq punpckhqdq punpckhwd punpckhwd punpcklbw punpcklbw punpckldq punpckldq punpcklqdq punpcklwd punpcklwd pxor pxor rcpps rcpss rdmsr rdpmc rdshr rdtsc resb resd resq rest resw rsdc rsldt rsm rsqrtps rsqrtss rsts setcc sfence shufpd shufps smi smint smintold smsw sqrtpd sqrtps sqrtsd sqrtss stmxcsr str subpd subps subsd subss svdc svldt svts syscall sysenter sysexit sysret ucomisd ucomiss ud0 ud1 ud2 umov unpckhpd unpckhps unpcklpd unpcklps verr verw wbinvd wrmsr wrshr xbts xlat xlatb xorpd xorps xstore

syn keyword asmDirective global section
syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_asm_syntax_inits")
  if version < 508
    let did_asm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink asmCode 	mblue
  HiLink asmSection	mblue
  HiLink asmLabel	normal
  HiLink asmComment	mgreen
  HiLink asmDirective	mblue

  HiLink asmInclude	mblue
  HiLink asmCond	mblue
  HiLink asmMacro	mblue

  HiLink hexNumber	normal
  HiLink decNumber	normal
  HiLink octNumber	normal
  HiLink binNumber	normal

  HiLink asmSpecialComment Type
  HiLink asmIdentifier normal
  HiLink asmType	mblue

  " My default color overrides:
  " hi asmSpecialComment ctermfg=red
  " hi asmIdentifier ctermfg=lightcyan
  " hi asmType ctermbg=black ctermfg=brown

  delcommand HiLink
endif

let b:current_syntax = "asm"

" vim: ts=8
