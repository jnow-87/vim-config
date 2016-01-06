"""""""""""
" options "
"""""""""""
	function! g:calcWidths()
		if &columns/5 <= 20
			let g:Tlist_WinWidth = 20
			let g:scratchWinWidth = 20
		else
			let g:Tlist_WinWidth=&columns/5
			let g:scratchWinWidth=g:Tlist_WinWidth
		endif

		if &window/5 <= 7
			let g:makeWinHeight = 7
		else
			let g:makeWinHeight = &window/5
		endif
	endfunction

	" function to enable colorcolumn for all but some filetypes
	function! g:enableColorColumn()
		" enable colorcolumn for selected filetypes
		" or empty filetype
		if &filetype =~ 'text\|gitcommit\|^$'
			setlocal colorcolumn=80
		endif
	endfunction

	" function to define highlighting, etc. for given filetypes
	function! g:setHighlight()
		if &filetype =~ 'text\|^$'
			syn match heading "\s*\*\*\*.*"
			syn match comment "^#.*"
			hi def link heading mlblue
			hi def link comment mblue
			set commentstring=#%s
		endif
	endfunction

	" vim common
		runtime! debian.vim
		syntax on
		set showcmd			" Show (partial) command in status line.
		set ignorecase		" Do case insensitive matching
		set smartcase		" Do smart case matching
		set incsearch		" Incremental search
		"set mouse=a		" Enable mouse usage (all modes) in terminals
		set nocp
		set nu!
		filetype plugin on
		set ai!
		set noexpandtab
		set tabstop=4
		set shiftwidth=4
		set numberwidth=2
		set spelllang=de,en
		set spellfile=~/.vim/spell/vimspell.add
		set tabpagemax=100
		set dir=/tmp

		autocmd BufEnter * call g:enableColorColumn()

	" vimdiff
		autocmd VimEnter * if &diff | execute 'windo set wrap' | endif	" enable line wrap

	" syntax highlighting
		highlight	mred			ctermfg=124
		highlight	mlblue			ctermfg=6
		highlight	mblue			ctermfg=27
		highlight	mgreen			ctermfg=28
		highlight	morange			ctermfg=202
		highlight	Comment			ctermfg=27
		highlight	LineNr			term=bold cterm=NONE ctermfg=darkred ctermbg=NONE gui=NONE guifg=Darkred guibg=NONE
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
		highlight	MatchParen		ctermfg=7 ctermbg=88
		highlight	ColorColumn		ctermbg=235
		highlight	SignColumn		ctermbg=0

		highlight	ExtraWhitespace	ctermbg=236
		autocmd 	BufEnter *.[chsS],*.cc,*.txt match ExtraWhitespace	"\( \+$\)\|\(^\zs \+\ze[^ ]\+\)\|\([^\t]\+\zs\t\+\ze$\)"
		autocmd 	BufEnter * call g:setHighlight()
		autocmd		BufRead,BufNewFile *.lds setf ld
		autocmd		BufRead,BufNewFile *.gperf setf gperf

	" omnicomplete
		:"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
		"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
		autocmd BufWinEnter *.[chsS],*.cc :silent exe "set tags+=/tmp/" . fnamemodify($PWD, ':t') . ".tags"
"		autocmd BufWinEnter *.java :silent exe "set tags+=/tmp/" . fnamemodify($PWD, ':t') . ".tags"
		autocmd VimEnter *.[chsS],*.cc :silent exe "!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq --languages=c,c++ -f /tmp/" . fnamemodify($PWD, ':t') . ".tags ."
"		autocmd VimEnter *.java :silent exe "!ctags -R --java-kinds=+p --fields=+iaS --extra=+fq --languages=java -f /tmp/" . fnamemodify($PWD, ':t') . ".tags ."
		autocmd VimEnter * :call g:calcWidths()
		autocmd BufWritePost *.[chsS],*.cc :silent exe "!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq --languages=c,c++ --append=yes -f /tmp/" . fnamemodify($PWD, ':t') . ".tags " . fnamemodify(bufname("%"), ':h')
