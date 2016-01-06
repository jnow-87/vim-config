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
set showcmd
set ignorecase
set smartcase
set incsearch
"set mouse=a
set nocp
set number
set numberwidth=2
set norelativenumber
set ai
set noexpandtab
set tabstop=4
set shiftwidth=4
set spelllang=de,en
set spellfile=~/.vim/spell/vimspell.add
set tabpagemax=100
set dir=/tmp
"}}}

""""
"" autocmds
""""
"{{{
" default filetype to text
"autocmd BufEnter * if &filetype == "" | setfiletype text | endif

" enable color column
autocmd FileType text setlocal colorcolumn=80
autocmd FileType gitcommit setlocal colorcolumn=80

" line wrap for vimdiff
autocmd VimEnter * if &diff | execute 'windo set wrap' | endif

" add filetype extensions
autocmd	BufRead,BufNewFile *.lds setf ld
autocmd	BufRead,BufNewFile *.gperf setf gperf
autocmd	BufRead,BufNewFile *.per setf per
autocmd	BufRead,BufNewFile pconfig,Pconfig setf kconfig

" window dimensions
autocmd VimEnter	* :call <sid>win_dimensions()
autocmd VimResized	* :call <sid>win_dimensions()
"}}}

""""
"" tag handling
""""
"{{{
set tag+=~/.vim/tags/stdc.tags		" generated with ctags on /usr/include
set tag+=~.vim/tags/kernel.tags		" generated with ctags on /usr/src/<kernel version>/include/linux

autocmd BufWinEnter		*.[chsS],*.cc			:silent exe "set tags+=/tmp/" . fnamemodify($PWD, ':t') . ".tags"
autocmd VimLeave		*.[chsS],*.cc,*.java	:silent exe "!rm /tmp/" . fnamemodify($PWD, ':t') . ".tags"

autocmd VimEnter		*.[chsS],*.cc			:silent call <sid>ctags("")
autocmd VimEnter		*.[chsS],*.cc			:silent call <sid>ctags("")
autocmd BufWritePost	*.[chsS],*.cc			:silent call <sid>ctags(fnamemodify(bufname("%"), ':.'))
"autocmd BufWinEnter	*.java					:silent exe "set tags+=/tmp/" . fnamemodify($PWD, ':t') . ".tags"
"autocmd VimEnter		*.java					:silent call <sid>ctags("")
"autocmd BufWritePost	*.java					:silent call <sid>ctags(fnamemodify(bufname("%"), ':.'))
"}}}
"}}}

"""""""""""""
" functions "
"""""""""""""
"{{{
" set certain window dimensions, depending on vim size
function! <sid>win_dimensions()
	let g:Tlist_WinWidth = (&columns/5 <= 20) ? 20 : &columns/5
	let g:scratchWinWidth = g:Tlist_WinWidth
	let g:makeWinHeight = (&window/5) <= 7 ? 7 : &window/5
endfunction

