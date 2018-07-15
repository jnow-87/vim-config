" Vim syntax file
" Language:	Yacc
" Maintainer:	Charles E. Campbell <NdrOchipS@PcampbellAfamily.Mbiz>
" Last Change:	Mar 20, 2014
" Version:	11
" URL:	http://mysite.verizon.net/astronaut/vim/index.html#vimlinks_syntax
"
" Options: {{{1
"   g:yacc_uses_cpp : if this variable exists, then C++ is loaded rather than C

" ---------------------------------------------------------------------
" this version of syntax/yacc.vim requires 6.0 or later
if version < 600
	finish
endif

if exists("b:current_syntax")
	syntax clear
endif


" ---------------------------------------------------------------------
" Read the C syntax to start with {{{1
" Read the C/C++ syntax to start with
let s:c_path = fnameescape(expand("<sfile>:p:h") . (exists("g:yacc_uses_cpp") ? "/cpp.vim" : "/c.vim"))

if !filereadable(s:c_path)
	for s:c_path in split(globpath(&rtp, (exists("g:yacc_uses_cpp") ? "syntax/cpp.vim" : "syntax/c.vim")), "\n")
		if filereadable(fnameescape(s:c_path))
			let s:c_path = fnameescape(s:c_path)
			break
		endif
	endfor
endif

let b:syntax_c_fold = 0
let b:syntax_c_fold_comment = 0
exe "syn include @cCode " . s:c_path


" ---------------------------------------------------------------------
"  Yacc Clusters: {{{1
syn cluster yaccDefCluster		contains=yaccComment,yaccSection,yaccKey,yaccDefine,yaccDestructor
syn cluster yaccRulesCluster	contains=yaccComment,yaccRuleLHS
syn cluster yaccUserCodeCluster	contains=@cCode


" ---------------------------------------------------------------------
"  Yacc Sections: {{{1
syn region	yaccDefinitions		start='.' end='^%%$'me=e-2,re=e-2 contains=@yaccDefCluster nextgroup=yaccRules skipwhite skipempty skipnl
syn region	yaccRules			matchgroup=yaccSectionSep start='^%%$'  end='^%%$'me=e-2,re=e-2 contains=@yaccRulesCluster nextgroup=yaccUserCode skipwhite skipempty skipnl
syn region	yaccUserCode		matchgroup=yaccSectionSep start='^%%$' end='\%$' contains=@yaccUserCodeCluster


" ---------------------------------------------------------------------
"  Yacc Common Rules: {{{1
syn	region	yaccComment			start="/\*"	end="\*/" contained
syn	region	yaccComment			start="//" 	skip="\\$" end="$" keepend contained
syn region	yaccCCode			matchgroup=yaccCurly start="^%{" start="{" matchgroup=yaccCurly end="[%]\?}" skipwhite skipempty contains=@cCode contained fold


" ---------------------------------------------------------------------
"  Yacc Definition Section Rules: {{{1
syn	match	yaccType			"<[a-zA-Z_][a-zA-Z0-9_]*>" contains=yaccBrkt contained
syn	match	yaccBrkt			"[<>]" contained
syn	match	yaccSection			"^%\(union\|initial-action\|parse-param\|lex-param\|code\s*\(top\|requires\|provides\)*\|\)\ze\s*{" skipwhite skipnl nextgroup=yaccCCode contained
syn	match	yaccKey				"^\s*%\(left\|right\|start\|ident\|nonassoc\|locations\|api\.pure\|pure-parser\|error-verbose\|prec\|expect\|glr-parser\)\>" contained
syn region	yaccDestructor		matchgroup=yaccSection start="%destructor" matchgroup=yaccSection end="destructor" skipwhite skipnl contains=yaccCCode contained
syn keyword	yaccKey				yyerrok yyclearin contained
syn	match	yaccKey				"^\s*%\(token\|type\)" nextgroup=yaccType skipwhite contained
syn	match	yaccDefine			'^%define\s\+.*$' contained


" ---------------------------------------------------------------------
"  Yacc Rule Section Rules: {{{1
syn region	yaccRuleLHS			start="^[0-9A-Za-z_-]\+" end=":"me=e-1 nextgroup=yaccRuleRHS skipwhite skipempty contained
syn region	yaccRuleRHS			matchgroup=yaccRuleSep start="[:|]" end="{"me=e-1 contains=yaccRuleSymbol,yaccRuleLiteral nextgroup=yaccRuleAction contained
syn match	yaccRuleSymbol		"[%a-zA-Z0-9_-]\+" contained
syn match	yaccRuleLiteral		"'[^']\+'" contained
syn region	yaccRuleAction		matchgroup=yaccCurly start="^%{" start="{" matchgroup=yaccCurly end="}" nextgroup=yaccRuleRHS,yaccRuleEnd skipwhite skipempty contains=yaccVar,yaccLoc,@cCode contained
syn match	yaccRuleEnd			";" contained
syn	match	yaccVar				'\$\d\+\|\$\$\|\$<\I\i*>\$\|\$<\I\i*>\d\+' containedin=cParen,cPreProc,cMulti contained
syn	match	yaccLoc				'@\d\+\|\$\$\|\$<\I\i*>\$\|\$<\I\i*>\d\+' containedin=cParen,cPreProc,cMulti contained


" ---------------------------------------------------------------------
" Yacc synchronization: {{{1
syn sync fromstart


" ---------------------------------------------------------------------
" Define the default highlighting. {{{1
if !exists("did_yacc_syn_inits")
	hi def link yaccSection			mlblue
	hi def link yaccCurly			white
	hi def link yaccKey				mlblue
	hi def link yaccDefine			mlblue
	hi def link yaccSectionSep		Todo
	hi def link yaccRuleLHS			mlblue
	hi def link yaccRuleRHS			mlblue
	hi def link yaccRuleSep			white
	hi def link yaccRuleSymbol		mlblue
	hi def link yaccRuleLiteral		white
	hi def link yaccBrkt			mlblue
	hi def link yaccComment			mgreen
	hi def link yaccType			mblue
	hi def link yaccVar				mlblue
	hi def link yaccLoc				mlblue
endif

let b:current_syntax = "yacc"
