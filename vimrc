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
autocmd	BufRead,BufNewFile *.lds setf ld
autocmd	BufRead,BufNewFile *.gperf setf gperf
autocmd	BufRead,BufNewFile *.per setf per
autocmd	BufRead,BufNewFile pconfig,Pconfig setf kconfig

" default filetype to text
autocmd	BufRead * if &filetype == "" | setfiletype text | endif

" window dimensions
autocmd	VimEnter	* :call <sid>win_dimensions()
autocmd	VimResized	* :call <sid>win_dimensions()

" delete tags file
autocmd VimLeave	* :exec "!rm /tmp/" . getpid() . ".tags"
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

" insert normal and insert mode mappings
function s:ni_silent_map(lhs, rhs)
	exec 'nnoremap <silent> ' . a:lhs . ' ' . a:rhs
	exec 'inoremap <silent> ' . a:lhs . ' <right><esc>' . a:rhs . '<insert>'
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
let g:gtd_sym_window_kinds_c		= ['c', 'd', 'f', 'g', 's', 't', 'u', 'v', 'x']
let g:gtd_sym_window_kinds_asm		= ['d', 'l', 'm', 't']
let g:gtd_sym_window_kinds_vim		= ['a', 'c', 'f', 'm', 'v']
let g:gtd_sym_window_kinds_sh		= ['f']
let g:gtd_sym_window_kinds_make		= ['m']
let g:gtd_sym_window_kinds_python	= ['c', 'f', 'm', 'v', 'i']
let g:gtd_sym_window_kinds_java		= ['c', 'e', 'f', 'g', 'i', 'l', 'm', 'p']

let g:gtd_sym_list_kinds_c			= ['d', 'f', 'g', 's', 't', 'u']
let g:gtd_sym_list_kinds_asm		= ['d', 'l', 'm', 't']
let g:gtd_sym_list_kinds_vim		= ['a', 'c', 'f', 'm', 'v']
let g:gtd_sym_list_kinds_sh			= ['f']
let g:gtd_sym_list_kinds_make		= ['m']
let g:gtd_sym_list_kinds_python		= ['c', 'f', 'm', 'v', 'i']
let g:gtd_sym_list_kinds_java		= ['c', 'e', 'f', 'g', 'i', 'l', 'm', 'p']

let g:gtd_sym_window_show_signature	= 1
let g:gtd_sym_window_foldopen = 1
let g:gtd_sym_menu = "» "


call s:ni_silent_map('<f9>', ':GtdSymWindowToggle<cr>')
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
"" lex/yacc
""""
"{{{
let yacc_uses_cpp = 1
let lex_uses_cpp = 1
"}}}

""""
"" make
""""
"{{{
let g:make_win_title = "make"
let g:make_win_height = 7

call s:ni_silent_map('<f5>', ':Make<cr>')
call s:ni_silent_map('<s-f5>', ':MakeToggle<cr>')

highlight def link make_header mblue
"}}}

""""
"" scratch
""""
"{{{
call s:ni_silent_map('<f8>', ':ScratchToggle<cr>')
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
""""
let g:snippet_base = "~/.vim/snippets"

inoremap <leader>titem	<esc>:call Snippet("itemize.tex")<cr>
inoremap <leader>tenum	<esc>:call Snippet("enum.tex")<cr>
inoremap <leader>tdesc	<esc>:call Snippet("description.tex")<cr>
inoremap <leader>talign	<esc>:call Snippet("align.tex")<cr>
inoremap <leader>ttab	<esc>:call Snippet("table.tex")<cr>
inoremap <leader>tfig	<esc>:call Snippet("figure.tex")<cr>
inoremap <leader>ttfig	<esc>:call Snippet("tabfigure.tex")<cr>

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
" enable spell checking and move between bad words
call s:ni_silent_map('<f1>', ':call <sid>spell_ctrl("b")<cr>')
call s:ni_silent_map('<f2>', ':call <sid>spell_ctrl("f")<cr>')