" remove character from input
function! <sid>eat_char(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunction

" control shift key behaviour in visual mode
function! <sid>v_key_shift()
	if getpos(".")[2] == 1
		normal v
	else
		let pos = getpos(".")
		call setpos(".", [pos[0], pos[1], pos[2]+1, pos[3]])
		normal v
	endif
endfunction

" echo syntax highlighting groups that apply to pattern under cursor
function! <sid>syn_stack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
	echo "hi: " . synIDattr(synID(line("."),col("."),1),"name") . ', trans: ' . synIDattr(synID(line("."),col("."),0),"name") . ", lo: " . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
endfunc

" generate ctags for c, cpp, asm and java
function! <sid>ctags(file)
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
highlight	mred			ctermfg=124
highlight	mlblue			ctermfg=6
highlight	mblue			ctermfg=27
highlight	mgreen			ctermfg=28
highlight	morange			ctermfg=202
highlight	Comment			ctermfg=27
highlight	LineNr			term=bold cterm=none ctermfg=darkred ctermbg=none gui=none guifg=Darkred guibg=none
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
highlight	ExtraWhitespace	ctermbg=236

" match extra whitespaces
autocmd	FileType c,cpp,asm,text match ExtraWhitespace	"\( \+$\)\|\(^\zs \+\ze[^ ]\+\)\|\([^\t]\+\zs\t\+\ze$\)"
"}}}

"""""""""""""""""
" plugin config "
"""""""""""""""""
"{{{
"""""
"" omnicomplete
""""
"{{{
:"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set completeopt=menuone,preview,longest

let OmniCpp_DisplayMode = 0
let OmniCpp_MayCompleteScope = 1
let OmniCpp_ShowScopeInAbbr = 1
let OmniCpp_ShowPrototypeInAbbr = 0
let OmniCpp_SelectFirstItem = 0
let OmniCpp_NamespaceSearch = 2
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
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
let Tlist_Display_Prototype=0
set updatetime=1000

hi def link MyTagListTagScope mblue
hi def link MyTagListTitle mblue
hi def link MyTagListComment mblue

"nmap <silent> <F1> :TlistShowPrototype<cr>
"imap <silent> <F1> <esc>:TlistShowPrototype<cr>
nmap <silent> <F6>	:call <sid>ctags("")<cr>
imap <silent> <F6>	<esc>:call <sid>ctags("")<cr>
nmap <silent> <F9> :TlistToggle<cr>
imap <silent> <F9> <esc>:TlistToggle<cr><insert>
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

let g:airline_section_a = "%{airline#parts#mode()}"
let g:airline_section_b = "%{(&readonly || !&modifiable ? g:airline_symbol_ro : g:airline_symbol_rw)}%{(exists('+key') && !empty(&key) ? '  ' . g:airline_symbol_crypt : '')}"
let g:airline_section_c = "%<%f%m"
let g:airline_section_x = "%{&filetype}"
let g:airline_section_y = "%{&fileformat}%{(&fileencoding != '' ? '  ' . g:airline_right_alt_sep . ' ' : '')}%{&fileencoding}"
let g:airline_section_z = "%3p%%"
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
nmap <silent> <F5>	:Make<cr><cr>
imap <silent> <F5>	<esc>:let save=winnr()<cr> :Make<cr><cr> :exec save . "wincmd w"<cr><insert>
nmap <silent> <F7> :MakeToggle<cr>
imap <silent> <F7> <esc>:MakeToggle<cr>
"}}}

""""
"" scratch
""""
"{{{
nmap <silent> <F8> :ScratchToggle<cr>
imap <silent> <F8> <esc>:ScratchToggle<cr><insert>
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
" line numbers
nmap <silent> <F11> <ESC>:set nu!<CR>
imap <silent> <F11> <ESC>:set nu!<CR><insert>

" spell checking and highlighting
" find next miss-spelled word
nmap <silent> <F1>	]s
imap <silent> <F1>	<esc><right>]s<insert>

" add word under cursor to spellfile
nmap <silent> <F2>	zg
imap <silent> <F2>	<esc>zg<insert>

" toggle spell checking
nmap <silent> <F12> <ESC>:set spell!<CR>
imap <silent> <F12> <ESC>:set spell!<CR><insert><right>

" enable search highlighting
nmap <silent> <F10> <esc>:set hls!<cr>
imap <silent> <F10> <esc>:set hls!<cr><insert>

" syntax highlighting debug
nmap <F3> :call <sid>syn_stack()<cr>

" movement
nnoremap <silent> $ :$<cr>
vnoremap <silent> $ G
nnoremap <silent> = :0<cr>
vnoremap <silent> = gg
nnoremap <c-a> ggvG$
inoremap <c-a> <esc>ggvG$
nnoremap t <c-]>

" search
nmap <silent> <cr> /<cr>
nmap <silent> <backspace> ?<cr>
nnoremap <silent> f :set hls<cr>:let @/=expand("<cword>")<cr>

" redo undo
nmap <silent> <c-z> :undo<cr>
imap <silent> <c-z> <esc>:undo<cr><insert>
nmap <silent> <c-a-z> :redo<cr>
imap <silent> <c-a-z> <esc>:redo<cr><insert>

" shift-mark
nmap <silent> <s-left> v
imap <silent> <s-left> <ESC>:call <sid>v_key_shift()<cr>
vmap <silent> <s-left> b
nmap <silent> <s-right> v
imap <silent> <s-right> <ESC>:call <sid>v_key_shift()<cr>
vnoremap <silent> <s-right> w
nmap <silent> <s-up> v<up>
imap <silent> <s-up> <esc>:call <sid>v_key_shift()<cr><up>
vmap <silent> <s-up> <up>
nmap <silent> <s-down> v<down>
imap <silent> <s-down> <esc>:call <sid>v_key_shift()<cr><down>
vmap <silent> <s-down> <down>

