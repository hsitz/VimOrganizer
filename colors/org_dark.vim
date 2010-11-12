let g:colors_name="org_dark"
"hi normal guifg=#11cc11 guibg=black	ctermfg=green ctermbg=black
hi normal guifg=#bbbbbb guibg=black	ctermfg=green ctermbg=black
hi StatusLine guifg=white guibg=black	ctermfg=white ctermbg=black
hi StatusLineNC guifg=white guibg=black	ctermfg=white ctermbg=black
hi VertSplit guifg=white guibg=black	ctermfg=white ctermbg=black
hi FoldColumn guifg=black guibg=NONE
hi SignColumn guibg=black

hi OL1 guifg=#7744ff guibg=black	ctermfg=blue
hi OL2 guifg=#aaaa22 guibg=black	ctermfg=brown
hi OL3 guifg=#00ccff guibg=black	ctermfg=cyan
hi OL4 guifg=#999999 guibg=black gui=italic  	ctermfg=gray
hi OL5 guifg=#eeaaee  	guibg=black ctermfg=lightgray
"hi OL1 guifg=#eeeeee 	ctermfg=white
"hi OL2 guifg=#ee0000 	ctermfg=white
"hi OL3 guifg=#00ccff 	ctermfg=white
"hi OL4 guifg=#6633ff  	ctermfg=magenta
hi OL5 guifg=#eeaaee  	ctermfg=cyan
hi OL6 guifg=#9966ff 	ctermfg=yellow
hi OL7 guifg=#dd99dd  	ctermfg=red
hi OL8 guifg=cyan	ctermfg=grey
hi OL9 guifg=magenta	ctermfg=blue
hi Folded gui=bold guifg=#6633ff guibg=#111111 	ctermfg=blue
"hi link OLB1 Folded 
hi WarningMsg gui=bold guifg=#aaaa22  guibg=#111111	ctermfg=brown
"hi link OLB2 WarningMsg
hi WildMenu gui=bold guifg=#00ccff  guibg=#111111	ctermfg=cyan
"hi link OLB3 WildMenu
hi DiffAdd gui=bold guifg=#999999 gui=italic  guibg=#111111	ctermfg=gray
"hi link OLB4 DiffAdd
hi DiffChange gui=bold guifg=#eeaaee  guibg=#111111	ctermfg=lightgray
"hi Folded gui=bold guifg=#eeeeee guibg=black	ctermfg=white
""hi link OLB1 Folded 
"hi WarningMsg gui=bold guifg=#ee0000  guibg=black	ctermfg=white
""hi link OLB2 WarningMsg
"hi WildMenu gui=bold guifg=#00ccff  guibg=black	ctermfg=white
""hi link OLB3 WildMenu
"hi DiffAdd gui=bold guifg=#6633ff  guibg=black	ctermfg=magenta
""hi link OLB4 DiffAdd
"hi DiffChange gui=bold guifg=#eeaaee  guibg=black	ctermfg=cyan
"hi link OLB5 DiffChange
hi OLB6 gui=bold guifg=#9966ff 	ctermfg=yellow
hi OLB7 gui=bold guifg=#dd99dd  	ctermfg=red
hi OLB8 gui=bold guifg=cyan	ctermfg=grey
hi OLB9 gui=bold guifg=magenta	ctermfg=blue
"hi OL1 guifg=#ee0000 	ctermfg=white
"hi OL2 guifg=#dddddd 	ctermfg=white
"hi OL3 guifg=#ee3333  	ctermfg=magenta
"hi OL4 guifg=#77eeff  	ctermfg=cyan
"hi OL5 guifg=#9966ff 	ctermfg=yellow
"hi OL6 guifg=#dd99dd  	ctermfg=red
"hi OL7 guifg=cyan	ctermfg=grey
"hi OL8 guifg=magenta	ctermfg=blue
"hi OL9 guifg=gray	ctermfg=magenta
"hi OL9 guifg=white	ctermfg=white

syn match Props '^\s*:\s*\S\+\s*:'
hi Props guifg=#ffa0a0
hi T1 guifg=#00ee00
hi T2 guifg=#ffff33
hi T3 guifg=#99cc33
hi T4 guifg=#99cc66
"
" colors for folded sections
"hi Folded gui=bold guifg=white guibg=NONE	ctermfg=white ctermbg=darkgreen
"hi FoldLevel1 gui=bold guifg=white guibg=NONE	ctermfg=lightcyan ctermbg=black
"hi FoldLevel2 gui=bold guifg=white guibg=NONE	ctermfg=lightcyan ctermbg=black
"hi FoldLevel3 gui=bold guifg=white guibg=NONE	ctermfg=lightcyan ctermbg=black
"hi FoldLevel4 gui=bold guifg=red guibg=NONE	ctermfg=lightyellow ctermbg=black
"hi FoldLevel5 gui=bold guifg=#00ccff guibg=NONE	ctermfg=lightred ctermbg=black
"
"hi FoldLevel6 gui=bold guifg=#6633ff guibg=NONE	ctermfg=lightgrey ctermbg=black
"hi FoldLevel7 gui=bold guifg=#eeaaee guibg=NONE	ctermfg=lightblue ctermbg=black
"hi FoldLevel8 gui=bold guifg=cyan guibg=NONE	ctermfg=lightred ctermbg=black
"hi FoldLevel8 gui=bold guifg=magenta guibg=NONE	ctermfg=lightred ctermbg=black
"hi FoldLevel9 gui=bold guifg=white guibg=NONE	ctermfg=lightred ctermbg=black
"hi FoldLevel10 gui=italic guifg=#008800 guibg=NONE	ctermfg=lightcyan ctermbg=black
"hi FoldLevel11 gui=bold guifg=white guibg=NONE	ctermfg=lightyellow ctermbg=black
"hi FoldLevel12 gui=bold guifg=white guibg=NONE	ctermfg=lightcyan ctermbg=black


"hi code guifg=#88aa88 gui=bold
hi code guifg=orange gui=bold
syn match code '=\S.\{-}\S='
hi itals gui=italic guifg=#aaaaaa
syn match itals '/\zs\S.\{-}\S\ze/'
hi boldtext gui=bold guifg=#aaaaaa
syn match boldtext '*\zs\S.\{-}\S\ze\*'
hi undertext gui=underline guifg=#aaaaaa
syn match undertext '_\zs\S.\{-}\S\ze_'
" color for body text
hi bt guifg=#00aa00	ctermfg=green

"syn match doneline '^.*[X].*$' 
"hi doneline guifg=#555555
"syn region colon start='^\t*' end=': ' keepend contained
syn match colon '^\t*:' contained
"syn match colon '^\t\d\.' contained
"syn match colon '^\t*:\s\d\.\d\.' contained
hi colon guifg=#666666
syn match lnumber '^\t*\(\d\.\)*\s\s' contained
"syn match lnumber '^\t*:' contained
"syn match lnumber '^\t*\(.\.\)\{1,}\s\s' contained
hi lnumber guifg=#999999
"#999 

"syn match headtext '{vo-text}.*{/vo-text}' contained
"hi headtext guifg=bg

" colors for experimental spelling error highlighting
" this only works for spellfix.vim with will be cease to exist soon
hi spellErr gui=underline guifg=yellow	cterm=underline ctermfg=yellow
hi BadWord gui=underline guifg=yellow	cterm=underline ctermfg=yellow
