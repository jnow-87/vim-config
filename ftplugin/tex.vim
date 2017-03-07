ab beign begin
ab itmeize itemize
ab ðescription description
ab desc desription
ab ð d
ab ¢ c

call util#map#i('<leader>itemize', ':call Snippet("itemize.tex")<cr>', '<buffer>')
call util#map#i('<leader>enum', ':call Snippet("enum.tex")<cr>', '<buffer>')
call util#map#i('<leader>desc', ':call Snippet("description.tex")<cr>', '<buffer>')
call util#map#i('<leader>align', ':call Snippet("align.tex")<cr>', '<buffer>')
call util#map#i('<leader>tab', ':call Snippet("table.tex")<cr>', '<buffer>')
call util#map#i('<leader>fig', ':call Snippet("figure.tex")<cr>', '<buffer>')
call util#map#i('<leader>tfig', ':call Snippet("tabfigure.tex")<cr>', '<buffer>')
