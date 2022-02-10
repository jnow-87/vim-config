if exists("g:loaded_vimrc")
    finish
endif

let g:loaded_vimrc = 1

" get own script ID
nmap <c-f11><c-f12><c-f13> <sid>
let s:sid = "<SNR>" . maparg("<c-f11><c-f12><c-f13>", "n", 0, 1).sid . "_"
nunmap <c-f11><c-f12><c-f13>

"""""""""""""""
" vim general "
"""""""""""""""
"{{{
""""
"" options
""""
"{{{
let &term='xterm-256color'
runtime! debian.vim
filetype plugin on
syntax on
set nocp
set viminfo+=n/tmp/viminfo.$USER
set showcmd
set ignorecase
set smartcase
set incsearch
set mouse=ni
set number
set numberwidth=2
set norelativenumber
set ai
set noexpandtab
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set complete=.,w,b,u,t,i
"set complete+=kspell
set completeopt=menuone,longest,noselect
set pumheight=10
set conceallevel=3
set concealcursor=vinc
set spelllang=de,en
set spellfile=~/.vim/spell/vimspell.add
set tabpagemax=100
set dir=/tmp
set path=.,/usr/include,/usr/include/linux
set updatetime=1000
set wildmode=list:longest
set foldtext=Foldtext()
set splitright
set splitbelow
set noequalalways

let mapleader = '\'
set fillchars=vert:\│
"}}}

""""
"" autocmds
""""
"{{{
" enable color column
autocmd	FileType text setlocal colorcolumn=80 | setlocal foldnestmax=2
autocmd	FileType gitcommit setlocal colorcolumn=80 | setlocal tabstop=4

" line wrap for vimdiff
autocmd	VimEnter * if &diff | execute 'windo set wrap' | endif

" add filetype extensions
autocmd	BufRead,BufNewFile *.lds			setfiletype ld
autocmd	BufRead,BufNewFile *.gperf			setfiletype gperf
autocmd	BufRead,BufNewFile *.per			setfiletype per
autocmd	BufRead,BufNewFile pconfig,Pconfig	setfiletype kconfig
autocmd	BufRead,BufNewFile *.make			setfiletype make

" default filetype to text
autocmd BufRead,BufNewFile *.cmm			set filetype=cmm
autocmd	BufRead,BufNewFile *				if &filetype == '' | setfiletype text | endif

" window dimensions
autocmd	VimEnter	* :call s:win_dimensions()
autocmd	VimResized	* :call s:win_dimensions()
"}}}
"}}}

"""""""""""""
" functions "
"""""""""""""
"{{{
" set certain window dimensions, depending on vim size
function s:win_dimensions()
	let g:scratchWinWidth = (&columns/5 <= 20) ? 20 : &columns/5
	let g:makeWinHeight = (&window/5) <= 7 ? 7 : &window/5
endfunction

" brief	add command alias for 'exe'-mode commands
function s:cabbrev(abbrev, expansion)
	exec 'cabbr ' . a:abbrev . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbrev . '"<CR>'
endfunction

" echo syntax highlighting groups that apply to pattern under cursor
function s:syn_stack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
	echo "hi: " . synIDattr(synID(line("."),col("."),1),"name") . ', trans: ' . synIDattr(synID(line("."),col("."),0),"name") . ", lo: " . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
endfunc

