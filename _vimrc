set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
set foldmethod=manual
filetype off
call pathogen#runtime_append_all_bundles() 
filetype plugin indent on
colorscheme org_dark

au BufWrite *.org :PreWriteTags
au BufWritePost *.org :PostWriteTags

function SetFileType()
	if expand("%:e") == 'org'
		execute "set filetype=org"
		PreLoadTags
	endif
	if !exists('g:in_agenda_search')
		setlocal foldmethod=expr
		set foldlevel=1
	endif
	syntax on
	colorscheme org_dark
endfunction	

au! BufRead,BufNewFile *.org		call SetFileType()

