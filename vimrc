"""""""""""
" options "
"""""""""""

	function g:calcWidths()
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

	" vim common
		runtime! debian.vim
		syntax on
		set nocp
		set nu!
		filetype plugin on
		set ai!
		set tabstop=4
		set shiftwidth=4
		set numberwidth=2
		set spelllang=de,en
		set spellfile=~/.vim/spell/vimspell.add
		set tabpagemax=100
		set foldmethod=marker
		set dir=/tmp



		" The following are commented out as they cause vim to behave a lot
		" differently from regular Vi. They are highly recommended though.
		"set showcmd		" Show (partial) command in status line.
		"set showmatch		" Show matching brackets.
		"set ignorecase		" Do case insensitive matching
		"set smartcase		" Do smart case matching
		"set incsearch		" Incremental search
		"set autowrite		" Automatically save before commands like :next and :make
		"set hidden         " Hide buffers when they are abandoned
		"set mouse=a		" Enable mouse usage (all modes) in terminals

	" coloring
		highlight	mblue		ctermfg=27
		highlight	mgreen		ctermfg=28
		highlight	Comment		ctermfg=27
		highlight	LineNr		term=bold cterm=NONE ctermfg=darkred ctermbg=NONE gui=NONE guifg=Darkred guibg=NONE
		highlight	Search		ctermfg=0 ctermbg=1
		highlight	Pmenu		ctermfg=0 ctermbg=1
		highlight	PmenuSel	ctermfg=0 ctermbg=3
		highlight	SpellBad	ctermfg=7 ctermbg=88
		highlight	SpellCap	ctermfg=7 ctermbg=21
		highlight	SpellLocal	ctermfg=7 ctermbg=57
		highlight	Visual		ctermfg=7 ctermbg=237
		highlight	DiffAdd		ctermbg=22
		highlight	DiffChange	ctermbg=33
		highlight	DiffDelete	ctermbg=88
		highlight	DiffText	ctermbg=1, ctermfg=15

	" omnicomplete
		"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
		"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
		autocmd BufWinEnter *.[ch],*.cc :silent exe "set tags+=/tmp/" . fnamemodify($PWD, ':t') . ".tags"
		autocmd VimEnter *.[ch],*.cc :silent exe "!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq --languages=c,c++ -f /tmp/" . fnamemodify($PWD, ':t') . ".tags ."
		autocmd BufWritePost *.[ch],*.cc :silent exe "!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq --languages=c,c++ --append=yes -f /tmp/" . fnamemodify($PWD, ':t') . ".tags " . fnamemodify(bufname("%"), ':h')
		autocmd VimLeave *.[ch],*.cc :silent exe "!rm /tmp/" . fnamemodify($PWD, ':t') . ".tags"
		autocmd VimResized * :call g:calcWidths()

		set completeopt+=longest

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
		"let Tlist_Sort_Type='name'
		let Tlist_Use_Right_Window=1
		let Tlist_Enable_Fold_Column=0
		let Tlist_Display_Prototype=1
		set updatetime=100

		set tag+=~/.vim/tags/stdc.tags		" generated with ctags on /usr/include
		set tag+=~.vim/tags/kernel.tags		" generated with ctags on /usr/src/<kernel version>/include/linux

		hi def link MyTagListTagScope mblue
		hi def link MyTagListTitle mblue
		hi def link MyTagListComment mblue