" enable spell checking and move between bad words
function s:spell_ctrl(dir)
	if &spell == 0
		set spell
	else
		if a:dir == 'f'
			normal ]s
		else
			normal [s
		endif
	endif
endfunction

" generate string for folded lines
function Foldtext()
	let nlines = v:foldend - v:foldstart + 1
	let s_lines = printf("%10s", nlines . ' lines')

	let i = 0

	" iterate through folded lines until a line with alpha characters is found
	while 1
		let s_line = getline(v:foldstart + i)
		let i += 1

		let s = -1
		let e = -1
		let j = 0

		while s_line[j] != ''
			" look for start of alpha string ([a-zA-Z#]
			if (s_line[j] >= 'a' && s_line[j] <= 'z') ||  (s_line[j] >= 'A' && s_line[j] <= 'Z') || s_line[j] == '#'
				let s = j

 				while 1
					" look for end of string
					if s_line[j] == '{' || s_line[j] == '}' || s_line[j] == '\\' || s_line[j] == ''
						let e = j
						break
					endif

					let j += 1
				endwhile

				break
			endif

			let j += 1
		endwhile

		if s != -1
			" break if a valid line has been found
			let s_line = strpart(s_line, s, e - s)
			break

		elseif i > nlines
			" break if no more lines are available
			break
		endif
	endwhile

	let foldtextlength = strlen(s_line) + strlen(s_lines) + &foldcolumn

	return s_line . repeat(' ', winwidth(0) - foldtextlength - 8) . s_lines . "        "
endfunction


let s:nline_indicator = [ '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' ]
let s:nline_indicator_len = len(s:nline_indicator)

" return a string indicating the position within the current file
" string characters are taken from nline_indicator
function Nline_indicator()
	let s = ""
	let i = 0

	" determine number of indicator elements to display
	let x = s:nline_indicator_len * line('.') / line('$') + 1
	
	if x > s:nline_indicator_len
		let x = s:nline_indicator_len
	endif

	" copy required number of elements to string
	while i < x
		let s .= s:nline_indicator[i]
		let i += 1
	endwhile

	return s
endfunction

" return string indicating the total number of search pattern matches
" and the index of the current match
" if search highlighting is off the string is blank
function! Search_index()
	let query = @/
    let total = 0
	let winview = winsaveview()
	let line = winview['lnum']
	let col = winview['col'] + 1

	" exit if
	" 	search highlight is not enabled or
	" 	file is too long
	if(&hls == 0 || line('$') > 100000)
		return ''
	endif

	" get existing search cache or initialise it
	let b:search_query = get(b:, 'search_query', "")
	let b:search_total = get(b:, 'search_total', "")
	let b:search_match = get(b:, 'search_match', {})

	" update search cache if the search pattern has changed
	if(query != b:search_query)
		let b:search_match = {}

		" get first match in buffer
		call cursor(1, 1)
		let [match_line, match_col] = searchpos(query, 'Wc')

		" iterate through matches
		while match_line
			let total += 1
			let b:search_match[match_line . ',' . match_col] = total

			" get next search result
			let [match_line, match_col] = searchpos(query, 'W')
		endwhile

		let b:search_total = total
		let b:search_query = query

		" restore window view
		call winrestview(winview)
	endif

	" get data from search cache
	let total = b:search_total
	let exact = '-'

	if(has_key(b:search_match, line . ',' . col))
		let exact = b:search_match[line . ',' . col]
	endif

	" return string
    return exact . '/' . total . '  '
endfunction
"}}}

"""""""""""""""""""""""
" syntax highlighting "
"""""""""""""""""""""""
"{{{
colorscheme default

highlight	mdefit			cterm=italic
highlight	mred			ctermfg=124
highlight	mlblue			ctermfg=6
highlight	mblue			ctermfg=27
highlight	PreProc			ctermfg=24
highlight	mgreen			ctermfg=22
highlight	mgreenHeading	ctermfg=29
highlight	morange			ctermfg=202
highlight	mpurple			ctermfg=56
highlight	Error			ctermfg=255 ctermbg=88
highlight	ErrorMsg		ctermfg=255 ctermbg=88
highlight	Comment			ctermfg=27
highlight	LineNr			ctermfg=88
highlight	Search			ctermfg=0 ctermbg=1
highlight	Pmenu			ctermfg=255 ctermbg=24
highlight	PmenuSel		ctermfg=255 ctermbg=236
highlight	SpellBad		ctermfg=7 ctermbg=88
highlight	SpellCap		ctermfg=7 ctermbg=21
highlight	SpellLocal		ctermfg=7 ctermbg=57
highlight	Visual			ctermfg=7 ctermbg=237
highlight	DiffAdd			ctermbg=28
highlight	DiffChange		ctermbg=33
highlight	DiffDelete		ctermbg=88
highlight	DiffText		ctermbg=1, ctermfg=15
highlight	MatchParen		ctermbg=88
highlight	ColorColumn		ctermbg=235
highlight	SignColumn		ctermbg=0
highlight	VertSplit		ctermbg=0 ctermfg=236 cterm=None
highlight	Folded			ctermfg=242 ctermbg=234
highlight	ExtraWhitespace	ctermbg=236

" match extra whitespaces
autocmd	FileType c,cpp,asm match ExtraWhitespace	"\( \+$\)\|\(^\zs \+\ze[^ \*]\+\)\|\([^\t]\+\zs\t\+\ze$\)"

" config
let g:syntax_c_fold_comment = 0
let sh_fold_enabled = 1
let yacc_uses_cpp = 1
let lex_uses_cpp = 1
"}}}

"""""""""""""""""
" plugin config "
"""""""""""""""""
"{{{
""""
"" be-complete
""""
"{{{
let g:becomplete_complete_fallback = "<c-n>"
let g:becomplete_complete_fallback_on_empty = 1

let g:becomplete_goto_menu_always = 1
let g:becomplete_goto_default = "tab"
let g:becomplete_goto_preview_width = max([ &columns / 5, 40 ])

let g:becomplete_kindsym_undef = "⁇"
let g:becomplete_kindsym_type = "t"
let g:becomplete_kindsym_namespace = "::"
let g:becomplete_kindsym_function = "Σ"
let g:becomplete_kindsym_specialfunction = "~"
let g:becomplete_kindsym_member = "."
let g:becomplete_kindsym_variable = "v"
let g:becomplete_kindsym_macro = "d"
let g:becomplete_kindsym_file = "⛁"
let g:becomplete_kindsym_text = "፸"

let g:becomplete_type_declaration = "dcl"
let g:becomplete_type_definition = "def"

highlight becomplete_arg ctermbg=33

let g:becomplete_language_servers = [
\	{
\		"command": [ "clangd-14.custom" ],
\		"filetypes": [ "c", "cpp" ],
\		"trigger": [ ".", "->", "::" ],
\		"timeout-ms": "1000"
\	},
\	{
\		"command": [ "vim-language-server", "--stdio" ],
\		"filetypes": [ "vim" ],
\		"trigger": [],
\		"timeout-ms": "1000"
\	},
\ ]

let g:becomplete_ctags_languages = {
\	"vim": { "recursive": 1 },
\	"sh": { "recursive": 0 },
\	"make": { "recursive": 0 },
\	"python": { "recursive": 0 },
\	"java": { "recursive": 1 },
\	"php": { "recursive": 0 },
\ }
"}}}

""""
"" vimgdb
""""
"{{{
let vimgdb_gdblog_show = 0
let vimgdb_userlog_show = 0
let vimgdb_use_xterm = 0
let vimgdb_inferior_show = 0
"let vimgdb_gdb_cmd = 'avr-gdb -ex \"target remote 127.0.0.1:1212\"'
"}}}

""""
"" comment
""""
"{{{
let g:comment_map_line = "cl"
let g:comment_map_block = "cb"
let g:comment_map_sexy = "cs"
"}}}

""""
"" make
""""
"{{{
let g:make_win_title = "make-log"
let g:make_win_height = 7
let g:make_key_select = "<cr>"

" run make
call util#map#ni('<f5>', ':Make<cr>', '')
call util#map#ni('<a-f5>', ':MakeToggle<cr>', '')

" cycle through errors
call util#map#n('e', ':MakeCycle e n<cr>', '')
call util#map#n('<a-e>', ':MakeCycle e p<cr>', '')
call util#map#ni('<c-e>', ':MakeCycle e n<cr>', '')
call util#map#ni('<c-a-e>', ':MakeCycle e p<cr>', '')

" cycle through warnings
call util#map#n('w', ':MakeCycle w n<cr>', '')
call util#map#n('<a-w>', ':MakeCycle w p<cr>', '')
call util#map#ni('<c-w>', ':MakeCycle w n<cr>', '')
call util#map#ni('<c-a-w>', ':MakeCycle w p<cr>', '')

highlight	make_header		ctermfg=27
highlight	make_select		ctermfg=255 ctermbg=24
"}}}

""""
"" gcovered
""""
"{{{
let g:gcovered_toggle = "cc"
let g:gcovered_update = "cu"
"}}}

""""
"" scratch
""""
"{{{
call util#map#ni('<f8>', ':ScratchToggle<cr>', '')
"}}}

""""
"" fastcp
""""
"{{{
let g:fastcp_map_timeout = 400
let g:fastcp_map_copy = 'y'
let g:fastcp_map_cut = 'x'
let g:fastcp_map_paste_front = '<a-p>'
let g:fastcp_map_paste_back = 'p'
let g:fastcp_map_paste_i = '<c-v>'
"}}}

""""
"" qdelete
""""
"{{{
let g:qdelete_map_delete_line = "dl"
let g:qdelete_map_delete_init = "<c-d>"
"}}}

""""
"" fold
""""
"{{{
let g:fold_map_toggle_ni = '<c-f>'
let g:fold_map_toggle_n = 'ff'
let g:fold_map_open_all = 'fo'
let g:fold_map_close_all = 'fc'
"}}}

""""
"" airline
""""
"{{{
set laststatus=2

let g:airline_theme = "darkpapercolor"
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
	\ '__' : '-',
	\ 'n'  : 'norm',
	\ 'i'  : 'ins',
	\ 'R'  : 'repl',
	\ 'c'  : 'C',
	\ 'v'  : 'vis',
	\ 'V'  : 'visl',
	\ '' : 'visb',
	\ 's'  : 'S',
	\ 'S'  : 'S',
	\ '' : 'S',
\ }

