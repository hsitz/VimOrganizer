let g:colors_name="org_dark"
" 'normal' holds defaults, set them to whatever you want
" or just move lines below it into your own color file and
" they will inherit 'normal' settings except where they
" override them
hi Normal guifg=#bbbbbb guibg=black	ctermfg=green ctermbg=black

hi FoldColumn guifg=black guibg=black ctermfg=black
hi SignColumn guifg=gray guibg=black ctermfg=black

" define foreground colors for ****UNfolded**** outline heading levels
hi OL1 guifg=#7744ff ctermfg=blue
hi OL2 guifg=#aaaa22 ctermfg=brown
hi OL3 guifg=#00ccff ctermfg=cyan
hi OL4 guifg=#999999 gui=italic  	ctermfg=gray
hi OL5 guifg=#eeaaee ctermfg=lightgray
hi OL6 guifg=#9966ff 	ctermfg=yellow
hi OL7 guifg=#dd99dd  	ctermfg=red
hi OL8 guifg=cyan	ctermfg=grey
hi OL9 guifg=magenta	ctermfg=blue

" define highlighting for ***FOLDED*** outline heading levels
" 'Folded' is used for folded OL1
hi Folded gui=bold guifg=#6633ff guibg=#111111 	ctermfg=blue
" 'WarningMsg' is used for folded OL2
hi WarningMsg gui=bold guifg=#aaaa22  guibg=#111111	ctermfg=brown
" 'WildMenu' is used for folded OL3
hi WildMenu gui=bold guifg=#00ccff  guibg=#111111	ctermfg=cyan
" 'DiffAdd' is used for folded OL4
hi DiffAdd gui=bold guifg=#999999 gui=italic  guibg=#111111	ctermfg=gray
" 'DiffChange' is used for folded OL5
hi DiffChange gui=bold guifg=#eeaaee  guibg=#111111	ctermfg=lightgray

" various text item highlightings are below
hi Properties guifg=pink ctermfg=lightred
hi Tags guifg=pink ctermfg=lightred
hi Dates guifg=magenta ctermfg=magenta
hi stars guifg=#444444 ctermfg=darkgray
hi Props guifg=#ffa0a0 ctermfg=lightred
hi code guifg=orange gui=bold ctermfg=14
hi itals gui=italic guifg=#aaaaaa ctermfg=lightgray
hi boldtext gui=bold guifg=#aaaaaa ctermfg=lightgray
hi undertext gui=underline guifg=#aaaaaa ctermfg=lightgray
hi lnumber guifg=#999999 ctermfg=gray

hi TODO guifg=orange guibg=NONE ctermfg=14 ctermbg=NONE
hi CANCELED guifg=red guibg=NONE ctermfg=red ctermbg=NONE
hi STARTED guifg=yellow guibg=NONE ctermfg=yellow ctermbg=NONE
hi NEXT guifg=cyan guibg=NONE ctermfg=cyan ctermbg=NONE
hi DONE guifg=green guibg=NONE ctermfg=green ctermbg=NONE

