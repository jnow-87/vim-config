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
"set mouse=a
set number
set numberwidth=2
set norelativenumber
set ai
set noexpandtab
set tabstop=4
set shiftwidth=4
set complete=.,w,b,u,t,i
"set complete+=kspell
set completeopt=menuone,longest
set pumheight=10
set conceallevel=3
set concealcursor=vinc
set spelllang=de,en
set spellfile=~/.vim/spell/vimspell.add
set tabpagemax=100
set dir=/tmp
set path=.,/usr/include,/usr/include/linux
set updatetime=1000
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
"}}}

""""
"" tag handling
""""
"{{{
set tag+=~/.vim/tags/stdc.tags		" generated with ctags on /usr/include

autocmd BufWinEnter		*.java		:silent exe "set tags+=/tmp/" . fnamemodify($PWD, ':t') . ".tags"
autocmd VimLeave		*.java		:silent exe "!rm /tmp/" . fnamemodify($PWD, ':t') . ".tags"
autocmd VimEnter		*.java		:silent call <sid>ctags("")
autocmd BufWritePost	*.java		:silent call <sid>ctags(fnamemodify(bufname("%"), ':.'))
"}}}
"}}}

"""""""""""""
" functions "
"""""""""""""
"{{{
" set certain window dimensions, depending on vim size
function s:win_dimensions()
	let g:Tlist_WinWidth = (&columns/5 <= 20) ? 20 : &columns/5
	let g:scratchWinWidth = g:Tlist_WinWidth
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

" generate ctags for c, cpp, asm and java
function s:ctags(file)
	if &filetype == "c" || &filetype == "cpp" || &filetype == "asm"
		let l:lang_args = "--languages=c,c++ --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq"
	elseif &filetype == "java"
		let l:lang_args = "--languages=java --java-kinds=+p --fields=+iaS --extra=+fq"
	endif

	exec "!ctags -R --tag-relative=yes --sort=yes " . l:lang_args . " -f /tmp/" . fnamemodify($PWD, ':t') . ".tags " . (a:file == "" ? "." : " --append " . a:file)
endfunction
"}}}

"""""""""""""""""""""""
" syntax highlighting "
"""""""""""""""""""""""
"{{{
colorscheme default

highlight	mred			ctermfg=124
highlight	mlblue			ctermfg=6
highlight	mblue			ctermfg=27
highlight	mgreen			ctermfg=28
highlight	morange			ctermfg=202
highlight	mpurple			ctermfg=56
highlight	Comment			ctermfg=27
highlight	LineNr			ctermfg=88
highlight	Search			ctermfg=0 ctermbg=1
highlight	Pmenu			ctermfg=0 ctermbg=1
highlight	PmenuSel		ctermfg=0 ctermbg=3
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

let g:clang_jumpto_declaration_key = "<C-]>"
let g:clang_jumpto_back_key = "<C-T>"
let g:clang_jumpto_declaration_in_preview_key = "<C-W>"

let g:clang_complete_auto = 1
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
"" taglist
""""
"{{{
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_SingleClick=1
let Tlist_Auto_Highlight_Tag=1
let Tlist_Sort_Type='name'
let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=0
let Tlist_Display_Prototype=1

hi def link MyTagListTagScope mblue
hi def link MyTagListTitle mblue
hi def link MyTagListComment mblue

call s:ni_silent_map('<f9>', ':TlistToggle<cr>')
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
call s:ni_silent_map('<f1>', ':call <sid>spell_ctrl("f")<cr>')
call s:ni_silent_map('<f2>', ':call <sid>spell_ctrl("b")<cr>')

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
nnoremap <silent> <c-a> ggvG$
inoremap <silent> <c-a> <esc>ggvG$
nnoremap <silent> t <c-]>

" search
nnoremap <silent> <cr> /<cr>
nnoremap <silent> <backspace> ?<cr>
nnoremap <silent> s :set hls<cr>/\<<c-r>=expand("<cword>")<cr>\><cr>

" undo/redo
call s:ni_silent_map('<c-z>', ':undo<cr>')
call s:ni_silent_map('<c-a-z>', ':redo<cr>')

" text selection
nnoremap <silent> <s-left> v
inoremap <silent> <expr> <s-left> getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v"
vnoremap <silent> <s-left> b
nnoremap <silent> <s-right> v
inoremap <silent> <expr> <s-right> getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v"
vnoremap <silent> <s-right> w
nnoremap <silent> <s-up> v<up>
inoremap <silent> <expr> <s-up> getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v\<up>"
vnoremap <silent> <s-up> <up>
nnoremap <silent> <s-down> v<down>
inoremap <silent> <expr> <s-down> getpos('.')[2] == 1 ? "\<esc>v" : "\<esc>\<right>v\<down>"
vnoremap <silent> <s-down> <down>

" indentation
vnoremap <silent> <tab> >
vnoremap <silent> <s-tab> <

""""
"" windows control
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
" typos
call s:cabbrev('W', 'w')
call s:cabbrev('Q', 'q')

" hex editor
call s:cabbrev('hex', '%!xxd')
"}}}
