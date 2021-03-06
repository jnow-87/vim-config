" Vim syntax file
" Language:	Lex
" Maintainer:	Charles E. Campbell <NdrOchipS@PcampbellAfamily.Mbiz>
" Last Change:	Nov 14, 2012
" Version:	14
" URL:	http://mysite.verizon.net/astronaut/vim/index.html#vimlinks_syntax
"
" Option:
"   lex_uses_cpp : if this variable exists, then C++ is loaded rather than C

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C/C++ syntax to start with
let s:Cpath= fnameescape(expand("<sfile>:p:h").(exists("g:lex_uses_cpp")? "/cpp.vim" : "/c.vim"))
if !filereadable(s:Cpath)
 for s:Cpath in split(globpath(&rtp,(exists("g:lex_uses_cpp")? "syntax/cpp.vim" : "syntax/c.vim")),"\n")
  if filereadable(fnameescape(s:Cpath))
   let s:Cpath= fnameescape(s:Cpath)
   break
  endif
 endfor
endif
exe "syn include @lexCcode ".s:Cpath

" --- ========= ---
" --- Lex stuff ---
" --- ========= ---

" Options Section
syn match lexOptions '^%option\>' contains=lexPatString

" Abbreviations Section
if has("folding")
 syn region lexAbbrvBlock	fold start="."	end="^\ze%%$"	skipnl	nextgroup=lexPatBlock contains=lexAbbrv,lexInclude,lexAbbrvComment,lexStartState,lexComment,lexOptions
else
 syn region lexAbbrvBlock	start="."	end="^\ze%%$"	skipnl	nextgroup=lexPatBlock contains=lexAbbrv,lexInclude,lexAbbrvComment,lexStartState,lexComment,lexOptions
endif
syn match  lexAbbrv		"^\I\i*\s"me=e-1			skipwhite	contained nextgroup=lexAbbrvRegExp
syn match  lexAbbrv		"^%[sx]"					contained
syn match  lexAbbrvRegExp	"\s\S.*$"lc=1				contained nextgroup=lexAbbrv,lexInclude
if has("folding")
 syn region lexInclude	fold matchgroup=lexSep	start="^%{"	end="%}"	contained	contains=@lexCcode
 syn region lexAbbrvComment	fold			start="^\s\+/\*"	end="\*/"	contains=@Spell
 syn region lexAbbrvComment	fold			start="\%^/\*"	end="\*/"	contains=@Spell
 syn region lexComment	fold 			start="/\*"	end="\*/"

 syn region lexStartState	fold matchgroup=lexAbbrv	start="^%[xs]"	end=" "	contained
else
 syn region lexComment	start="/\*"	end="\*/"
 syn region lexInclude	matchgroup=lexSep		start="^%{"	end="%}"	contained	contains=@lexCcode
 syn region lexAbbrvComment				start="^\s\+/\*"	end="\*/"	contains=@Spell
 syn region lexAbbrvComment				start="\%^/\*"	end="\*/"	contains=@Spell
 syn region lexStartState	matchgroup=lexAbbrv		start="^%\a\+"	end="$"	contained
endif

"%% : Patterns {Actions}
if has("folding")
 syn region lexPatBlock	fold matchgroup=Todo	start="^%%$" matchgroup=Todo	end="^%\ze%$"	skipnl	skipwhite	nextgroup=lexFinalCodeBlock	contains=lexPatTag,lexPatTagZone,lexPatComment,lexPat,lexPatInclude
 syn region lexPat		fold			start=+\S+ skip="\\\\\|\\."	end="\s"me=e-1	skipwhite	contained nextgroup=lexMorePat,lexPatSep,lexPattern contains=lexPatTag,lexPatString,lexSlashQuote,lexBrace
 syn region lexPatInclude	fold matchgroup=lexSep	start="^%{"	end="%}"	contained	contains=lexPatCode,@lexCcode
 syn region lexBrace	fold			start="\[" skip=+\\\\\|\\+	end="]"			contained
 syn region lexPatString	fold 	start=+"+	skip=+\\\\\|\\"+	 end=+"+	contained
else
 syn region lexPatBlock	matchgroup=Todo		start="^%%$" matchgroup=Todo	end="^%%$"	skipnl	skipwhite	nextgroup=lexFinalCodeBlock	contains=lexPatTag,lexPatTagZone,lexPatComment,lexPat,lexPatInclude
 syn region lexPat					start=+\S+ skip="\\\\\|\\."	end="\s"me=e-1	skipwhite	contained nextgroup=lexMorePat,lexPatSep,lexPattern contains=lexPatTag,lexPatString,lexSlashQuote,lexBrace
 syn region lexPatInclude	matchgroup=lexSep		start="^%{"	end="%}"	contained	contains=lexPatCode,@lexCcode
 syn region lexBrace				start="\[" skip=+\\\\\|\\+	end="]"			contained
 syn region lexPatString			start=+"+	skip=+\\\\\|\\"+	 end=+"+	contained