let g:airline_symbol_crypt = "\u221e"
let g:airline_symbol_ro = "\ue0a2"
let g:airline_symbol_rw = "✎"
let g:airline_symbol_modified = "⛁"
let g:airline_symbol_truncat = "‥"
let g:airline_symbol_unnamed = "⁇"

let g:airline_symbols = {}
let g:airline_symbols.modified = " " . g:airline_symbol_modified

let g:airline_section_a = "%4{airline#parts#mode()}"
let g:airline_section_b = "%{(&readonly || !&modifiable ? g:airline_symbol_ro : g:airline_symbol_rw)}%{(exists('+key') && !empty(&key) ? '  ' . g:airline_symbol_crypt : '')}"
let g:airline_section_c = "%<%f %{&modified ? g:airline_symbol_modified : ''}"
let g:airline_section_x = "%{&filetype}"
let g:airline_section_y = "%{&fileformat}%{(&fileencoding != '' ? '  ' . g:airline_right_alt_sep . ' ' : '')}%{&fileencoding}"
let g:airline_section_z = "%{Search_index()}%7(%l,%v%) %-" . s:nline_indicator_len . "{Nline_indicator()}"
let g:airline_section_warning = ""

let g:airline_extensions = ['tabline']
let g:airline#extensions#default#section_truncate_width = {
	\ 'x' : 60,
	\ 'y' : 88,
