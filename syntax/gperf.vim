" Vim syntax file
" Language:	gperf
" Maintainer:	Jan Nowotsch
" Last Change:	Jan 10, 2015
" Version:	1

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C/C++ syntax to start with
let s:Cpath= fnameescape(expand("<sfile>:p:h").(exists("g:lex_uses_cpp")? "/cpp.vim" : "/c.vim"))
if !filereadable(s:Cpath)
 for s:Cpath in split(globpath(&rtp,(exists("g:lex_uses_cpp")? "syntax/cpp.vim" : "syntax/c.vim")),"\n")
  if filereadable(fnameescape(s:Cpath))
   let s:Cpath= fnameescape(s:Cpath)
   break
  endif
 endfor
endif
exe "syn include @gperfCcode ".s:Cpath

" --- ========= ---
" --- gperf stuff ---
" --- ========= ---

" keywords
syn match gperfDeclaration	'^%.\+' contained
syn match gperfKeyword		'^[^,:]\+[,:]' contained
syn match gperfComment		'^#.*$'

" sections
syn	region	gperfDeclarationBlock	start='.'ms=s-1,rs=s-1	matchgroup=gperfSep		end='^%%$'me=e-2,re=e-2	contains=gperfDeclaration,@gperfCcode nextgroup=gperfKeywordBlock	skipwhite skipempty
syn	region	gperfKeywordBlock		matchgroup=gperfSep	start='^%%$'				end='^%%$'me=e-2,re=e-2	contains=gperfKeyword,gperfComment nextgroup=gperfFunctions	skipwhite skipempty contained
syn	region	gperfFunctions			matchgroup=gperfSep	start='^%%$'				end='\%$'				contains=@gperfCcode contained




hi def link gperfDeclaration	mlblue
hi def link gperfKeyword		mlblue
hi def link gperfSep			TODO
hi def link gperfComment		mgreen

let b:current_syntax = "gperf"

" vim:ts=10
