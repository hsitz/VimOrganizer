function! s:SynStars(perlevel)
	let b:levelstars = a:perlevel
	exe 'syntax match OL1 +^\(*\)\{1}\s.*+ contains=stars'
	exe 'syntax match OL2 +^\(*\)\{'.( 1 + 1*a:perlevel).'}\s.*+ contains=stars'
	exe 'syntax match OL3 +^\(*\)\{'.(1 + 2*a:perlevel).'}\s.*+ contains=stars'
	exe 'syntax match OL4 +^\(*\)\{'.(1 + 3*a:perlevel).'}\s.*+ contains=stars'
	exe 'syntax match OL5 +^\(*\)\{'.(1 + 4*a:perlevel).'}\s.*+ contains=stars'
	exe 'syntax match OL6 +^\(*\)\{'.(1 + 5*a:perlevel).'}\s.*+ contains=stars'
	exe 'syntax match OL7 +^\(*\)\{'.(1 + 6*a:perlevel).'}\s.*+ contains=stars'
	exe 'syntax match OL8 +^\(*\)\{'.(1 + 7*a:perlevel).'}\s.*+ contains=stars'
	exe 'syntax match OL9 +^\(*\)\{'.(1 + 8*a:perlevel).'}\s.*+ contains=stars'
endfunction
command! ChangeSyn  call <SID>SynStars(b:levelstars)

syntax match Properties +^\s*:\s*\S\{-1,}\s*:+
hi Properties guifg=pink
syntax match Tags +\s*:\S*:\s*$+
hi Tags guifg=pink
syntax match Dates +<\d\d\d\d-\d\d-\d\d.\{-1,}>+
hi Dates guifg=magenta
syntax match stars +\*\+\*+me=e-1 contained
hi stars guifg=#444444
syntax match TODO '\* \zsTODO' containedin=OL1,OL2,OL3,OL4,OL5,OL6
syntax match STARTED '\* \zsSTARTED' containedin=OL1,OL2,OL3,OL4,OL5,OL6
syntax match DONE '\* \zsDONE' containedin=OL1,OL2,OL3,OL4,OL5,OL6
hi TODO guifg=red guibg=NONE
hi STARTED guifg=yellow
hi DONE guifg=green
"syntax match source '^#+\(begin\|end\)_src.*$' contained
"hi source gui=underline
syntax match OL1 +^\(*\)\{1}\s.*+ contains=stars
syntax match OL2 +^\(*\)\{2}\s.*+ contains=stars
syntax match OL3 +^\(*\)\{3}\s.*+ contains=stars
syntax match OL4 +^\(*\)\{4}\s.*+ contains=stars
syntax match OL5 +^\(*\)\{5}\s.*+ contains=stars
syntax match OL6 +^\(*\)\{6}\s.*+ contains=stars
syntax match OL7 +^\(*\)\{7}\s.*+ contains=stars
syntax match OL8 +^\(*\)\{8}\s.*+ contains=stars
syntax match OL9 +^\(*\)\{9}\s.*+ contains=stars
syntax match T1 +^\t*:.*$+ contains=tcolon,url 
syntax match T2 +^\t*;.*$+ contains=tcolon,url
syntax match T3 +^\t*|.*$+ contains=tcolon,url
syntax match T4 +^\t*>.*$+ contains=tcolon,url
hi T1 guifg=#00ee00
hi T2 guifg=#ffff33
hi T3 guifg=#99cc33
hi T4 guifg=#99cc66
"hi FoldColumn guifg=#666666 guibg=bg
syntax match tcolon '^\t*:' contained
hi tcolon guifg=#666666
syntax match url '<url:.*>'
hi url guifg=#888822

"syntax region Main start='^begin-org' end='^end-org' contains=orgPerl
let b:current_syntax = ''
unlet b:current_syntax

"syntax include @Vimcode $VIMRUNTIME\syntax\vim.vim
"syntax region orgVim start='^src-vimscript' end='^end-vimscript' contains=@Vimcode
"unlet b:current_syntax
syntax include @Lispcode $VIMRUNTIME\syntax\lisp.vim
"syntax region orgLisp start='^#+begin-lisp' end='^#+end_src' contains=@Lispcode
syntax region orgLisp start='^#+begin_src\semacs-lisp' end='^#+end_src$' contains=@Lispcode
let b:current_syntax = 'combined'
hi orgLisp gui=bold

syntax region orgList start='^\s*\(\d\+[.):]\|[-+] \)' end='^\(\s*$\|^\*\)'me=e-1 

"unlet b:current_syntax
"syntax include @rinvim $VIMRUNTIME\syntax\r.vim
"syntax region orgR matchgroup=Snip start="^src-R" end="^end-R" keepend contains=@rinvim
"let b:current_syntax = ''
"unlet b:current_syntax
"syntax include @python $VIMRUNTIME\syntax\python.vim
"syntax region orgPython matchgroup=Snip start="^src-Python" end="^end-Python" keepend contains=@python
"hi link orgPython TabLineFill
"let b:current_syntax='combined'
"hi link Snip SpecialComment


" vim600: set foldmethod=marker foldlevel=0:
