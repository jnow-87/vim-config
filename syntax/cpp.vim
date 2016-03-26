" Vim syntax file
" Language:	C++
" Last Change:	2016 Feb 21

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
  so <sfile>:p:h/c.vim

elseif exists("b:current_syntax")
  finish

else
  runtime! syntax/c.vim
  unlet b:current_syntax

endif

let b:current_syntax = "cpp"

" C++ extentions
syn keyword	cppKeyword	new delete this friend using public protected private virtual explicit export throw try catch operator typeid mutable class typename template namespace "[<>]?"
syn keyword	cppKeyword	 "\<\(const\|static\|dynamic\|reinterpret\)_cast\s*<"me=e-1" "\<\(const\|static\|dynamic\|reinterpret\)_cast\s*$"
syn region	cCppString	start=+'+ skip=+\\\\\|\\"\|\\$+ excludenl end=+'+ contains=@Spell
syn region	cCppString	start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ contains=@Spell

" colors
hi def link 	cppKeyword 	mblue
