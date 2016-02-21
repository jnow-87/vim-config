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


ab \begin{align*} \begin{align*}<cr><tab><cr><backspace>\end{align*}<up><end><c-r>=<sid>eat_char('\s')<insert>
ab \begin{itemize} \begin{itemize}<cr><tab>\item <cr><backspace>\end{itemize}<up><end><c-r>=<sid>eat_char('\s')<insert>
ab \begin{item} \begin{itemize}<cr><tab>\item <cr><backspace>\end{itemize}<up><end><c-r>=<sid>eat_char('\s')<insert>
ab \begin{description} \begin{description}<cr>\item <cr>\end{description}<up><end><c-r>=<sid>eat_char('\s')<insert>
ab \begin{enumerate} \begin{enumerate}<cr><tab>\item <cr><backspace>\end{enumerate}<up><end><c-r>=<sid>eat_char('\s')<insert>
ab \begin{tabular} \begin{table}[]<cr><tab>\centering<cr><cr>\begin{tabular}{}<cr>\end{tabular}<cr><left>\end{table}<up><up><end><c-r>=<sid>eat_char('\s')<insert>
ab \begin{minipage} \begin{minipage}{cm}<cr>\end{minipage}<up><end><left><left><c-r>=<sid>eat_char('\s')<insert>
ab \begin{figure} \begin{figure}[]<cr><tab>\centering<cr>\includegraphics[scale=.5]{}<cr>\caption{}<cr><backspace>\end{figure}<up><up><up><end><c-r>=<sid>eat_char('\s')<esc><insert>
ab \begin{tabfigure} \begin{figure}[]<cr>\begin{tabular}{cc}<cr><tab>\begin{minipage}{.5\textwidth}<cr><tab>\includegraphics[scale=.5]{}<cr><backspace>\end{minipage}&<cr>\begin{minipage}{.5\textwidth}<cr><tab>\includegraphics[scale=.5]{}<cr><backspace>\end{minipage}<cr><backspace>\end{tabular}<cr><tab>\caption{}<cr><backspace>\end{figure}<up><up><up><up><up><up><up><end><c-r>=<sid>eat_char('\s')<insert>
ab \begin{columns} \begin{columns}<cr><tab>\begin{column}{5cm}<cr>\end{column}<cr><cr>\begin{column}{5cm}<cr>\end{column}<cr><backspace>\end{columns}<up><up><up><up><up><up><end><c-r>=<sid>eat_char('\s')<insert>