"""""""""""""""""
" abbreviations "
"""""""""""""""""

	func Eatchar(pat)
		let c = nr2char(getchar(0)) 
		return (c =~ a:pat) ? '' : c
	endfunc

	" C/C++
		ab #i #include 
		ab inlcude include
		ab MPI_CW MPI_COMM_WORLD

	" laTex
		ab beign begin
		ab itmeize itemize
		ab ðescription description
		ab desc desription
		ab ð d
		ab ¢ c
		"ab ¢enter center

		ab \begin{align*} \begin{align*}<cr><tab><cr><backspace>\end{align*}<up><end><c-r>=Eatchar('\s')<cr><insert>
		ab \begin{itemize} \begin{itemize}<cr><tab>\item <cr><backspace>\end{itemize}<up><end><c-r>=Eatchar('\s')<cr><insert>
		ab \begin{item} \begin{itemize}<cr><tab>\item <cr><backspace>\end{itemize}<up><end><c-r>=Eatchar('\s')<cr><insert>
		ab \begin{description} \begin{description}<cr>\item <cr>\end{description}<up><end><c-r>=Eatchar('\s')<cr><insert>
		ab \begin{enumerate} \begin{enumerate}<cr><tab>\item <cr><backspace>\end{enumerate}<up><end><c-r>=Eatchar('\s')<cr><insert>
		ab \begin{tabular} \begin{table}[]<cr><tab>\centering<cr><cr>\begin{tabular}{}<cr>\end{tabular}<cr><left>\end{table}<up><up><end><c-r>=Eatchar('\s')<cr><insert>
		ab \begin{minipage} \begin{minipage}{cm}<cr>\end{minipage}<up><end><left><left><c-r>=Eatchar('\s')<cr><insert>
		ab \begin{figure} \begin{figure}[]<cr><tab>\centering<cr>\includegraphics[draft=\isdraft, scale=.5]{}<cr>\caption{}<cr><backspace>\end{figure}<up><up><up><end><c-r>=Eatchar('\s')<cr><esc><insert>
		ab \begin{tabfigure} \begin{figure}[]<cr>\begin{tabular}{cc}<cr><tab>\begin{minipage}{7cm}<cr><tab>\includegraphics[scale=.5]{}<cr><backspace>\end{minipage}&<cr>\begin{minipage}{7cm}<cr><tab>\includegraphics[scale=.5]{}<cr><backspace>\end{minipage}<cr><backspace>\end{tabular}<cr><tab>\caption{}<cr><backspace>\end{figure}<up><up><up><up><up><up><up><end><c-r>=Eatchar('\s')<cr><insert>
		ab \begin{columns} \begin{columns}<cr><tab>\begin{column}{5cm}<cr>\end{column}<cr><cr>\begin{column}{5cm}<cr>\end{column}<cr><backspace>\end{columns}<up><up><up><up><up><up><end><c-r>=Eatchar('\s')<cr><insert>

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

	" vim functions
		command! Q :q
		command! W :w
		" find next missspelled word
		nmap <silent> <F1>	]s
		imap <silent> <F1>	<esc>]s<insert>

		" add word under cursor to spellfile
		nmap <silent> <F2>	zg
		imap <silent> <F2>	<esc>zg<insert>
		nmap <silent> <F5>	:Make<cr><cr>
		imap <silent> <F5>	<esc>:let save=winnr()<cr> :Make<cr><cr> :exec save . "wincmd w"<cr><insert>
		nmap <silent> <F6>	:exe "!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq --languages=c,c++ -f /tmp/" . fnamemodify($PWD, ':t') . ".tags ."<cr><cr>:echo "updated tags: /tmp/vim.tags." . fnamemodify($PWD, ':t')<cr>
		imap <silent> <F6>	<esc>:exe "!ctags -R --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+fq --languages=c,c++ -f /tmp/" . fnamemodify($PWD, ':t') . ".tags ."<cr><cr>:echo "updated tags: /tmp/vim.tags." . fnamemodify($PWD, ':t')<cr>
		nmap <silent> <F10> <esc>:set hls!<cr>
		imap <silent> <F10> <esc>:set hls!<cr><insert>
		nmap <silent> <F11> <ESC>:set nu!<CR>
		imap <silent> <F11> <ESC>:set nu!<CR><insert>
		nmap <silent> <F12> <ESC>:set spell!<CR>
		imap <silent> <F12> <ESC>:set spell!<CR><insert><right>

	" make
	 	nmap <silent> <F7> :MakeToggle<cr>
		imap <silent> <F7> <esc>:MakeToggle<cr>

	" scratch
		nmap <silent> <F8> :ScratchToggle<cr>
		imap <silent> <F8> <esc>:ScratchToggle<cr><insert>

	" tagList
"		nmap <silent> <F1> :TlistShowPrototype<cr>
"		imap <silent> <F1> <esc>:TlistShowPrototype<cr>
		nmap <silent> <F9> :TlistToggle<cr>
		imap <silent> <F9> <esc>:TlistToggle<cr><insert>

	" movement
		nnoremap <silent> $ :$<cr>
		nnoremap <silent> = :0<cr>

	" search
		nmap <silent> <cr> /<cr>
		nmap <silent> <backspace> ?<cr>

	" redo undo
		nmap <silent> <c-z> :undo<cr>
		imap <silent> <c-z> <esc>:undo<cr><insert>
		nmap <silent> <c-r> :redo<cr>
		imap <silent> <c-r> <esc>:redo<cr><insert>

	" copy/paste/mark
		" copy
			"vnoremap y "ay
			"nnoremap p "ap
			"vnoremap x "ax
			imap <silent> <C-V> <ESC>p<INSERT>

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

	" folding
	" FoldingMethode <manual, marker, syntax, indent, expr>
		nmap <silent> <s-F> :foldopen<CR><insert>
		nmap <silent> <c-F> :foldclose<CR>
		vmap <silent> <c-F> :fold<CR>
		imap <silent> <c-F> <ESC>:foldclose<CR>

	" tabs
		nmap <C-o> :tabnew 
		imap <C-o> <esc>:tabnew 
		nmap <silent> <C-C> <ESC>:q<CR>

		nmap <silent> <C-Home> :tabprev<cr>
		imap <silent> <C-Home> <esc>:tabprev<cr><insert>
		nmap <silent> <C-End> :tabnext<cr>
		imap <silent> <C-End> <esc>:tabnext<cr><insert>

	" auto vervollstaendigung
		"imap <F2> <c-x><c-o>
		"imap <F3> <c-x><c-i>
		"imap <F4> <ESC>:pclose<CR><insert>
		"map <F4> <ESC>:pclose<CR><insert>
