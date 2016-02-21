" syntax file
" Language:	C
" Last Change:	2016 Feb 21

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "c"

" read asm syntax file
let s:asm_path= fnameescape(expand("<sfile>:p:h")."/asm.vim")
if !filereadable(s:asm_path)
	for s:asm_path in split(globpath(&rtp,"syntax/asm.vim"),"\n")
		if filereadable(fnameescape(s:asm_path))
			let s:asm_path= fnameescape(s:asm_path)
			break
		endif
	endfor
endif

exe "syntax include @asmCode " . s:asm_path

syntax sync ccomment cComment minlines=50

syntax cluster	cAll				contains=cKeyword,cBlock,cString,cComment,cUserLabel,asmBlock,cPreProc,cPreProcBlock,cPreProcIf0

" keywords
syntax keyword	cKeyword			static register auto extern const inline restrict volatile __volatile__
syntax keyword	cKeyword			goto break return continue case default if else switch while for do
syntax keyword	cKeyword			asm __asm__ contained
syntax keyword	cKeyword			sizeof typeof attribute __attribute__ 
syntax keyword	cKeyword			true false 
syntax keyword	cKeyword			struct union enum typedef
syntax keyword	cKeyword			int long short char void signed unsigned float double size_t time_t va_list bool int8_t int16_t int32_t int64_t uint8_t uint16_t uint32_t uint64_t addr_t register_t
syntax keyword	cTodo				TODO FIXME XXX contained

" {}-block
syntax region	cBlock				start="{" end="}" transparent fold

" string
syntax region	cString				start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell

" comments
syntax region	cComment			start="//" skip="\\$" end="$" keepend contains=cTodo,@Spell
syntax region	cComment			matchgroup=cComment start="/\*" end="\*/" contains=cTodo,@Spell fold

" labels
syntax match	cUserLabel			display "^\zs\s*[^ \t\:]\+\s*\:\ze[^\:]*$"

" preprocessor
syntax region	cPreProc			display matchgroup=cPreProc start="^\s*\(%:\|#\)\s*include" end="$" end="//"me=s-1 transparent contains=None,cPreProc
syntax region	cPreProc			start="^\s*\(%:\|#\)\s*\(define\|undef\)\>"	skip="\\$" end="$" end="//"me=s-1 keepend fold
syntax region	cPreProc			start="^\s*\(%:\|#\)\s*\(pragma\|line\|warning\|warn\|error\)" skip="\\$" end="$" keepend
syntax match	cPreProc			"^\s*\(%:\|#\)\s*\(if\s\+\|ifdef\s\+\|ifndef\s\+\)"
syntax match	cPreProc			"^\s*\(%:\|#\)\s*\(else\|elif.\+\|endif\)"

" #if | #ifdef | #ifndef macro blocks with first line not ending on '_H'
syntax region	cPreProcBlock		matchgroup=cPreProc start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+[ \ta-zA-Z0-9=_]\+\([^_]H\|[^H]\)$" matchgroup=cPreProc end="^\s*\(%:\|#\)\s*endif" transparent contains=@cAll fold
syntax region	cNonePreProcBlock	matchgroup=cPreProc start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+\S\+_H$" matchgroup=cPreProc end="^\s*\(%:\|#\)\s*endif" transparent contains=@cAll
syntax region	cPreProcIf0			start="^\s*\(%:\|#\)\s*if\s*0" end="^\s*\(%:\|#\)\s*\(endif\|else\|elif\)" contains=None fold

" inline assembly
syntax region	asmBlock			start="asm\s*[\(volatile\|goto\)]*\s*(" end=")" contains=cKeyword,cComment,cPreProcBlock,asmTemplate,asmArgs transparent
syntax region	asmTemplate			start='"' end='"' skip='\\"' contained contains=asmArgRef,@asmCode
syntax region	asmArgs				start="\s*:\s*" end=")"me=e-1 contained contains=asmArgRefName,asmArgString,asmArgValue transparent
syntax match	asmArgRef			"%\d*"
syntax match	asmArgRef			"%[\[{][a-zA-Z0-9_]*[\]}]"
syntax match	asmArgRefName		"\[[a-zA-Z0-9_]*\]" contained
syntax match	asmArgString		'"\([ib]\|=m\|=\?r\d*\|cr\d*\|memory\|cc\)"' contained
syntax match	asmArgValue			"([^)]*)" contained contains=cKeyword

" colors
hi def link cComment				mgreen
hi def link cUserLabel				mblue
hi def link cPreProc				mblue
hi def link cPreProcS				mblue
hi def link cPreProcIf0				mblue
hi def link cKeyword				mblue
hi def link cString					white
hi def link cTodo					Todo
hi def link asmArgString			mlblue
hi def link asmArgRef				mlblue
hi def link asmArgRefName			mlblue
