syn match heading "\s*\*\*\*.*"
syn match comment "^#.*"
syn keyword todo TODO XXX contained

syn cluster all contains=heading,comment,todo

hi def link heading mlblue
hi def link comment mblue
hi def link todo Todo

syn region section start="^\*\*\*" end="\n\*\*\* "me=s-1 transparent fold contains=subsection,@all
syn region subsection start="^\s\{1,}\*\*\* .*" end="\n\s*\*\*\* "me=s-1 transparent fold contained

setlocal commentstring=#%s
setlocal foldmethod=syntax
