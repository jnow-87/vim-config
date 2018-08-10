" syntax file
" Language:	Lauterbach practice (cmm)
" Last Change:	2018 Jul 09

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "cmm"

" keywords
syntax keyword	pKeyword			do go gosub return enddo if else repeat while entry local private global
syntax keyword	pKeyword			DO GO GOSUB RETURN ENDDO IF ELSE REPEAT WHILE ENTRY LOCAL PRIVATE GLOBAL
syntax keyword	pTodo				TODO FIXME XXX NOTE contained

" macros
syntax match	pMacro				'&[a-zA-Z0-9_]\+'

" stirngs
syntax region	pString				start=+L\="+ skip=+\\\\\|\\"+ end=+"+

" comments
syntax region	pComment			start=";" end="$" keepend contains=pTodo
syntax region	pComment			start="//" end="$" keepend contains=pTodo


" colors
hi def link	pKeyword				mblue
hi def link	pComment				mgreen
hi def link	pMacro					mlblue
hi def link	pString					mdefit
hi def link	pTodo					Todo
