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
		"call input("you reached bufenter func!")
		"call input("did_ft . . . " . did_filetype())
                if &filetype != 'org'
		    	"call input("you reached bufenter func!")
			"call input("did_ft before set. . . " . did_filetype())
                        execute "set filetype=org"
			"call input("did_ft after set. . . " . did_filetype())
			if !exists('g:org_todo_setup')
				let g:org_todo_setup = 'TODO | DONE'
			endif
			if !exists('g:org_tag_setup')
				let g:org_tag_setup = '{home(h) work(w)}'
			endif
			"call OrgTodoSetup(g:org_todo_setup)
			"call OrgTagSetup(g:org_tag_setup)
			call OrgProcessConfigLines()
			"let g:ft_ignore_pat = '\.org'
			":let g:ft_ignore_pat = '\.\(Z\|gz\|bz2\|zip\|tgz\)$'
                endif
		"call input("you reached bufenter func!")
		syntax on
		if &fdm!='expr'
			set fdm=expr
		endif
        endif
        "if !exists('g:in_agenda_search') && (&foldmethod!='expr')
        "        setlocal foldmethod=expr
        "        set foldlevel=1
        "endif
endfunction     

function! org#Pad(s,amt)
    return a:s . repeat(' ',a:amt - len(a:s))
endfunction

function! org#Timestamp()
    return strftime("%Y-%m-%d %a %H:%M")
endfunction

function! org#GetGroupHighlight(group)
    " this code was copied and modified from code posted on StackOverflow
    " http://stackoverflow.com/questions/1331213/how-to-modify-existing-highlight-group-in-vim
    " Redirect the output of the "hi" command into a variable
    " and find the highlighting
    redir => GroupDetails
    exe "silent hi " . a:group
    redir END

    " Resolve linked groups to find the root highlighting scheme
    while GroupDetails =~ "links to"
        let index = stridx(GroupDetails, "links to") + len("links to")
        let LinkedGroup =  strpart(GroupDetails, index + 1)
        redir => GroupDetails
        exe "silent hi " . LinkedGroup
        redir END
    endwhile

    " Extract the highlighting details (the bit after "xxx")
    let MatchGroups = matchlist(GroupDetails, '\<xxx\>\s\+\(.*\)')
    let ExistingHighlight = MatchGroups[1]

    return ExistingHighlight

endfunction

