" org.vim, autoload function file for VimOrganizer
" Author: Herbert Sitz
" Date: Nov 29, 2010
"-----------------------------------

if exists("g:org_autoload_funcs")
	finish
endif

let g:org_autoload_funcs=1

function! org#SetOrgFileType()
        if expand("%:e") == 'org'
                if &filetype != 'org'
                        execute "set filetype=org"
                endif
        endif
	if !exists('g:org_todo_setup')
		let g:org_todo_setup = 'TODO | DONE'
	endif
	if !exists('g:org_tag_setup')
		let g:org_tag_setup = '{home(h) work(w)}'
	endif
	"call OrgTodoSetup(g:org_todo_setup)
	"call OrgTagSetup(g:org_tag_setup)
	call OrgProcessConfigLines()
        if !exists('g:in_agenda_search') && (&foldmethod!='expr')
                setlocal foldmethod=expr
                set foldlevel=1
        endif
endfunction     

function! org#Pad(s,amt)
    return a:s . repeat(' ',a:amt - len(a:s))
endfunction

function! org#Timestamp()
    return strftime("%Y-%m-%d %a %H:%M")
endfunction


