if exists("b:current_syntax")
	syntax clear
endif

setlocal foldnestmax=3
setlocal foldmethod=syntax
setlocal iskeyword+=-
setlocal commentstring=//%s

let b:current_syntax = "dts"

" clusters
syntax cluster	dts_blocks			contains=dts_section,dts_device,dts_comment,@dts_preproc
syntax cluster	dts_preproc			contains=dts_pp,dts_pp_block,dts_pp_if0,dts_pp_ref
syntax cluster	dts_pp_contained	contains=dts_comment,dts_pp_dev_key,dts_pp_device,becomplete_arg

" sections
syntax keyword	dts_section			arch nextgroup=dts_arch_block
syntax region	dts_arch_block		start="\s*=\s*{" end="}" contains=dts_comment,@dts_preproc,dts_arch_key,dts_device,dts_assert,dts_ref,becomplete_arg fold

syntax keyword	dts_section			memory nextgroup=dts_memory_block
syntax region	dts_memory_block	start="\s*=\s*{" end="}" contains=dts_comment,@dts_preproc,dts_device,dts_assert,dts_ref,becomplete_arg fold

syntax keyword	dts_section			devices nextgroup=dts_devices_block
syntax region	dts_devices_block	start="\s*=\s*{" end="}" contains=dts_comment,@dts_preproc,dts_device,dts_assert,dts_ref,becomplete_arg fold

" asserts
syntax keyword	dts_assert			assert ASSERT contained

" references
syntax match	dts_ref_attr		"\.[0-9a-zA-Z_-]\+\(\[\d\+\]\)\?" contained contains=dts_arch_key
syntax region	dts_ref				start="[0-9a-zA-Z_-]\+\."me=e-1 end="[ \t+=,;]"me=e-1 contains=dts_ref_attr contained

" device
syntax match	dts_device			"[0-9a-zA-Z_-]\+\ze\s*=\s*{" nextgroup=dts_device_block
syntax region	dts_device_block	start="\s*=\s*{" end="}" contains=dts_comment,@dts_preproc,dts_dev_key,dts_string,dts_device,dts_assert,dts_ref,dts_pp_ref,becomplete_arg fold

" section and device content
let s:dev_keywords = "reg baseaddr compatible size string"
let s:dev_width = '\s*<[0-9]\+>'

syntax match	dts_string			"\".*\"" contained
syntax keyword	dts_arch_key		addr-width reg-width ncores num-ints num-vints timer-int syscall-int ipi-int timer-cycle-time-us
syntax keyword	dts_dev_key			int nextgroup=dts_width contained

exec "syntax keyword dts_dev_key " . s:dev_keywords . " contained"
exec "syntax match dts_width \"" . s:dev_width . "\" contained"

" comments
syntax region	dts_comment			start="//" skip="\\$" end="$"
syntax region	dts_comment			start="/\*" end="\*/"

" preprocessor
syntax match	dts_header			"[\"<].*[\">]" contained
syntax match	dts_pp				"^\s*\(%:\|#\)\s*include\s*\ze[<\"].*[>\"]" nextgroup=dts_header
syntax region	dts_pp				start="^\s*\(%:\|#\)\s*\|undef\>" skip="\\$" end="$" end="//"me=s-1 keepend contains=@dts_blocks fold contains=@dts_pp_contained
syntax region	dts_pp				start="^\s*\(%:\|#\)\s*\(define\|pragma\|line\|warning\|warn\|error\)" skip="\\$" end="$" keepend fold contains=@dts_pp_contained
syntax match	dts_pp				"^\s*\(%:\|#\)\s*\(if\s\+\|ifdef\s\+\|ifndef\s\+\)" contains=@dts_blocks
syntax match	dts_pp				"^\s*\(%:\|#\)\s*\(else\|elif.\+\|endif\)" contains=@dts_blocks
syntax keyword	dts_pp_dev_key		int nextgroup=dts_pp_width contained
syntax match	dts_pp_device		"[0-9a-zA-Z_-]\+\(\s*##\s*[0-9a-zA-Z_-]\+\)*\ze\s*=\s*{"
syntax match	dts_pp_ref			"[0-9a-z_-]\+\ze\s*("

exec "syntax keyword dts_pp_dev_key " . s:dev_keywords . " contained"
exec "syntax match dts_pp_width \"" . s:dev_width . "\" contained"

" #if | #ifdef | #ifndef macro blocks with first line not ending on '_DTS'
syntax region	dts_pp_block		matchgroup=dts_pp start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+[ \ta-zA-Z0-9!<>|&=_()]\+" matchgroup=dts_pp end="^\s*\(%:\|#\)\s*endif" transparent contains=@dts_blocks,@dts_pp_contained fold
syntax region	dts_pp_block_none	matchgroup=dts_pp start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+\S\+_DTS$" matchgroup=dts_pp end="^\s*\(%:\|#\)\s*endif" transparent contains=@dts_blocks,@dts_pp_contained
syntax region	dts_pp_if0			start="^\s*\(%:\|#\)\s*if\s*0" end="^\s*\(%:\|#\)\s*\(endif\|else\|elif\)" contains=None fold

" highlighting
hi def link dts_section		mpurple
hi def link dts_device		mlblue
hi def link dts_arch_key	mlblue
hi def link dts_dev_key		mblue
hi def link dts_assert		mred
hi def link dts_ref			mlblue
hi def link dts_width		mlblue
hi def link dts_string		white
hi def link dts_comment		mgreen
hi def link dts_pp			PreProc
hi def link dts_pp_if0		PreProc
hi def link dts_pp_dev_key	mdblue
hi def link dts_pp_width	mdlblue
hi def link dts_pp_device	mdlblue
hi def link dts_pp_ref		mlblue
