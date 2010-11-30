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
		if exists('g:org_todo_setup')
			call OrgTodoSetup(g:org_todo_setup)
		endif
		if exists('g:org_tag_setup')
			call OrgTagSetup(g:org_tag_setup)
		endif
        endif
        if !exists('g:in_agenda_search') && (&foldmethod!='expr')
                setlocal foldmethod=expr
                set foldlevel=1
        endif
endfunction     