"		autocmd BufWritePost *.java :silent exe "!ctags -R --java-kinds=+p --fields=+iaS --extra=+fq --languages=java --append=yes -f /tmp/" . fnamemodify($PWD, ':t') . ".tags " . fnamemodify(bufname("%"), ':h')
		autocmd VimLeave *.[chsS],*.cc :silent exe "!rm /tmp/" . fnamemodify($PWD, ':t') . ".tags"
		autocmd VimResized * :call g:calcWidths()

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

	" taglist
		let Tlist_GainFocus_On_ToggleOpen=1
		let Tlist_Exit_OnlyWindow=1
		let Tlist_Use_SingleClick=1
		let Tlist_Auto_Highlight_Tag=1
		let Tlist_Sort_Type='name'
		let Tlist_Use_Right_Window=1
		let Tlist_Enable_Fold_Column=0
		let Tlist_Display_Prototype=0
		set updatetime=1000

		set tag+=~/.vim/tags/stdc.tags		" generated with ctags on /usr/include
		set tag+=~.vim/tags/kernel.tags		" generated with ctags on /usr/src/<kernel version>/include/linux

		hi def link MyTagListTagScope mblue
		hi def link MyTagListTitle mblue
		hi def link MyTagListComment mblue

	" lex/yacc
		let yacc_uses_cpp = 1
		let lex_uses_cpp = 1

	" vimgdb
		let vimgdb_gdblog_show = 0
		let vimgdb_userlog_show = 0
		let vimgdb_use_xterm = 0
"		let vimgdb_gdb_cmd = 'avr-gdb -ex \"target remote 127.0.0.1:1212\"'

"""""""""""""""""
" abbreviations "
"""""""""""""""""

	func! Eatchar(pat)
		let c = nr2char(getchar(0))
		return (c =~ a:pat) ? '' : c
	endfunc

	" C/C++
		autocmd FileType c,cpp ab #i #include 
		autocmd FileType c,cpp ab inlcude include
		autocmd FileType c,cpp ab MPI_CW MPI_COMM_WORLD

	" laTex
		autocmd FileType tex ab beign begin
		autocmd FileType tex ab itmeize itemize
		autocmd FileType tex ab ðescription description
		autocmd FileType tex ab desc desription
		autocmd FileType tex ab ð d
		autocmd FileType tex ab ¢ c
		"ab ¢enter center

		autocmd FileType tex ab \begin{align*} \begin{align*}<cr><tab><cr><backspace>\end{align*}<up><end><c-r>=Eatchar('\s')<insert>
		autocmd FileType tex ab \begin{itemize} \begin{itemize}<cr><tab>\item <cr><backspace>\end{itemize}<up><end><c-r>=Eatchar('\s')<insert>
		autocmd FileType tex ab \begin{item} \begin{itemize}<cr><tab>\item <cr><backspace>\end{itemize}<up><end><c-r>=Eatchar('\s')<insert>
		autocmd FileType tex ab \begin{description} \begin{description}<cr>\item <cr>\end{description}<up><end><c-r>=Eatchar('\s')<insert>
		autocmd FileType tex ab \begin{enumerate} \begin{enumerate}<cr><tab>\item <cr><backspace>\end{enumerate}<up><end><c-r>=Eatchar('\s')<insert>
		autocmd FileType tex ab \begin{tabular} \begin{table}[]<cr><tab>\centering<cr><cr>\begin{tabular}{}<cr>\end{tabular}<cr><left>\end{table}<up><up><end><c-r>=Eatchar('\s')<insert>
		autocmd FileType tex ab \begin{minipage} \begin{minipage}{cm}<cr>\end{minipage}<up><end><left><left><c-r>=Eatchar('\s')<insert>
		autocmd FileType tex ab \begin{figure} \begin{figure}[]<cr><tab>\centering<cr>\includegraphics[scale=.5]{}<cr>\caption{}<cr><backspace>\end{figure}<up><up><up><end><c-r>=Eatchar('\s')<esc><insert>
		autocmd FileType tex ab \begin{tabfigure} \begin{figure}[]<cr>\begin{tabular}{cc}<cr><tab>\begin{minipage}{.5\textwidth}<cr><tab>\includegraphics[scale=.5]{}<cr><backspace>\end{minipage}&<cr>\begin{minipage}{.5\textwidth}<cr><tab>\includegraphics[scale=.5]{}<cr><backspace>\end{minipage}<cr><backspace>\end{tabular}<cr><tab>\caption{}<cr><backspace>\end{figure}<up><up><up><up><up><up><up><end><c-r>=Eatchar('\s')<insert>
		autocmd FileType tex ab \begin{columns} \begin{columns}<cr><tab>\begin{column}{5cm}<cr>\end{column}<cr><cr>\begin{column}{5cm}<cr>\end{column}<cr><backspace>\end{columns}<up><up><up><up><up><up><end><c-r>=Eatchar('\s')<insert>

