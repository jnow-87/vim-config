" syntax file
" Language:	C
" Last Change:	2016 Feb 21

if exists("b:current_syntax")
  finish
endif

let g:c_fold_enabled = get(g:, "c_fold_enabled", 1)
let b:c_fold_enabled = get(b:, "c_fold_enabled", 1)

let b:current_syntax = "c"

" disable folding
if g:c_fold_enabled == 0 || b:c_fold_enabled == 0
	setlocal foldnestmax=0
endif

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
syntax keyword	cKeyword			goto goto_errno break return return_errno continue case default if else switch while for do
syntax keyword	cKeyword			sizeof typeof attribute __attribute__ 
syntax keyword	cKeyword			true false 
syntax keyword	cKeyword			struct union enum typedef
syntax keyword	cKeyword			int long short char void signed unsigned float double size_t ssize_t time_t va_list bool int8_t int16_t int32_t int64_t uint8_t uint16_t uint32_t uint64_t addr_t register_t intmax_t uintmax_t ptrdiff_t sptrdiff_t FILE
syntax keyword	cTodo				TODO FIXME XXX NOTE contained

" {}-block
syntax region	cBlock				start="{" end="}" transparent fold

" string
syntax match	cString				"'.'"
syntax region	cString				start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell

" comments
syntax region	cComment			start="//" skip="\\$" end="$" keepend contains=cTodo,@Spell
syntax match	cCommentHeading		" \(macros\|\(incomplete \)\?types\|prototypes\|local\/static prototypes\|\(external\|global\|static\) variables\|\(global\|local\) functions\) "
syntax region	cComment			matchgroup=cComment start="/\*" end="\*/" contains=cTodo,@Spell,cCommentHeading

" labels
syntax match	cUserLabel			display "^\zs[^ \/\t\:\"\']\+\s*\:\ze[^\:]*$"

" preprocessor
syntax region	cPreProc			display matchgroup=cPreProc start="^\s*\(%:\|#\)\s*include" end="$" end="//"me=s-1 transparent contains=None,cPreProc,cComment
syntax region	cPreProc			start="^\s*\(%:\|#\)\s*\(define\|undef\)\>"	skip="\\$" end="$" end="//"me=s-1 keepend fold contains=cComment
syntax region	cPreProc			start="^\s*\(%:\|#\)\s*\(pragma\|line\|warning\|warn\|error\)" skip="\\$" end="$" keepend
syntax match	cPreProc			"^\s*\(%:\|#\)\s*\(if\s\+\|ifdef\s\+\|ifndef\s\+\)" contains=cComment
syntax match	cPreProc			"^\s*\(%:\|#\)\s*\(else\|elif.\+\|endif\)" contains=cComment

" #if | #ifdef | #ifndef macro blocks with first line not ending on '_H'
syntax region	cPreProcBlock		matchgroup=cPreProc start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+[ \ta-zA-Z0-9!<>|&=_()]\+\([^_]H\|[^H]\)$" matchgroup=cPreProc end="^\s*\(%:\|#\)\s*endif" transparent contains=@cAll,@cppAll fold
syntax region	cNonePreProcBlock	matchgroup=cPreProc start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+\S\+_H$" matchgroup=cPreProc end="^\s*\(%:\|#\)\s*endif" transparent contains=@cAll,@cppAll
syntax region	cPreProcIf0			start="^\s*\(%:\|#\)\s*if\s*0" end="^\s*\(%:\|#\)\s*\(endif\|else\|elif\)" contains=None fold

" inline assembly
syntax region	asmBlock			matchgroup=cKeyword start="\(asm\|__asm__\)" matchgroup=None end=")" contains=cKeyword,cComment,cPreProcBlock,asmTemplate,asmArgs
syntax region	asmTemplate			start='"' end='"' skip='\\"' contained contains=asmArgRef,@asmCode
syntax region	asmArgs				start="\s*:\s*" end=");"me=e-2 contained contains=asmArgRefName,asmArgString,asmArgValue,cComment transparent
syntax match	asmArgRef			"%\d*" contained
syntax match	asmArgRef			"%[a-z]\{0,1}[\[{][a-zA-Z0-9_]*[\]}]" contained
syntax match	asmArgRefName		"\[[a-zA-Z0-9_]*\]" contained
syntax match	asmArgString		'"\([ib]\|=m\|[+=]\?r\d*\|cr\d*\|memory\|cc\|[a-z]\)"' contained
syntax match	asmArgValue			"([^)]*)" contained contains=cKeyword

" colors
hi def link cComment				mgreen
hi def link cCommentHeading			mgreenHeading
hi def link cUserLabel				mblue
hi def link cPreProc				PreProc
hi def link cPreProcIf0				PreProc
hi def link cKeyword				mblue
hi def link cString					mdefit
hi def link cTodo					Todo
hi def link asmArgString			mpurple
hi def link asmArgRef				mlblue
hi def link asmArgRefName			mlblue