endif
syn match  lexPatTag	"^<\I\i*\(,\I\i*\)*>"			contained nextgroup=lexPat,lexPatTag,lexMorePat,lexPatSep
syn match  lexPatTagZone	"^<\I\i*\(,\I\i*\)*>\s\+\ze{"			contained nextgroup=lexPatTagZoneStart
syn match  lexPatTag	+^<\I\i*\(,\I\i*\)*>*\(\\\\\)*\\"+		contained nextgroup=lexPat,lexPatTag,lexMorePat,lexPatSep

" Lex Patterns
syn region lexPattern	start='[^ \t{}]'	end="$"			contained	contains=lexPatRange
syn region lexPatRange	matchgroup=Delimiter	start='\['	skip='\\\\\|\\.'	end='\]'	contains=lexEscape
syn match  lexEscape	'\%(\\\\\)*\\.'				contained

if has("folding")
 syn region lexPatTagZoneStart matchgroup=lexPatTag	fold	start='{' end='}'	contained contains=lexPat,lexPatComment
 syn region lexPatComment	start="\s\+/\*" end="\*/"	fold	skipnl	contained contains=cTodo skipwhite nextgroup=lexPatComment,lexPat,@Spell
else
 syn region lexPatTagZoneStart matchgroup=lexPatTag		start='{' end='}'	contained contains=lexPat,lexPatComment
 syn region lexPatComment	start="\s\+/\*" end="\*/"		skipnl	contained contains=cTodo skipwhite nextgroup=lexPatComment,lexPat,@Spell
endif
syn match  lexPatCodeLine	"[^{\[].*"				contained contains=@lexCcode
syn match  lexMorePat	"\s*|\s*$"			skipnl	contained nextgroup=lexPat,lexPatTag,lexPatComment
syn match  lexPatSep	"\s\+"					contained nextgroup=lexMorePat,lexPatCode,lexPatCodeLine
syn match  lexSlashQuote	+\(\\\\\)*\\"+				contained
if has("folding")
 syn region lexPatCode matchgroup=lexStartState start="{" end="}"	fold	skipnl contained contains=@lexCcode,lexCFunctions
else
 syn region lexPatCode matchgroup=lexStartState start="{" end="}"	skipnl	contained contains=@lexCcode,lexCFunctions
endif

" Lex "functions" which may appear in C/C++ code blocks
syn keyword lexCFunctions	BEGIN	input	unput	woutput	yyleng	yylook	yytext
syn keyword lexCFunctions	ECHO	output	winput	wunput	yyless	yymore	yywrap

" %%
"  lexAbbrevBlock
" %%
"  lexPatBlock
" %%
"  lexFinalCodeBlock
syn region lexFinalCodeBlock matchgroup=Todo start="%$"me=e-1 end="\%$"	contained	contains=@lexCcode

" <c.vim> includes several ALLBUTs; these have to be treated so as to exclude lex* groups
syn cluster cParenGroup	add=lex.*
syn cluster cDefineGroup	add=lex.*
syn cluster cPreProcGroup	add=lex.*
syn cluster cMultiGroup	add=lex.*

" Synchronization
syn sync clear
syn sync minlines=500
syn sync match lexSyncPat	grouphere  lexPatBlock	"^%[a-zA-Z]"
syn sync match lexSyncPat	groupthere lexPatBlock	"^<$"
syn sync match lexSyncPat	groupthere lexPatBlock	"^%%$"

" The default highlighting.
hi def link lexComment	mgreen
hi def link lexAbbrvComment	mgreen
hi def link lexAbbrvRegExp	mred
hi def link lexAbbrv	mlblue
hi def link lexBrace	mlblue
hi def link lexCFunctions	white
hi def link lexCstruct	mred
hi def link lexMorePat	mred
hi def link lexOptions	mlblue
hi def link lexPatComment	mgreen
hi def link lexPat		mlblue
hi def link lexPatString	mlblue
hi def link lexPatTag	white
hi def link lexPatTagZone	mred
hi def link lexSep		mlblue
hi def link lexSlashQuote	mred
hi def link lexStartState	white

let b:current_syntax = "lex"

" vim:ts=10
