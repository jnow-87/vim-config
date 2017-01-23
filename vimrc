if exists("g:loaded_vimrc")
    finish
endif

let g:loaded_vimrc = 1


"""""""""""""""
" vim general "
"""""""""""""""
"{{{
""""
"" options
""""
"{{{
runtime! debian.vim
filetype plugin on
syntax on
set nocp
set viminfo+=n/tmp/viminfo
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
set complete=.,w,b,u,t,i
"set complete+=kspell
set completeopt=menu,longest
set pumheight=10
set conceallevel=3
set concealcursor=vinc
set spelllang=de,en
set spellfile=~/.vim/spell/vimspell.add
set tabpagemax=100
set dir=/tmp
set path=.,/usr/include,/usr/include/linux
set updatetime=1000
"set wildmode=longest,full
set foldtext=Foldtext()
set splitright
set splitbelow
set noequalalways

exec "set tags+=/tmp/" . getpid() . ".tags"

let mapleader = '\'
"}}}

""""
"" autocmds
""""
"{{{
" enable color column
autocmd	FileType text setlocal colorcolumn=80
autocmd	FileType gitcommit setlocal colorcolumn=80 | setlocal tabstop=4

" line wrap for vimdiff
autocmd	VimEnter * if &diff | execute 'windo set wrap' | endif

" add filetype extensions
autocmd	BufRead,BufNewFile *.lds			setf ld
autocmd	BufRead,BufNewFile *.gperf			setf gperf
autocmd	BufRead,BufNewFile *.per			setf per
autocmd	BufRead,BufNewFile pconfig,Pconfig	setf kconfig

" default filetype to text
autocmd	BufRead * if &filetype == "" | setfiletype text | endif

" window dimensions
autocmd	VimEnter	* :call <sid>win_dimensions()
autocmd	VimResized	* :call <sid>win_dimensions()

" delete tags file
autocmd VimLeave	* :exec "silent !rm -f /tmp/" . getpid() . ".tags"
"}}}
"}}}

"""""""""""""
" functions "
"""""""""""""
"{{{
" set certain window dimensions, depending on vim size
function s:win_dimensions()
	let g:scratchWinWidth = (&columns/5 <= 20) ? 20 : &columns/5
	let g:gtd_sym_window_width = (&columns/5 <= 20) ? 20 : &columns/5
	let g:gtd_sym_preview_width = (&columns/3 <= 20) ? 20 : &columns/3
	let g:makeWinHeight = (&window/5) <= 7 ? 7 : &window/5
endfunction

" create normal mode mapping
function s:n_map(lhs, rhs)
	exec 'nnoremap <silent> ' . a:lhs . ' ' . a:rhs
endfunction

" create insert mode mapping
function s:i_map(lhs, rhs)
	exec 'inoremap <silent> ' . a:lhs . ' <right><esc>' . a:rhs . '<insert>'
endfunction

" create visual mode mapping
function s:v_map(lhs, rhs)
	exec 'vnoremap <silent> ' . a:lhs . ' ' . a:rhs
	exec 'snoremap <silent> ' . a:lhs . ' ' . a:rhs
endfunction

" create normal and insert mode mapping
function s:ni_map(lhs, rhs)
	call s:n_map(a:lhs, a:rhs)
	call s:i_map(a:lhs, a:rhs)
endfunction

" create normal and visual mode mapping
function s:nv_map(lhs, rhs)
	call s:n_map(a:lhs, a:rhs)
	call s:v_map(a:lhs, a:rhs)
endfunction

" delete line from cursor till user supplied charater
function s:del_until(feedkey)
	let l:sleeped = 800

	" wait for user input
	while l:sleeped > 0 && getchar(1) == 0
		sleep 50m
		let l:sleeped = l:sleeped - 50 
	endwhile

	" get user input
	let c = nr2char(getchar(1))

	" check user input
	if c == '$'
		" '$'
		exec "normal! d$"

	elseif c != ""
		" default non-empty
		exec "normal! dt" . nr2char(getchar(0))
	endif

	if a:feedkey != ""
		call feedkeys(a:feedkey)
	endif
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