" disable spell checking
call s:ni_silent_map('<s-f1>', ':set spell!<cr>')

" add word under cursor to spellfile
call s:ni_silent_map('<s-f2>', 'zg')

""""
"" vim settings
""""
" syntax highlighting debug
call s:ni_silent_map('<f12>', ':call <sid>syn_stack()<cr>')

" toggle 'paste'
call s:ni_silent_map('<f4>', ':set paste!<cr>')

" toggle 'list' mode
call s:ni_silent_map('<f3>', ':set list!<cr>')

" toggle search highlighting
call s:ni_silent_map('<f10>', ':set hls!<cr>')

" toggle line numbers
call s:ni_silent_map('<f11>', ':set nu!<cr>')

""""
"" buffer operations
""""
" movement
nnoremap <silent> ´ $
nnoremap <silent> ` :$<cr>
nnoremap <silent> ° :0<cr>
vnoremap <silent> ´ $
vnoremap <silent> ` G
vnoremap <silent> ° gg
nnoremap <silent> tt <c-]>
nnoremap <silent> gtt g<c-]>
nnoremap <silent> <s-t> <c-t>
nnoremap <silent> ^ 0
vnoremap <silent> ^ 0
call s:ni_silent_map('<c-a>', 'ggvG$')

" search
nnoremap <silent> <cr> /<cr>
vnoremap <silent> <cr> /<cr>
nnoremap <silent> <backspace> ?<cr>
nnoremap <silent> s :set hls<cr>:let @/ = '\<' . expand('<cword>') . '\>'<cr>:let @s = expand('<cword>')<cr>

" undo/redo
call s:ni_silent_map('<c-z>', ':undo<cr>')
call s:ni_silent_map('<c-a-z>', ':redo<cr>')

" text selection
nnoremap <silent> <s-left> v
inoremap <silent> <expr> <s-left> getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v"
vnoremap <silent> <s-left> ge
nnoremap <silent> <s-right> v
inoremap <silent> <expr> <s-right> getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v"
vnoremap <silent> <s-right> e
nnoremap <silent> <s-up> v<up>
inoremap <silent> <expr> <s-up> getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v\<up>"
vnoremap <silent> <s-up> <up>
nnoremap <silent> <s-down> v<down>
inoremap <silent> <expr> <s-down> getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v\<down>"
vnoremap <silent> <s-down> <down>
vnoremap <silent> d di
snoremap <silent> d di

" indentation
vnoremap <silent> <tab> >
vnoremap <silent> <s-tab> <

" folding
nnoremap <silent> fo :0,$foldopen<cr>
nnoremap <silent> fc :0,$foldclose<cr>

""""
"" window control
"""""
" movement
call s:ni_silent_map('<c-pagedown>', ':wincmd w<cr>')
call s:ni_silent_map('<c-j>', ':wincmd w<cr>')
call s:ni_silent_map('<c-pageup>', ':wincmd W<cr>')
call s:ni_silent_map('<c-k>', ':wincmd W<cr>')

" resize
call s:ni_silent_map('<c-a-left>', '<c-w><')
call s:ni_silent_map('<c-a-h>', '<c-w><')
call s:ni_silent_map('<c-a-right>', '<c-w>>')
call s:ni_silent_map('<c-a-l>', '<c-w>>')
call s:ni_silent_map('<c-a-up>', '<c-w>-')
call s:ni_silent_map('<c-a-j>', '<c-w>-')
call s:ni_silent_map('<c-a-down>', '<c-w>+')
call s:ni_silent_map('<c-a-k>', '<c-w>+')

""""
"" tab control
""""
" open/close
nmap <c-o> :tabnew 
imap <c-o> <esc>:tabnew 
nmap <silent> <c-c> <esc>:q<cr>

" movement
call s:ni_silent_map('<c-home>', ':tabprev<cr>')
call s:ni_silent_map('<c-h>', ':tabprev<cr>')
call s:ni_silent_map('<c-end>', ':tabnext<cr>')
call s:ni_silent_map('<c-l>', ':tabnext<cr>')
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
