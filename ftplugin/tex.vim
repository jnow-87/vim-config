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