"""""""""""""
" shortcuts "
"""""""""""""
	function! ShiftVisual()
		if getpos(".")[2] == 1
			normal v
		else
			let pos = getpos(".")
			call setpos(".", [pos[0], pos[1], pos[2]+1, pos[3]])
			normal v
		endif
	endfunction

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
		" echo syntax highlighting groups that apply to pattern under cursor
		function! <sid>SynStack()
			if !exists("*synstack")
				return
			endif
			echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
			echo "hi: " . synIDattr(synID(line("."),col("."),1),"name") . ', trans: ' . synIDattr(synID(line("."),col("."),0),"name") . ", lo: " . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
		endfunc
		
		nmap <F3> :call <sid>SynStack()<cr>

	" make
		nmap <silent> <F5>	:Make<cr><cr>
		imap <silent> <F5>	<esc>:let save=winnr()<cr> :Make<cr><cr> :exec save . "wincmd w"<cr><insert>
	 	nmap <silent> <F7> :MakeToggle<cr>
		imap <silent> <F7> <esc>:MakeToggle<cr>

	" scratch
		nmap <silent> <F8> :ScratchToggle<cr>
		imap <silent> <F8> <esc>:ScratchToggle<cr><insert>

	" tagList
"		nmap <silent> <F1> :TlistShowPrototype<cr>
"		imap <silent> <F1> <esc>:TlistShowPrototype<cr>
		nmap <silent> <F6>	:exe "!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq --languages=c,c++ -f /tmp/" . fnamemodify($PWD, ':t') . ".tags ."<cr><cr>:echo "updated tags: /tmp/vim.tags." . fnamemodify($PWD, ':t')<cr>
		imap <silent> <F6>	<esc>:exe "!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq --languages=c,c++ -f /tmp/" . fnamemodify($PWD, ':t') . ".tags ."<cr><cr>:echo "updated tags: /tmp/vim.tags." . fnamemodify($PWD, ':t')<cr>
		nmap <silent> <F9> :TlistToggle<cr>
		imap <silent> <F9> <esc>:TlistToggle<cr><insert>

	" movement
		nnoremap <silent> $ :$<cr>
		vnoremap <silent> $ G
		nnoremap <silent> = :0<cr>
		vnoremap <silent> = gg

	" search
		nmap <silent> <cr> /<cr>
		nmap <silent> <backspace> ?<cr>

	" redo undo
		nmap <silent> <c-z> :undo<cr>
		imap <silent> <c-z> <esc>:undo<cr><insert>
		nmap <silent> <c-a-z> :redo<cr>
		imap <silent> <c-a-z> <esc>:redo<cr><insert>

	" shift-mark
		nmap <silent> <s-left> v
		imap <silent> <s-left> <ESC>:call ShiftVisual()<cr>
		vmap <silent> <s-left> b
		nmap <silent> <s-right> v
		imap <silent> <s-right> <ESC>:call ShiftVisual()<cr>
		vnoremap <silent> <s-right> w
		nmap <silent> <s-up> v<up>
		imap <silent> <s-up> <esc>:call ShiftVisual()<cr><up>
		vmap <silent> <s-up> <up>
		nmap <silent> <s-down> v<down>
		imap <silent> <s-down> <esc>:call ShiftVisual()<cr><down>
		vmap <silent> <s-down> <down>

	" move marked text
		vmap <silent> <tab> >
		vmap <silent> <s-tab> <

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
