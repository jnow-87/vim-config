syn match heading "\s*\*\*\*.*"
syn match comment "^#.*"

hi def link heading mlblue
hi def link comment mblue

setlocal commentstring=#%s