\ }
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#tab_min_count = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#formatter = "custom"
let g:airline#extensions#tabline#formatter#custom#truncat_len = 3
let g:airline#extensions#tabline#formatter#custom#truncat_sym = g:airline_symbol_truncat
let g:airline#extensions#tabline#formatter#cutomst#unnamed = g:airline_symbol_unnamed

"}}}

""""
"" snippet
""""
"{{{
" XXX: file-type specific snippes are listed in ~/.vim/ftplugin/<filetype>

let g:snippet_base = "~/.vim/snippets"
"}}}
"}}}

""""""""""""
" mappings "
""""""""""""
"{{{
" fix shifted function keys f1 to f4 for xterm
" 	keycodes can be obtained through "$cat" in terminal
exec "set <s-f1>=\e[1;2P"
exec "set <s-f2>=\e[1;2Q"
exec "set <s-f3>=\e[1;2R"
exec "set <s-f4>=\e[1;2S"

" map <c-backspace> to <f13> the given keycode is set within ~/.Xresources
exec "set <f13>=\e[25;6~"

""""
"" spell checking and highlighting
""""
" toggle spell checking and move between bad words
call util#map#ni('<f6>', ':call ' . s:sid . 'spell_ctrl("b")<cr>', '')
call util#map#ni('<f7>', ':call ' . s:sid . 'spell_ctrl("f")<cr>', '')

" disable spell checking
call util#map#ni('<a-f6>', ':set spell!<cr>', '')

" add word under cursor to spellfile
call util#map#ni('<a-f7>', 'zg', '')

""""
"" vim settings
""""
" syntax highlighting debug
call util#map#ni('<f1>', ':call ' . s:sid . 'syn_stack()<cr>', '')

" toggle 'paste'
call util#map#ni('<f2>', ':set paste!<cr>', '')

" toggle search highlighting
call util#map#ni('<f10>', ':set hls!<cr>', '')