" generate tags file /tmp/<dirname>.tags
function s:gentags()
	call system("ctags --append --tag-relative=yes -R -f /tmp/" . getpid() . ".tags .")
endfunction

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
highlight	mgreen			ctermfg=28
highlight	morange			ctermfg=202
highlight	mpurple			ctermfg=56
highlight	Comment			ctermfg=27
highlight	LineNr			ctermfg=88
highlight	Search			ctermfg=0 ctermbg=1
highlight	Pmenu			ctermfg=255 ctermbg=24
highlight	PmenuSel		ctermfg=255 ctermbg=31
highlight	SpellBad		ctermfg=7 ctermbg=88
highlight	SpellCap		ctermfg=7 ctermbg=21
highlight	SpellLocal		ctermfg=7 ctermbg=57
highlight	Visual			ctermfg=7 ctermbg=237
highlight	DiffAdd			ctermbg=22
highlight	DiffChange		ctermbg=33
highlight	DiffDelete		ctermbg=88
highlight	DiffText		ctermbg=1, ctermfg=15
highlight	MatchParen		ctermbg=88
highlight	ColorColumn		ctermbg=235
highlight	SignColumn		ctermbg=0
highlight	Folded			ctermfg=242 ctermbg=234
highlight	ExtraWhitespace	ctermbg=236
highlight	clang_arg		ctermbg=33

