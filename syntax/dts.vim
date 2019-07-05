if exists("b:current_syntax")
	syntax clear
endif

setlocal foldnestmax=3
setlocal foldmethod=syntax

syn cluster dts_all contains=dts_block,dts_sec,dts_key,dts_string,dts_identifier,dts_comment

syn keyword dts_sec memory driver

syn keyword dts_key	reg baseaddr compatible size contained
syn keyword dts_key int nextgroup=dts_width contained

syn region dts_block start="{" end="}" fold transparent contains=@dts_all
syn region dts_string start=+L\="+ skip=+\\\\\|\\"+ end=+"+
syn region dts_comment start="//" skip="\\$" end="$"
syn region dts_comment start="/\*" end="\*/"
syn match dts_width "\s*<[0-9]\+>" contained
syn match dts_identifier "[0-9a-zA-Z_-]\+\ze\s*=\s*{"


hi def link dts_sec			mpurple
hi def link dts_key			mblue
hi def link dts_width		mlblue
hi def link dts_identifier	mlblue
hi def link dts_string		white
hi def link dts_comment		mgreen

let b:current_syntax = "dts"