" toggle line numbers
call util#map#ni('<f11>', ':set nu!<cr>', '')

" toggle 'list' mode
call util#map#ni('<f12>', ':set list!<cr>', '')

""""
"" buffer operations
""""
" content modification
	" delete word backward
call util#map#i('<f13>', '<c-w>', 'noescape noinsert')
cnoremap <f13>	<c-w>

" movement
	" goto line x
call util#map#n('l', "':' . input(\"\") . '<cr>'", '<expr> nosilent')

	" goto line 0
call util#map#ni('<a-s-up>', ':0<cr>', '')
call util#map#v('<a-s-up>', 'gg', '')

	" goto last line
call util#map#ni('<a-s-down>', ':$<cr>', '')
call util#map#v('<a-s-down>', 'G$', '')

	" select all
call util#map#ni('<c-a>', 'ggvG$', '')

	" goto tag
call util#map#n('tt', '<c-]>', '')
call util#map#n('gtt', 'g<c-]>', '')
call util#map#n('<a-t>', '<c-t>', '')

	" goto next diff
if &diff
	call util#map#n('<cr>', ']c', '')
	call util#map#n('<backspace>', '[c', '')
endif

" text selection
call util#map#n('<s-left>', 'v', '')
call util#map#n('<s-right>', 'v', '')
call util#map#n('<s-up>', 'v<up>', '')
call util#map#n('<s-down>', 'v<down>', '')
call util#map#v('<s-left>', 'ge', '')
call util#map#v('<s-a-left>', '0', '')
call util#map#v('<s-right>', 'e', '')
call util#map#v('<s-a-right>', '$', '')
call util#map#v('<s-up>', '<up>', '')
call util#map#v('<s-down>', '<down>', '')
call util#map#i('<s-left>', 'v', 'noinsert')
call util#map#i('<s-right>', 'v', 'noinsert')
call util#map#i('<s-up>', 'v<up>', 'noinsert')
call util#map#i('<s-down>',	'v<down>', 'noinsert')

" search
	" search for word under cursor and copy to 's' register
let search_map = ':set hls<cr>:let @/ = ''\<'' . expand(''<cword>'') . ''\>''<cr>:let @s = expand(''<cword>'')<cr>'

call util#map#n('s', search_map, '')
call util#map#ni('<c-s>', search_map, '')

	" next/prev seatch result
call util#map#ni('<a-s>', '/<cr>', '')
call util#map#ni('<a-s-s>', '?<cr>', '')

if !&diff
	call util#map#nv('<cr>', '/<cr>', '')
	call util#map#nv('<backspace>', '?<cr>', '')
endif

" undo/redo
call util#map#n('u', ':undo<cr>', '')
call util#map#n('<a-u>', ':redo<cr>', '')
call util#map#ni('<c-u>', ':undo<cr>', '')
call util#map#ni('<c-a-u>', ':redo<cr>', '')

" indentation
call util#map#v('<tab>', '>', '')
call util#map#v('<s-tab>', '<', '')

""""
"" window and tab control
"""""
" movement between tabs
call util#map#ni('<c-h>', ':tabprev<cr>', '')
call util#map#ni('<c-l>', ':tabnext<cr>', '')

" movement between splits
call util#map#ni('<c-k>', ':wincmd w<cr>', '')	" up
call util#map#ni('<c-j>', ':wincmd W<cr>', '')	" down

" resize
call util#map#ni('<c-a-h>', '<c-w><', '')
call util#map#ni('<c-a-l>', '<c-w>>', '')
call util#map#ni('<c-a-j>', '<c-w>+', '')
call util#map#ni('<c-a-k>', '<c-w>-', '')

" open/close tab
call util#map#n('o', ':tabnew ', 'nosilent')
call util#map#ni('<c-o>', ':tabnew ', 'nosilent')
call util#map#ni('<c-c>', ':q<cr>', '')
"}}}

"""""""""""""""""
" abbreviations "
"""""""""""""""""
"{{{
" commands
call s:cabbrev("make", "Make")
call s:cabbrev("gfe", "Search -e build -e recent -e .git")

" typos
call s:cabbrev("W", "w")
call s:cabbrev("Q", "q")

" hex editor
call s:cabbrev("hex", "%!xxd")
"}}}
