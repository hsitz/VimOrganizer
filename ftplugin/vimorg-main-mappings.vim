"Section Mappings and Endstuff
" below block of 10 or 15 maps are ones collected
" from body of doc that weren't getting assigned for docs
" oepened after initial org filetype doc
nmap <silent> <buffer> <tab> :call OrgCycle()<cr>
nmap <silent> <buffer> <s-tab> :call OrgGlobalCycle()<cr>
nmap <silent> <buffer> <localleader>ci :call OrgClockIn(line("."))<cr>
nmap <silent> <buffer> <localleader>co :call OrgClockOut()<cr>
"cnoremap <space> <C-\>e(<SID>OrgDateEdit())<CR>
" dl is for the date on the current line
map <silent> <buffer> <localleader>dg :call OrgGenericDateEdit()<cr>
map <silent> <buffer> <localleader>dt :call OrgDateEdit('TIMESTAMP')<cr>
map <silent> <buffer> <localleader>dd :call OrgDateEdit('DEADLINE')<cr>
map <silent> <buffer> <localleader>dc :call OrgDateEdit('CLOSED')<cr>
map <silent> <buffer> <localleader>ds :call OrgDateEdit('SCHEDULED')<cr>
map <silent> <buffer> <localleader>a* :call OrgRunAgenda(strftime("%Y-%m-%d"),'w,'')<cr>
map <silent> <buffer> <localleader>aa :call OrgRunAgenda(strftime("%Y-%m-%d"),'w,'+ALL_TODOS')<cr>
map <silent> <buffer> <localleader>at :call OrgRunAgenda(strftime("%Y-%m-%d"),'w,'+UNFINISHED_TODOS')<cr>
map <silent> <buffer> <localleader>ad :call OrgRunAgenda(strftime("%Y-%m-%d"),'w,'+FINISHED_TODOS')<cr>
map <silent> <buffer> <localleader>ag :call OrgAgendaDashboard()<cr>
map <silent> <buffer> <localleader>ac :call OrgCustomSearchMenu()<cr>
command! -nargs=0 Agenda :call OrgAgendaDashboard()
nmap <silent> <buffer> <s-up> :call OrgDateInc(1)<CR>
nmap <silent> <buffer> <s-down> :call OrgDateInc(-1)<CR>
nnoremap <silent> <buffer> <2-LeftMouse> :call OrgMouseDate()<CR>
nmap <localleader>pl :call s:MyPopup()<cr>
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
"map <silent> <localleader>b  :call ShowBottomCal()<cr> 

nmap <silent> <buffer> <localleader>et :call OrgTagsEdit()<cr>

" clear search matching
nmap <silent> <buffer> <localleader>cs :let @/=''<cr>

map <silent> <buffer> <localleader>rh :call OrgRefile(line('.'))<cr>
map <silent> <buffer> <localleader>rj :call OrgJumpToRefilePoint()<cr>
map <silent> <buffer> <localleader>rs :call OrgSetRefilePoint()<cr>
map <silent> <buffer> <localleader>rp :call OrgRefileToPermPoint(line('.'))<cr>
map <silent> <buffer> <localleader>xe :silent call OrgEval()<cr>

map <buffer>   <C-K>         <C-]>
map <buffer>   <C-N>         <C-T>
map <silent> <buffer>   <localleader>,0  :call OrgExpandWithoutText(99999)<CR>
map <silent> <buffer>   <localleader>,9  :call OrgExpandWithoutText(9)<CR>
map <silent> <buffer>   <localleader>,8  :call OrgExpandWithoutText(8)<CR>
map <silent> <buffer>   <localleader>,7  :call OrgExpandWithoutText(7)<CR>
map <silent> <buffer>   <localleader>,6  :call OrgExpandWithoutText(6)<CR>
map <silent> <buffer>   <localleader>,5  :call OrgExpandWithoutText(5)<CR>
map <silent> <buffer>   <localleader>,4  :call OrgExpandWithoutText(4)<CR>
map <silent> <buffer>   <localleader>,3  :call OrgExpandWithoutText(3)<CR>
map <silent> <buffer>   <localleader>,2  :call OrgExpandWithoutText(2)<CR>
map <silent> <buffer>   <localleader>,1  :call OrgExpandWithoutText(1)<CR>
" set reasonable max limit of 12 for '0' command below, because it iterates
" each for each level, just assume 12 is max. . .
map <silent> <buffer>   <localleader>0   :call OrgShowSubs(12,0)<CR>
map <silent> <buffer>   <localleader>9   :call OrgShowSubs(9,0)<CR>
map <silent> <buffer>   <localleader>8   :call OrgShowSubs(8,0)<CR>
map <silent> <buffer>   <localleader>7   :call OrgShowSubs(7,0)<CR>
map <silent> <buffer>   <localleader>6   :call OrgShowSubs(6,0)<CR>
map <silent> <buffer>   <localleader>5   :call OrgShowSubs(5,0)<CR>
map <silent> <buffer>   <localleader>4   :call OrgShowSubs(4,0)<CR>
map <silent> <buffer>   <localleader>3   :call OrgShowSubs(3,0)<CR>
map <silent> <buffer>   <localleader>2   :call OrgShowSubs(2,0)<CR>
map <silent> <buffer>   <localleader>1   :call OrgShowSubs(1,0)<CR>

vmap <silent> <buffer> <localleader>ci   "zdi/<C-R>z/<ESC>l 
nmap <silent> <buffer> <localleader>ci   i//<ESC>h
vmap <silent> <buffer> <localleader>cu   "zdi_<C-R>z_<ESC>l 
nmap <silent> <buffer> <localleader>cu   i__<ESC>h 
vmap <silent> <buffer> <localleader>cc   "zdi=<C-R>z=<ESC>l 
nmap <silent> <buffer> <localleader>cc   i==<ESC>h
vmap <silent> <buffer> <localleader>cb   "zdi*<C-R>z*<ESC>l 
nmap <silent> <buffer> <localleader>cb   i**<ESC>h

nmap <silent> <buffer> <localleader>no :call NarrowOutline(line('.'))<cr>
nmap <silent> <buffer> <localleader>ns :call NarrowOutline(line('.'))<cr>
nmap <silent> <buffer> <localleader>nc :call NarrowCodeBlock(line('.'))<cr>
" ----------------------------------------
" table commands
au InsertEnter *.org :call org#tbl#reset_tw(line("."))
au InsertLeave *.org :call org#tbl#format(line("."))
command! -buffer -nargs=* OrgTable call org#tbl#create(<f-args>)
nmap <silent> <buffer> <localleader>bc :call org#tbl#create()<cr>
command! -buffer OrgTableAlignQ call org#tbl#align_or_cmd('gqq')
command! -buffer OrgTableAlignW call org#tbl#align_or_cmd('gww')
command! -buffer OrgTableMoveColumnLeft call org#tbl#move_column_left()
nmap <silent> <buffer> <localleader>bl :call org#tbl#move_column_left()<cr>
command! -buffer OrgTableMoveColumnRight call org#tbl#move_column_right()
nmap <silent> <buffer> <localleader>br :call org#tbl#move_column_right()<cr>

" table function mappings
inoremap <buffer> <expr> <CR> org#tbl#kbd_cr()
inoremap <expr> <buffer> <Tab> org#tbl#kbd_tab()
inoremap <expr> <buffer> <S-Tab> org#tbl#kbd_shift_tab()
nnoremap <buffer> gqq :OrgTableAlignQ<CR>
nnoremap <buffer> gww :OrgTableAlignW<CR>
  "nmap <silent><buffer> <A-Left> <Plug>OrgTableMoveColumnLeft
nnoremap <silent><script><buffer>
      \ <Plug>OrgTableMoveColumnLeft :OrgTableMoveColumnLeft<CR>
  "nmap <silent><buffer> <A-Right> <Plug>OrgTableMoveColumnRight
nnoremap <silent><script><buffer>
      \ <Plug>OrgTableMoveColumnRight :OrgTableMoveColumnRight<CR>
" -------------------------------------

imap <silent> <buffer>   <s-c-CR>        <c-r>=OrgNewHead('levelup',1)<CR>
imap <silent> <buffer>   <c-CR>          <c-r>=OrgNewHead('leveldown',1)<CR>
imap <silent> <buffer>   <s-CR>          <c-r>=OrgNewHead('same',1)<CR>
nmap <silent> <buffer>   <s-c-CR>        :call OrgNewHead('levelup')<CR>
nmap <silent> <buffer>   <c-CR>          :call OrgNewHead('leveldown')<CR>
nmap <silent> <buffer>   <CR>            :call OrgEnterFunc()<CR>
map <silent> <buffer> <c-left>           :call OrgShowLess(line("."))<CR>
map <silent> <buffer> <c-right>          :call OrgShowMore(line("."))<CR>
map <silent> <buffer> <c-a-left>         :call OrgMoveLevel(line("."),'left')<CR>
map <silent> <buffer> <c-a-right>        :call OrgMoveLevel(line("."),'right')<CR>
map <silent> <buffer> <c-a-up>           :call OrgMoveLevel(line("."),'up')<CR>
map <silent> <buffer> <c-a-down>         :call OrgMoveLevel(line("."),'down')<CR>
map <silent> <buffer> <a-end>            :call OrgNavigateLevels("end")<CR>
map <silent> <buffer> <a-home>           :call OrgNavigateLevels("home")<CR>
map <silent> <buffer> <a-up>             :call OrgNavigateLevels("up")<CR>
map <silent> <buffer> <a-down>           :call OrgNavigateLevels("down")<CR>
map <silent> <buffer> <a-left>           :call OrgNavigateLevels("left")<CR>
map <silent> <buffer> <a-right>          :call OrgNavigateLevels("right")<CR>
map <silent> <buffer> <localleader>le    :call EditLink()<cr>
map <silent> <buffer> <localleader>lf    :call FollowLink(s:GetLink())<cr>
map <silent> <buffer> <localleader>ln    :/]]<cr>
map <silent> <buffer> <localleader>lp    :?]]<cr>
map <silent> <buffer> <localleader>lc    :set conceallevel=3\|set concealcursor=nc<cr>
map <silent> <buffer> <localleader>la    :set conceallevel=3\|set concealcursor=c<cr>
map <silent> <buffer> <localleader>lx    :set conceallevel=0<cr>
nmap <silent> <buffer>  <localleader>,e  :call OrgSingleHeadingText("expand")<CR>
nmap <silent> <buffer>  <localleader>,E  :call OrgBodyTextOperation(1,line("$"),"expand")<CR>
nmap <silent> <buffer>  <localleader>,C  :call OrgBodyTextOperation(1,line("$"),"collapse")<CR>
nmap <silent> <buffer>  <localleader>,c  :call OrgSingleHeadingText("collapse")<CR>
nmap <silent> <buffer>   zc              :call OrgDoSingleFold(line("."))<CR>
"map <buffer>   <localleader>,,           :source $HOME/.vim/ftplugin/org.vim<CR>
"map! <buffer>  <localleader>w            <Esc>:w<CR>a