" move marked text
vnoremap <silent> <tab> <c-v>I<tab><esc>
vnoremap <silent> <s-tab> <

" visual mode multi-line insert/append
vnoremap i I
vnoremap a A

" tabs
nmap <C-o> :tabnew 
imap <C-o> <esc>:tabnew 
nmap <silent> <C-C> <ESC>:q<CR>

nmap <silent> <C-Home> :tabprev<cr>
imap <silent> <C-Home> <esc>:tabprev<cr><insert>
nmap <silent> <C-End> :tabnext<cr>
imap <silent> <C-End> <esc>:tabnext<cr><insert>
nmap <silent> <c-pagedown> :wincmd w<cr>
imap <silent> <c-pagedown> <esc>:wincmd w<cr><insert>
nmap <silent> <c-pageup> :wincmd W<cr>
imap <silent> <c-pageup> <esc>:wincmd W<cr><insert>

" hex editor
cabbrev hex %!xxd
"}}}

"""""""""""""""""
" abbreviations "
"""""""""""""""""
"{{{
""""
"" C/C++
""""
"{{{
autocmd FileType c,cpp ab #i #include 
autocmd FileType c,cpp ab inlcude include
autocmd FileType c,cpp ab MPI_CW MPI_COMM_WORLD
"}}}

""""
"" laTex
""""
"{{{
autocmd FileType tex ab beign begin
autocmd FileType tex ab itmeize itemize
autocmd FileType tex ab ðescription description
autocmd FileType tex ab desc desription
autocmd FileType tex ab ð d
autocmd FileType tex ab ¢ c
"ab ¢enter center

autocmd FileType tex ab \begin{align*} \begin{align*}<cr><tab><cr><backspace>\end{align*}<up><end><c-r>=<sid>eat_char('\s')<insert>
autocmd FileType tex ab \begin{itemize} \begin{itemize}<cr><tab>\item <cr><backspace>\end{itemize}<up><end><c-r>=<sid>eat_char('\s')<insert>
autocmd FileType tex ab \begin{item} \begin{itemize}<cr><tab>\item <cr><backspace>\end{itemize}<up><end><c-r>=<sid>eat_char('\s')<insert>
autocmd FileType tex ab \begin{description} \begin{description}<cr>\item <cr>\end{description}<up><end><c-r>=<sid>eat_char('\s')<insert>
autocmd FileType tex ab \begin{enumerate} \begin{enumerate}<cr><tab>\item <cr><backspace>\end{enumerate}<up><end><c-r>=<sid>eat_char('\s')<insert>
autocmd FileType tex ab \begin{tabular} \begin{table}[]<cr><tab>\centering<cr><cr>\begin{tabular}{}<cr>\end{tabular}<cr><left>\end{table}<up><up><end><c-r>=<sid>eat_char('\s')<insert>
autocmd FileType tex ab \begin{minipage} \begin{minipage}{cm}<cr>\end{minipage}<up><end><left><left><c-r>=<sid>eat_char('\s')<insert>
autocmd FileType tex ab \begin{figure} \begin{figure}[]<cr><tab>\centering<cr>\includegraphics[scale=.5]{}<cr>\caption{}<cr><backspace>\end{figure}<up><up><up><end><c-r>=<sid>eat_char('\s')<esc><insert>
autocmd FileType tex ab \begin{tabfigure} \begin{figure}[]<cr>\begin{tabular}{cc}<cr><tab>\begin{minipage}{.5\textwidth}<cr><tab>\includegraphics[scale=.5]{}<cr><backspace>\end{minipage}&<cr>\begin{minipage}{.5\textwidth}<cr><tab>\includegraphics[scale=.5]{}<cr><backspace>\end{minipage}<cr><backspace>\end{tabular}<cr><tab>\caption{}<cr><backspace>\end{figure}<up><up><up><up><up><up><up><end><c-r>=<sid>eat_char('\s')<insert>
autocmd FileType tex ab \begin{columns} \begin{columns}<cr><tab>\begin{column}{5cm}<cr>\end{column}<cr><cr>\begin{column}{5cm}<cr>\end{column}<cr><backspace>\end{columns}<up><up><up><up><up><up><end><c-r>=<sid>eat_char('\s')<insert>
"}}}
"}}}
