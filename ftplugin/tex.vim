if exists("g:loaded_ft_tex") || &compatible
	finish
endif

let g:loaded_ft_tex = 1


" remove character from input
function s:eat_char(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunction



ab beign begin
ab itmeize itemize
ab ðescription description
ab desc desription
ab ð d
ab ¢ c

inoremap <buffer> <leader>item	<esc>:call Snippet("itemize.tex")<cr>
inoremap <buffer> <leader>enum	<esc>:call Snippet("enum.tex")<cr>
inoremap <buffer> <leader>desc	<esc>:call Snippet("description.tex")<cr>
inoremap <buffer> <leader>align	<esc>:call Snippet("align.tex")<cr>
inoremap <buffer> <leader>tab	<esc>:call Snippet("table.tex")<cr>
inoremap <buffer> <leader>fig	<esc>:call Snippet("figure.tex")<cr>
inoremap <buffer> <leader>tfig	<esc>:call Snippet("tabfigure.tex")<cr>