" match extra whitespaces
autocmd	FileType c,cpp,asm,text match ExtraWhitespace	"\( \+$\)\|\(^\zs \+\ze[^ \*]\+\)\|\([^\t]\+\zs\t\+\ze$\)"

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
"" clang_complete
""""
"{{{
"let g:clang_complete_loaded = 0
let g:clang_library_path = "/usr/lib/llvm-3.7/lib"
let g:clang_use_library = 1

let g:clang_complete_auto = 1
let g:clang_complete_fallback = 1
let g:clang_auto_select = 1
let g:clang_complete_macros = 1
let g:clang_complete_copen = 0
let g:clang_sort_algo = "alpha"

let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
let g:clang_conceal_snippets = 1
"let g:clang_trailing_placeholder = 1
"let g:clang_complete_optional_args_in_snippets = 0

let g:clang_hl_errors = 0
let g:clang_periodic_quickfix = 0
"let g:clang_complete_auto
"}}}

""""
"" gtd
""""
"{{{
" symbol window config
let g:gtd_sym_window_show_signature	= 1
let g:gtd_sym_window_foldopen = 1

" symbol menu config
let g:gtd_sym_menu = "» "

" mappings
call s:ni_map('<f9>', ':GtdSymWindowToggle<cr>')

let g:gtd_key_def_split			= "lf"
let g:gtd_key_def_tab			= "tf"
let g:gtd_key_decl_split		= "lp"
let g:gtd_key_decl_tab			= "tp"

let g:gtd_key_def_split_glob	= "glf"
let g:gtd_key_def_tab_glob		= "gtf"
let g:gtd_key_decl_split_glob	= "glp"
let g:gtd_key_decl_tab_glob		= "gtp"

let g:gtd_key_head_list			= "lh"
let g:gtd_key_head_focus		= "th"

let g:gtd_key_opt_menu			= "lm"
let g:gtd_key_sym_menu_loc		= "ls"

" kinds of symbols to display in gtd window
let g:gtd_sym_window_kinds_c		= ['c', 'd', 'f', 'g', 's', 't', 'u', 'v', 'x']
let g:gtd_sym_window_kinds_asm		= ['d', 'l', 'm', 't']
let g:gtd_sym_window_kinds_vim		= ['a', 'c', 'f', 'm', 'v']
let g:gtd_sym_window_kinds_sh		= ['f']
let g:gtd_sym_window_kinds_make		= ['m']
let g:gtd_sym_window_kinds_python	= ['c', 'f', 'm', 'v', 'i']
let g:gtd_sym_window_kinds_java		= ['c', 'e', 'f', 'g', 'i', 'l', 'm', 'p']

" kinds of symbols to keep in symbol list
let g:gtd_sym_list_kinds_c			= ['d', 'f', 'g', 's', 't', 'u']
let g:gtd_sym_list_kinds_asm		= ['d', 'l', 'm', 't']
let g:gtd_sym_list_kinds_vim		= ['a', 'c', 'f', 'm', 'v']
let g:gtd_sym_list_kinds_sh			= ['f']
let g:gtd_sym_list_kinds_make		= ['m']
let g:gtd_sym_list_kinds_python		= ['c', 'f', 'm', 'v', 'i']
let g:gtd_sym_list_kinds_java		= ['c', 'e', 'f', 'g', 'i', 'l', 'm', 'p']
"}}}

""""
"" airline
""""
"{{{
set laststatus=2

let g:airline_theme = "papercolor"
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
let g:airline_symbol_rw = "\u2261"

let g:airline_section_a = "%4{airline#parts#mode()}"
let g:airline_section_b = "%{(&readonly || !&modifiable ? g:airline_symbol_ro : g:airline_symbol_rw)}%{(exists('+key') && !empty(&key) ? '  ' . g:airline_symbol_crypt : '')}"
let g:airline_section_c = "%<%f%m"
let g:airline_section_x = "%{&filetype}"
let g:airline_section_y = "%{&fileformat}%{(&fileencoding != '' ? '  ' . g:airline_right_alt_sep . ' ' : '')}%{&fileencoding}"
let g:airline_section_z = "%7(%l,%c%)"
let g:airline_section_warning = ""

let g:airline_extensions = ['tabline']
let g:airline#extensions#default#section_truncate_width = {
	\ 'x' : 60,
	\ 'y' : 88,
\ }
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_close_button = 0
"}}}

"""
"" tagcomplete
""""
"{{{
let g:tagcomplete_ignore_filetype = { 
	\ "c" : 1,
	\ "cpp" : 1,
	\ "objc" : 1,
	\ "objcpp" : 1,
\ }
"}}}

""""
"" make
""""
"{{{
let g:make_win_title = "make"
let g:make_win_height = 7

" run make
call s:ni_map('<f5>', ':Make<cr>')
call s:ni_map('<a-f5>', ':MakeToggle<cr>')

" cycle through errors
call s:n_map('e', ':MakeCycle e n<cr>')
call s:n_map('<a-e>', ':MakeCycle e p<cr>')
call s:ni_map('<c-e>', ':MakeCycle e n<cr>')
call s:ni_map('<c-a-e>', ':MakeCycle e p<cr>')

" cycle through warnings
call s:n_map('w', ':MakeCycle w n<cr>')
call s:n_map('<a-w>', ':MakeCycle w p<cr>')
call s:ni_map('<c-w>', ':MakeCycle w n<cr>')
call s:ni_map('<c-a-w>', ':MakeCycle w p<cr>')

highlight def link make_header mblue
"}}}

""""
"" scratch
""""
"{{{
call s:ni_map('<f8>', ':ScratchToggle<cr>')
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
"" snippet

" XXX: file-type specific snippes are listed in ~/.vim/ftplugin/<filetype>

let g:snippet_base = "~/.vim/snippets"
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

""""
"" spell checking and highlighting
""""
" toggle spell checking and move between bad words
call s:ni_map('<f11>', ':call <sid>spell_ctrl("b")<cr>')
call s:ni_map('<f12>', ':call <sid>spell_ctrl("f")<cr>')

" disable spell checking
call s:ni_map('<a-f11>', ':set spell!<cr>')

" add word under cursor to spellfile
call s:ni_map('<a-f12>', 'zg')

""""
"" vim settings
""""
" syntax highlighting debug
call s:ni_map('<f1>', ':call <sid>syn_stack()<cr>')

" toggle line numbers
call s:ni_map('<f2>', ':set nu!<cr>')

" toggle 'list' mode
call s:ni_map('<f3>', ':set list!<cr>')

" toggle 'paste'
call s:ni_map('<f4>', ':set paste!<cr>')

" toggle search highlighting
call s:ni_map('<f10>', ':set hls!<cr>')

""""
"" buffer operations
""""
" movement
	" goto line x
nnoremap <expr> l ':' . input("") . '<cr>'

	" goto line 0
call s:ni_map('<a-s-up>', ':0<cr>')
call s:v_map('<a-s-up>', 'gg')

	" goto last line
call s:ni_map('<a-s-down>', ':$<cr>')
call s:v_map('<a-s-down>', 'G$')

	" select all
call s:ni_map('<c-a>', 'ggvG$')

	" goto tag
call s:n_map('tt', '<c-]>')
call s:n_map('gtt', 'g<c-]>')
call s:n_map('<a-t>', '<c-t>')

" text selection
call s:n_map('<s-left>', 'v')
call s:n_map('<s-right>', 'v')
call s:n_map('<s-up>', 'v<up>')
call s:n_map('<s-down>', 'v<down>')
call s:v_map('<s-left>', 'ge')
call s:v_map('<s-a-left>', '0')
call s:v_map('<s-right>', 'e')
call s:v_map('<s-a-right>', '$')
call s:v_map('<s-up>', '<up>')
call s:v_map('<s-down>', '<down>')
inoremap <silent> <expr> <s-left>	getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v"
inoremap <silent> <expr> <s-right>	getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v"
inoremap <silent> <expr> <s-up>		getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v\<up>"
inoremap <silent> <expr> <s-down>	getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v\<down>"

" search
	" search for word under cursor and copy to 's' register
let search_map = ':set hls<cr>:let @/ = ''\<'' . expand(''<cword>'') . ''\>''<cr>:let @s = expand(''<cword>'')<cr>'

call s:n_map('s', search_map)
call s:ni_map('<c-s>', search_map)

	" next/prev seatch result
call s:ni_map('<a-s>', '/<cr>')
call s:ni_map('<a-s-s>', '?<cr>')
call s:nv_map('<cr>', '/<cr>')
call s:nv_map('<backspace>', '?<cr>')

" undo/redo
call s:n_map('u', ':undo<cr>')
call s:n_map('<a-u>', ':redo<cr>')
call s:ni_map('<c-u>', ':undo<cr>')
call s:ni_map('<c-a-u>', ':redo<cr>')

" deletion
inoremap <c-d> <right><esc>:call <sid>del_until('i')<cr>

" indentation
vnoremap <silent> <tab> >
vnoremap <silent> <s-tab> <

" folding
call s:n_map('fo', ':0,$foldopen<cr>')
call s:n_map('fc', ':0,$foldclose<cr>')

""""
"" window and tab control
"""""
" movement between tabs
call s:ni_map('<c-h>', ':tabprev<cr>')
call s:ni_map('<c-l>', ':tabnext<cr>')

" movement between splits
call s:ni_map('<c-k>', ':wincmd w<cr>')	" up
call s:ni_map('<c-j>', ':wincmd W<cr>')	" down

" resize
call s:ni_map('<c-a-h>', '<c-w><')
call s:ni_map('<c-a-l>', '<c-w>>')
call s:ni_map('<c-a-j>', '<c-w>+')
call s:ni_map('<c-a-k>', '<c-w>-')

" open/close tab
nmap o :tabnew
nmap <c-o> :tabnew 
imap <c-o> <esc>:tabnew 
call s:ni_map('<c-c>', ':q<cr>')
"}}}

"""""""""""""""""
" abbreviations "
"""""""""""""""""
"{{{
" commands
call s:cabbrev("make", "Make")

" typos
call s:cabbrev('W', 'w')
call s:cabbrev('Q', 'q')

" hex editor
call s:cabbrev('hex', '%!xxd')
"}}}

""""""""""""
" commands "
""""""""""""
"{{{
command Gentags call s:gentags()
"}}}
