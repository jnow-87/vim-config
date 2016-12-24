syn match heading "\s*\*\*\*.*"
syn match comment "^#.*"

hi def link heading mlblue
hi def link comment mblue

syn region section start="^\*\*\*" end="\n\*\*\* "me=s-1 transparent fold contains=subsection,heading
syn region subsection start="^\s\{1,}\*\*\* .*" end="\n\s*\*\*\* "me=s-1 transparent fold contained

setlocal commentstring=#%s
setlocal foldmethod=syntax
