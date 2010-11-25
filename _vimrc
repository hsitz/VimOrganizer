" ********************* IMPORTANT ************
" This vimrc is sample vimrc that works with VimOrganizer.
" 
" Some of the commands could be deleted (e.g., the first 
" five below. .  .
"-------------------"
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
" --------------------
" most of the rest of the commands are necessary, be careful about changing
set foldmethod=manual
filetype off
filetype plugin indent on
colorscheme org_dark
set shellslash

au! BufRead *.org 
au! BufWrite *.org
au! BufWritePost *.org
au BufRead *.org :PreLoadTags
au BufWrite *.org :PreWriteTags
au BufWritePost *.org :PostWriteTags

" if desired, set main directories where you store .org files here,
" these will be used to assemble list of agenda files to choose from
let g:agenda_dirs=["c:/users/herbert/documents/my\ dropbox","c:/users/herbert/desktop"]

" You can (and should) modify TodoSetup() and TagSetup() calls
" in SetFileType() below, but be careful about changing anything else
function! SetFileType()
        if expand("%:e") == 'org'
                if &filetype != 'org'
                        execute "set filetype=org"
                endif
		" The two lines below set up TODOS and tag lists for your
		" org files, eventually each file will be able to have
		" these defined with customization lines in the file, but
		" for now must call a function manually.  You can set 
		" different org files up differently, if you want.  As
		" it stands now all org files use same sample setup, below
                call TodoSetup([['TODO','NEXT'],'STARTED',['DONE','CANCELED']])
		call TagSetup('{@home(h) @work(w) @tennisclub(t)} {easy(e) hard(d)} {computer(c) phone(p)}')
        endif
        if !exists('g:in_agenda_search') && (&foldmethod!='expr')
                setlocal foldmethod=expr
                set foldlevel=1
        endif
        syntax on
        colorscheme org_dark
endfunction     

" these are two examples of "hooks" in org-mode, which are customizable
" functions that will be called
" whenever a particular event happens. . . For more information on 
" possible hooks, see: http://orgmode.org/worg/org-configs/org-hooks.php
" Only a couple of hooks have been implemented so far. . .
function! Org_property_changed_functions(line,key, val)
        "call confirm("prop changed: ".a:line."--key:".a:key." val:".a:val)
endfunction
function! Org_after_todo_state_change_hook(line,state1, state2)
        "call ConfirmDrawer("LOGBOOK")
        "let str = ": - State: " . Pad(a:state2,10) . "   from: " . Pad(a:state1,10) .
        "            \ '    [' . Timestamp() . ']'
        "call append(line("."), repeat(' ',len(matchstr(getline(line(".")),'^\s*'))) . str)
        
endfunction

"keep all below 
syntax on
au! BufRead,BufNewFile *.org            call SetFileType()





nmap <F9> :execute "normal o<".Timestamp().'>'<cr>
imap <F9> <c-r>=' <'.Timestamp().'>'<cr>
map <c-left> :tabprevious<cr>
map <c-right> :tabnext<cr>
map <c-up> :wincmd W<cr>
map <c-down> :wincmd w<cr>

