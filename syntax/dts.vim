if exists("b:current_syntax")
	syntax clear
endif

setlocal foldnestmax=3
setlocal foldmethod=syntax
setlocal iskeyword+=-

" clusters
syn cluster dts_blocks contains=dts_section,dts_device,dts_comment,@dts_preproc
syn cluster dts_preproc contains=dts_c_pp,dts_c_pp_block,dts_c_pp_if0

" sections
syn keyword dts_section arch nextgroup=dts_arch_block
syn region dts_arch_block start="\s*=\s*{" end="}" contains=dts_comment,@dts_preproc,dts_arch_key,dts_device,dts_assert,dts_ref fold

syn keyword dts_section memory nextgroup=dts_memory_block
syn region dts_memory_block start="\s*=\s*{" end="}" contains=dts_comment,@dts_preproc,dts_device,dts_assert,dts_ref fold

syn keyword dts_section devices nextgroup=dts_devices_block
syn region dts_devices_block start="\s*=\s*{" end="}" contains=dts_comment,@dts_preproc,dts_device,dts_assert,dts_ref fold

" asserts
syn keyword dts_assert assert ASSERT contained

" references
syn match dts_ref_attr "\.[0-9a-zA-Z_-]\+\(\[\d\+\]\)\?" contained contains=dts_arch_key
syn region dts_ref start="[0-9a-zA-Z_-]\+\."me=e-1 end="[ \t+=,;]"me=e-1 contains=dts_ref_attr contained

" device
syn match dts_device "[0-9a-zA-Z_-]\+\ze\s*=\s*{" nextgroup=dts_device_block
syn region dts_device_block start="\s*=\s*{" end="}" contains=dts_comment,@dts_preproc,dts_dev_key,dts_string,dts_device,dts_assert,dts_ref fold

" section and device content
syn keyword dts_arch_key addr-width reg-width ncores num-ints num-vints timer-int syscall-int ipi-int timer-cycle-time-us
syn keyword dts_dev_key	reg baseaddr compatible size string contained
syn keyword dts_dev_key int nextgroup=dts_width contained

syn match dts_width "\s*<[0-9]\+>" contained
syn match dts_string "\".*\"" contained

" comments
syn region dts_comment start="//" skip="\\$" end="$"
syn region dts_comment start="/\*" end="\*/"

" preprocessor
syntax match	dts_c_pp			"^\s*\(%:\|#\)\s*include\s*\ze[<\"].*[>\"]" nextgroup=dts_string
syntax region	dts_c_pp			start="^\s*\(%:\|#\)\s*\(define\|undef\)\>"	skip="\\$" end="$" end="//"me=s-1 keepend contains=@dts_blocks fold
syntax region	dts_c_pp			start="^\s*\(%:\|#\)\s*\(pragma\|line\|warning\|warn\|error\)" skip="\\$" end="$" keepend
syntax match	dts_c_pp			"^\s*\(%:\|#\)\s*\(if\s\+\|ifdef\s\+\|ifndef\s\+\)" contains=@dts_blocks
syntax match	dts_c_pp			"^\s*\(%:\|#\)\s*\(else\|elif.\+\|endif\)" contains=@dts_blocks

" #if | #ifdef | #ifndef macro blocks with first line not ending on '_H'
syntax region	dts_c_pp_block		matchgroup=dts_c_pp start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+[ \ta-zA-Z0-9!<>|&=_()]\+\([^_]H\|[^H]\)$" matchgroup=dts_c_pp end="^\s*\(%:\|#\)\s*endif" transparent contains=@dts_blocks fold
syntax region	dts_c_pp_block_none	matchgroup=dts_c_pp start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\)\s\+\S\+_H$" matchgroup=dts_c_pp end="^\s*\(%:\|#\)\s*endif" transparent contains=@dts_blocks
syntax region	dts_c_pp_if0		start="^\s*\(%:\|#\)\s*if\s*0" end="^\s*\(%:\|#\)\s*\(endif\|else\|elif\)" contains=None fold

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
hi def link dts_c_pp		PreProc
hi def link dts_c_pp_if0	PreProc

let b:current_syntax = "dts"
