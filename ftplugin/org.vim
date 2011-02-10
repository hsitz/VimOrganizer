"if !exists('g:v')
"    let g:v={}
"endif
let b:v={}
let b:v.prevlev = 0
let maplocalleader = ","        " Org key mappings prepend single comma

let b:v.dateMatch = '\(\d\d\d\d-\d\d-\d\d\)'
let b:v.headMatch = '^\*\+\s'
let b:v.headMatchLevel = '^\(\*\)\{level}\s'
let b:v.propMatch = '^\s*:\s*\(PROPERTIES\)'
let b:v.propvalMatch = '^\s*:\s*\(\S*\)\s*:\s*\(\S.*\)\s*$'
let b:v.drawerMatch = '^\s*:\s*\(PROPERTIES\|LOGBOOK\)'
let b:v.levelstars = 1
let b:v.effort=['0:05','0:10','0:15','0:30','0:45','1:00','1:30','2:00','4:00']
let b:v.tagMatch = '\(:\S*:\)\s*$'
let b:v.mytags = ['buy','home','work','URGENT']
let b:v.foldhi = ''

let w:sparse_on = 0
let b:v.columnview = 0
let b:v.clock_to_logbook = 1
let b:v.messages = []
let b:v.global_cycle_levels_to_show=4
let b:v.src_fold=0
let b:v.foldhilines = []
let b:v.cycle_with_text=1
let b:v.foldcolors=['Normal','SparseSkip','Folded','WarningMsg','WildMenu','DiffAdd','DiffChange','Normal','Normal','Normal','Normal']
let b:v.cols = []
setlocal cfu=Mycfu
set noswapfile
hi MatchGroup guibg=yellow guifg=black

setlocal ignorecase         " searches ignore case
setlocal smartcase          " searches use smart case
setlocal autoindent 
setlocal backspace=2
setlocal nowrap
setlocal tw=78
setlocal expandtab
setlocal nosmarttab
setlocal softtabstop=0 
setlocal foldcolumn=1 
setlocal tabstop=4   
setlocal shiftwidth=4
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\\-\\s\\+
if !exists('g:in_agenda_search') "&& (&foldmethod!='expr')
        setlocal foldmethod=expr
        set foldlevel=1
else
    setlocal foldmethod=manual
endif
setlocal foldexpr=OrgFoldLevel(v:lnum)
setlocal indentexpr=
"setlocal iskeyword+=<
setlocal nocindent
setlocal iskeyword=@,39,45,48-57,_,129-255

let b:v.basedate = strftime("%Y-%m-%d %a")
let b:v.sparse_list = []
let b:v.fold_list = []
let b:v.suppress_indent=0
let b:v.suppress_list_indent=0

if !exists('g:org_agenda_dirs')
    execute "let g:org_agenda_dirs =['".expand("%:p:h")."']"
endif

if !exists('g:org_loaded')

let g:org_clock_history=[]
let g:org_path_to_emacs='"c:\program files (x86)\emacs\emacs\bin\emacs.exe"'
let s:org_headMatch = '^\*\+\s'
let s:org_cal_date = '2000-01-01'
let g:org_tag_group_arrange = 0
let g:org_first_sparse=0
let g:org_clocks_in_agenda = 0
let s:remstring = '^\s*:'
let s:block_line = '^\s*\(:\|DEADLINE\|SCHEDULED\|CLOSED\|<\d\d\d\d-\|[\d\d\d\d-\)'
"let s:remstring = '^\s*\(:\|DEADLINE:\|SCHEDULED:\|CLOSED:\|<\d\d\d\d-\)'
let g:org_use_calendar = 1
let g:org_todoitems=[]
let s:headline = ''
let g:org_ColumnHead = 'Lines'
let g:org_gray_agenda = 0
let g:org_sparse_lines_after = 10
let g:org_capture_file=''
let g:org_log_todos=0
let g:org_timegrid=[8,17,1]
let g:org_colview_list = []
let s:firsttext = ''

let g:org_item_len=100
let w:sparse_on = 0
let g:org_folds = 1
let g:org_show_fold_lines = 1
let g:org_colview_list=['tags',30]
let g:org_show_fold_dots = 0
let g:org_show_matches_folded=1
let g:org_indent_from_head = 0
let g:org_agenda_skip_gap = 2
let g:org_agenda_days=7
let g:org_agenda_minforskip = 8

let g:org_show_balloon_tips=1
let g:org_datelist = []
let g:org_search_spec = ''
let g:org_deadline_warning_days = 3
let s:org_weekdays = ['mon','tue','wed','thu','fri','sat','sun']
let s:org_weekdaystring = '\cmon\|tue\|wed\|thu\|fri\|sat\|sun'
let s:org_months = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']
let s:org_monthstring = '\cjan\|feb\|mar\|apr\|may\|jun\|jul\|aug\|sep\|oct\|nov\|dec'
let s:AgendaBufferName = "__Agenda__"

function! OrgProcessConfigLines()
    g/^#+\(TODO\|TAGS\)/execute "call TodoTags('".getline(line('.'))."')"
    normal gg
endfunction
function! TodoTags(line)
    let line = a:line
    if line =~ '#+TAGS'
        call OrgTagSetup(matchstr(line,'#+TAGS \zs.*'))
    elseif line =~ '#+TODO'
        call OrgTodoSetup(matchstr(line,'#+TODO \zs.*'))
    endif
endfunction

function! OrgTodoConvert(orgtodo)
    let todolist = []
    let sublist = []
   " let templist = []
    let temp_list = split(a:orgtodo,' ')
    " count '|' chars in list, if 0 or 1 then
    " it is like Org-mode format, otherwise
    " sublists are used in non-done slot"
    let bar_count = count(split(a:orgtodo,'\zs'),'|')
    let after_bar = 0
    if bar_count >= 2
        for item in temp_list
           if item != '|'
                call add(sublist,item)
           elseif (item == '|') 
               call add(todolist,sublist)
               let sublist = []
           endif
        endfor
    else
        for item in temp_list
           if (item != '|') && (after_bar == 1)
                call add(sublist,item)
            elseif (item != '|') && (after_bar == 0)
                call add(todolist,item)
           elseif (item == '|') 
               let sublist = []
               let after_bar = 1
            endif
        endfor
    endif
    if sublist != []
        call add(todolist,sublist)
    endif
    return todolist
endfunction
        
function! OrgTodoSetup(todolist_str)
    let todolist = OrgTodoConvert(a:todolist_str)
    "set up list and patterns for use throughout
    let b:v.todoitems=[]
    let b:v.fulltodos=todolist
    let b:v.todocycle=[]
    let b:v.todoMatch=''
    let b:v.todoNotDoneMatch=''
    let b:v.todoDoneMatch=''
    let i = 0
    while i < len(todolist) 
        if type(todolist[i]) == type('abc')
            call add(b:v.todoitems,todolist[i])
            call add(b:v.todocycle,todolist[i])
            " add to patterns
            let newtodo = b:v.todoitems[len(b:v.todoitems)-1]
            let b:v.todoMatch .= newtodo . '\|'
            if i < len(todolist) - 1
                let b:v.todoNotDoneMatch .= newtodo . '\|'
            else
                let b:v.todoDoneMatch .= newtodo . '\|'
            endif
            else
            let j = 0
            while j < len(todolist[i])
                call add(b:v.todoitems,todolist[i][j])
                if j == 0
                    call add(b:v.todocycle,todolist[i][0])
                endif
                " add to patterns
                let b:v.todoMatch .= todolist[i][j] . '\|'
                if i < len(todolist) - 1
                    let b:v.todoNotDoneMatch .= todolist[i][j] . '\|'
                else
                    let b:v.todoDoneMatch .= todolist[i][j] . '\|'
                endif
                let j += 1
            endwhile
        endif
        let i += 1
    endwhile
    let b:v.todoMatch = '^\*\+\s*\('.b:v.todoMatch[:-2] . ')'
    let b:v.todoDoneMatch = '^\*\+\s*\('.b:v.todoDoneMatch[:-2] . ')'
    let b:v.todoNotDoneMatch = '^\*\+\s*\('.b:v.todoNotDoneMatch[:-2] . ')'

endfunction
function! s:CurfileAgenda()
    exec "let g:agenda_files=['".expand("%")."']"
endfunction

function! OrgTagSetup(tagspec)
       let b:v.tags = split(tr(a:tagspec,'{}','  '),'\s\+') 
       let b:v.tagdict={}
       let b:v.tagchars=''
       let b:v.tags_order = []
       for item in b:v.tags
            if item =~ '('
                   let char = matchstr(item,'(\zs.\ze)')
                  let tag = matchstr(item,'.*\ze(')
            else
                 let char = ''
                    let tag = item
            endif
            let b:v.tagdict[item] = {'char':char, 'tag':tag, 'exclude':'', 'exgroup':0}
            call add(b:v.tags_order,item)
            if char != ' '
                let b:v.tagchars .= char
            endif
        endfor

       let templist = a:tagspec
       let i = 1
        while templist =~ '{.\{}}'
                let strikeout = matchstr(templist,'{.\{-}}')
                let exclusive = matchstr(templist,'{\zs.\{-}\ze}')
                let templist = substitute(templist,strikeout,'','')
                let xlist = split(exclusive,'\s\+')
                for item in xlist
                    let b:v.tagdict[item].exgroup = i
                    for x in xlist
                            if x != item
                                   let b:v.tagdict[item].exclude .= b:v.tagdict[x].char
                            endif
                    endfor
                endfor
                let i += 1
        endwhile
endfunction

function! OrgTagsEdit(...)
        let filestr = ''
        let line_file_str = ''
        let lineno=line('.')
        if bufname("%")==('__Agenda__')
            let lineno = matchstr(getline(line('.')),'^\d\+')
            let file = matchstr(getline(line('.')),'^\d\+\s*\zs\S\+').'.org'
            let line_file_str = ','.lineno.',"'.file.'"'
            let filestr = ',"'.file.'"'
            let b:v.tagdict = getbufvar(file,'v').tagdict
            let b:v.tags_order = getbufvar(file,'v').tags_order
        endif
    
        execute "let heading_tags = get(s:GetProperties(lineno,0".filestr."),'tags','')"
    
    let new_heading_tags = s:TagMenu(heading_tags)
    if new_heading_tags != heading_tags
            silent execute "call s:SetProp('tags'".",'".new_heading_tags."'".line_file_str .")"
    endif
endfunction

function! s:TagMenu(heading_tags)
    let heading_tags = a:heading_tags
    let tagstring = ''
    let tagchars = ''
    for item in b:v.tags_order
        let tagchars .= b:v.tagdict[item].char
        if match(heading_tags,':'.b:v.tagdict[item].tag .':') >= 0
            let tagstring .= b:v.tagdict[item].char
        endif
    endfor

        hi Cursor guibg=black
        let cue = ''
    set nomore
    while 1
        echo repeat('-',winwidth(0)-1)
        echohl Title | echo 'Choose tags:   ' | echohl None | echon '( <enter> to accept, <esc> to cancel )'
        echo '------------'
        let oldgroup = 0
        for item in b:v.tags_order
            if item == '\n'
                continue
            endif
            let curindex = index(b:v.tags_order,item)
            let newgroup = b:v.tagdict[item].exgroup
            let select = ' '
            if match(tagstring,b:v.tagdict[item].char) >= 0
                let select = 'X'
                echohl Question
            else
                echohl None
            endif
            "if (g:org_tag_group_arrange==0) || (newgroup != oldgroup) || (newgroup == 0 ) || (b:v.tags_order[curindex+1]=='\n')
            if (curindex==0) || (b:v.tags_order[curindex-1]=='\n')
                echo repeat(' ',3) . '[' | echohl Question | echon select | echohl None | echon '] ' 
                echohl None | echon b:v.tagdict[item].tag | echohl Title | echon '('.b:v.tagdict[item].char.')' | echohl None
                let nextindent = repeat(' ',12-len(b:v.tagdict[item].tag))
            else    
                "echon repeat(' ',3) . 
                echon nextindent
                echon '[' | echohl Question | echon select | echohl None | echon '] ' 
                echohl None | echon b:v.tagdict[item].tag | echohl Title | echon '('.b:v.tagdict[item].char.')' | echohl None
                let nextindent = repeat(' ',12-len(b:v.tagdict[item].tag))
                "echon repeat(' ', 12-len(b:v.tagdict[item]))
            endif
            let oldgroup = b:v.tagdict[item].exgroup
        endfor
        echo ""
            "echohl LineNr | echon 'Date+time ['.basedate . ' '.basetime.']: ' 
            "echohl None | echon cue.'_   =>' | echohl WildMenu | echon ' '.newdate.' '.newtime
            let nchar = getchar()
            let newchar = nr2char(nchar)
            if (nchar == "\<BS>") && (len(cue)>0)
                let cue = cue[:-2]
            elseif nchar == "\<s-c-up>"
                let cue = ((curdif-365>=0) ?'+':'').(curdif-365).'d'
            elseif newchar == "\<cr>"
                break
            elseif newchar == "\<Esc>"
                hi Cursor guibg=gray
                redraw
                return a:heading_tags
            elseif (match(tagchars,newchar) >= 0) 
                if (match(tagstring,newchar)==-1) 
                    let tagstring .= newchar
                    " check for mutually exclusve tags
                    for item in keys(b:v.tagdict)
                        if b:v.tagdict[item].char == newchar
                            let exclude_str = b:v.tagdict[item].exclude
                            let tagstring = tr(tagstring,exclude_str,repeat(' ',len(exclude_str)))
                            break
                        endif
                    endfor
                else
                    let tagstring = tr(tagstring,newchar,' ')
                endif
            endif
            call substitute(tagstring,' ','','')
            echon repeat(' ',72)
            redraw
    endwhile

    hi Cursor guibg=gray
    redraw
    echo 
    set more

    let heading_tags = ''
    for item in keys(b:v.tagdict)
        if (item!='\n') && (match(tagstring, b:v.tagdict[item].char) >= 0)
            let heading_tags .= b:v.tagdict[item].tag . ':'
        endif
    endfor
    if heading_tags > '' | let heading_tags = ':' . heading_tags | endif
    return heading_tags
endfunction


function! s:GetBufferTags()
    let save_cursor = getpos(".") 
    let b:v.tagdict = {}
    " call addtags for each headline in buffer
    g/^\*/call s:AddTagsToDict(line("."))
    call setpos('.',save_cursor)
    return sort(keys(b:v.tagdict))
endfunction
inoremap <F5> <C-R>=OrgEffort()<CR>
noremap <F5> A<C-R>=OrgEffort()<CR>
function! OrgEffort()
    if getline(line('.'))=~':Effort:'
        call setline(line('.'), substitute(getline(line('.')),'ort:\zs.*','',''))
        normal A  
        call complete(col('.'),b:v.effort)
    endif
    return ''
endfunction
function! s:AddTagsToDict(line)
    "call add(g:donelines,line('.'))
    let taglist = s:GetTagList(a:line)
    if !empty(taglist)
        for item in taglist
            "if has_key(b:v.tagdict, item)
            "execute "let b:v.tagdict['" . item . "'] += 1"
            "else
            execute "let b:v.tagdict['" . item . "'] = 1"
            "endif
        endfor
    endif
endfunction

function! s:GetTagList(line)
    let text = getline(a:line+1)
    if (text !~ b:v.drawerMatch) && (text !~ b:v.dateMatch) && (text =~ s:remstring)
        let tags = matchlist(text,':\(\S*\):\s*$')
        if !empty(tags)
            return split(tags[1],':')
        else
            return []
        endif
    else
        return []
    endif
endfunction
function! s:IsTagLine(line)
    let text = getline(a:line)
    return (text !~ b:v.drawerMatch) && (text !~ b:v.dateMatch) && (text =~ s:remstring)
endfunction
function! s:GetTags(line)
    if s:IsTagLine(a:line+1)
        return matchstr(getline(a:line+1),':.*$')
    else
        return ''
    endif
endfunction
function! s:AddTag(tag,line)
    if s:IsTagLine(a:line + 1)
        if matchstr(getline(a:line+1),':'.a:tag.':') == ''
            call setline(a:line+1,getline(a:line+1) . ':' .a:tag. ':')
        endif
    else
        call append(a:line, '     :' . a:tag . ':')
    endif
endfunction
function! s:TagInput(line)
    let linetags = s:GetTagList(a:line)
    if empty(linetags)
        call append(a:line,':')
    endif   
    let buftags = s:GetBufferTags()
    let displaytags = deepcopy(buftags)
    call insert(displaytags,'  Exit Menu')
    while 1
        let curstatus = []
        call add(curstatus,0)
        let i = 1
        let linetags = s:GetTagList(a:line)
        while i < len(buftags) + 1 
            if index(linetags, buftags[i-1]) >= 0 
                let cbox = '[ X ]'
                call add(curstatus,1)
            else
                let cbox = '     '
                call add(curstatus,0)
            endif

            let displaytags[i] = cbox . s:PrePad('&'.buftags[i-1],28)
            let i += 1
        endwhile

        let @/=''
        if foldclosed(a:line) > 0
            let b:v.sparse_list = [a:line]
        else
            normal V
        endif
        redraw
        if foldclosed(a:line) > 0
            let b:v.sparse_list = []
        else
            normal V
        endif
        "call insert(displaytags,'Choose tags below:')
        "let key = inputlist(displaytags) - 1 
        let taglist = join(displaytags,"\n") 
        set guioptions+=v
        let key = confirm('Choose tags:',taglist)-1
        set guioptions-=v
        "call remove(displaytags,0)
        if (key == 0)   " || (key==1)
            " need setline for final redraw
            call setline(a:line+1,getline(a:line+1))
            redraw
            break
        endif
        let curstatus[key] = 1 - curstatus[key]
        let newtags = ''
        let i = 1
        while i < len(curstatus)
            if curstatus[i] == 1
                let newtags .= ':' . buftags[i-1] . ':'
            endif
            let i += 1
        endwhile
        let newtags = substitute(newtags, '::',':','g')
        call setline(a:line+1, repeat(' ',s:Starcount(a:line)+1) . newtags)

    endwhile
    if empty(s:GetTagList(a:line))
        execute a:line+1 .'d'
        execute a:line
    endif   
endfunction

function! s:UnconvertTags(line)
    if s:IsTagLine(a:line+1)
        normal J
    endif
endfunction
function! <SID>GlobalUnconvertTags(state)
    let g:save_cursor = getpos(".")
    normal A 
    g/^\*\+\s/call s:UnconvertTags(line("."))
endfunction
function! <SID>UndoUnconvertTags()
    undo
    call setpos(".",g:save_cursor)
endfunction

function! s:ConvertTags(line)
    let tags = matchstr(getline(a:line), '\(:\S*:\)\s*$')
    if tags > ''
        s/\s\+:.*:\s*$//
        call append(a:line, repeat(' ',s:Starcount(a:line)+1) . tags)
    endif
endfunction
function! <SID>GlobalConvertTags()
    let save_cursor = getpos(".")
    g/^\*\+\s/call s:ConvertTags(line("."))
    call setpos(".",save_cursor)
endfunction
function! s:GlobalFormatTags()
    let save_cursor = getpos(".")
    g/^\*\+\s/call s:FormatTags(line("."))
    call setpos(".",save_cursor)
endfunction
function! s:FormatTags(line)
    let tagmatch = matchlist(getline(a:line),'\(:\S*:\)\s*$')
    if !empty(tagmatch)
        let linetags = tagmatch[1]
        s/\s\+:.*:\s*$//
        " add newtags back in, including new tag
        call setline(a:line,getline(a:line) . '    ' 
                    \ . repeat(' ', winwidth(0) - len(getline(a:line)) - len(linetags) - 15) 
                    \ . linetags)
    endif
endfunction

function! s:FCTest(line)
    if foldclosed(a:line) != a:line
        return a:line . ' ---  ' . foldclosed(a:line)
    endif
endfunction

function! OrgSequenceTodo(line,...)
    if a:0 == 1
        if a:1 == 'x'
            let newtodo = ''
        else
            for item in b:v.todoitems
                if item[0] ==? a:1
                    let newtodo = item
                endif
            endfor
        endif
    endif
    let linetext = getline(a:line)
    if (linetext =~ s:org_headMatch) 
        " get first word in line and its index in todoitems
        let tword = matchstr(linetext,'\*\+\s\+\zs\S\+\ze')
        if a:0 == 1
            call s:ReplaceTodo(tword,newtodo)
        else
            call s:ReplaceTodo(tword)
        endif
    endif
endfunction
function! s:NewTodo(curtodo)
    let curtodo = a:curtodo
    " check whether word is in todoitems and make appropriate
    " substitution
    let j = -1
    let newi = -1
    let i = index(b:v.fulltodos,curtodo)
    if i == -1 
        let i = 0
        while i < len(b:v.fulltodos)
            if type(b:v.fulltodos[i])==type([])
                let j = index(b:v.fulltodos[i],curtodo)
                if j > -1
                    break
                endif
            endif
            let i += 1
        endwhile
    endif

    if i == len(b:v.fulltodos)-1
        let newtodo = ''
    else
        if (i == len(b:v.fulltodos))
            " not found, newtodo is index 0
            let newi = 0
        elseif (i >= 0) 
            let newi = i+1
        endif

        if type(b:v.fulltodos[newi]) == type([])
            let newtodo = b:v.fulltodos[newi][0]
        else
            let newtodo = b:v.fulltodos[newi]
        endif
    endif
    return newtodo
endfunction

function! s:ReplaceTodo(todoword,...)
    let save_cursor = getpos('.')
    let todoword = a:todoword
    if bufname("%")==('__Agenda__')
        let file = s:filedict[str2nr(matchstr(getline(line('.')), '^\d\d\d'))]
        "let file = matchstr(getline(line('.')),'^\d\+\s*\zs\S\+').'.org'
        let b:v.fulltodos = getbufvar(file,'v').fulltodos
        let b:v.todoitems = getbufvar(file,'v').todoitems
    endif
    if a:0 == 1
        let newtodo = a:1
    else
        let newtodo = s:NewTodo(todoword)
    endif
    if newtodo > ''
        let newtodo .= ' '
    endif
    if (index(b:v.todoitems,todoword) >= 0) 
        if newtodo > ''
            let newline = substitute(getline(line(".")),
                        \ '\* ' . a:todoword.' ',
                        \ '\* ' . newtodo,'g')
        else
            let newline = substitute(getline(line(".")),
                        \ '\* ' . a:todoword.' ',
                        \ '\* ' . '','g')
        endif
    else
        let newline = substitute(getline(line(".")),
                    \ '\zs\* \ze\S\+', 
                    \ '\* ' . newtodo ,'g')
    endif

    call setline(line("."),newline)

    if exists("*Org_after_todo_state_change_hook") && (bufnr("%") != bufnr('Agenda'))
        let Hook = function("Org_after_todo_state_change_hook")
        call Hook(line('.'),todoword,newtodo)
    endif

    "if g:org_log_todos && (bufnr("%") != bufnr('Agenda'))
     "   call OrgConfirmDrawer("LOGBOOK")
     "   let str = ": - State: " . org#Pad(newtodo,10) . "   from: " . org#Pad(a:todoword,10) .
     "               \ '    [' . sorg#Timestamp() . ']'
     "   call append(line("."), repeat(' ',len(matchstr(getline(line(".")),'^\s*'))) . str)
     "   execute s:OrgGetHead()
    "endif
    call setpos('.',save_cursor)
endfunction

function! s:OrgSubtreeLastLine()
    " Return the line number of the next head at same level, 0 for none
    return s:OrgSubtreeLastLine_l(line("."))
endfunction

function! s:OrgSubtreeLastLine_l(line)
    if a:line == 0
        return line("$")
    endif
    let l:starthead = s:OrgGetHead_l(a:line)
    let l:stars = s:Starcount(l:starthead) 
    let l:mypattern = substitute(b:v.headMatchLevel,'level', '1,'.l:stars, "")    
    let l:lastline = s:Range_Search(l:mypattern,'nW', line("$"), l:starthead) 
    " lastline now has NextHead on abs basis so return end of subtree
    if l:lastline != 0 
        let l:lastline -= 1
    else
        let l:lastline = line("$")
    endif
    return l:lastline

endfunction

function! s:OrgUltimateParentHead()
    " Return the line number of the parent heading, 0 for none
    return s:OrgUltimateParentHead_l(line("."))
endfunction

function! s:OrgUltimateParentHead_l(line)
    " returns 0 for main headings, main heading otherwise
    let l:starthead = s:OrgGetHead_l(a:line)

    if s:Ind(l:starthead) >  1
        return s:Range_Search('^* ','bnW',1,l:starthead)
    else
        return 0
    endif
endfunction

function! s:OrgParentHead()
    " Return the line number of the parent heading, 0 for none
    return s:OrgParentHead_l(line("."))
endfunction

function! s:OrgParentHead_l(line)
    " todo -- get b:v.levelstars in here
    let l:starthead = s:OrgGetHead_l(a:line)
    let l:parentheadlevel = s:Starcount(l:starthead) - b:v.levelstars
    if l:parentheadlevel <= 0 
        return 0
    else
        let l:mypattern = substitute(b:v.headMatchLevel,'level',l:parentheadlevel,'')
        return s:Range_Search(l:mypattern,'bnW',1,l:starthead)
    endif
endfunction


function! s:Range_Search(stext, flags, ...)
    " searches range, restores cursor to 
    " beginning position, and returns
    " first occurrence of pattern
    let save_cursor = getpos(".")
    " a:1 and a:2 are stopline and startline
    if a:0 == 2
        let l:stopline = a:1
        " go to startline
        execute a:2 
        normal! $
    elseif a:0 == 1
        let l:stopline = a:1
    else
        let l:stopline = line("$")
    endif
    let l:result =  search(a:stext, a:flags, l:stopline)
    call setpos('.',save_cursor)
    return l:result
endfunction

function! s:OrgGetHead()
    return s:OrgGetHead_l(line("."))
endfunction

function! s:OrgGetHead_l(line)
    if s:IsText(a:line)   
        return s:Range_Search(b:v.headMatch,'nb', 1, a:line)
    else
        return a:line
    endif
endfunction

function! s:OrgPrevSiblingHead()
    return s:OrgPrevSiblingHead_l(line("."))
endfunction
function! s:OrgPrevSiblingHead_l(line)
    if s:Ind(a:line) > 0
        let upperline = s:OrgParentHead_l(a:line)
    else
        let upperline = 0
    endif
    let sibline = s:OrgPrevHeadSameLevel_l(a:line)
    if (sibline <= upperline) 
        let sibline = 0
    endif
    return sibline
endfunction

function! s:OrgNextSiblingHead()
    return s:OrgNextSiblingHead_l(line("."))
endfunction
function! s:OrgNextSiblingHead_l(line)
    if s:Ind(a:line) > 0
        let lastline = s:OrgSubtreeLastLine_l(s:OrgParentHead_l(a:line))
    else
        let lastline = line("$")
    endif
    let sibline = s:OrgNextHeadSameLevel_l(a:line)
    if (sibline > lastline) 
        let sibline = 0
    endif
    return sibline
endfunction

function! s:OrgNextHead()
    " Return the line number of the next heading, 0 for none
    return s:OrgNextHead_l(line("."))
endfunction
function! s:OrgNextHead_l(line)
    return s:Range_Search(b:v.headMatch,'n', line("$"),a:line)
endfunction

function! s:OrgPrevHead()
    " Return the line number of the previous heading, 0 for none

    return s:OrgPrevHead_l(line("."))

endfunction

function! s:OrgPrevHead_l(line)

    return s:Range_Search(b:v.headMatch,'nb', 1, a:line-1)

endfunction

function! s:OrgNextHeadSameLevel()
    " Return the line number of the next head at same level, 0 for none
    return s:OrgNextHeadSameLevel_l(line("."))
endfunction

function! s:OrgNextHeadSameLevel_l(line)
    let level = s:Starcount(a:line) 
    let mypattern = substitute(b:v.headMatchLevel,'level', level, "") 
    let foundline = s:Range_Search(mypattern,'nW', line("$"), a:line)
    if foundline < line ("$")
        return foundline
    else
        if s:Starcount(foundline) > 0
            return foundline
        else
            return 0
        endif
    endif       
endfunction

function! s:OrgPrevHeadSameLevel()
    " Return the line number of the previous heading, 0 for none
    return s:OrgPrevHeadSameLevel_l(line("."))
endfunction
function! s:OrgPrevHeadSameLevel_l(line)
    let l:level = s:Starcount(a:line)
    let l:mypattern = substitute(b:v.headMatchLevel,'level', l:level, "") 
    let foundline = s:Range_Search(mypattern,'nbW', 1, a:line-1)
    if foundline > 1
        return foundline
    else
        if (s:Starcount(foundline) > 0) 
            return 1
        else
            return 0
        endif
    endif       

endfunction

function! s:OrgFirstChildHead()
    " Return the line number of first child, 0 for none
    return s:OrgFirstChildHead_l(line("."))
endfunction
function! s:OrgFirstChildHead_l(line)
    let l:starthead = s:OrgGetHead_l(a:line)

    let l:level = s:Starcount(l:starthead) + 1
    let l:nexthead = s:OrgNextHeadSameLevel_l(l:starthead)
    if l:nexthead == 0 
        let l:nexthead = line("$") 
    endif
    let l:mypattern = substitute(b:v.headMatchLevel,'level', l:level, "") 
    return s:Range_Search(l:mypattern,'nW',l:nexthead, l:starthead)
endfunction

function! s:OrgLastChildHead()
    " Return the line number of the last child, 0 for none
    return s:OrgLastChildHead_l(line("."))
endfunction

function! s:OrgLastChildHead_l(line)
    " returns line number of last immediate child, 0 if none
    let l:starthead = s:OrgGetHead_l(a:line)

    let l:level = s:Starcount(l:starthead) + 1

    let l:nexthead = s:OrgNextHeadSameLevel_l(l:starthead)
    if l:nexthead == 0 
        let l:nexthead = line("$") 
    endif

    let l:mypattern = substitute(b:v.headMatchLevel,'level', l:level, "") 
    return s:Range_Search(l:mypattern,'nbW',l:starthead, l:nexthead)

endfunction

function! s:MyLastChild(line)
    " Return the line number of the last decendent of parent line
    let l:parentindent = s:Ind(a:line)
    if s:IsText(a:line+1)
        let l:searchline = s:NextLevelLine(a:line+1)
    else    
        let l:searchline = a:line+1
    endif
    while s:Ind(l:searchline) > l:parentindent
        let l:searchline = l:searchline+1
    endwhile
    return l:searchline-1
endfunction

function! s:NextVisibleHead(line)
    " Return line of next visible heanding, 0 if none
    let save_cursor = getpos(".")

    while 1
        let nh = s:OrgNextHead()
        if (nh == 0) || s:IsVisibleHeading(nh)
            break
        endif
        execute nh
    endwhile

    call setpos('.',save_cursor)
    return nh

endfunction

function! s:FoldStatus(line)
    " adds new heading or text level depending on type
    let l:fc = foldclosed(a:line)
    if l:fc == -1
        let l:status = 'unfolded'
    elseif l:fc > 0 && l:fc < a:line
        let l:status = 'infold'
    elseif l:fc == a:line
        let l:status = 'foldhead'
    endif   
    return l:status
endfunction 

function! OrgNewHead(type,...)
    " adds new heading or text level depending on type
    if a:0 == 1
        normal 
    endif
    execute s:OrgGetHead()
    let l:org_line = line(".")
    let l:linebegin = matchlist(getline(line(".")),'^\(\**\s*\)')[1]
    if s:IsText(line("."))==0

        let l:lastline  = s:OrgSubtreeLastLine()  
        if a:type == 'levelup'
            let l:linebegin = substitute(l:linebegin,'^\*\{'.b:v.levelstars.'}','','')
        elseif a:type == 'leveldown'
            let l:linebegin = substitute(l:linebegin,'^\*',repeat('*',b:v.levelstars+1),'')
        endif   
        call append( l:lastline ,l:linebegin)
        execute l:lastline + 1
        startinsert!

    endif
    return ''
endfunction

function! s:IsText(line)
    " checks for whether line is any kind of text block
    " test if line matches all-inclusive text block pattern
    return getline(a:line) !~ b:v.headMatch
endfunction 

function! s:NextLevelAbs(line)
    " Return line of next heading
    " in absolute terms, not just visible headings
    let l:i = 1
    " go down to next non-text line
    while s:IsText(a:line + l:i)
        let l:i = l:i + 1
        "if (a:line + l:i) == line("$")
        :"  return 0
        "endif  
    endwhile    
    return a:line + l:i
endfunction

function! s:NextLevelLine(line)
    " Return line of next heading
    let l:fend = foldclosedend(a:line)
    if l:fend == -1
        let l:i = 1
        " go down to next non-text line
        while s:IsText(a:line + l:i)
            let l:i = l:i + 1
        endwhile    
        return a:line + l:i
    else
        return l:fend+1
    endif
endfunction

function! s:HasChild(line)
    " checks for whether heading line has
    " a sublevel
    " checks to see if heading has a non-text sublevel 
    if s:IsText(a:line + 1) && 
                \   (s:Ind(s:NextLevelLine(a:line+1)) > s:Ind(a:line))
        return 1
    elseif s:IsText(a:line + 1) == 0 && 
                \   (s:Ind(s:NextLevelLine(a:line)) > s:Ind(a:line))
        return 1
    else
        return 0    
    endif   
endfunction

function! s:DoFullCollapse(line) 
    " make sure headline is not just 
    " text collapse
    " test if line matches all-inclusive text block pattern
    if foldclosed(a:line) == -1 && (s:HasChild(a:line) || s:IsText(a:line+1))
        normal! zc
    endif       
    if s:IsTextOnlyFold(a:line) && s:HasChild(a:line)
        normal! zc
        if s:IsTextOnlyFold(a:line) && s:HasChild(a:line)
            normal! zc
            if s:IsTextOnlyFold(a:line) && s:HasChild(a:line)
                normal! zc
            endif
        endif   
    endif   
endfunction

function! s:IsTextOnlyFold(line)
    " checks for whether heading line has full fold
    " or merely a text fold
    "if s:IsText(a:line + 1) && (foldclosed(a:line + 1) == a:line) 
    if s:IsText(a:line + 1) && (foldclosedend(a:line) > 0)
                \    && (s:Ind(foldclosedend(a:line)) <= s:Ind(a:line))
        return 1
    else
        return 0
    endif   
endfunction

function! s:MaxVisIndent(headingline)
    " returns max indent for 
    " visible lines in a heading's subtree
    " used by ShowSubs
    let l:line = a:headingline
    let l:endline = s:OrgSubtreeLastLine()
    "let l:endline = s:MyLastChild(l:line)
    let l:maxi = s:Ind(l:line)
    let l:textflag = 0
    while l:line <= l:endline
        if (s:Ind(l:line) > l:maxi) && 
                    \   ( foldclosed(l:line) == l:line 
                    \  || foldclosed(l:line) == -1  )
            let l:maxi = s:Ind(l:line)
            if s:IsText(l:line)
                let l:textflag = 1
            endif   
        endif
        let l:line = l:line + 1
    endwhile    
    return l:maxi + l:textflag
endfunction

function! OrgShowLess(headingline)
    " collapses headings at farthest out visible level
    let l:maxi = s:MaxVisIndent(a:headingline)
    let l:offset = l:maxi - s:Ind(a:headingline)
    if l:offset > 1 
        call s:ShowSubs(l:offset - 1,0)
    elseif l:offset == 1
        normal! zc  
    endif   
endfunction


function! OrgShowMore(headingline)
    " expands headings at furthest out 
    " visible level in a heading's subtree
    let l:maxi = s:MaxVisIndent(a:headingline)
    let l:offset = l:maxi - s:Ind(a:headingline)
    if l:offset >= 0 
        call s:ShowSubs(l:offset + 1,0)
        if l:maxi == s:MaxVisIndent(a:headingline)
            "call OrgSingleHeadingText('expand')
        endif
    endif
endfunction

function! s:ShowSubs(number,withtext)
    " shows specif number of levels down from current 
    " heading, includes text
    " or merely a text fold
    let save_cursor = getpos(".")

    call s:DoFullCollapse(line("."))
    let l:start = foldclosed(line("."))
    let l:end = foldclosedend(line("."))
    exec "".l:start.",".l:end."foldc!"
    exec "normal! zv"
    if a:number >= 2 
        let l:i = 2
        while l:i <= a:number
            exec "".l:start.",".l:end."foldo"
            let l:i = l:i + 1
        endwhile    
    endif
    if a:withtext == 0
        call OrgSingleHeadingText('collapse')
    endif   

    call setpos(".",save_cursor)
endfunction

function! OrgMoveLevel(line, direction)
    " move a heading tree up, down, left, or right
    let lastline = s:OrgSubtreeLastLine_l(a:line)
    if a:direction == 'up'
        let l:headabove = s:OrgPrevSiblingHead()
        if l:headabove > 0 
            let l:lines = getline(line("."), lastline)
            call s:DoFullCollapse(a:line)
            silent normal! dd
            call append(l:headabove-1,l:lines)
            execute l:headabove
            call s:ShowSubs(1,0)
        else 
            echo "No sibling heading above in this subtree."
        endif
    elseif a:direction == 'down'
        let l:headbelow = s:OrgNextSiblingHead()
        if l:headbelow > 0 
            let endofnext = s:OrgSubtreeLastLine_l(l:headbelow)
            let lines = getline(line("."),lastline)
            call append(endofnext,lines)
            execute endofnext + 1
            " set mark and go back to delete original subtree
            normal ma
            execute a:line
            call s:DoFullCollapse(a:line)
            silent normal! dd
            normal g'a
            call s:ShowSubs(1,0)
        else 
            echo "No sibling below in this subtree."
        endif
    elseif a:direction == 'left'
        if s:Ind(a:line) > 2 
            " first move to be last sibling
            let movetoline = s:OrgSubtreeLastLine_l(s:OrgParentHead_l(a:line))
            let lines = getline(line("."),lastline)
            call append(movetoline,lines)
            execute movetoline + 1
            " set mark and go back to delete original subtree
            normal ma
            execute a:line
            call s:DoFullCollapse(a:line)
            silent exe 'normal! dd'
            normal g'a
            " now move tree to the left
            normal ma
            silent execute line(".") ',' . s:OrgSubtreeLastLine() . 's/^' . repeat('\*',b:v.levelstars) .'//'
            call s:DoFullCollapse(a:line)
            normal g'a
            call s:ShowSubs(1,0)
            execute line(".")
        else 
            echo "You're already at main heading level."
        endif       
    elseif a:direction == 'right'
        if s:Ind(s:OrgPrevHead_l(a:line)) >= s:Ind(a:line)
            execute a:line . ',' . lastline . 's/^\*/'.repeat('\*',b:v.levelstars+1).'/'
            call s:DoFullCollapse(a:line)
            execute a:line
            call s:ShowSubs(1,0)
        else
            echo "Already at lowest level of this subtree."
        endif   
    endif
endfunction

function! OrgNavigateLevels(direction)
    " Move among headings 
    " direction: "up", "down", "right", "left","end", or 'home'
    if s:IsText(line("."))
        exec s:OrgGetHead()
        return  
    endif

    if s:Ind(line(".")) > 0 
        let lowerlimit = s:OrgParentHead()
        let upperlimit = s:OrgSubtreeLastLine_l(lowerlimit)
    else
        let lowerlimit = 0
        let upperlimit = line("$")
    endif       

    if a:direction == "left"
        let dest = s:OrgParentHead()
        let msg = "At highest level."
    elseif a:direction == "home"
        let dest = s:OrgParentHead()
        let msg = "At highest level."
    elseif a:direction == "right"
        let dest = s:OrgFirstChildHead()
        let msg = (dest > 0 ? "Has subheadings, but none visible."
                    \  : "No more subheadings.")
    elseif a:direction == 'end'
        let dest = s:OrgLastChildHead()
        let msg = (dest > 0 ? "Has subheadings, but none visible."
                    \  : "No more subheadings.")
    elseif a:direction == 'up'
        let dest = s:OrgPrevHeadSameLevel()
        let msg = "Can't go up more here."
    elseif a:direction == 'down'
        let dest = s:OrgNextHeadSameLevel()
        let msg = "Can't go down more."
    endif

    let visible = s:IsVisibleHeading(dest) 
    if (dest > 0) && visible && (dest >= lowerlimit) && (dest <= upperlimit) 
        execute dest
    else 
        echo msg
    endif   
endfunction

function! OrgExpandWithoutText(tolevel)
    " expand all headings but leave Body Text collapsed 
    " tolevel: number, 0 to 9, of level to expand to
    "  expand levels to 'tolevel' with all body text collapsed
    let l:startline = 1 
    let l:endline = line("$")
    let l:execstr = "set foldlevel=" . string(a:tolevel  )
    "let l:execstr = "set foldlevel=" . (a:tolevel - 1)
    exec l:execstr  
    call OrgBodyTextOperation(l:startline,l:endline,"collapse")
endfunction
function! s:OrgExpandSubtree(headline,...)
    if a:0 > 0
        let withtext = a:1
    endif
    let save_cursor = getpos(".")
    call s:DoFullFold(a:headline)
    "let end = foldclosedend(a:headline)
    "normal! zO
    "call OrgBodyTextOperation(a:headline, end, 'collapse')
    call s:ShowSubs(3,withtext)
    call setpos(".",save_cursor)
endfunction
function! s:OrgExpandHead(headline)
    let save_cursor = getpos(".")
    call s:DoFullFold(a:headline)
    "let end = foldclosedend(a:headline)
    "normal! zO
    "call OrgBodyTextOperation(a:headline, end, 'collapse')
    call s:ShowSubs(1,0)
    while foldclosed(a:headline) !=  -1
        normal! zo
    endwhile
    call setpos(".",save_cursor)
endfunction
function! s:DoFullFold(headline)
    let save_cursor = getpos(".")
    "normal! zo
    call s:DoAllTextFold(a:headline)
    let fend = foldclosedend(a:headline)
    if ((fend > a:headline) && (s:Ind(fend+1) > s:Ind(a:headline)))
                \ || (s:Ind(a:headline+1) > s:Ind(a:headline))
        normal zc
    endif
    call setpos(".",save_cursor)
endfunction
function! s:OrgCycle(headline)
    let save_cursor = getpos(".")
    let end = foldclosedend(a:headline)
    if (end>0) && (s:Ind(end+1) <= s:Ind(a:headline))
        call s:OrgExpandHead(a:headline)
    elseif ((end == -1) && (s:Ind(s:OrgNextHead_l(a:headline)) > s:Ind(a:headline))          
                \ && (foldclosed(s:OrgNextHead_l(a:headline)) > 0))
        let nextsamelevel = s:OrgNextHeadSameLevel_l(a:headline)
        let nextuplevel = s:OrgNextHeadSameLevel_l(s:OrgParentHead_l(a:headline)) 
        if (nextsamelevel > 0) && (nextsamelevel > nextuplevel)
            let endline = nextsamelevel
        elseif nextuplevel > a:headline
            let endline = nextuplevel
        else 
            let endline = line('$')
        endif
        if b:v.cycle_with_text
            call OrgBodyTextOperation(a:headline+1,endline,'expand')
        else
            call s:OrgExpandSubtree(a:headline,0)
        endif
    else
        call s:DoFullFold(a:headline)
    endif
    call setpos(".",save_cursor)
endfunction
function! OrgCycle()
    if getline(line(".")) =~ b:v.headMatch
        call s:OrgCycle(line("."))
    elseif getline(line(".")) =~ b:v.drawerMatch
        normal! za
    endif
    " position to center of screen with cursor in col 0
    normal! z.
endfunction
function! OrgGlobalCycle()
    if (&foldlevel > 1) && (&foldlevel != b:v.global_cycle_levels_to_show)
        call OrgExpandWithoutText(1)
    elseif &foldlevel == 1
        call OrgExpandWithoutText(b:v.global_cycle_levels_to_show)
    else
        set foldlevel=9999
    endif
endfunction
function! s:LastTextLine(headingline)
    " returns last text line of text under
    " a heading, or 0 if no text
    let l:retval = 0
    if s:IsText(a:line + 1) 
        let l:i = a:line + 1
        while s:IsText(l:i)
            let l:i = l:i + 1
        endwhile
        let l:retval = l:i - 1
    endif
    return l:retval
endfunction

function! s:ShowSynStack()
    for id in synstack(line("."),col("."))
        echo synIDattr(id,"name")
    endfor  
endfunction
function! s:SignList()
    let signlist = ''
    redir => signlist
    silent execute "sign list"
    redir END
    return split(signlist,'\n')
endfunction
function! s:DeleteSigns()
    " first delete all placed signs
    sign unplace *
    let signs = s:SignList()
    for item in signs
        silent execute "sign undefine " . matchstr(item,'\S\+ \zs\S\+\ze ') 
    endfor
    sign define piet text=>>
    sign define fbegin text=>
    sign define fend text=<
endfunction

function! s:GetPlacedSignsString(buffer)
    let placedstr = ''
    redir => placedstr
    silent execute "sign place buffer=".a:buffer
    redir END
    return placedstr

endfunction
function! s:GetProperties(hl,withtextinfo,...)
    let save_cursor = getpos(".")
    if a:0 >=1
        let curtab = tabpagenr()
        let curwin = winnr()
    " optional args are: a:1 - lineno, a:2 - file
        call s:LocateFile(a:1)
    endif
    let hl = s:OrgGetHead_l(a:hl)
    let datesdone = 0
    let result1 = {}
    let result = {}
    let result1['line'] = hl
    let linetext = getline(hl)
    let result1['ITEM'] = linetext
    "let result1['CATEGORY'] = b:v.org_dict.iprop(hl,'CATEGORY')
    let result1['CATEGORY'] = b:v.org_dict.iCATEGORY(hl)
    "let result1['file']=expand("%:t:r")
    let filematch = index(g:agenda_files,expand("%:t"))
    if filematch == -1
        let filematch = index(g:agenda_files,expand("%:p"))
    endif
    let result1['file'] = filematch
    " get date on headline, if any
    if linetext =~ b:v.dateMatch
        let result1['ld'] = matchlist(linetext,b:v.dateMatch)[1]
    endif
    if (getline(hl+1) =~ b:v.tagMatch) && (getline(hl+1) !~ b:v.drawerMatch)
        let result1['tags'] = matchstr(getline(hl+1),b:v.tagMatch)
    endif
    if linetext =~ b:v.todoMatch
        let result1['todo'] = matchstr(linetext,b:v.todoMatch)[2:]
    else
        let result1['todo'] = ''
    endif

    let line = hl + 1
    "let firsttext=0
    while 1
        let ltext = getline(line)
        if ltext =~ b:v.propMatch
            let result = s:GetPropVals(line+1)        
        elseif (ltext =~ b:v.dateMatch) && !datesdone
            let dateresult = s:GetDateVals(line)
            let datesdone = 1
            " no break, go back around to check for props
        elseif  ltext =~ '^\s*:\s*CLOCK'
            " do nothing
        elseif  (ltext !~ s:block_line)
            call extend(result, result1)
            if datesdone
                call extend(result, dateresult)
            endif
            let result['block_end'] = line - 1
            break
        endif
        let line += 1
    endwhile
    if a:withtextinfo
        "let result['tbegin'] = line 
        let result['tend'] = s:OrgNextHead_l(hl) - 1
    endif
    if a:0 >= 1
        execute "tabnext ".curtab
        execute curwin . "wincmd w"
    endif
    call setpos(".",save_cursor)
    "debugging
    let g:org_result = result
    return result
endfunction

function! s:GetDateVals(line)
    "result is dict with all date vals 
    let myline = a:line
    let result = {}
    while 1
        let ltext = getline(myline)
        let mtest1 = '<\zs'.b:v.dateMatch.'.*\ze>'
        let mtest2 = '\[\zs'.b:v.dateMatch.'.*\ze\]'
        if ltext =~ mtest1
            let mydate = matchstr(ltext, mtest1)
            if ltext =~ 'DEADLINE'
                let dtype = 'DEADLINE'
            elseif ltext =~ 'SCHEDULED'
                let dtype = 'SCHEDULED'
            elseif ltext =~ 'CLOSED'
                let dtype = 'CLOSED'
            else
                let dtype = 'TIMESTAMP'
            endif
        elseif ltext =~ mtest2
            let mydate = matchstr(ltext, mtest2)
            let dtype = 'TIMESTAMP_IA'
        else
            break
        endif

        try
            "only add if first of dtype encountered
            if get(result,dtype) == 0
                let result[dtype] = mydate  
            endif
        catch /^Vim\%((\a\+)\)\=:E/ 
        endtry
        let myline += 1
    endwhile
    return result
endfunction

function! s:GetPropVals(line)
    "result is dict with all prop vals 
    let myline = a:line
    let result = {}
    while 1
        let ltext = getline(myline)
        if ltext =~ b:v.propvalMatch
            let mtch = matchlist(ltext, b:v.propvalMatch)
            try
                let result[mtch[1]] = mtch[2]   
            catch /^Vim\%((\a\+)\)\=:E/ 
            endtry
        else
            break
        endif
        let myline += 1
    endwhile
    return result
endfunction


function! s:RedoTextIndent()
    set fdm=manual
    set foldlevel=9999
    exec 1
    let myindent = 0
    while line(".") < line("$")
        let line = getline(line("."))
        if matchstr(line,'^\*\+') > ''
            let myindent = len(matchstr(line,'^\*\+')) + g:org_indent_from_head 
            normal j
        else 
            let text = matchstr(line,'^ *\zs.*')
            let spaces = len(matchstr(line,'^ *'))
            if (spaces != (myindent + 1)) && (text != '')
                call setline(line("."),repeat(' ',myindent+1) . text)
            endif
            normal j
        endif
    endwhile
    exec 1
    set fdm=expr
endfunction

function! s:LoremIpsum()
    let lines = ["Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?","At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."]
    return split(lines[s:Random(3)-1],'\%70c\S*\zs \ze')
endfunction

function! s:Random(range)
    "returns random integer from 1 to range
    return (Rndm() % a:range) + 1
endfunction

function! s:RandomDate()
    let date = string((2009 + s:Random(3) - 1)).'-'.s:Pre0(s:Random(12)).'-'.s:Pre0(s:Random(28))
    let dstring = ''
    if s:Random(3)==3
        let dstring = date. ' ' . calutil#dayname(date)
    else
        let dstring = date. ' ' . calutil#dayname(date).' '.s:Pre0(s:Random(23)).':'.s:Pre0((s:Random(12)-1)*5)
    endif
    if s:Random(6)==6
        let dstring .= ' +'.s:Random(4).['d','w','m'][s:Random(3)-1]
    endif
    return '<'.dstring.'>'
    "if a:date_type != ''
    "    call s:SetProp(a:date_type,date)
    "else
    "    silent execute "normal A".date
    "endif
endfunction
function! s:SetRandomDate(...)
    call s:OrgGetHead()
    if a:0 == 1
        let date_type = a:1
    else
        let date_type = ['DEADLINE','TIMESTAMP','SCHEDULED'][s:Random(3)-1]
    endif
    if date_type != ''
        call s:SetProp(date_type,s:RandomDate())
    else
        let hl = line('.')
        let dmatch = match(getline(hl),'\s*<\d\d\d\d-\d\d-\d\d')
        if dmatch > 0
            let dmatch = dmatch - 1
            call setline(hl,getline(hl)[:dmatch])
        endif
        let newd = s:RandomDate()
        execute hl
        execute "normal A ". newd
    endif
endfunction
function! s:SetRandomTodo()
    let newtodo = b:v.todoitems[s:Random(3)-1]
    if index(b:v.todoitems,matchstr(getline(line('.')),'^\*\+ \zs\S*\ze ')) >= 0
        call setline(line('.'),matchstr(getline(line('.')),'^\*\+ ') . newtodo . 
                    \    ' '. matchstr(getline(line('.')),'^\*\+ \S* \zs.*')) 
    else
        call setline(line('.'),matchstr(getline(line('.')),'^\*\+ ') . newtodo . 
                    \    ' '.  matchstr(getline(line('.')),'^\*\+ \zs.*')) 
    endif

endfunction

function! s:UpdateHeadlineSums()
    g/^\s*:TotalClockTime/d
    call OrgMakeDict()
    let g:tempdict = {}
    g/^\*\+ /let g:tempdict[line('.')] = b:v.org_dict.SumTime(line('.'),'ItemClockTime')
    let items = sort(map(copy(keys(g:tempdict)),"str2nr(v:val)"),'s:NumCompare')
    let i = len(items) - 1
    while i >= 0
        if g:tempdict[items[i]] != '0:00'
            call s:SetProp('TotalClockTime',g:tempdict[items[i]],items[i])
        endif
        let i = i-1
    endwhile
endfunction

function! OrgMakeDictInherited()
    let b:v.org_dict = {'0':{'c':[],'CATEGORY':expand("%:t:r")}}
    function! b:v.org_dict.iCATEGORY(ndx) dict
        let ndx = a:ndx
        let result = get(self[ndx] , 'CATEGORY','')
        if (result == '') && (ndx != 0)
            "recurse up through parents in tree
            let result = b:v.org_dict.iCATEGORY(self[ndx].parent)
        endif
        return result
    endfunction 
    function! b:v.org_dict.iprop(ndx,property) dict
        let prop = a:property
        let ndx = a:ndx
        let result = get(self[ndx] , prop,'')
        if (result == '') && (ndx != 0)
            "recurse up through parents in tree
            let result = b:v.org_dict.iprop(self[ndx].parent,prop)
        endif
        return result
    endfunction 
    execute 1
   let next = 1
   if s:IsText(line('.'))
      let next = s:OrgNextHead()
   endif
   while next > 0
      execute next
  "    let b:v.org_dict[line('.')] = {'c':[]}
      if getline(line('.'))[1] == ' '
          let parent = 0
      else
          let parent = s:OrgParentHead()
      endif
      let b:v.org_dict[line('.')] = {'parent': parent}
  "    let b:v.org_dict[line('.')].parent = parent
  "    if parent > 0
  "        call add(b:v.org_dict[parent].c ,line('.'))
  "    endif
      let next = s:OrgNextHead()
   endwhile 
   " parent properties assigned above, now explicity record CATEGORY for 
   " any headlines where CATEGORY won't be inherited
   silent execute 'g/^\s*:CATEGORY:/let b:v.org_dict[s:OrgGetHead()].CATEGORY = matchstr(getline(line(".")),":CATEGORY:\\s*\\zs.*")'
endfunction

function! OrgMakeDict()
    let b:v.org_dict = {}
    call OrgMakeDictInherited()
    function! b:v.org_dict.SumTime(ndx,property) dict
        let prop = a:property
        let result = get(self[a:ndx].props , prop,'0:00')
        " now recursion down the subtree of children in c
        for item in self[a:ndx].c
            let result = s:AddTime(result,b:v.org_dict.SumTime(item,prop))
        endfor
        return result
    endfunction 
    function! b:v.org_dict.Sum(ndx,property) dict
        let prop = a:property
        let result = get(self[a:ndx].props , prop)
        " now recursion down the subtree of children in c
        for item in self[a:ndx].c
            let result += b:v.org_dict.Sum(item,prop)
        endfor
        return result
    endfunction 
    execute 1
   let next = 1
   if s:IsText(line('.'))
      let next = s:OrgNextHead()
   endif
   while next > 0
      execute next
      let b:v.org_dict[line('.')].c = []
      let b:v.org_dict[line('.')].props = s:GetProperties(line('.'),1)
      "let parent = s:OrgParentHead()
      let parent = b:v.org_dict[line('.')].parent
      "if parent > 0
          call add(b:v.org_dict[parent].c ,line('.'))
      "endif
      let next = s:OrgNextHead()
   endwhile 
endfunction

function! s:ClearSparseTreeOld()
    set fdm=manual
    silent exe '%s/^*x//'
    silent exe 'undojoin | %s/^*o//'
    "g/^*x/call substitute(getline(line(".")),'^*x',''))
    "g/^*o/call substitute(getline(line(".")),'^*o',''))

    call clearmatches()
    set fdm=expr
    echo "sparse tree view cleared"
endfunction

function! s:SparseTreeRun(term)

    call s:ClearSparseLists()
    let w:sparse_on = 1
    execute 'g/' . a:term . '/call add(b:v.sparse_list,line("."))'
    call s:SparseTreeDoFolds()
    call clearmatches()
    let g:org_first_sparse=1
    let b:v.signstring= s:GetPlacedSignsString(bufnr("%")) 
    set fdm=expr
    set foldlevel=0
    let g:org_first_sparse=0
    execute 'let @/ ="' . a:term .'"'
    execute 'g/' . a:term . '/normal zv'
    set hlsearch
    execute 1
endfunction

function! s:SparseTreeDoFolds()
    let i = len(b:v.sparse_list) - 1
    while i >= 0
        "if b:v.sparse_list[i] + g:org_sparse_lines_after > line("$")
        if b:v.sparse_list[i] + 10 > line("$")
            call remove(b:v.sparse_list, i) "insert(b:v.fold_list,0)
            let i -= 1
            continue
        "elseif (i>0) && (b:v.sparse_list[i] < b:v.sparse_list[i-1] + g:org_sparse_lines_after)
        elseif (i>0) && (b:v.sparse_list[i] < b:v.sparse_list[i-1] + 10)
            call remove(b:v.sparse_list, i) "insert(b:v.fold_list,0)
            let i -= 1
            continue
        else
            let phead = s:OrgUltimateParentHead_l(b:v.sparse_list[i])
            if phead >= 1 
                call insert(b:v.fold_list,phead-1)
            else
                " match is already on level 1 head
                call insert(b:v.fold_list,b:v.sparse_list[i]-1)
            endif
        endif

        let i -= 1
    endwhile        
    "call map(b:v.sparse_list,"v:val + g:org_sparse_lines_after")
    call map(b:v.sparse_list,"v:val + 10")
    call insert(b:v.sparse_list, 1)
    call add(b:v.fold_list, line("$"))

    " sign method to potentially supersede list based method above
    call s:DeleteSigns()
    for item in b:v.sparse_list
        execute "sign place " . item ." line=".item." name=fbegin buffer=".bufnr("%")
    endfor
    for item in b:v.fold_list
        execute "sign place " . item ." line=".item." name=fend buffer=".bufnr("%")
    endfor
    " FoldTouch below instead of fdm line above to save time
    " updating folds for just newly changed foldlevel lines
    "call s:FoldTouch()

endfunction

function! s:ClearSparseLists()
    " mylist with lines of matches
    let b:v.sparse_list = []
    " foldlist with line before previous level 1 parent
    let b:v.fold_list = []
    let b:v.sparse_heads = []
endfunction
function! s:ClearSparseTree()
    " mylist with lines of matches
    let w:sparse_on = 0
    let b:v.sparse_list = []
    " foldlist with line before previous level 1 parent
    let b:v.fold_list = []
    set fdm=expr
    set foldlevel=1
    execute 1
endfunction

function! s:FoldTouch()
    " not used right now, since speed increase over 
    " set fdm=expr is uncertain, and was having problems
    " in cleanly undoing it.
    "
    " touch each line in lists to update their fold levels  
    let i = 0
    while i < len(b:v.sparse_list)
        execute b:v.sparse_list[i]
        " insert letter 'b' to  force level update and then undo
        silent execute "normal! ib"
        silent execute "normal! u"
        execute b:v.fold_list[i]
        silent execute "normal! ib"
        silent execute "normal! u"
        let i += 1
    endwhile
endfunction

function! s:OrgIfExpr()
    let mypattern = ''
    " two wrapper subst statements around middle 
    " subst are to make dates work properly with substitute/split
    " operation
    let str = substitute(g:org_search_spec,'\(\d\{4}\)-\(\d\d\)-\(\d\d\)','\1xx\2xx\3','g')
    let str = substitute(str,'\([+-]\)','~\1','g')
    let str = substitute(str,'\(\d\{4}\)xx\(\d\d\)xx\(\d\d\)','\1-\2-\3','g')
    let g:str = str
    let b:v.my_if_list = split(str,'\~')
    let ifexpr = ''
    " okay, right now we have split list with each item prepended by + or -
    " now change each item to be a pattern match equation in parens
    " e.g.,'( prop1 =~ propval) && (prop2 =~ propval) && (thisline =~tag)
    let i = 0
    "using while structure because for structure doesn't allow changing
    " items?
    while i < len(b:v.my_if_list)
        let item = b:v.my_if_list[i]
        " Propmatch has '=' sign and something before and after
        if item[1:] =~ 'TEXT=\S.*'
            let mtch = matchlist(item[1:],'\(\S.*\)=\(\S.*\)')
            let b:v.my_if_list[i] = "(s:Range_Search('" . mtch[2] . "','nbW'," 
            let b:v.my_if_list[i] .= 'tbegin,tend)> 0)'
            let i += 1
            " loop to next item
            continue
        endif
        if item[1:] =~ '\S.*=\S.*'
            let pat = '\(\S.*\)\(==\|>=\|<=\|!=\)\(\S.*\)'
            let mtch = matchlist(item[1:],pat)
            "let b:v.my_if_list[i] = '(lineprops["' . mtch[1] . '"] ' . mtch[2]. '"' . mtch[3] . '")'
            if mtch[3] =~ '^\d\+$'
                " numeric comparison
                let b:v.my_if_list[i] = '(get(lineprops,"' . mtch[1] . '") ' . mtch[2]. mtch[3] . ')'
            else
                " string comparison
                let rightside="'".mtch[3]."'"
                let b:v.my_if_list[i] = '(get(lineprops,"' . mtch[1] . '","") ' . mtch[2]. rightside. ')'
                "let b:v.my_if_list[i] = '(get(lineprops,"' . mtch[1] . '","") ' . mtch[2]. '"' . mtch[3] . '")'
            endif
            let i += 1
            " loop to next item
            continue
        endif

        " do todo or tag item
        if item[0] == '+'
            let op = '=~'
        elseif item[0] == '-'
            let op = '!~'
        endif
        if index(b:v.todoitems,item[1:]) >= 0
            let item = '(thisline ' . op . " '^\\*\\+\\s*" . item[1:] . "')"
            let b:v.my_if_list[i] = item
        elseif item[1:] == 'UNFINISHED_TODOS'
            let item = '(thisline ' . op . " '" . b:v.todoNotDoneMatch . "')"
            let b:v.my_if_list[i] = item
        elseif item[1:] == 'FINISHED_TODOS'
            let item = '(thisline ' . op . " '" . b:v.todoDoneMatch . "')"
            let b:v.my_if_list[i] = item
        elseif item[1:] == 'ALL_TODOS'
            let item = '(thisline ' . op . " '" . b:v.todoMatch . "')"
            let b:v.my_if_list[i] = item
        else
            let item = '(thisline ' . op . " ':" . item[1:] . ":')"
            let b:v.my_if_list[i] = item
        endif
        let i += 1 
    endwhile    
    let i = 0
    let b:v.check1 = b:v.my_if_list
    let ifexpr = ''
    while i < len(b:v.my_if_list) 
        let ifexpr .= b:v.my_if_list[i]
        if i < len(b:v.my_if_list) - 1
            let ifexpr .= ' && '
        endif
        let i += 1
    endwhile

    return ifexpr

endfunction

function! s:CheckIfExpr(line,ifexpr,...)
    " this is 'ifexpr' eval func used for agenda date searches
    let headline = s:OrgGetHead_l(a:line)
    " 0 arg is to not get start and end line numbers
    let lineprops=s:GetProperties(headline,0)
    " _thisline_ is variable evaluated in myifexpr
    let thisline = getline(headline)
    if s:IsTagLine(headline + 1)
        let thisline .= ' ' . getline(headline+1)
    endif
    return eval(a:ifexpr)

endfunction

function! FileDict()
    return s:filedict
endfunction

function! s:OrgIfExprResults(ifexpr,...)
    " ifexpr has single compound expression that will evaluate
    " as true only for desired lines
    let sparse_search = 0
    if a:0 > 0
        let sparse_search = a:1
    endif

    let myifexpr = a:ifexpr
    "let g:agenda_lines = []    
    execute 1
    if getline(line('.'))!~ '^\*\+ '
        let headline = s:OrgNextHead()
    else
        let headline = 1
    endif
    let g:checkexpr = a:ifexpr
    while 1
        if headline > 0 
            execute headline
            " _thisline_ is variable evaluated in myifexpr
            let thisline = getline(headline)
            if s:IsTagLine(headline + 1)
                let thisline .= ' ' . getline(headline+1)
            endif
            " lineprops is main variable tested in 'ifexpr' 
            " expression that gets evaluated
            let lineprops = s:GetProperties(headline,1)
            " next line is to fix for text area search
            " now that we can reference tbegin and tend
            let myifexpr = substitute(a:ifexpr,'tbegin,tend',get(lineprops,'tbegin') .','. get(lineprops,'tend'),"")
            "let s:filedict={}
            let s:filedict  = copy(g:agenda_files)
"            let i = 1
"            for item in g:agenda_files
"               "let s:filedict[item]= s:PrePad(i,3,'0')
"                if match(item,'c:\') >= 0
"                   "execute "let s:filedict['".matchstr(item,'.*\\\zs\S\{}\ze.org$')."']='".s:PrePad(i,3,'0')."'"
"                   "let s:filedict[ matchstr(item,'.*\\\zs\S\{}\ze.org$') ] = s:PrePad(i,3,'0')
"                   let s:filedict[ s:PrePad(i,3,'0') ] = matchstr(item,'.*\\\zs\S\{}\ze.org$')
"                elseif match(item,'/') >= 0
"                    "execute "let s:filedict['".matchstr(item,'.*/\zs\S\{}\ze.org$')."']='".s:PrePad(i,3,'0')."'"
"                     "let s:filedict['".matchstr(item,'.*/\zs\S\{}\ze.org$')."']='".s:PrePad(i,3,'0')."'"
"                    let s:filedict[ s:PrePad(i,3,'0')] = matchstr(item,'.matchstr(item,'.*/\zs\S\{}\ze.org$')
"                else
"                    "execute "let s:filedict['".matchstr(item,'.*\ze.org')."']='".s:PrePad(i,3,'0')."'"
"                    let s:filedict[ s:PrePad(i,3,'0')] = matchstr(item,'.*\ze.org')
"                endif
"                let i +=1
"            endfor
"
            "********  eval() is what does it all ***************
            if eval(myifexpr)
                if sparse_search
                    let keyval = headline
                else
                    "let keyval = s:PrePad(index(s:agenda_files_copy, lineprops.file . '.org'),3,'0') . s:PrePad(headline,5,'0')
                    let keyval = s:PrePad(lineprops.file,3,'0') . s:PrePad(headline,5,'0')
                endif

                let g:adict[keyval]=lineprops

            endif
            normal l
            let headline = s:OrgNextHead() 
        else
            break
        endif
    endwhile
endfunction

function! s:MakeResults(search_spec,...)
    let sparse_search = 0
    if a:0 > 0
        let sparse_search = a:1
    endif
    let save_cursor = getpos(".")
    let curfile = substitute(expand("%"),' ','\\ ','g')

    let g:org_search_spec = a:search_spec
    let g:org_todoitems=[]
    let g:adict = {}
    let g:datedict = {}
    let s:agenda_files_copy = copy(g:agenda_files)
    " fix so copy doesn't have full path. .  .
    "call map(s:agenda_files_copy, 'matchstr(v:val,"[\\/]") > "" ? matchstr(v:val,"[^/\\\\]*$") : v:val')
    if sparse_search 
        "execute 'let myfiles=["' . curfile . '"]'
        let ifexpr = s:OrgIfExpr()
        call s:OrgIfExprResults(ifexpr,sparse_search)
    else
        for file in g:agenda_files
            let mycommand = 'tab drop '. file
            execute mycommand
            "call OrgMakeDictInherited()
            call OrgMakeDict()
            let ifexpr = s:OrgIfExpr()
            let g:org_todoitems = extend(g:org_todoitems,b:v.todoitems)
            call s:OrgIfExprResults(ifexpr,sparse_search)
        endfor
        call s:LocateFile(curfile)
    endif
    call setpos(".",save_cursor)
endfunction

function! s:DaysInMonth(date)
        let month = str2nr(a:date[5:6])
        let year = str2nr(a:date[0:3])
        if (month == 2) && (year % 4) 
            let days = 28 
        elseif month == 2
            let days = 29
        elseif index([1,3,5,7,8,10,12],month) >= 0 
            let days = 31
        else
            let days = 30
        endif
        return days
endfunction

function! s:MakeAgenda(date,count,...)
    if a:0 >= 1
        let g:org_search_spec = a:1
    else
        let g:org_search_spec = ''
    endif
    let as_today = ''
    if a:0 >= 2
        let as_today = a:2
    endif
    let save_cursor = getpos(".")
    let curfile = expand("%:t")
    if a:count == 7
        let g:agenda_startdate = calutil#cal(calutil#jul(a:date) - calutil#dow(a:date))
        let g:org_agenda_days=7
    elseif (a:count>=28) && (a:count<=31)
        let g:agenda_startdate = a:date[0:7].'01'
        let g:org_agenda_days = s:DaysInMonth(a:date)
    elseif (a:count > 360) 
        let g:agenda_startdate = a:date[0:3].'-01-01'
        let g:org_agenda_days = a:count
    else
        let g:agenda_startdate = a:date
        let g:org_agenda_days=a:count
    endif
    if a:count == 1 | let as_today = g:agenda_startdate | endif
    "let myfiles=['newtest3.org','test3.org', 'test4.org', 'test5.org','test6.org', 'test7.org']
    let g:adict = {}
    let s:filedict = copy(g:agenda_files)
    let s:agenda_files_copy = copy(g:agenda_files)
    let g:datedict = {}
    call s:MakeCalendar(g:agenda_startdate,g:org_agenda_days)
    let g:in_agenda_search=1
    for file in g:agenda_files
        call s:LocateFile(file)
        call OrgMakeDict()
        let s:filenum = index(g:agenda_files,file)
        let t:agenda_date=a:date
        if as_today > ''
            call s:GetDateHeads(g:agenda_startdate,a:count,as_today)
        else 
            call s:GetDateHeads(g:agenda_startdate,a:count)
        endif
    endfor
    unlet g:in_agenda_search
    call s:LocateFile(curfile)
    call setpos(".",save_cursor)
endfunction

function! s:NumCompare(i1, i2)
    return a:i1 == a:i2 ? 0 : a:i1 > a:i2 ? 1 : -1
endfunc

function! OrgRunSearch(search_spec,...)
        "set mouseshape-=n:busy,v:busy,i:busy

    try
    if bufname('%') == '__Agenda__'
        " vsplit agenda ********************
        " wincmd h
        " *************************
        wincmd k
    endif

    let g:agenda_head_lookup={}
    let sparse_search = 0
    if a:0 > 0
        if a:1 == 1
            let sparse_search = a:1
        else
            let search_type=a:1
        endif
    endif
    let g:adict={}
    let g:agenda_date_dict={}
    if !exists("g:agenda_files") || (g:agenda_files==[])
        call confirm("No agenda files defined.  Will add current file to agenda files.")
        call s:CurfileAgenda()
    endif
    if exists('b:v.sparse_list') && (len(b:v.sparse_list) > 0)
        call s:ClearSparseTree()
    endif
    call s:MakeResults(a:search_spec,sparse_search)

    if sparse_search
        "call s:ClearSparseTree()
        let w:sparse_on = 1
        let temp = []
        for key in keys(g:adict)
            call add(temp,g:adict[key].line)
        endfor
        let b:v.sparse_list = sort(temp,'s:NumCompare')
        "for key in keys(g:adict)
        "   call add(b:v.sparse_heads,str2nr(key))
        "endfor
        "for item in sort(b:v.sparse_heads,'NumCompare')
        call sort(b:v.fold_list,"s:NumCompare")
        call s:SparseTreeDoFolds()
        "for item in sort(b:v.fold_list,'NumCompare')
        set fdm=expr
        set foldlevel=0
        for item in b:v.sparse_list
            if item > 11
                execute item - g:org_sparse_lines_after
                normal! zv
            endif
            "execute 'call matchadd("MatchGroup","\\%' . line(".") . 'l")'
        endfor
        execute 1
    else
        " make agenda buf have its own todoitems, need
        " to get rid of g:... so each agenda_file can have
        " its own todoitems defined. . . "
        let todos = b:v.todoitems
        let todoNotDoneMatch = b:v.todoNotDoneMatch
        let todoDoneMatch = b:v.todoDoneMatch
        let todoMatch = b:v.todoMatch
        let fulltodos = b:v.fulltodos
        if bufnr('__Agenda__') >= 0
            bwipeout __Agenda__
        endif
        :AAgenda
        let b:v={}
        let b:v.todoitems = todos
        let b:v.todoNotDoneMatch = todoNotDoneMatch
        let b:v.todoDoneMatch = todoDoneMatch
        let b:v.todoMatch = todoMatch
        let b:v.fulltodos = fulltodos
        %d
        set nowrap
        map <buffer> <silent> <tab> :call OrgAgendaGetText()<CR>
        map <buffer> <silent> <s-CR> :call OrgAgendaGetText(1)<CR>
        map <silent> <buffer> <c-CR> :MyAgendaToBuf<CR>
        map <silent> <buffer> <CR> :AgendaMoveToBuf<CR>
        nmap <silent> <buffer> r :call OrgRunSearch(matchstr(getline(1),'spec: \zs.*$'))<CR>
        nmap <silent> <buffer> <s-up> :call OrgDateInc(1)<CR>
        nmap <silent> <buffer> <s-down> :call OrgDateInc(-1)<CR>
        call matchadd( 'OL1', '\s\+\*\{1}.*$' )
        call matchadd( 'OL2', '\s\+\*\{2}.*$') 
        call matchadd( 'OL3', '\s\+\*\{3}.*$' )
        call matchadd( 'OL4', '\s\+\*\{4}.*$' )
        call s:AgendaBufHighlight()
        "wincmd J
        let i = 0
        call s:ADictPlaceSigns()
        call setline(1, ["Headlines matching search spec: ".g:org_search_spec,''])
        if exists("search_type") && (search_type=='agenda_todo')
            let msg = "Press num to redo search: "
            let numstr= ''
            "let tlist = ['ALL_TODOS','UNFINISHED_TODOS', 'FINISHED_TODOS'] + b:v.todoitems
            let tlist = ['ALL_TODOS','UNFINISHED_TODOS', 'FINISHED_TODOS'] + Union(g:org_todoitems,[])
            for item in tlist
                let num = index(tlist,item)
                let numstr .= '('.num.')'.item.'  '
                execute "nmap <buffer> ".num."  :call OrgRunSearch('+".tlist[num]."','agenda_todo')<CR>"
            endfor
            call append(1,split(msg.numstr,'\%72c\S*\zs '))
        endif
        for key in sort(keys(g:adict))
            call setline(line("$")+1, key . ' ' . 
                        \ org#Pad(g:adict[key].CATEGORY,13)  . 
                        \ s:PrePad(matchstr(g:adict[key].ITEM,'^\*\+ '),8) .
                        \ matchstr(g:adict[key].ITEM,'\* \zs.*$'))
                        "\ org#Pad(g:adict[key].file,13)  . 
            let i += 1
        endfor
    endif

    finally
        "set mouseshape-=n:busy,v:busy,i:busy
    endtry
endfunction

function! s:TestTime()
    let g:timestart=join(reltime(), ' ') 
    let g:start = strftime("%")
    let i = 0
    set fdm=expr
    let g:timefinish=join(reltime(), ' ')
    echo g:timestart . ' --- ' . g:timefinish
endfunction
function! s:TestTime2(fu)
    let g:timestart=join(reltime(), ' ') 
    let g:start = strftime("%")
    let i = 0
    execute a:fu
    let g:timefinish=join(reltime(), ' ')
    echo g:timestart . ' --- ' . g:timefinish
endfunction

function! s:ADictPlaceSigns()
    let myl=[]
    call s:DeleteSigns()  " signs placed in GetDateHeads
    for key in keys(g:adict)
        let headline = g:adict[key].line
        let filenum = g:adict[key].file
        let buf = bufnr(s:agenda_files_copy[filenum])
        try
            silent execute "sign place " . headline . " line=" 
                        \ . headline . " name=piet buffer=" . buf  
        catch 
            echo "ERROR: headline " . headline . ' and buf ' .buf 
            echo key .', '. matchstr(key,'^.*\ze_\d\+$')
        finally
        endtry
    endfor
endfunction
function! s:DateDictPlaceSigns()
    let myl=[]
    call s:DeleteSigns()  " signs placed in GetDateHeads
    for key in keys(g:agenda_date_dict)
        let myl = get(g:agenda_date_dict[key], 'l')
        if len(myl) > 0
            for item in myl
                let dateline = matchstr(item,'^\d\d\d\zs\d\+')
                let filenum = str2nr(item[0:2])
                let buf = bufnr(s:agenda_files_copy[filenum])
                try
                    silent execute "sign place " . dateline . " line=" 
                                \ . dateline . " name=piet buffer=" . buf  
                catch 
                    echo "ERROR: headline " . headline . ' and buf ' . buf . ' and dateline ' . dateline

                    echo (matchstr(item,'^\d\+\s\+\zs\S\+') . '.org')
                finally
                endtry
            endfor
        endif
    endfor
endfunction

function! s:DateDictToScreen()
    let message = ["Press <f> or <b> for next or previous period." ,
                \ "<Enter> on a heading to synch main file, <ctl-Enter> to goto line," ,
                \ "<tab> to cycle heading text, <shift-Enter> to cycle Todos.",'']
    let search_spec = g:org_search_spec > '' ? g:org_search_spec : 'None - include all heads'
    call add(message,"Agenda view for " . g:agenda_startdate 
                \ . " to ". calutil#cal(calutil#jul(g:agenda_startdate)+g:org_agenda_days-1)
                \ . ' with SearchSpec=' . search_spec  )
    call add(message,'')
    call setline(1,message)
    call s:DateDictPlaceSigns()
    let gap = 0
    let mycount = len(keys(g:agenda_date_dict)) 
    for key in sort(keys(g:agenda_date_dict))
        if empty(g:agenda_date_dict[key].l)
            let gap +=1
            call setline(line('$')+ 1,g:agenda_date_dict[key].marker)
        else
            if (gap > g:org_agenda_skip_gap) && (g:org_agenda_minforskip <= mycount)
                silent execute line("$")-gap+2 . ',$d'
                call setline(line("$"), ['','  [. . . ' .gap. ' empty days omitted ]',''])
            endif
            let gap = 0
            call setline(line('$')+ 1,g:agenda_date_dict[key].marker)
            call setline(line('$')+ 1,g:agenda_date_dict[key].l)
            if ((g:org_agenda_days==1) || (key==strftime("%Y-%m-%d"))) && exists('g:org_timegrid') && (g:org_timegrid != [])
                call s:PlaceTimeGrid(g:agenda_date_dict[key].marker)
            endif
        endif
    endfor
    if (gap > g:org_agenda_skip_gap) && (g:org_agenda_minforskip <= mycount)
        silent execute line("$")-gap+2 . ',$d'
        call setline(line("$"), ['','  [. . . ' .gap. ' empty days omitted ]',''])
    endif
endfunction
function! s:PlaceTimeGrid(marker)
    let grid = s:TimeGrid(g:org_timegrid[0],g:org_timegrid[1],g:org_timegrid[2])
    call search(a:marker)
    exec line('.')+1
    if getline(line('.'))=~'\%20c\d\d:\d\d'
        "put grid lines in and then sort with other time items
        let start = line('.')
        call append(line('.'),grid)
        while (matchstr(getline(line('.')),'\%20c\d\d:\d\d'))
            if line('.') != line('$')
                exec line('.')+1
                let end = line('.')-1
            else
                let end = line('.')
                break
            endif
        endwhile
        exec start.','.end.'sort /.*\%19c/'
        " now delete duplicates where grid is same as actual entry
        exec end
        while line('.') >= start
            let match1 = matchstr(getline(line('.')),'\%20c.*\%25c')
            let match2 = matchstr(getline(line('.')-1),'\%20c.*\%25c')
            if match1 == match2
                if match1[0]==' '
                    normal ddk
                else
                    normal kdd
                endif
            endif
            exec line('.')-1
        endwhile
    endif
endfunction
function! OrgRunAgenda(date,count,...)
    try

    if bufname('%') == '__Agenda__'
        " vsplit agenda ***************
        "wincmd h
        " *******************
        wincmd k
    endif
    let g:agenda_head_lookup={}
    let win = bufwinnr('Calendar')
    if win >= 0 
        execute win . 'wincmd w'
        normal ggjjj
        wincmd l
        execute 'bd' . bufnr('Calendar')

    endif   
    if !exists("g:agenda_files") || (g:agenda_files==[])
        call confirm("No agenda files defined.  Will add current file to agenda files.")
        call s:CurfileAgenda()
    endif
    if exists('b:v.sparse_list') && (len(b:v.sparse_list) > 0)
        call s:ClearSparseTree()
    endif
    " a:1 is search_spec, a:2 is "today" for search
    if a:0 == 1
        call s:MakeAgenda(a:date,a:count,a:1)
    elseif a:0 == 2
        call s:MakeAgenda(a:date,a:count,a:1,a:2)
    else
        call s:MakeAgenda(a:date,a:count)
    endif
    let todos = b:v.todoitems
    let todoNotDoneMatch = b:v.todoNotDoneMatch
    let todoDoneMatch = b:v.todoDoneMatch
    let todoMatch = b:v.todoMatch
    let fulltodos = b:v.fulltodos
    if bufnr('__Agenda__') >= 0
        bwipeout __Agenda__
    endif
    :AAgenda
    let b:v={}
    let b:v.todoitems = todos
    let b:v.todoNotDoneMatch = todoNotDoneMatch
    let b:v.todoDoneMatch = todoDoneMatch
    let b:v.todoMatch = todoMatch
    let b:v.fulltodos = fulltodos
    silent exe '%d'
    set nowrap
    map <silent> <buffer> <c-CR> :MyAgendaToBuf<CR>
    map <silent> <buffer> <CR> :AgendaMoveToBuf<CR>
    map <silent> <buffer> vt :call OrgRunAgenda(strftime("%Y-%m-%d"), 1,g:org_search_spec)<CR>
    map <silent> <buffer> vd :call OrgRunAgenda(g:agenda_startdate, 1,g:org_search_spec,g:agenda_startdate)<CR>
    map <silent> <buffer> vw :call OrgRunAgenda(g:agenda_startdate, 7,g:org_search_spec)<CR>
    map <silent> <buffer> vm :call OrgRunAgenda(g:agenda_startdate, 30,g:org_search_spec)<CR>
    map <silent> <buffer> vy :call OrgRunAgenda(g:agenda_startdate, 365,g:org_search_spec)<CR>
    map <silent> <buffer> f :call OrgAgendaMove('forward')<cr>
    map <silent> <buffer> b :call OrgAgendaMove('backward')<cr>
    map <silent> <buffer> <tab> :call OrgAgendaGetText()<CR>
    map <silent> <buffer> <s-CR> :call OrgAgendaGetText(1)<CR>
    nmap <silent> <buffer> r :call OrgRunAgenda(g:agenda_startdate, g:org_agenda_days,g:org_search_spec)<CR>
    nmap <silent> <buffer> <s-up> :call OrgDateInc(1)<CR>
    nmap <silent> <buffer> <s-down> :call OrgDateInc(-1)<CR>

    "wincmd J
    for key in keys(g:agenda_date_dict)
        call sort(g:agenda_date_dict[key].l, 's:AgendaCompare')
    endfor
    call s:DateDictToScreen()
    if win >= 0
        let year = matchstr(t:agenda_date,'\d\d\d\d')
        let month = matchstr(t:agenda_date,'\d-\zs\d\d\ze-')
        execute 'Calendar ' . year .' '. str2nr(month) 
        execute bufwinnr('Agenda').'wincmd w'
    endif
    " rigamarole to get status line window, if any, back to zero height
    let curheight=winheight(0)
    wincmd k
    resize
    wincmd j
    execute 1
    execute 'resize ' . curheight   

    finally
        "set mouseshape-=n:busy,v:busy,i:busy
    endtry

endfunction
function! s:Resize()
    let cur = winheight(0)
    resize 
    resize cur
endfunction

function! s:GetDateHeads(date1,count,...)
    let save_cursor=getpos(".")
    if g:org_search_spec > ''
        let b:v.agenda_ifexpr = s:OrgIfExpr()
    endif
    let g:date1 = a:date1
    let date1 = a:date1
    let date2 = calutil#Jul2Cal(calutil#Cal2Jul(split(date1,'-')[0],split(date1,'-')[1],split(date1,'-')[2]) + a:count)
    execute 1
    "while search('\(\|[^-]\)[[<]\d\d\d\d-\d\d-\d\d','W') > 0
    while search('[^-][[<]\d\d\d\d-\d\d-\d\d','W') > 0
        let repeatlist = []
        let line = getline(line("."))
        let datematch = matchstr(line,'[[<]\d\d\d\d-\d\d-\d\d\ze')
        let repeatmatch = matchstr(line, '<\d\d\d\d-\d\d-\d\d.*+\d\+\S\+.*>\ze')
        if repeatmatch != ''
            " if date has repeater then call once for each repeat in period
            let repeatlist = s:RepeatMatch(repeatmatch[1:],date1,date2)
            for dateitem in repeatlist
                if a:0 == 1
                    call s:ProcessDateMatch(dateitem,date1,date2,a:1)
                else
                    call s:ProcessDateMatch(dateitem,date1,date2)
                endif
            endfor
        else
            if (datematch[0]!='[') || g:org_clocks_in_agenda
                if a:0 == 1
                    call s:ProcessDateMatch(datematch[1:],date1,date2,a:1)
                else
                    call s:ProcessDateMatch(datematch[1:],date1,date2)
                endif
            endif
        endif
        "endif
    endwhile
    call setpos(".",save_cursor)
endfunction

function! s:ProcessDateMatch(datematch,date1,date2,...)
    if a:0 > 0
        let today = a:1
    else
        let today = strftime("%Y-%m-%d")
    endif
    let datematch = a:datematch
    let rangedate = matchstr(getline(line(".")),'--<\zs\d\d\d\d-\d\d-\d\d')

    let locator = s:PrePad(s:filenum,3,'0') . s:PrePad(line('.'),5,'0') . '  '
    
    let g:myline = s:OrgGetHead_l(line('.'))
    "let g:myline = s:OrgParentHead_l(line('.'))
    "if g:myline == 0
    "    let filename = org#Pad(b:v.org_dict[g:myline].CATEGORY,13)
    "else
        let filename = org#Pad(b:v.org_dict.iprop(g:myline,'CATEGORY'),13)
    "endif
    let line = getline(line("."))
    let date1 = a:date1
    let date2 = a:date2
    let s:headline=0
    if (datematch >= date1) && (datematch < date2)
                \ && ((g:org_search_spec == '') || (s:CheckIfExpr(line("."),b:v.agenda_ifexpr)))
        let mlist = matchlist(line,'\(DEADLINE\|SCHEDULED\|CLOSED\)')
        call s:SetHeadInfo()
        if empty(mlist)
            " it's a regular date, first check for time parts
            let tmatch = matchstr(line,' \zs\d\d:\d\d\ze.*[[>]')
            if tmatch > ''
                let tmatch2 = matchstr(line,'<.\{-}-\zs\d\d:\d\d\ze.*>')
                if tmatch2 > ''
                    let tmatch .= '-' . tmatch2
                else
                    if match(line,':\s*CLOCK\s*:') >= 0
                        let tmatch .= '-'.matchstr(line,'--\[.\{-}\zs\d\d:\d\d\ze\]')
                        let s:headtext = s:headtext[0:6] . 'Clocked: ('.matchstr(line,'->\s*\zs.*$') .') '.s:headtext[7:]
                    else
                        let tmatch .= '......'
                    endif
                endif
            endif
            call add(g:agenda_date_dict[datematch].l,  locator . filename . org#Pad(tmatch,11) . s:headtext)
            "call add(g:agenda_date_dict[datematch].l,  line(".") . repeat(' ',6-len(line("."))) . filename . org#Pad(tmatch,11) . s:headtext)
            if rangedate != ''
                "let startdate = matchstr(line,'<\zs\d\d\d\d-\d\d-\d\d\ze')
                "let thisday = calutil#jul(datematch) - calutil#jul(startdate) + 1
                let days_in_range = calutil#jul(rangedate) - calutil#jul(datematch) + 1
                "let rangestr = '('.thisday.'/'.days_in_range.')'
                let i = days_in_range
                "while (rangedate < date2) && (rangedate > datematch)
                while (rangedate > datematch)
                    let rangestr = '('.i.'/'.days_in_range.')'
                    if exists("g:agenda_date_dict['".rangedate."']")
                        "call add(g:agenda_date_dict[rangedate].l,  line(".") . repeat(' ',6-len(line("."))) . 
                        call add(g:agenda_date_dict[rangedate].l,  locator . 
                                    \ filename . org#Pad(rangestr,11) . s:headtext)
                    endif
                    let rangedate = calutil#cal(calutil#jul(rangedate) - 1)
                    let i = i - 1
                endwhile
                " to end of line to avoid double
                " treatment
                normal $
            endif
        else
            " it's a deadline/scheduled/closed date
            let type = org#Pad(mlist[1][0] . tolower(mlist[1][1:]) . ':' , 11)
            call add(g:agenda_date_dict[datematch].l,  locator . filename . type  . s:headtext)
        endif
    endif
    " Now test for late and upcoming warnings if 'today' is in range
    if (today >= date1) && (today < date2)
        if (datematch < today) && (match(line,'\(DEADLINE\|SCHEDULED\)')>-1)
                    \ && ((g:org_search_spec == '') || (s:CheckIfExpr(line("."),b:v.agenda_ifexpr)))
            let mlist = matchlist(line,'\(DEADLINE\|SCHEDULED\)')
            call s:SetHeadInfo()
            if !empty(mlist)
                let dayspast = calutil#jul(today) - calutil#jul(datematch)
                if mlist[1] == 'DEADLINE'
                    let newpart = org#Pad('In',6-len(dayspast)) . '-' . dayspast . ' d.:' 
                else
                    let newpart = org#Pad('Sched:',9-len(dayspast)) . dayspast . 'X:'
                endif
                call add(g:agenda_date_dict[today].l,  locator . filename . newpart . s:headtext)
            endif
            " also put in warning entry for deadlines when appropriate
        elseif (datematch > today) && (match(line,'DEADLINE')>-1)
                    \ && ((g:org_search_spec == '') || (s:CheckIfExpr(line("."),b:v.agenda_ifexpr)))
            let mlist = matchlist(line,'DEADLINE')
            call s:SetHeadInfo()
            if !empty(mlist)
                let daysahead = calutil#jul(datematch) - calutil#jul(today)
                let g:specific_warning = str2nr(matchstr(line,'<\S*\d\d.*-\zs\d\+\zed.*>'))
                if (daysahead <= g:org_deadline_warning_days) || (daysahead <= g:specific_warning)
                    let newpart = org#Pad('In',7-len(daysahead)) . daysahead . ' d.:' 
                    call add(g:agenda_date_dict[today].l,  locator . filename . newpart . s:headtext)
                endif
            endif
        endif
    endif
    " finally handle things for a range that began before date1
    if (rangedate != '')  && (datematch < date1)
                \ && ((g:org_search_spec == '') || (s:CheckIfExpr(line("."),b:v.agenda_ifexpr)))
        let days_in_range = calutil#jul(rangedate) - calutil#jul(datematch) + 1
        if rangedate >= date2
            let last_day_to_add = calutil#jul(date2) - calutil#jul(datematch) 
            let rangedate = calutil#cal(calutil#jul(date2)-1)
        else
            let last_day_to_add = days_in_range
        endif

        call s:SetHeadInfo()
        let i = last_day_to_add
        while (rangedate >= date1)
            let rangestr = '('.i.'/'.days_in_range.')'
            call add(g:agenda_date_dict[rangedate].l,  locator . 
                        \ filename . org#Pad(rangestr,11) . s:headtext)
            let rangedate = calutil#cal(calutil#jul(rangedate) - 1)
            let i = i - 1
        endwhile
        " go past match to avoid double treatment
        normal $
    endif
    if s:headline > 0
        let g:agenda_head_lookup[line(".")]=s:headline
    endif
endfunction

function! s:SetHeadInfo()
    let s:headline = s:OrgGetHead_l(line("."))
    let s:headtext = getline(s:headline)
    let s:mystars = matchstr(s:headtext,'^\*\+')
    let s:headstars = s:PrePad(s:mystars,6)
    let s:headtext = s:headstars . ' ' . s:headtext[len(s:mystars)+1:]
endfunction

function! s:RepeatMatch(rptdate, date1, date2)
    let yearflag = 0
    let basedate = matchstr(a:rptdate,'\d\d\d\d-\d\d-\d\d')
    if basedate >= a:date2
        " no need for repeat, rturn to check fo deadlien warnings
        return [basedate]
    endif
    let date1 = a:date1
    if basedate > date1
        let date1 = basedate
    endif
    let baserpt = matchstr(a:rptdate, '+\zs\S\+\ze.*>')
    let rptnum = matchstr(baserpt, '^\d\+')
    let rpttype = matchstr(baserpt, '^\d\+\zs.')
    let g:rptlist = []
    let date1jul = calutil#jul(date1)
    let date2jul = calutil#jul(a:date2)
    if rpttype == 'w'
        let rpttype = 'd'
        let rptnum = str2nr(rptnum)*7
    endif
    if rpttype == 'y'
        let rpttype = 'm'
        let rptnum = str2nr(rptnum)*12
        let yearflag = 1
    endif
    if rpttype == 'd'
        let dmod = (date1jul - calutil#jul(basedate)) % rptnum
        let i = 0
        while 1
            let testjul = date1jul - dmod + (i*rptnum)
            if testjul < date2jul
                call add(g:rptlist, calutil#cal(testjul))
            else
                break
            endif
            let i += 1
        endwhile
    elseif rpttype == 'm'
        let g:special = baserpt[-1:]
        let monthday = str2nr(basedate[8:]) 
        let baseclone = basedate
        " this if-structure assigns begin test month as 
        " first repeat month _before_ date1
        if yearflag
            if (date1[:6]) >= (date1[:3] . baseclone[4:6]) 
                let baseclone = date1[:3] . baseclone[4:]
            else
                let baseclone = string(str2nr(date1[:3]) - 1) . baseclone[4:]
            endif
            let first_of_month_jul = calutil#jul(baseclone[:7]. '01')
        else
            let first_of_month_jul = calutil#jul(date1[:4] .
                        \ s:Pre0( date1[5:6] - 1) . '-01')
        endif

        if g:special == '*'
            let specialnum = (monthday / 7) + 1
            let specialdaynum = calutil#dow(basedate)
        endif
        while 1
            if g:special != '*'
                let testjul = first_of_month_jul - 1 + monthday
            else
                " process for 'xth weekday of month' type
                let fdow = calutil#dow(calutil#cal(first_of_month_jul))
                if fdow == specialdaynum
                    let testjul = first_of_month_jul + (specialnum-1)*7
                elseif fdow < specialdaynum
                    let testjul = first_of_month_jul + (specialnum-1)*7
                                \ + (specialdaynum - fdow)
                elseif fdow > specialdaynum
                    let testjul = first_of_month_jul + (specialnum*7)
                                \ - (fdow - specialdaynum)
                endif
            endif

            if (testjul < date2jul) && (testjul >= first_of_month_jul)
                call add(g:rptlist, calutil#cal(testjul))
            else
                "put in this one to check for deadlien warnings
                "if len(g:rptlist)>0
                call add(g:rptlist, calutil#cal(testjul))
                "endif
                break
            endif
            let first_cal = calutil#cal(first_of_month_jul)
            let nextmonth = str2nr(first_cal[5:6]) + rptnum
            let year = str2nr(first_cal[0:3]) 
            if nextmonth >= 13
                let nextmonth = (nextmonth-12)
                let year += 1 
            endif
            let first_of_month_jul = calutil#jul(string(year) . '-' . s:Pre0(nextmonth) . '-01')
        endwhile
    endif

    return g:rptlist

endfunction

function! s:BufMinMaxDate()
    let b:v.MinMaxDate=['2099-12-31','1900-01-01']
    g/<\d\d\d\d-\d\d-\d\d/call s:CheckMinMax()

endfunction
function! s:CheckMinMax()
    let date = matchstr(getline(line(".")),'<\zs\d\d\d\d-\d\d-\d\d')
    if (date < b:v.MinMaxDate[0])
        let b:v.MinMaxDate[0] = date
    endif
    if (date > b:v.MinMaxDate[1])
        let b:v.MinMaxDate[1] = date
    endif
endfunction        
function! s:Timeline(...)
    if a:0 > 0
        let spec = a:1
    else
        let spec = ''
    endif
    if bufname("%") == '__Agenda__'
        "go back up to main org buffer
        wincmd k
    endif
    let prev_spec = g:org_search_spec
    let prev_files = g:agenda_files
    exec "let g:agenda_files=['".substitute(expand("%"),' ','\\ ','g')."']"
    call s:BufMinMaxDate()
    let num_days = 1 + calutil#jul(b:v.MinMaxDate[1]) - calutil#jul(b:v.MinMaxDate[0])
    try
        call OrgRunAgenda(b:v.MinMaxDate[0], num_days,spec)
    finally
        let g:org_search_spec = prev_spec
        let g:agenda_files = prev_files
    endtry
endfunction

function! s:Pre0(s)
    return repeat('0',2 - len(a:s)) . a:s
endfunction

function! s:PrePad(s,amt,...)
    if a:0 > 0
        let char = a:1
    else
        let char = ' '
    endif
    return repeat(char,a:amt - len(a:s)) . a:s
endfunction
function! s:AgendaCompare(i0, i1)
    "let mymstr = '^\(\d\+\)\s\+\(\S\+\)\s\+\(\%24c.\{11}\).*\(\*\+\)\s\(.*$\)'
    let mymstr = '^\(\d\+\)\s\+\(\S\+\)\s\+\(\S.\{10}\).*\(\*\+\)\s\(.*$\)'
    " [1] is lineno, [2] is file, [3] is scheduling, [4] is levelstarts, 
    " [5] is headtext
    let cp0 = matchlist(a:i0,mymstr)
    let cp1 = matchlist(a:i1,mymstr)
    let myitems = [cp0, cp1]
    let sched_comp = []
    let i = 0
    while i < 2
        let item = myitems[i]
        if item[3][0] == 'S'
            if item[3][5] == ':'
                "let str_ord = 'a' . substitute(item[3][6:8],' ', '0','')
                let str_ord = 'aa' . s:PrePad(1000-str2nr(item[3][6:8]),' ', '0')
            else
                let str_ord = 'ab000'
            endif
        elseif item[3][0] == 'I' 
            if matchstr(item[3],'-') > ''
                let str_ord = 'd-'.s:PrePad(1000-str2nr(matchstr(item[3],'\d\+')),3,'0')
            else
                let str_ord = 'da'.s:PrePad(matchstr(item[3],'\d\+'),3,'0')
            endif
        elseif item[3][0] == 'D'
            let str_ord = 'd0000'
        elseif item[3][0] == ' '
            let str_ord = 'zzzzz'
        else
            let str_ord = item[3][:4]
        endif
        call add(sched_comp,str_ord.item[2].s:PrePad(item[1],5,'0'))
        let i += 1
    endwhile 

    return sched_comp[0] == sched_comp[1] ? 0 : sched_comp[0] > sched_comp[1] ? 1 : -1

"    let num1 = str2nr(matchstr(a:i1,'In *\zs[ -]\d\+\ze d.:'))
"    let num2 = str2nr(matchstr(a:i2,'In *\zs[ -]\d\+\ze d.:'))
"    if num1 == 0 
"        let num1 = str2nr(matchstr(a:i1,'Sched: *\zs\d\+\zeX:'))
"        if num1 !=0 
"            let num1 = -num1 - 10000
"        endif
"    endif
"    if num2 == 0 
"        let num2 = str2nr(matchstr(a:i2,'Sched: *\zs\d\+\zeX:'))
"        if num2 !=0 
"            let num2 = -num2 - 10000
"        endif
"    endif
"    if (a:i1 =~ '^\d\+\s\+\S\+\s\+\d') 
"        let num1=num1-20000
"    endif
"    if (a:i2 =~ '^\d\+\s\+\S\+\s\+\d') 
"        let num2=num2-20000
"    endif

"    return num1 == num2 ? 0 : num1 > num2 ? 1 : -1

endfunc

function! s:DateListAdd(valdict)
    let namelist = [' GENERAL','SCHEDULED','CLOSED','DEADLINE']
    let templist = []
    call add(templist, get(a:valdict,'ud',0))
    call add(templist, get(a:valdict,'sd',0))
    call add(templist, get(a:valdict,'cd',0))
    call add(templist, get(a:valdict,'dd',0))
    let i = 0
    while i < 4
        if templist[i] != 0
            call add(g:org_datelist, templist[i] . ' ' . namelist[i] . ' ' . a:valdict.l )
        endif
        let i += 1
    endwhile
    return a:valdict
endfunction 

function! OrgAgendaMove(direction)
    if a:direction == 'forward'
        if g:org_agenda_days == 1
            let g:agenda_startdate = calutil#cal(calutil#jul(g:agenda_startdate)+1)
        elseif g:org_agenda_days == 7
            let g:agenda_startdate = calutil#cal(calutil#jul(g:agenda_startdate)+7)
        elseif g:org_agenda_days >= 360
            let g:agenda_startdate = string(g:agenda_startdate[0:3]+1).'-01-01'
        else
            if g:agenda_startdate[5:6] == '12'
                let g:agenda_startdate = string(g:agenda_startdate[0:3] + 1).'-01-01'
            else
                let g:agenda_startdate = g:agenda_startdate[0:4].
                            \ s:Pre0(string(str2nr(g:agenda_startdate[5:6])+1)) .'-01'
            endif
            let g:org_agenda_days = s:DaysInMonth(g:agenda_startdate)
        endif
    else            "we're going backward
        if g:org_agenda_days == 1
            let g:agenda_startdate = calutil#cal(calutil#jul(g:agenda_startdate)-1)
        elseif g:org_agenda_days == 7
            let g:agenda_startdate = calutil#cal(calutil#jul(g:agenda_startdate)-7)
        elseif g:org_agenda_days >= 360
            let g:agenda_startdate = string(g:agenda_startdate[0:3]-1).'-01-01'
        else
            if g:agenda_startdate[5:6] == '01'
                let g:agenda_startdate = string(g:agenda_startdate[0:3] - 1).'-12-01'
            else
                let g:agenda_startdate = g:agenda_startdate[0:4].
                            \ s:Pre0(string(str2nr(g:agenda_startdate[5:6]) - 1)) .'-01'
            endif
            let g:org_agenda_days = s:DaysInMonth(g:agenda_startdate)
        endif

    endif
    if g:org_agenda_days==1
        call OrgRunAgenda(g:agenda_startdate,g:org_agenda_days,g:org_search_spec,g:agenda_startdate)
    else
        call OrgRunAgenda(g:agenda_startdate,g:org_agenda_days,g:org_search_spec)
    endif
endfunction

function! s:TimeGrid(starthour,endhour,inc)
    let result = []
    for i in range(a:starthour, a:endhour,a:inc)
        call add(result,repeat(' ',19).s:Pre0(i).':00......       ------------')
    endfor
    return result
endfunction

function! s:MakeCalendar(date, daycount)
    "function! s:MakeCalendar(year, month, day, daycount)
    " this function is taken from vim tip by Siegfried Bublitz
    " at: http://vim.wikia.com/wiki/Generate_calendar_file
    " with many mods to 1.output to list rather than to buffer
    " and 2. get weekday and weekno from calutils
    let g:agenda_date_dict = {}
    let g:agenda_head_lookup = {}
    "let startdate = calutil#Jul2Cal((calutil#Cal2Jul(a:year,a:month,a:day) - calutil#DayOfWeek(a:year,a:month,a:day)))
    let year = split(a:date,'-')[0]
    let month = split(a:date,'-')[1]
    let day = split(a:date,'-')[2]
    let day = str2nr(day)

    if a:daycount == 7
        let wd = 1
    elseif (a:daycount>=28) && (a:daycount <=31)
        let wd = calutil#dow(a:date[0:7].'01') + 1
    else
        let wd = calutil#dow(a:date) + 1
    endif
    let week = 1 + (calutil#Cal2Jul(year,month,day) - calutil#Cal2Jul(year,1,1)) / 7
    let index = 0
    let datetext = ''
    let diy = 777 " day in year, wrong before next year
    while (index < a:daycount) " no of days to output
        let diy = diy + 1
        if (wd > 7)
            let wd = 1
            let week = week + 1
            if (week >= 53)
                if (week >= 54)
                    let week = 1
                elseif (day >= 28 || day <= 3)
                    let week = 1
                endif
            endif
        endif
        let monthnames=['January','February','March','April','May','June','July',
                    \ 'August','September','October','November','December']
        "let daynames = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
        let daynames = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
        let dn = daynames[wd-1]
        if ((day > 31) || (month == 2 && (day > 29 || day > 28 && year % 4))
                    \ || (month == 4 && day > 30) || (month == 6 && day > 30)
                    \ || (month == 9 && day > 30) || (month == 11 && day > 30))
            let day = 1
            let month = month + 1
            if (month > 12)
                let month = 1
                let diy = 1
                let year = year + 1
                if (wd <= 3)
                    let week = 1
                endif
            endif
        endif

        let datetext = dn . repeat(' ',10-len(dn)) . (day<10?'   ':'  ') . 
                    \ day . ' ' . monthnames[month-1] . ' ' . year . (wd==1 ? ' Wk' . week : '' )

        let g:agenda_date_dict[year . '-' . s:Pre0(month) .  '-' .  (day<10 ? '0'.day : day) ]
                    \ = {'marker': datetext, 'l': [] }
        let index = index + 1
        let day = day + 1
        let wd = wd + 1
    endwhile

endfunction

function! s:ActualBufferLine(lineref_in_agenda,bufnumber)
    let actual_line = matchstr(s:GetPlacedSignsString(a:bufnumber),'line=\zs\d\+\ze\s\+id='.a:lineref_in_agenda)
    return actual_line
endfunction

function! s:AgendaPutText(...)
    let save_cursor = getpos(".")
    let thisline = getline(line("."))
    if thisline =~ '^\d\+\s\+'
        if (getline(line(".") + 1) =~ '^\*\+ ')
            "let file = matchstr(thisline,'^\d\+\s\+\zs\S\+\ze')
            "let file = s:filedict[str2nr(matchstr(thisline, '^\d\d\d'))]
            let file = s:agenda_files_copy[str2nr(matchstr(thisline, '^\d\d\d'))]
            "let lineno = matchstr(thisline,'^\d\+\ze\s\+')
            let lineno = str2nr(matchstr(thisline,'^\d\d\d\zs\d*'))
            let starttab = tabpagenr() 

            "call s:LocateFile(file.'.org')
            call s:LocateFile(file)
            if g:agenda_date_dict != {}
                "let confirmhead = g:agenda_head_lookup[lineno]
                let confirmhead = lineno
            elseif g:adict != {}
                let confirmhead = lineno
            endif
            let newhead = matchstr(s:GetPlacedSignsString(bufnr("%")),'line=\zs\d\+\ze\s\+id='.confirmhead)
            let newhead = s:OrgGetHead_l(newhead)
            execute newhead
            let lastline = s:OrgNextHead_l(newhead) - 1
            if lastline > newhead
                let g:text = getline(newhead,lastline)
            else    
                let g:text = []
            endif

            execute 'tabnext ' . starttab
            execute bufwinnr('Agenda').'wincmd w'

            call setpos(".",save_cursor)
            " okay, we're back in agenda and have main buffer's
            " text in g:text, now need to compare it

            normal j
            let firstline = line(".")
            let daytextpat = '^\S\+\s\+\d\{1,2}\s\S\+\s\d\d\d\d'
            while (getline(line(".")) !~ '^\d\+\s\+') && (line(".") != line("$"))
                        \ && (getline(line(".")) !~ daytextpat)
                        \ && (getline(line(".")) !~ '\d empty days omitted')
                normal j
            endwhile
            let lastline = line(".")
            if (lastline < line("$"))  ||
                        \ ( (getline(line(".")) =~ '^\d\+\s\+')
                        \ || (getline(line(".")) =~ daytextpat) 
                        \ || (getline(line(".")) =~ '\d empty days omitted') )
                let lastline = line(".") - 1
            endif
            "execute firstline . ', ' . lastline . 'd'
            if g:text == getline(firstline, lastline)
                echo "headings are identical"
            else
                if g:adict != {}
                    let resp = confirm("Heading's text has changed, save changes?","&Save\n&Cancel",1)
                    if resp == 1
                        call s:SaveHeadline(file, newhead,getline(firstline,lastline))
                        "call s:SaveHeadline(file, confirmhead,getline(firstline,lastline))
                    else
                        echo "Changes were _not_ saved."
                    endif
                else
                    call confirm("Heading's text has changed, but saving is\n"
                        \ . "temporarily disabled for date-based agenda views.\n"
                        \ . "No changes are being saved, original buffer text remains as it was.")
                endif
            endif
        endif
    else
        echo "You're not on a headline line."
    endif
    call setpos(".",save_cursor)
endfunction
function! s:SaveHeadline(file, headline, lines)
    let file = a:file
    let headline = a:headline
    let lines=a:lines
    let starttab = tabpagenr() 

    "call s:LocateFile(file.'.org')
    call s:LocateFile(file)
    "let newhead = matchstr(s:GetPlacedSignsString(bufnr("%")),'line=\zs\d\+\ze\s\+id='.headline)
    let newhead = a:headline
    execute newhead

    let lastline = s:OrgNextHead_l(newhead) - 1
    execute newhead+1.','.lastline.'d'
    " don't delete orig headline b/c that's where sign is placed
    call setline(newhead,lines[0])
    call append(newhead,lines[1:])

    execute 'tabnext ' . starttab
    execute bufwinnr('Agenda').'wincmd w'

endfunction
function! OrgAgendaGetText(...)
    "type: 'datedict' for date agenda, 'adict' for regular search
    let cycle_todo = 0
    if a:0 >= 1 
        let cycle_todo = 1
        if a:0 == 2
            let newtodo = a:2
        endif
    endif
    " called by <TAB> map to toggle view of heading's body text in agenda
    " view
    let save_cursor = getpos(".")
    let thisline = getline(line("."))
    let curTodo = matchstr(thisline, '\*\+ \zs\S\+')
    if thisline =~ '^\d\+\s\+'
        if (getline(line(".") + 1) =~ '^\d\+\s\+') || (line(".") == line("$")) ||
                    \ (getline(line(".") + 1 ) =~ '^\S\+\s\+\d\{1,2}\s\S\+\s\d\d\d\d')
                    \ || (getline(line(".") + 1 ) =~ '\d empty days omitted')
            let file = s:agenda_files_copy[str2nr(matchstr(thisline, '^\d\d\d'))]
            let lineno = str2nr(matchstr(thisline,'^\d\d\d\zs\d*'))
            let starttab = tabpagenr() 

            call s:LocateFile(file)
            let save_cursor2 = getpos(".")
            "let confirmhead = s:OrgGetHead_l(headline)
            if g:agenda_date_dict != {}
                "let confirmhead = g:agenda_head_lookup[lineno]
                let confirmhead = lineno
            elseif g:adict != {}
                let confirmhead = lineno
            endif
            let newhead = matchstr(s:GetPlacedSignsString(bufnr("%")),'line=\zs\d\+\ze\s\+id='.confirmhead)
            let newhead = s:OrgGetHead_l(newhead)
            execute newhead

            if cycle_todo
                if a:0 >= 2
                    call s:ReplaceTodo(curTodo,newtodo)
                else
                    call s:ReplaceTodo(curTodo)
                endif
            else
                let lastline = s:OrgNextHead_l(newhead) - 1
                if lastline > newhead
                    let g:text = getline(newhead,lastline)
                else    
                    let g:text = []
                endif
            endif
            call setpos(".",save_cursor2)
            execute 'tabnext ' . starttab
            execute bufwinnr('Agenda').'wincmd w'
            if !cycle_todo
                call append(line("."),g:text)
            endif
        else
            normal j
            let firstline = line(".")
            let daytextpat = '^\S\+\s\+\d\{1,2}\s\S\+\s\d\d\d\d'
            while (getline(line(".")) !~ '^\d\+\s\+') && (line(".") != line("$"))
                        \ && (getline(line(".")) !~ daytextpat)
                        \ && (getline(line(".")) !~ '\d empty days omitted')
                normal j
            endwhile
            let lastline = line(".")
            if (lastline < line("$"))  ||
                        \ ( (getline(line(".")) =~ '^\d\+\s\+')
                        \ || (getline(line(".")) =~ daytextpat) 
                        \ || (getline(line(".")) =~ '\d empty days omitted')) 
                let lastline = line(".") - 1
            endif
            call setpos(".",save_cursor)
            call s:AgendaPutText()
            silent execute firstline . ', ' . lastline . 'd'
        endif
    else
        echo "You're not on a headline line."
    endif
    call setpos(".",save_cursor)
    if cycle_todo
        if a:0 >= 2
            call s:ReplaceTodo(curTodo, newtodo)
        else
            call s:ReplaceTodo(curTodo)
        endif
        echo "Todo cycled."
    endif

endfunction

function! s:IsVisibleHeading(line)
    " returns 1 if line is of a visible heading,
    " 0 if not
    " a heading is visible if foldclosed = -1
    " (i.e., it's not in a fold) 
    " OR if it's not in an earlier-started fold
    " (i.e. start of fold heading is in is 
    " same as line of heading)
    " ***************************   the second and third lines of if 
    " statement are necessary because of bug where foldclosed is less 
    " than a head even though it is the fold head ***************
    let fc = foldclosed(a:line)
    if ((a:line > 0) && (fc == -1)) || (fc == a:line)
                \ || ((fc < a:line) &&  s:IsText(fc) )
                \ || ((fc < a:line) &&  (foldclosedend(fc) < a:line) )
        "   \ || (s:Ind(a:line) == 2)
        return 1
    else    
        return 0
    endif
endfunction

function! OrgSingleHeadingText(operation)
    " expand or collapse all visible Body Text
    " under Heading fold that cursor is in
    " operation:  "collapse" or "expand"
    " expand or collapse all Body Text 
    " currently visible under current heading
    let l:startline = line(".")
    let l:endline = s:OrgSubtreeLastLine_l(l:startline) - 1
    call OrgBodyTextOperation(l:startline,l:endline,a:operation)
endfunction

function! s:StarLevelFromTo(from, to)
    let save_cursor = getpos(".")
    set fdm=manual
    let b:v.levelstars = a:to
    ChangeSyn
    g/^\*\+/call setline(line("."),substitute(getline(line(".")),'^\*\+','*' . 
                \ repeat('*',(len(matchstr(getline(line(".")),'^\*\+')) - 1) * a:to / a:from),''))
    set fdm=expr
    call setpos(".",save_cursor)
endfunction

function! s:StarsForLevel(level)
    return 1 + (a:level - 1) * b:v.levelstars
endfunction

function! s:OrgExpandLevelText(startlevel, endlevel)
    " expand regular text for headings by level
    let save_cursor = getpos(".")

    normal gg
    let startlevel = s:StarsForLevel(a:startlevel)
    let endlevel = s:StarsForLevel(a:endlevel)
    let l:mypattern = substitute(b:v.headMatchLevel,'level', startlevel . ',' . endlevel, "") 
    while search(l:mypattern, 'cW') > 0
        execute line(".") + 1
        while getline(line(".")) =~ b:v.drawerMatch
            execute line(".") + 1
        endwhile
        if s:IsText(line(".")) 
            normal zv
        endif
        "normal l
    endwhile

    call setpos('.',save_cursor)

endfunction

" just an idea using 'global' not used anywhere yet
" visible is problem, must operate only on visible, doesn't do ths now
function! s:BodyTextOperation3(startline,endline, operation)
    let l:oldcursor = line(".")
    let nh = 0
    call cursor(a:startline,0)
    g/\*\{4,}/s:DoAllTextFold(line("."))
    call cursor(l:oldcursor,0)

endfunction


function! OrgBodyTextOperation(startline,endline, operation)
    " expand or collapse all Body Text from startline to endline
    " operation:  "collapse" or "expand"
    " save original line 
    let l:oldcursor = line(".")
    let nh = 0
    " go to startline
    call cursor(a:startline,0)
    " travel from start to end operating on any
    while 1
        if getline(line(".")) =~ b:v.headMatch
            if a:operation == "collapse"
                call s:DoAllTextFold(line("."))
            elseif a:operation == 'expand'
                normal zv
            endif
            "elseif s:IsText(line(".")+1) && foldclosed(line("."))==line(".")
            "elseif foldclosed(line("."))==line(".")
            "   "echo 'in expand area'
            "   if a:operation == 'expand'
            "       normal zv
            "   endif   
        endif
        let lastnh = nh
        let nh = s:NextVisibleHead(line("."))
        "echo 'last ' . lastnh . '    now ' . nh
        if (nh == 0) || (nh >= a:endline) || (nh == lastnh) 
            "echo "hit break"
            break
        elseif lastnh == nh
            break
            echo "bad exit from BodyTextOp"
        else
            "echo "hit ex"
            execute nh 
        endif

    endwhile
    " now go back to original line position in buffer
    call cursor(l:oldcursor,0)
endfunction

let g:calendar_sign = 'OrgCalSign'
function! OrgCalSign(day, month, year)
  if a:year .'-'.s:Pre0(a:month).'-'.s:Pre0(a:day) == s:org_cal_date
      return 1
  else
      return 0
  endif
endfunction
function! OrgSetLine(line, file, newtext)
    let save_cursor = getpos(".")
    let curfile = expand("%:t")

    call s:LocateFile(a:file)
    call setline(a:line,a:newtext)
    
    call s:LocateFile(curfile)
    call setpos('.',save_cursor)
endfunction
function! OrgGetLine(line, file)
    let save_cursor = getpos(".")
    let curfile = expand("%:t")

    call s:LocateFile(a:file)
    let result = getline(a:line)
    
    call s:LocateFile(curfile)
    call setpos('.',save_cursor)
    return result
endfunction
function! OrgAgendaDateType()
    " return type of date line in Agenda
    let text = getline(line('.'))[19:29]
    if text =~ 'Sched'
        let result = 'Scheduled'
    elseif text =~ '\(In \|DEADLINE\)'
       let result = 'Deadline'
    elseif text =~ 'Closed'
        let result = 'Closed'
    elseif text =~ '('
        let result = 'Range'
    else
        let result = 'Regular'
    endif
    return result
endfunction

function! GetDateAtCursor()
        " save visual bell settings so no bell
        " when not found"
        let orig_vb = &vb
        let orig_t_vb = &t_vb
        set vb t_vb=

        "  check for date string within brackets
        normal! vi<
        normal! "xy
        if len(@x) < 7 
            "normal! vi["xy
            normal! vi[
            normal! "xy
        endif

        if (len(@x)>=14) && (len(@x)<40)
            let date = matchstr(@x,'^\d\d\d\d-\d\d-\d\d')
        else
            let date = ''
        endif

        " restore visual bell settings
        let &vb = orig_vb
        let &t_vb = orig_t_vb

        if date > ''
            return @x
        else
            return ''
        endif
        
endfunction

function! OrgDateEdit(type)
    " type can equal DEADLINE/CLOSED/SCHEDULED/TIMESTAMP or blank for 
    " date on current line
    let old_cal_navi = g:calendar_navi
    unlet g:calendar_navi
    try
        let text = a:type
        let line_pos = getpos('.')[2]
        let b:v.basetime=''
        let from_agenda=0
        let str = ''
        let filestr = ''
        let lineno=line('.')
        let buffer_lineno = lineno
        let file = expand("%:t")
        let bufline = getline(lineno)
        if bufname("%")==('__Agenda__')
            let lineno = matchstr(getline(line('.')),'^\d\+')
            let file = matchstr(getline(line('.')),'^\d\+\s*\zs\S\+').'.org'
            let filestr = ',"'.file.'"'
            let from_agenda=1
            let buffer_lineno = s:ActualBufferLine(lineno,bufnr(file))
            let str = ',' . buffer_lineno . ',"' . file . '"'
            let bufline = OrgGetLine(buffer_lineno,file)
            if bufline !~ '[<[]\d\d\d\d-\d\d-\d\d'
                call confirm("Can't find corresponding line in main buffer, may need to refresh Agenda")
                return
            endif
            let b:v.mdate = matchstr(bufline,'\d\d\d\d-\d\d-\d\d \S\S\S\( \d\d:\d\d-\d\d:\d\d\| \d\d:\d\d\|\)') 
        else
            let b:v.mdate = GetDateAtCursor()
        endif
        if text =~ '\(DEADLINE\|SCHEDULED\|CLOSED\|TIMESTAMP\)'
            let b:v.mdate = s:GetProp(text,buffer_lineno, file)
        endif

        if matchstr(bufline,'[[<]\d\d\d\d-\d\d-\d\d.\{-}+\d\+') != ''
           call confirm("Date has a repeater.  Please edit by hand.")
           return
        endif

        let b:v.mdate = matchstr(b:v.mdate,'\d\d\d\d-\d\d-\d\d \S\S\S\( \d\d:\d\d-\d\d:\d\d\| \d\d:\d\d\|\)') 
        let replace_str = b:v.mdate
        if b:v.mdate > ''
            let b:v.basedate = b:v.mdate[0:9]
            let b:v.baseday = b:v.mdate[11:13]
            if len(b:v.mdate) > 14
                let b:v.basetime = b:v.mdate[15:]
            else
                let b:v.basetime = ''
            endif
        else
            let b:v.mdate=strftime("%Y-%m-%d %a")
            let b:v.basedate=s:Today()
            let b:v.basetime = ''
        endif

"function! OrgDatePrompt(basedate, basetime)
        let basedate = b:v.basedate[0:9]
        let basetime = b:v.basetime
        let newdate = '<' . b:v.mdate[0:13] . (b:v.basetime > '' ? ' ' . b:v.basetime : '') . '>'
        let newtime = b:v.basetime

        hi Cursor guibg=black
        let s:org_cal_date = newdate[1:10]
        call Calendar(1,newdate[1:4],str2nr(newdate[6:7]))
        " highlight chosen dates in calendar
        hi Ag_Date guifg=red
        call matchadd('Ag_Date','+\s\{0,1}\d\+')
        redraw
        let g:calendar_action='<SNR>'.s:SID().'_CalendarInsertDate'
        let cue = ''
        while 1
            echohl LineNr | echon 'Date+time ['.basedate . ' '.basetime.']: ' 
            "echohl None | echon cue.'_   =>' | echohl WildMenu | echon ' '.newdate[:-2] . ' ' . newtime 
            echohl None | echon cue.'_   =>' | echohl WildMenu | echon ' '.newdate[:-2] . '>' 
            let nchar = getchar()
            let newchar = nr2char(nchar)
            if newdate !~ 'interpret'
                let curdif = calutil#jul(newdate[1:10])-calutil#jul(s:Today())
            endif
            if (nchar == "\<BS>") && (len(cue)>0)
                let cue = cue[:-2]
            elseif nchar == "\<s-right>"
                let cue = ((curdif+1>=0) ?'+':'').(curdif+1).'d'
            elseif nchar == "\<s-left>"
                let cue = ((curdif-1>=0) ?'+':'').(curdif-1).'d'
            elseif nchar == "\<s-down>"
                let cue = ((curdif+7>=0) ?'+':'').(curdif+7).'d'
            elseif nchar == "\<s-up>"
                let cue = ((curdif-7>=0) ?'+':'').(curdif-7).'d'
            elseif nchar == "\<c-down>"
                let cue = ((curdif+30>=0) ?'+':'').(curdif+30).'d'
            elseif nchar == "\<c-up>"
                let cue = ((curdif-30>=0) ?'+':'').(curdif-30).'d'
            elseif nchar == "\<s-c-down>"
                let cue = ((curdif+365>=0) ?'+':'').(curdif+365).'d'
            elseif nchar == "\<s-c-up>"
                let cue = ((curdif-365>=0) ?'+':'').(curdif-365).'d'
            elseif newchar == "\<cr>"
                break
            elseif newchar == "\<Esc>"
                hi Cursor guibg=gray
                if bufwinnr('__Calendar') > 0
                    bdelete Calendar
                endif
                redraw
                return
            elseif (nchar == "\<LeftMouse>") && (v:mouse_win > 0) && (bufwinnr('__Calendar')== v:mouse_win)
                let g:cal_list=[]
                exe v:mouse_win . "wincmd w"
                exe v:mouse_lnum
                exe "normal " . v:mouse_col."|"
                normal 
                if g:cal_list != []
                    if newtime > ''
                        let timespec = newtime
                    else
                        let timespec = matchstr(newdate,'\S\+:.*>')
                    endif
                    let newdate = '<'.g:cal_list[0].'-'.s:Pre0(g:cal_list[1]).'-'.s:Pre0(g:cal_list[2]) . ' '
                    let newdate .= calutil#dayname( g:cal_list[0].'-'.g:cal_list[1].'-'.g:cal_list[2])
                    let newdate .=  timespec > '' ? ' ' . timespec : ''.'>'
                    break
                endif
            else
                let cue .= newchar
            endif
            let newdate = '<' . s:GetNewDate(cue,basedate,basetime)  . '>'
            "let newdate = '<' . s:GetNewDate(cue,basedate) . ( newtime > '' ? ' ' . newtime : '') . '>'
            "let newtime = s:GetNewTime(cue,basetime)
            if g:org_use_calendar && (match(newdate,'\d\d\d\d-\d\d')>=0)
                let s:org_cal_date = newdate[1:10]
                call Calendar(1,newdate[1:4],str2nr(newdate[6:7]))
            endif
            echon repeat(' ',72)
            redraw
        endwhile
        hi Cursor guibg=gray
        bdelete __Calendar
        if (from_agenda==0) && bufname("%")=='__Agenda__'
           wincmd k 
        endif

        " set buffer text with new date . . . 
        if text =~ '\(DEADLINE\|SCHEDULED\|CLOSED\|TIMESTAMP\)'
            let b:v.mdate = s:SetProp(text,newdate,buffer_lineno, file)
        else
            " set the date at linenumber to new date
            "let newdate = substitute(bufline,'[[<]\zs\d\d\d\d-\d\d-\d\d.\{-}\ze[>\]]',newdate[1:-2],'')
            let newdate = substitute(bufline,replace_str,newdate[1:-2] ,'')
            if bufname("%")==('__Agenda__')
                call OrgSetLine(buffer_lineno,file,newdate)
            else
                call setline(buffer_lineno,newdate)
            endif
        endif
        let @/=''
        set nohlsearch
        set hlsearch
        redraw
        echo 
        redraw
    finally
        let g:calendar_navi = old_cal_navi
    endtry
endfunction

function! s:GetNewTime(cue, basetime)
    let timecue = a:cue
    if timecue =~ '\d\d:\d\d'
        let mytime = ' '.timecue
    else
        let mytime = ''
    endif
    return mytime

endfunction

function! s:GetNewDate(cue,basedate,basetime)
        if match(a:cue,':') >= 0
            let cue = matchstr(a:cue,'^\S\+\ze \S\+:')
            let timecue = matchstr(a:cue,'\S\+:\S\+')
        else
            let cue = a:cue
            let timecue = ''
        endif
        let basedate = a:basedate
        let newdate = a:basedate
        if cue =~ '^\(+\|++\|-\|--\)$'
            let cue = cue . '1d'
        elseif cue =~ '^\(+\|++\|-\|--\)\d\+$'
            let cue = cue .'d'
        endif
        if cue == '.'
            let newdate = strftime('%Y-%m-%d')
        elseif cue == ''
            let newdate = a:basedate
        elseif (cue =~ '^\d\+$') && (str2nr(cue) <= 31)
            " day of month string
            if str2nr(cue) > str2nr(basedate[8:9])
                let newdate = calutil#cal(calutil#jul(basedate[0:7].s:Pre0(cue)))
            else 
                let newmonth = s:Pre0(basedate[5:6]+1)
                let newdate = calutil#cal(calutil#jul(basedate[0:4].newmonth.'-'.s:Pre0(cue)))
            endif
        elseif cue =~ '^\d\+[-/]\d\+$'
            " month/day string
            let month = matchstr(cue,'^\d\+')
            let day = matchstr(cue,'\d\+$')
            let year = basedate[0:3]
            if basedate[0:4] . s:Pre0(month) . '-' . s:Pre0(day) < basedate
                let year = year + 1
            endif
            let newdate = calutil#cal(calutil#Cal2Jul(year,month,day))
        elseif cue =~ '\d\+/\d\+/\d\+'
            " m/d/y string
            let month = matchstr(cue,'^\d\+\ze/.*/')
            let day = matchstr(cue,'/\zs\d\+\ze/')
            let year = matchstr(cue,'/\zs\d\+\ze$')
            if len(year) < 3
                let year +=2000
            endif
            let newdate = calutil#cal(calutil#Cal2Jul(year,month,day))
        elseif cue =~ '\d\+-\d\+-\d\+'
            " y-m-d string
            let year = matchstr(cue,'^\d\+\ze-.*-')
            if year < 100
                let year +=2000
            endif
            let month = matchstr(cue,'-\zs\d\+\ze-')
            let day = matchstr(cue,'-\zs\d\+\ze$')
            let newdate = calutil#cal(calutil#Cal2Jul(year,month,day))

            "       elseif cue =~ s:org_monthstring
            "           let mycount = matchstr(cue,'^\d\+')
            "           let mymonth = 
            "           let newday = index(s:org_weekdays,cue)
            "           let oldday = calutil#dow(basedate)
            "           if newday > oldday
            "               let amt=newday-oldday
            "           elseif newday < oldday
            "               let amt =7-oldday+newday
            "           else
            "               let amt = 7
            "           endif
            "           let newdate=calutil#cal(calutil#jul(basedate)+amt)
        elseif cue =~ s:org_weekdaystring
            " wed, 3tue, 5fri, i.e., dow string
            let mycount = matchstr(cue,'^\d\+')
            let myday = matchstr(cue,s:org_weekdaystring) 
            let newday = index(s:org_weekdays,myday)
            let oldday = calutil#dow(matchstr(basedate,'\d\d\d\d-\d\d-\d\d'))
            if newday > oldday
                let amt=newday-oldday
            elseif newday < oldday
                let amt =7-oldday+newday
            else
                let amt = 7
            endif
            let amt = amt + (mycount*7)
            let newdate=calutil#cal(calutil#jul(basedate)+amt)
        elseif cue =~ '\c\([-+]\|[-+][-+]\)\d\+[ dwmy]'
            " plus minus count of dwmy
            let mlist =  matchlist(cue,'\c\([-+]\|[-+][-+]\)\(\d\+\)\([ wdmy]\)')
            let op = mlist[1]
            let mycount = mlist[2]
            let type = mlist[3]
            if len(op) == 1
                let mydate = strftime('%Y-%m-%d')
            else
                let mydate = basedate
            endif
            let op = op[0]
            let year = mydate[0:3]
            let month = mydate[5:6]
            let day = mydate[8:9]
            if type == 'y'
                let type = 'm'
                let mycount = mycount * 12
            elseif type == 'w'
                let type='d'
                let mycount = mycount * 7
            endif
            if type == 'm'
                if (op == '+')
                    let yplus = mycount / 12
                    let mplus = mycount % 12
                    let year +=   yplus
                    let month += mplus
                    if month > 12
                        let month = month - 12
                        let year = year + 1
                    endif
                elseif ((mycount % 12) >= month) && (op == '-')
                    let yminus = mycount/12
                    let year = year - yminus - 1
                    let month = (month + 12 - (mycount % 12))   
                else " '-' with month greater
                    let month = month - (mycount % 12)
                    let year = year - (mycount / 12)
                endif
                " correct for bad dates
                while calutil#cal(calutil#jul(year.'-'.s:Pre0(month).'-'.s:Pre0(day)))[5:6] != month
                    let day = day - 1
                endwhile
            elseif (type == 'd') || (type==' ')
                let newjul = calutil#jul(mydate)
                if op == '+'
                    let newjul = newjul + mycount
                else
                    let newjul = newjul - mycount
                endif
                "execute 'let newjul = newjul ' . op . mycount
                let mydate = calutil#cal(newjul)
                let year = mydate[0:3]
                let month = mydate[5:6]
                let day = mydate[8:9]
            endif

            let newdate = year . '-' . s:Pre0(month) . '-' . s:Pre0(day)
        else
            return " ?? can't interpret your spec"
        endif
        if timecue =~ '\d\d:\d\d'
            let mytime = ' '.timecue
        else
            let mytime = a:basetime > '' ? ' ' . a:basetime : ''
        endif
        let mydow = calutil#dayname(newdate)
        return newdate . ' ' . mydow . mytime
endfunction

function! s:TimeInc(direction)
    let save_cursor = getpos(".")
    let i = 0
    let col = save_cursor[2] - 1
    let line = getline(line("."))
    if line[col] =~ '\d'
        let i = 1
        while i < 6
            let start = col - i
            let end = col - i + 6
            silent execute 'let timetest = line[' . start . ':' . end .']'
            if timetest =~ ' \d\d:\d\d[>\]]'
                break
            endif          
            let i += 1
        endwhile
    else
        let i = 6
    endif
    if i == 6
        execute "normal! \<s-up>"
        return
    else
        let start = col - i + 1
        let end = col - i + 5
        execute 'let time = line[' . start . ':' . end .']'
        if i > 3
            let newminutes = (time[3:4] + (a:direction *5)) 
            let newminutes = newminutes - (newminutes % 5)
            if (newminutes >= 60) 
                let newminutes = 0
                let newhours = time[0:1] + 1
            elseif (newminutes == -5) && (a:direction == -1)
                let newminutes = 55
                let newhours = time[0:1] - 1
            else
                let newhours = time[0:1]
            endif
        else
            let newhours = time[0:1] + (1 * a:direction)
            let newminutes = time[3:4]
        endif
        if newhours >= 24
            let newhours = 0
            "let tempsave = getpos(".")
        elseif newhours < 0
            let newhours = 23
            "execute "normal ".start-6."|"
            "call OrgDateInc(a:direction)
            "call setpos(".",tempsave)         
        endif
        let matchcol = col-i+2
        execute 's/\%'.matchcol.'c\zs\d\d:\d\d/' . s:Pre0(newhours) . ':' . s:Pre0(newminutes).'/'
    endif
    call setpos(".",save_cursor)
endfunction
function! OrgDateInc(direction)
    "       <dddd-dd-dd
    "       01234567890
    "       09876543210
    let save_cursor = getpos(".")
    let i = 0
    let col = save_cursor[2] - 1
    let line = getline(line("."))
    if line[col] =~ '\d'
        let i = 1
        while i < 21
            let start = col - i
            let end = col - i + 11
            silent execute 'let datetest = line[' . start . ':' . end .']'
            if datetest =~ '[<[]\d\d\d\d-\d\d-\d\d'
                break
            endif          
            let i += 1
        endwhile
    else
        let i = 21
    endif
    if i == 21
        execute "normal! \<s-up>"
        return
    else
        if i > 12
            call setpos(".",save_cursor)
            call s:TimeInc(a:direction)
            return
        endif
        let start = col - i + 1
        let end = col - i + 11
        execute 'let date = line[' . start . ':' . end .']'
        if i > 7
            let newdate = calutil#cal(calutil#jul(date) + a:direction)
            let newyear = newdate[0:3]
            let newmonth = newdate[5:6]
            let newday = newdate[8:9]
        elseif i < 5
            let spot = 'year'
            let newyear = date[0:3] + a:direction
            let newmonth = date[5:6]
            let newday = date[8:9]
            "execute 's/\d\d\d\d/' . newyear . '/'
        else
            let spot = 'month'
            let newmonth = date[5:6] + a:direction  
            let newday = date[8:9]
            if newmonth > 12
                let newyear = date[0:3] + 1
                let newmonth = '01'
                let newday = '01'
            elseif newmonth < 1
                let newyear = date[0:3] - 1
                let newmonth = '12'
                let newday = '31'
            else
                let newyear = date[0:3]
                let newday = date[8:9]
            endif
        endif
        " correct for bad dates
        while calutil#cal(calutil#jul(newyear.'-'.newmonth.'-'.newday))[5:6] != newmonth
            let newday = newday - 1
        endwhile
        let matchcol = col-i+2
        execute 's/\%'.matchcol.'c\zs\d\d\d\d-\d\d-\d\d/' . newyear . '-' . s:Pre0(newmonth) . '-' . s:Pre0(newday).'/'
        " update dow if there is one
        let end +=5
        silent execute 'let datetest = line[' . start . ':' . end .']'
        if datetest =~ '\d\d\d\d-\d\d-\d\d \S\S\S'
            let dow = calutil#DayOfWeek(newyear,newmonth,newday,2)
            silent execute 's/\%'.matchcol.'c\(\d\d\d\d-\d\d-\d\d \)\S\S\S/\1' . dow.'/'
        endif          
    endif
    call setpos(".",save_cursor)
endfunction

function! s:GetClock()
    return '['.strftime("%Y-%m-%d %a %H:%M").']'
endfunction 
function! OrgClockIn(...)
    let save_cursor=getpos(".")
    let filestr = ''
    let lineno=line('.')
    if bufname("%")==('__Agenda__')
        let lineno = matchstr(getline(line('.')),'^\d\+')
        let file = matchstr(getline(line('.')),'^\d\+\s*\zs\S\+').'.org'
        let str = ','.lineno.',"'.file.'"'
        let filestr = ',"'.file.'"'
        call s:SetProp('CLOCKIN','',lineno,file)
    else
   
        if a:0 > 1
            execute a:1
        endif
        execute s:OrgGetHead()
        if s:IsTagLine(line(".")+1)
            execute line('.')+1
        endif
        "exe 'normal o:CLOCK: ' . s:GetClock()
        call append(line('.'),'  :CLOCK: '.s:GetClock())
        let dict={'file':expand("%"),'line':line('.'),'Timestamp':org#Timestamp()}
        call add(g:org_clock_history,dict)
    endif


    call setpos(".",save_cursor)
endfunction
function! s:GetOpenClock()
    let found_line = 0
    let file = ''
    if !exists('g:agenda_files') || (g:agenda_files==[])
        call confirm("No agenda files defined, will search only this buffer for open clocks.")
        let found = search('CLOCK: \[\d\d\d\d-\d\d-\d\d \S\S\S \d\d:\d\d\]\($\|\s\)','w')
    else
        for file in g:agenda_files
            call s:LocateFile(file)
            let found_line = search('CLOCK: \[\d\d\d\d-\d\d-\d\d \S\S\S \d\d:\d\d\]\($\|\s\)','w')
            let file = expand("%")
            if found_line > 0
                break
            endif
        endfor
    endif
    return [file,found_line]
endfunction
function! OrgClockOut(...)
    let cur_file=expand("%")
    let save_cursor= getpos('.')
    if a:0 > 1
        execute a:1
    else
        let oc = s:GetOpenClock()
        if oc[0] > '' 
           call s:LocateFile(oc[0])
           execute oc[1]
        endif
    endif
    execute s:OrgGetHead()
    let bottom = s:OrgNextHead() > 0 ? s:OrgNextHead() - 1 : line("$")
    let str = 'CLOCK: \[\d\d\d\d-\d\d-\d\d \S\S\S \d\d:\d\d\]\($\|\s\)'
    let found = s:Range_Search(str,'n',bottom,line("."))
    if found
        execute found
        execute 'normal A--' . s:GetClock() 
        if b:v.clock_to_logbook 
            let headline = s:OrgGetHead()
            let clockline = getline(line(".")) . ' -> ' . s:ClockTime(line("."))
            normal! dd
            call OrgConfirmDrawer("LOGBOOK",headline)
            let clockline = matchstr(getline(line(".")),'^\s*') . matchstr(clockline,'\S.*')
            call append(line("."),clockline )
        endif
        let msg = "Open clock found and clocked out in \n"
        let msg .= "file: ".expand("%")."\n"
        let msg .= "in headline at line number: ".headline
        call confirm(msg)
    else
        echo 'No open clock found. . . .'
    endif
    call s:LocateFile(cur_file)
    call setpos(".",save_cursor)
endfunction
function! s:UpdateAllClocks()
    %g/^\s*:CLOCK:/call s:AddClockTime(line("."))
endfunction
function! s:AddClockTime(line)
    call setline(a:line,matchstr(getline(a:line),'.*\]') . ' -> ' . s:ClockTime(a:line))
endfunction

function! s:UpdateClockSums()
    let save_cursor = getpos(".")
    g/^\s*:ItemClockTime/d
    call s:UpdateAllClocks()
    g/^\s*:CLOCK:/call s:SetProp('ItemClockTime', s:SumClockLines(line(".")))
    call setpos(".",save_cursor)
endfunction

function! s:SumClockLines(line)
    let save_cursor = getpos(".")
    execute s:OrgGetHead_l(a:line) + 1
    "execute a:line + 1
    let hours = 0
    let minutes = 0
    while 1
        let text = getline(line("."))
        if text !~ s:remstring
            break
        endif
        let time = matchstr(text,'CLOCK.*->\s*\zs\d\+:\d\+')
        if time > ''
            let hours   += str2nr(split(time,':')[0])
            let minutes += str2nr(split(time,':')[1])
        endif

        if line('.') == line('$')
            break
        else
            execute line('.') + 1
        endif
        
    endwhile
    let totalminutes = (60 * hours) + minutes
    call setpos(".",save_cursor)
    return (totalminutes/60) . ':' . s:Pre0(totalminutes % 60)

endfunction
function! s:UpdateBlock()
   ?^#+BEGIN:
    let block_type = matchstr(getline(line('.')),'\S\+\s\+\zs\S\+')
   if matchstr(getline(line('.')+1),'^#+END') == ''
        normal jV/^#+END/-1dk
    endif
    if block_type == 'clocktable'
        let block_type='ClockTable'
    endif
    let mycommand = block_type.'()'
    execute "call append(line('.'),".mycommand.")"
endfunction
function! ClockTable()
    let save_cursor = getpos(".")

    call s:UpdateClockSums()
    call s:UpdateHeadlineSums()
    call OrgMakeDict()
    let g:ctable_dict = {}
    let mycommand = "let g:ctable_dict[line('.')] = "
                \ . "{'text':s:GetProperties(line('.'),0)['ITEM']"
                \ . " , 'time':s:GetProperties(line('.'),0)['TotalClockTime']}"
    g/:TotalClockTime/execute mycommand
    let total='00:00'
    for item in keys(g:ctable_dict)
        "let test = g:ctable_dict[item].text
        if g:ctable_dict[item].text[0:1]=='* '
        "if test[0:1]=='* '
            let total = s:AddTime(total,g:ctable_dict[item].time)
        endif
    endfor
    let result = ['Clock summary at ['.org#Timestamp().']','',
                \ '|Lev| Heading                      |  ClockTime',
                \ '|---+------------------------------+-------+--------' ,
                \ '|   |                      *TOTAL* | '.total ]
    for item in sort(keys(g:ctable_dict),'s:NumCompare')
        let level = len(matchstr(g:ctable_dict[item].text,'^\*\+')) 
        let treesym = repeat('   ',level-2) . (level > 1 ? '\_ ' : '')
        let str = '| '.level.' | ' 
                    \ . org#Pad(treesym . matchstr(g:ctable_dict[item].text,'^\*\+ \zs.*')[:20],28) . ' | '
                    \ . repeat('      | ',level-1)
                    \ . s:PrePad(g:ctable_dict[item].time,5) . ' |'
        if g:ctable_dict[item].text[0:1]=='* '
            call add(result, '|---+------------------------------+-------+-------+' )
        endif
        call add(result, str)
    endfor
    call setpos(".",save_cursor)
    return result

endfunction

function! s:NumCompare(i1,i2)
    let i1 = str2nr(a:i1)
    let i2 = str2nr(a:i2)
    return i1 == i2 ? 0 : i1>i2 ? 1 : -1
endfunction

function! s:ClockTime(line)
    let ctext = getline(a:line)
    let start = matchstr(ctext,'CLOCK:\s*\[\zs\S\+\s\S\+\s\S\+\ze\]')
    let end = matchstr(ctext,'--\[\zs.*\ze\]')
    let daydifference = calutil#jul(end[0:9])-calutil#jul(start[0:9])
    let startmin = 60*start[15:16] + start[18:19]
    let endmin = 60*end[15:16] + end[18:19]
    let totalmin = (daydifference * 1440) + (endmin - startmin)
    return string(totalmin/60) . ':' . s:Pre0(totalmin % 60)
endfunction
function! s:AddTime(time1, time2)
    let time1 = a:time1
    let time2 = a:time2
    if match(time1,':') == -1 | let time1 = '00:00' | endif
    if match(time2,':') == -1 | let time2 = '00:00' | endif
    let hours = str2nr(matchstr(time1,'^.*\ze:')) + str2nr(matchstr(time2,'^.*\ze:'))
    let minutes = (60*hours) + time1[-2:] + time2[-2:]
    return (minutes/60) . ':' . s:Pre0(minutes % 60)
endfunction
function! s:GetProp(key,...)
    let save_cursor = getpos(".")
    if a:0 >=2
        let curtab = tabpagenr()
        let curwin = winnr()
    " optional args are: a:1 - lineno, a:2 - file
        call s:LocateFile(a:2)
    endif
    if (a:0 >= 1) && (a:1 > 0)
        execute a:1 
    endif
    execute s:OrgGetHead() + 1
    let myval = ''
    while 1
        let text = getline(line("."))
        if text !~ s:remstring
            break
        endif
        let mymatch = matchstr(text,':\s*'.a:key.'\s*:')
        if mymatch > ''
            let myval = matchstr(text,':\s*'.a:key.'\s*:\s*\zs.*$')
            break
        endif
        execute line(".") + 1
    endwhile
    if a:0 >= 2
        execute "tabnext ".curtab
        execute curwin . "wincmd w"
    endif
    call setpos(".",save_cursor)
    return myval

endfunction
function! s:SetDateProp(type,newdate,...)
    " almost identical to s:GetProp() above, need to refactor
    let save_cursor = getpos(".")
    if a:0 == 1
        execute a:1 + 1
    else
        execute line(".") + 1
    endif
    let myval = ''
    while 1
        let text = getline(line("."))
        if text !~ s:remstring
            break
        endif
        let mymatch = matchstr(text,'\s*'.a:type.'\s*:')
        if mymatch > ''
            execute 's/'.a:type.'.*$/'.a:type.':<'.a:newdate.'>/'
            break
        endif
        execute line(".") + 1
    endwhile
    call setpos(".",save_cursor)
    return myval
endfunction
function! s:SetProp(key, val,...)
    let save_cursor = getpos(".")
    " optional args are: a:1 - lineno, a:2 - file
    if a:0 >=2
        let curtab = tabpagenr()
        let curwin = winnr()
        call s:LocateFile(a:2)
    endif
    if (a:0 >= 1) && (a:1 > 0)
        execute a:1 
    endif
    let key = a:key
    let val = a:val
    execute s:OrgGetHead() 
    " block_end was end of properties block, but getting that 
    " from GetProperties(line('.'),0) creates problems with 
    " line numbers having changed from previous run of OrgMakeDict
    " So, just use next head as end of block for now.
    let block_end = s:OrgNextHead()
    let block_end = (block_end == 0) ? line('$') : block_end
    if key =~ 'DEADLINE\|SCHEDULED\|CLOSED\|TIMESTAMP'
        " it's one of the five date props
        " find existing date line if there is one
        if key=='TIMESTAMP' 
            let key = ''
            let foundline = s:Range_Search('^\s*:\s*<\d\d\d\d-\d\d-\d\d','n',block_end,line("."))
        elseif key=='TIMESTAMP_IA' 
            let key = ''
            let foundline = s:Range_Search('^\s*:\s*[\d\d\d\d-\d\d-\d\d','n',block_end,line("."))
        else
            let foundline = s:Range_Search('^\s*\(:\)\{}'.key.'\s*:','n',block_end,line("."))
        endif
        if foundline > 0
            exec foundline
            exec 's/:\s*<\d\d\d\d.*$/'.':'.a:val
        else
            let line_ind = len(matchstr(getline(line(".")),'^\**'))+1 + g:org_indent_from_head
            if s:IsTagLine(line('.')+1)
                execute line('.') + 1
            endif
            call append(line("."),org#Pad(' ',line_ind)
                        \ .':'.key.(key==''?'':':').a:val)
        endif
    elseif key == 'tags'
        if s:IsTagLine(line('.') + 1)
            call setline(line('.') + 1, a:val)
        else
            call append(line('.'), a:val)
        endif
    elseif key == 'CLOCKIN'
        call OrgClockIn()
    elseif key == 'CLOCKOUT'
        call OrgClockOut(a:val)
    else
        " it's a regular key/val pair in properties drawer
        call OrgConfirmDrawer("PROPERTIES")
        while (getline(line(".")) !~ '^\s*:\s*' . key) && 
                    \ (getline(line(".")) =~ s:remstring) &&
                    \ (line('.') != line('$'))
            execute line(".") + 1
        endwhile

        if (getline(line(".")) =~ s:remstring) && (getline(line('.')) !~ '^\s*:END:')
            call setline(line("."), matchstr(getline(line(".")),'^\s*:') .
                        \ key . ': ' . val)
        else
            execute line(".") - 1
            call OrgConfirmDrawer("PROPERTIES")
            let curindent = matchstr(getline(line(".")),'^\s*')
            let newline = curindent . ':' . key . ': ' . val
            call append(line("."),newline)
        endif
    endif

    "if exists("*Org_property_changed_functions") && (bufnr("%") != bufnr('Agenda'))
    "    let Hook = function("Org_property_changed_functions")
    "    silent execute "call Hook(line('.'),a:key, a:val)"
    "endif
    if a:0 >=2
        "back to tab/window where setprop call was made
        execute "tabnext ".curtab
        execute curwin . "wincmd w"
    endif
    call setpos(".",save_cursor)
endfunction

function! s:LocateFile(filename)
    if !exists("g:agenda_files") || (g:agenda_files==[])
        call confirm('You have no agenda files defined right now.\n'
                    \ . 'Will assign current file to agenda files.')
        call s:CurfileAgenda()
    endif
    let myvar = ''
    " set filename
    let filename = a:filename
    " but change to be full name if appropriate
    for item in g:agenda_files
        " match fullpathname or just filename w/o path
        if (item == a:filename) || (item =~ matchstr(a:filename,'.*[/\\]\zs.*'))
            let filename = item
            break
        endif
    endfor
    if bufwinnr(filename) >= 0
        silent execute bufwinnr(filename)."wincmd w"
    else
        execute 'tab drop ' . filename
    endif
    "endif
    " below is alternate method:
    " ==========================
    " remember current value of switchbuf
    "  let l:old_switchbuf = &switchbuf
    "  try
    "    " change switchbuf so other windows and tabs are used
    "    set switchbuf=useopen,usetab
    "    execute 'sbuf' a:filename
    "  finally
    "    " restore old value of switchbuf
    "    let &switchbuf = l:old_switchbuf
    "  endtry
endfunction

function! OrgConfirmDrawer(type,...)
    let line = s:OrgGetHead()
    if a:0 == 1
        let line = a:1
    endif
    execute line
    let bottom = s:OrgNextHead() > 0 ? s:OrgNextHead() - 1 : line("$")
    let found = s:Range_Search(':\s*'. a:type . '\s*:','n',bottom,line)
    if !found
        while getline(line(".") + 1) =~ s:remstring
            execute line('.')+1
        endwhile
        "if line == line(".")-1
        "    "back to headline in this case
        "    execute line
        "endif
        execute 'normal o:'. a:type . ':'
        execute 'normal o:END:'
        normal k
    else
        execute found
    endif
endfunction

function! OrgMouseDate()
    let @x=''
    let date=''
    let save_cursor = getpos(".")
    let found = ''
    let date = GetDateAtCursor()
    if date > ''
        let found='date'
        let date = date[0:9]
    else
        call setpos(".",save_cursor)
        " get area between colons, if any, in @x
        normal T:vt:"xy
        if (matchstr(@x,'\S\+') > '') && (len(@x)<25)
            let found = 'tag'
        endif
    endif
    call setpos(".",save_cursor)
    if found == 'date'
        call OrgRunAgenda(date,1,'',date)
        execute 8
    elseif found == 'tag'
        call OrgRunSearch('+'.@x)
    else
        echo 'Nothing found to search for.'
    endif

endfunction
function! s:SetColumnHead()

    let result = ''
    let i = 0
    while i < len(g:org_colview_list)
        let result .= '|' . s:PrePad(g:org_colview_list[i] , g:org_colview_list[i+1]) . ' ' 
        let i += 2
    endwhile
    let g:org_ColumnHead = result[:-2]
endfunction

function! s:GetColumns(line)
    let props = s:GetProperties(a:line,0)
    let result = ''
    let i = 0
    while i < len(g:org_colview_list)
        let result .= '|' . s:PrePad(get(props,g:org_colview_list[i],'') , g:org_colview_list[i+1]) . ' ' 
        let i += 2
    endwhile
    if get(props,'Columns') > ''
        let g:org_colview_list=split(props['Columns'],',')
    endif
    return result[:-2]

endfunction
function! s:ToggleColumnView()

    "au! BufEnter ColHeadBuffer call s:ColHeadBufferEnter()
    if b:v.columnview
        let winnum = bufwinnr('ColHeadBuffer')
        if winnum > 0 
            execute "bd" . bufnr('ColHeadBuffer')
            "wincmd c
        endif
        let b:v.columnview = 0
    else
        call s:ColHeadWindow()
        let b:v.columnview = 1
    endif   
endfunction
function! <SID>ColumnStatusLine()
    let part2 = s:PrePad(g:org_ColumnHead, winwidth(0)-12) 
    return '      ITEM ' .  part2
endfunction
function! s:AdjustItemLen()
    "if exists('b:v.columnview') && b:v.columnview 
    let g:org_item_len = winwidth(0) - 10 - len(g:org_ColumnHead)
    "endif
endfunction
au VimResized * call s:AdjustItemLen()

function! <SID>CalendarChoice(day, month, year, week, dir)
    let g:agenda_startdate = a:year.'-' . s:Pre0(a:month).'-'.s:Pre0(a:day) 
    call OrgRunAgenda(g:agenda_startdate, g:org_agenda_days,g:org_search_spec)
endfunction
function! <SID>CalendarInsertDate(day, month, year, week, dir)
    if (a:year > 0) && (a:month>0) && (a:day>0)
        let g:cal_list=[a:year,a:month,a:day] 
    endif
    
    "call confirm('got here')
endfunction
function! s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun
function! OrgSID(func)
    execute 'call <SNR>'.s:SID().'_'.a:func
endfunction
function! OrgFunc(func,...)
    "not working, itnended to be general way to 
    " call script-local functions
    let myfunc = function('<SNR>'.s:SID().'_'.a:func)
    if a:000 > 0
        let myargs = split(a:000,',')
    else
        let myargs = ''
    endif
endfunction
    
function! s:MyPopup()
    call feedkeys("i\<c-x>\<c-u>")
endfunction

let g:calendar_action = '<SNR>' . s:SID() .'_CalendarChoice'
let b:v.ColorList=['purple', 'green', 'white', 'black','blue','red','orange','green']
function! s:CompleteOrg(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\a'
            let start -= 1
        endwhile
        return start
    else
        let prop = matchstr(getline(line(".")),'^\s*:\zs\s*\S\+\s*\ze:')
        " find months matching with "a:base"
        let res = []
        execute "let proplist = b:v." . prop . 'List' 
        "for m in split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec")
        for m in proplist
            if m =~ '^' . a:base
                call add(res, m)
            endif
        endfor
        return res
    endif
endfunction
set completefunc=CompleteOrg


function! OrgFoldText(...)
    " Create string used for folded text blocks
    if a:0 == 1
        let l:line = getline(line("."))
        let foldstart = line(".")
    else
        let l:line = getline(v:foldstart)
        let foldstart = v:foldstart
    endif
    let origline = l:line
    let l:nextline = getline(foldstart + 1)
    let myind = s:Ind(foldstart)

    let v:foldhighlight = hlID(b:v.foldcolors[myind])

    "if s:Ind(v:foldstart) == v:foldlevel - 3
    "   let l:txtmrk = 'd-'
    "elseif s:Ind(v:foldstart) == v:foldlevel - 2
    "   let l:txtmrk = 't-'
    "   if getline(v:foldstart + 1)  =~ '^\s*:'
    "       let l:txtmrk = 'd' . l:txtmrk
    "   endif
    "else
    let l:txtmrk = ''
    "endif  
    " get rid of header prefix
    let l:line = substitute(l:line,'^\*\+\s*','','g')
    let l:line = repeat(' ', s:Starcount(foldstart)+1) . l:line 
    let line_count = v:foldend - v:foldstart

    if l:line =~ b:v.drawerMatch
        let v:foldhighlight = hlID('Title')
        let l:line = repeat(' ', len(matchstr(l:line,'^ *'))-1)
                    \ . matchstr(l:line,'\S.*$') 
        let line_count = line_count - 1
    elseif l:line[0] == '#'
        let v:foldhighlight = hlID('VisualNOS')
    else
        let l = g:org_item_len
        let line = line[:l]
    endif
    if exists('w:sparse_on') && w:sparse_on && (a:0 == 0) 
        let b:v.signstring= s:GetPlacedSignsString(bufnr("%")) 
        if match(b:v.signstring,'line='.v:foldstart.'\s\sid=\d\+\s\sname=fbegin') >=0
        "if index(b:v.sparse_list,v:foldstart) > -1            "v:foldstart == 10
            let l:line = '* * * * * * * * * * * ' . (v:foldend - v:foldstart) . ' lines skipped here * * * * * * *'
            let l:line .= repeat(' ', winwidth(0)-len(l:line)-28) . 'SPARSETREE SKIP >>'
            let v:foldhighlight = hlID('TabLineFill')
        endif
    endif
    if g:org_show_fold_dots 
        let l:line .= '...'
    endif
    let offset = &fdc + 5*(&number) + 4
    if b:v.columnview && (origline =~ b:v.headMatch) 
        let l:line .= s:PrePad(s:GetColumns(foldstart), winwidth(0)-len(l:line) - offset)
    elseif a:0 && (foldclosed(line('.')) > 0)
        let l:line .= s:PrePad("(" 
            \  . s:PrePad(l:txtmrk . (foldclosedend(line('.'))-foldclosed(line('.'))) . ")",5),
            \ winwidth(0)-len(l:line) - offset) 
    elseif g:org_show_fold_lines && !b:v.columnview 
        "let l:line .= s:PrePad("(" . s:PrePad(l:txtmrk . (v:foldend - v:foldstart) . ")",5),
        let l:line .= s:PrePad("(" . s:PrePad(l:txtmrk . (line_count) . ")",5),
                    \ winwidth(0)-len(l:line) - offset) 
    endif

    return l:line
endfunction

function! s:MySort(comppattern) range
    let b:v.sortcompare = a:comppattern
    let b:v.complist = ['\s*\S\+','\s*\S\+\s\+\zs\S\+','\s*\(\S\+\s\+\)\{2}\zs\S\+'
                \ , '\s*\(\S\+\s\+\)\{3}\zs\S\+'
                \ , '\s*\(\S\+\s\+\)\{4}\zs\S\+'
                \ , '\s*\(\S\+\s\+\)\{5}\zs\S\+'
                \ , '\s*\(\S\+\s\+\)\{6}\zs\S\+']
    let mylines = getline(a:firstline, a:lastline)
    let mylines = sort(mylines,"s:BCompare")
    call setline(a:firstline, mylines)
    unlet b:v.sortcompare
    unlet b:v.complist
endfunction

function! s:BCompare(i1,i2)
    if !exists('b:v.sortcompare')
        echo 'b:v.sortcompare is not defined'
        return
    endif
    let i = 0

    while i < len(b:v.sortcompare)
        " prefix an item by 'n' if you want numeric sorting
        if (i < len(b:v.sortcompare) - 1) && (b:v.sortcompare[i] == 'n')
            let i = i + 1
            let m1 = str2nr(matchstr(a:i1,b:v.complist[b:v.sortcompare[i]-1])) 
            let m2 = str2nr(matchstr(a:i2,b:v.complist[b:v.sortcompare[i]-1]))
        else
            let m1 = matchstr(a:i1,b:v.complist[b:v.sortcompare[i]-1]) 
            let m2 = matchstr(a:i2,b:v.complist[b:v.sortcompare[i]-1])
        endif
        if m1 == m2
            if i == len(b:v.sortcompare) - 1
                return 0
            else
                let i += 1
                continue
            endif
        elseif m1 > m2 
            return 1
        else 
            return -1
        endif
    endwhile
endfunction

function! s:OrgShowMatch(cycleflag)
    "wincmd k
    " first, make sure agenda buffer has same heading pattern
    " and todo list as main buffer
    call s:GotoMainWindow()
    let l:headMatch = b:v.headMatch
    let l:todoitems = b:v.todoitems
    "wincmd j
    call s:GotoAgendaWindow()
    let b:v.headMatch = l:headMatch
    let b:v.todoitems = l:todoitems
    if a:cycleflag
        call OrgSequenceTodo(line("."))
    endif
    "let g:showndx = line(".")-1
    if getline(line(".")) =~ '^\d\+'
        let g:showndx = matchlist(getline(line(".")),'^\d\+')[0]
        execute "let b:v.sparse_list = [" . g:showndx . ']'
    endif
    "wincmd k
    call s:GotoMainWindow()
    call OrgExpandWithoutText(1)
    execute g:showndx
    "execute g:alines[g:showndx]
    normal zv
    if a:cycleflag
        call OrgSequenceTodo(line("."))
    endif
    if getline(line(".")) =~ b:v.headMatch
        call OrgBodyTextOperation(line("."),s:OrgNextHead(),'collapse')
    endif
    "wincmd j
    call s:GotoAgendaWindow()
endfunction
command! MySynch call <SID>OrgShowMatch(0)
command! MySynchCycle call <SID>OrgShowMatch(1)
command! MyAgendaToBuf call <SID>OrgAgendaToBufTest()
command! AgendaMoveToBuf call s:OrgAgendaToBuf()

function! s:OrgAgendaToBufTest()
    " this loads unfolded buffer into same window as Agenda
    if getline(line(".")) =~ '^\d\+'
        let thisline = getline(line('.'))
        let g:tofile = s:filedict[str2nr(matchstr(thisline, '^\d\d\d'))]
        let g:showndx = str2nr(matchstr(thisline,'^\d\d\d\zs\d*'))
        "let g:showndx = matchlist(getline(line(".")),'^\d\+')[0]
        "let g:tofile = matchlist(getline(line(".")),'^\d\+\s*\(\S\+\)')[1]
    endif
    let cur_buf = bufnr("%")
    let g:org_folds=0
    let newbuf = bufnr(g:tofile)
    execute "b"newbuf
    execute g:showndx
    let g:org_folds=1
endfunction
function! s:OrgAgendaToBuf()
    let win = bufwinnr('Calendar')
    if win >= 0 
        execute win . 'wincmd w'
        wincmd c
        execute bufwinnr('Agenda').'wincmd w'
    endif   

    if getline(line(".")) =~ '^\d\+'
        let thisline = getline(line('.'))
        let g:tofile = s:filedict[str2nr(matchstr(thisline, '^\d\d\d'))]
        let g:showndx = str2nr(matchstr(thisline,'^\d\d\d\zs\d*'))
    endif
    let ag_line = line(".")
    let ag_height = winheight(0)
    let cur_buf = bufnr("%")  " should be Agenda
    close!
    call s:LocateFile(g:tofile )
    "call s:LocateFile(g:tofile . '.org')
    if &fdm != 'expr'
        set fdm=expr
    endif
    " vsplit agenda *********************
    "vsplit
    " *********************
    split
    "wincmd J
    execute "b"cur_buf
    "call s:LocateFile(g:tofile . '.org')
    wincmd x
    "let new_buf=bufnr("%")
    execute g:showndx
    "setlocal cursorline
    set foldlevel=1
    normal! zv
    normal! z.
    "wincmd j
    execute bufnr('Agenda').'wincmd w'
    "wincmd c
    "split
    "wincmd j
    "execute "b" . bufnr('Agenda')
    execute ag_line
    resize
    execute "resize " . ag_height 
    "set foldlevel=9999
    "execute g:showndx
    "normal! z.
    if win >= 0
        Calendar
        execute 1
        wincmd l
        wincmd j
    endif
endfunction

function! s:OrgSource()
    unlet g:org_loaded
    source $VIM/vimfiles/ftplugin/org.vim
endfunction

function! s:OrgSetLevel(startlevel, endlevel)
    "call OrgExpandWithoutText(a:endlevel)
    call s:OrgExpandLevelText(a:startlevel, a:endlevel)
endfunction

function! s:Starcount(line)
    " used to get number of stars for a heading
    return (len(matchstr(getline(a:line),'^\**\s'))-1)
endfunction

function! s:GotoAgendaWindow()
    "wincmd b
    silent execute "b __Agenda__"
endfunction

function! s:GotoMainWindow()
    wincmd t
endfunction

function! s:Ind(line) 
    " used to get level of a heading (todo : rename this function)
    "return 1 + (len(matchstr(getline(a:line),'^\**\s'))-1)/b:v.levelstars  
    return 2 + (len(matchstr(getline(a:line),'^\**\s'))-2)/b:v.levelstars  

endfunction

function! s:DoAllTextFold(line)
    "let d = inputdialog('in fullfold')
    if s:IsText(a:line+1) == 0
        return 
    endif
    while ((s:NextVisibleHead(a:line) != foldclosedend(a:line) + 1) 
                \ && (foldclosedend(a:line) <= line("$"))
                \ && (s:NextVisibleHead(a:line) != 0)
                \ && (OrgFoldLevel(a:line) =~ '>')) 
                \ || (foldclosedend(a:line) < 0)  
                \ || ((s:NextVisibleHead(a:line)==0) && (s:OrgSubtreeLastLine() == line('$')) && (foldclosedend(a:line)!=line('$')))
        call OrgDoSingleFold(a:line)
    endwhile
endfunction

function! OrgDoSingleFold(line)
    if (foldclosed(a:line) == -1) "&& (getline(a:line+1) !~ b:v.headMatch)
        if (getline(a:line+1) !~ b:v.headMatch) || (s:Ind(a:line+1) > s:Ind(a:line))
            while foldclosed(a:line) == -1
                normal! zc
            endwhile
        endif
        "elseif (foldclosed(a:line) < a:line)
        " do nothing, line is not visible
    else
        let cur_end = foldclosedend(a:line)
        " I know runaway can happen if at last heading in document,
        " not sure where else
        let runaway_count = 0
        if (cur_end >= line("$")) || (OrgFoldLevel(cur_end+1) == '<0')
            return
        endif
        if getline(cur_end+1) =~ b:v.drawerMatch
            "while (foldclosedend(a:line) == cur_end) && (runaway_count < 10)
            while (foldclosedend(a:line) == cur_end) && (cur_end != line("$"))
                let runaway_count += 1
                normal! zc
            endwhile
        elseif getline(cur_end+1) !~ b:v.headMatch
            "while (foldclosedend(a:line) == cur_end) && (runaway_count < 10)
            while (foldclosedend(a:line) == cur_end) && (cur_end <= line("$"))
                let runaway_count += 1
                normal! zc
            endwhile
        elseif (getline(cur_end+1) =~ b:v.headMatch) && (s:Ind(cur_end+1) > s:Ind(a:line))
            while (foldclosedend(a:line) == cur_end) && (cur_end != line("$"))
                "   let runaway_count += 1
                normal! zc
            endwhile
        endif
    endif
endfunction


function! OrgFoldLevel(line)
    " called as foldexpr to determine the fold level of a line.
    if g:org_folds == 0
        return 0
    endif
    let l:text = getline(a:line)
    "if l:text =~ b:v.headMatch
    if l:text[0] == '*'
        let b:v.myAbsLevel = s:Ind(a:line)
    endif
    let l:nextAbsLevel = s:Ind(a:line+1)
    let l:nexttext = getline(a:line + 1)

    " STUFF FOR SPARSE TREE LEVELS
    if exists('w:sparse_on') && w:sparse_on  
        if g:org_first_sparse==0    
            let b:v.signstring= s:GetPlacedSignsString(bufnr("%")) 
            if match(b:v.signstring,'line='.(a:line+1).'\s\sid=\d\+\s\sname=fbegin') >=0
                return '<0'
            endif
            if match(b:v.signstring,'line='.a:line.'\s\sid=\d\+\s\sname=fbegin') >=0
                return '>99'
            elseif match(b:v.signstring,'line='.a:line.'\s\sid=\d\+\s\sname=fend') >=0
                return '<0'
            endif
        else
            if index(b:v.sparse_list,a:line+1) >= 0
                return '<0'
            endif
            let sparse = index(b:v.sparse_list,a:line)
            if sparse >= 0
                return '>20'
            endif
            let sparse = index(b:v.fold_list,a:line)
            if sparse >= 0
                return '<0' 
            endif
        endif
    endif

    "if l:text =~ b:v.headMatch
    if l:text[0] == '*'
        " we're on a heading line

        " propmatch line is new (sep 27) need ot test having different
        " value for propmatch and deadline lines
        if l:nexttext =~ b:v.drawerMatch
            let b:v.lev = '>' . string(b:v.myAbsLevel + 4)
        elseif l:nexttext =~ s:remstring
            let b:v.lev = '>' . string(b:v.myAbsLevel + 6)
        elseif l:nexttext !~ b:v.headMatch
            let b:v.lev = '>' . string(b:v.myAbsLevel + 3)
        elseif l:nextAbsLevel > b:v.myAbsLevel
            "let b:v.lev = '>20'
            "let b:v.lev = '>' . string(l:nextAbsLevel)
            let b:v.lev = '>' . string(b:v.myAbsLevel)
        elseif l:nextAbsLevel < b:v.myAbsLevel
            let b:v.lev = '<' . string(l:nextAbsLevel)
        else
            let b:v.lev = '<' . b:v.myAbsLevel
        endif
        let b:v.prevlev = b:v.myAbsLevel

    else    
        "we have a text line 
        if b:v.lastline != a:line - 1    " backup to headline to get bearings
            let b:v.prevlev = s:Ind(s:OrgPrevHead_l(a:line))
        endif

        if l:text =~ b:v.drawerMatch
            let b:v.lev = '>' . string(b:v.prevlev + 4)
        elseif l:text =~ s:remstring
            if (getline(a:line - 1) =~ b:v.headMatch) && (l:nexttext =~ s:remstring)
                let b:v.lev =  string(b:v.prevlev + 5)
            elseif (l:nexttext !~ s:remstring) || 
                        \ (l:nexttext =~ b:v.drawerMatch) 
                let b:v.lev = '<' . string(b:v.prevlev + 4)
            " reverting back to use the if and elseif blocks above
            " (11-24-2009)
            "if (getline(a:line - 1) =~ b:v.headMatch) 
            "    let b:v.lev = '>' . string(b:v.prevlev + 4)
            else
                let b:v.lev = b:v.prevlev + 4
            endif
        elseif l:text[0] != '#'
            let b:v.lev = (b:v.prevlev + 2)
        elseif b:v.src_fold  
            if l:text =~ '^#+begin_src'
                let b:v.lev = '>' . (b:v.prevlev + 2)
            elseif l:text =~ '^#+end_src'
                let b:v.lev = '<' . (b:v.prevlev + 2)
            endif
        else 
            let b:v.lev = (b:v.prevlev + 2)
        endif   

        "if l:nexttext =~ b:v.headMatch
        if l:nexttext[0] == '*'
            let b:v.lev = '<' . string(l:nextAbsLevel)
        endif
    endif   
    let b:v.lastline = a:line
    return b:v.lev    

endfunction

function! s:AlignSection(regex,skip,extra) range
    " skip is first part of regex, 'regex' is part to match
    " they must work together so that 'skip.regex' is matched
    " and the point where they connect is where space is inserted
    let extra = a:extra
    let sep = empty(a:regex) ? '=' : a:regex
    let minst = 999
    let maxst = 0
    let b:v.stposd = {}
    let section = getline(a:firstline, a:lastline)
    for line in section
        let stpos = matchend(line,a:skip)   
        let b:v.stposd[index(section,line)]=stpos
        if maxst < stpos
            let maxst = stpos
        endif
        let stpos = len(matchstr(matchstr(line,a:skip),'\s*$'))
        if minst > stpos
            let minst = stpos
        endif
    endfor
    call map(section, 's:AlignLine(v:val, sep, a:skip, minst, maxst - matchend(v:val,a:skip), extra)')
    call setline(a:firstline, section)
endfunction

function! s:AlignLine(line, sep, skip, maxpos, offset, extra)
    let b:v.m = matchlist(a:line, '\(' .a:skip . '\)\('.a:sep.'.*\)')
    if empty(b:v.m)
        return a:line
    endif
    let spaces = repeat(' ',  a:offset + a:extra)
    exec 'return b:v.m[1][:-' . a:maxpos .'] . spaces . b:v.m[3]'
endfunction
function! s:AlignSectionR(regex,skip,extra) range
    let extra = a:extra
    let sep = empty(a:regex) ? '=' : a:regex
    let minst = 999
    let maxpos = 0
    let maxst = 0
    let b:v.stposd = {}
    let section = getline(a:firstline, a:lastline)
    for line in section
        execute 'let pos = matchend(line, a:skip ." *".sep)'
        if maxpos < pos
            let maxpos = pos
        endif
        let stpos = len(matchstr(matchstr(line,a:skip),'\s*$')) 
        if minst > stpos
            let minst = stpos
        endif
    endfor
    call map(section, 's:AlignLine(v:val, sep, a:skip, minst, maxpos - matchend(v:val,a:skip.sep) , extra)')
    call setline(a:firstline, section)
endfunction
function! s:ColHeadWindow()
    au! BufEnter ColHeadBuffer
    let s:AgendaBufferName = 'ColHeadBuffer'
    call s:AgendaBufferOpen(1)
    let s:AgendaBufferName = '__Agenda__'
    call s:AgendaBufSetup()
    "set nobuflisted
    call s:SetColumnHead()
    execute "setlocal statusline=%#Search#%{<SNR>" . s:SID() . '_ColumnStatusLine()}'
    resize 1
    set winfixheight
    set winminheight=0
    "wincmd K
    wincmd j
    " make lower window as big as possible to shrink 
    " ColHeadWindow to zero height
    let curheight = winheight(0)
    resize 100
    if bufwinnr('Agenda') > 0
        execute "resize " . curheight 
    endif
    au BufEnter ColHeadBuffer call s:ColHeadBufferEnter()
endfunction

function! s:ColHeadBufferEnter()
    wincmd j
endfunction
" AgendaBufferOpen
" Open the scratch buffer
function! s:AgendaBufferOpen(new_win)
    let split_win = a:new_win

    " If the current buffer is modified then open the scratch buffer in a new
    " window
    if !split_win && &modified
        let split_win = 1
    endif

    " Check whether the scratch buffer is already created
    let scr_bufnum = bufnr(s:AgendaBufferName)
    if scr_bufnum == -1
        " open a new scratch buffer
        if split_win
            " vsplit agenda ***************
            "exe "vnew " . s:AgendaBufferName
            " ***************************
            exe "new " . s:AgendaBufferName
        else
            exe "edit " . s:AgendaBufferName
        endif
        " vsplit agenda *******************
        "wincmd L
        " ******************
        wincmd J
    else
        " Agenda buffer is already created. Check whether it is open
        " in one of the windows
        let scr_winnum = bufwinnr(scr_bufnum)
        if scr_winnum != -1
            " Jump to the window which has the scratch buffer if we are not
            " already in that window
            if winnr() != scr_winnum
                exe scr_winnum . "wincmd w"
            endif
        else
            " open a window and put existing Agenda in
            if split_win
                " vspli agenda ********************
                "exe "vsplit +buffer" . scr_bufnum
                " **************************
                exe "split +buffer" . scr_bufnum
            else
                exe "buffer " . scr_bufnum
            endif
        endif
    endif
endfunction

function! s:CaptureBuffer()
    let w:prevbuf=bufnr("%")
    sp _Capture_
    normal ggVGd
    normal i** 
    silent exec "normal o<".org#Timestamp().">"
    call s:AgendaBufSetup()
    command! -buffer W :call s:ProcessCapture()
    normal gg$a
    
endfunction
function! s:ProcessCapture()
    normal ggVG"xy
    execute "tab drop ".g:org_capture_file
    normal gg
    call search('^\* Agenda')
    execute s:OrgSubtreeLastLine()
    normal p
    normal gg
    silent write
    redo
    call s:LocateFile('_Capture_')
    execute "bd"
endfunction

function! EditAgendaFiles()
    if !exists("g:agenda_files") || (g:agenda_files==[])
        call s:CurfileAgenda()
    endif
    tabnew
    call s:AgendaBufSetup()
    command! W :call s:SaveAgendaFiles()
    let msg = "These are your current agenda files:"
    let msg2 = "Org files in your 'g:org_agenda_dirs' are below."
    call setline(1,[msg])
    call append(1, repeat('-',winwidth(0)-5))
    call append("$",g:agenda_files + ['',''])
    " change '\ ' to plain ' ' for current text in buffer
    silent! execute '%s/\\ / /g'
    let line = repeat('-',winwidth(0)-5)
    call append("$",[line] + [msg2,"To add files to 'g:agenda_files' copy or move them ","to between the preceding lines and press :W to save (or :q to cancel):","",""])
    for item in g:org_agenda_dirs
        call append("$",split(globpath(item,"**/*.org"),"\n"))
    endfor
endfunction
function! s:SaveAgendaFiles()
    " yank files into @a
   normal gg/^--jV/^--?^\S"ay 
   let @a = substitute(@a,' ','\\ ','g')
   if g:agenda_files[0][1] != '-'
        let g:agenda_files = split(@a,"\n")
    else
        let g:agenda_files=[]
    endif
    :bw
    delcommand W
endfunction

function! s:AgendaBufSetup()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
    setlocal fdc=1
endfunction
function! s:Emacs2PDF()
    silent !"c:program files (x86)\emacs\emacs\bin\emacs.exe" -batch --visit=newtest3.org --funcall org-export-as-pdf
    "silent !c:\sumatra.exe newtest3.org
endfunction
function! s:Today()
    return strftime("%Y-%m-%d")
endfunction
function! OrgAgendaDashboard()
    if (bufnr('__Agenda__') >= 0) && (bufwinnr('__Agenda__') == -1)
        " move agenda to cur tab if it exists and is on a different tab
        let curtab = tabpagenr()
        call s:LocateFile('__Agenda__')
        wincmd c
        execute "tabnext ".curtab
        split
        winc j
        buffer __Agenda__
    else
        " show dashboard if there is no agenda buffer or it's 
        " already on this tab page
        echo " Press key for an agenda command:"
        echo " --------------------------------"
        echo " a   Agenda for current week or day"
        echo " t   List of all TODO entries"
        echo " m   Match a TAGS/PROP/TODO query"
        echo " L   Timeline for current buffer"
        echo " s   Search for keywords"
        echo " "
        echo " f   Sparse tree of: " . g:org_search_spec
        echo " "
        let key = nr2char(getchar())
        if key == 't'
            redraw
            silent execute "call OrgRunSearch('+ALL_TODOS','agenda_todo')"
        elseif key == 'a'
            redraw
            silent execute "call OrgRunAgenda(s:Today(),7)"
        elseif key == 'L'
            redraw
            silent execute "call s:Timeline()"
        elseif key == 'm'
            redraw
            let mysearch = input("Enter search string: ")
            silent execute "call OrgRunSearch(mysearch)"
        elseif key == 'f'
            redraw
            let mysearch = input("Enter search string: ",g:org_search_spec)
            if bufname("%")=='__Agenda__'
                :bd
            endif
            silent execute "call OrgRunSearch(mysearch,1)"
        endif
    endif
endfunction

function! s:AgendaBufHighlight()
    hi Overdue guifg=red
    hi Upcoming guifg=yellow
    hi DateType guifg=#dd66bb
    hi Locator guifg=#333333
"    hi Todos guifg=pink
    hi Dayline guifg=#44aa44 gui=underline
    hi Weekendline guifg=#55ee55 gui=underline
    syntax match Scheduled '\(Scheduled:\|\dX:\)\zs.*$'
    syntax match Deadline '\(Deadline:\|\d d.:\)\zs.*$'
   " let todoMatchInAgenda = '\s*\*\+\s*\zs\(TODO\|DONE\|STARTED\)\ze'
   call s:AgendaHighlight()
    let daytextpat = '^[^S]\S\+\s\+\d\{1,2}\s\S\+\s\d\d\d\d.*'
    let wkendtextpat = '^S\S\+\s\+\d\{1,2}\s\S\+\s\d\d\d\d.*'
    call matchadd( 'AOL1', '\*\{1} .*$' )
    call matchadd( 'AOL2', '\*\{2} .*$') 
    call matchadd( 'AOL3', '\*\{3} .*$' )
    call matchadd( 'AOL4', '\*\{4} .*$' )
    call matchadd( 'AOL5', '\*\{5} .*$' )
    
    call matchadd( 'Overdue', '^\S*\s*\S*\s*\(In\s*\zs-\S* d.\ze:\|Sched.\zs.*X\ze:\)')
    call matchadd( 'Upcoming', '^\S*\s*\S*\s*In\s*\zs[^-]* d.\ze:')
    call matchadd( 'Locator', '^\d\+')
"    call matchadd( 'Todos', todoMatchInAgenda )
    call matchadd( 'Dayline', daytextpat )
    call matchadd( 'Weekendline', wkendtextpat)
    call matchadd( 'DateType','DEADLINE\|SCHEDULED\|CLOSED')
   " call matchadd( 'Todos', '^\s*:\zs.*\ze:')
    call matchadd('TODO', '^.*\* \zsTODO')
    call matchadd('STARTED', '^.*\* \zsSTARTED')
    call matchadd('DONE', '^.*\* \zsDONE')
    call matchadd('NEXT', '^.*\* \zsNEXT')
    call matchadd('CANCELED', '^.*\* \zsCANCELED')

    map <silent> <buffer> <localleader>tt :call OrgAgendaGetText(1,'TODO')<cr>
    map <silent> <buffer> <localleader>ts :call OrgAgendaGetText(1,'STARTED')<cr>
    map <silent> <buffer> <localleader>td :call OrgAgendaGetText(1,'DONE')<cr>
    map <silent> <buffer> <localleader>tc :call OrgAgendaGetText(1,'CANCELED')<cr>
    map <silent> <buffer> <localleader>tn :call OrgAgendaGetText(1,'NEXT')<cr>
    map <silent> <buffer> <localleader>tx :call OrgAgendaGetText(1,'')<cr>
    nmap <silent> <buffer> <localleader>et :call OrgTagsEdit()<cr>
    nmap <silent> <buffer> <localleader>ci :call OrgClockIn()<cr>
    nmap <silent> <buffer> <localleader>co :call OrgClockOut()<cr>
    nmap <silent> <buffer> q  :quit<cr>
    nmap <silent> <buffer> <c-tab>  :wincmd k<cr>
endfunction
function! s:AgendaHighlight()
    if g:org_gray_agenda
        hi link AOL1 NONE 
        hi link AOL2 NONE
        hi link AOL3 NONE
        hi link AOL4 NONE
        hi link AOL5 NONE
        hi Deadline guifg=lightred
        hi Scheduled guifg=lightyellow
        
    else
        hi link AOL1 OL1
        hi link AOL2 OL2
        hi link AOL3 OL3
        hi link AOL4 OL4
        hi link AOL5 OL5
        hi Deadline guifg=NONE
        hi Scheduled guifg=NONE
    endif
endfunction

function! OrgScreenLines() range
    " returns lines as
    " seen on screen, including folded text overlays
    " Call with visual selection set, or will
    " use last selection
    let save_cursor = getpos('.')
    let newline=0
    let oldline=1
    let mylines=[]
    normal '>
    let endline = line('.')
    " go to first line of selection
    normal '<
    while (line('.') <= endline) && (newline != oldline)
        let oldline=line('.')
        let newline=oldline
        call add(mylines,OrgFoldText(line('.')))
        normal j
        let newline=line('.')
    endwhile
    call setpos('.',save_cursor)
    return mylines
endfunction

function! s:CurTodo(line)
    let result = matchstr(getline(a:line),'.*\* \zs\S\+\ze ')`
    if index(b:v.todoitems,curtodo) == -1
        let result = ''
    endif
    return result
endfunction

"autocmd CursorHold * call s:Timer()
function! s:Timer()
    call feedkeys("f\e")
    " K_IGNORE keycode does not work after version 7.2.025)
    echo strftime("%c")
    " there are numerous other keysequences that you can use
endfunction

autocmd BufNewFile __Agenda__ call s:AgendaBufSetup()
autocmd BufWinEnter __Agenda__ call s:AgendaBufHighlight()
" Command to edit the scratch buffer in the current window
"command! -nargs=0 Agenda call s:AgendaBufferOpen(0)
" Command to open the scratch buffer in a new split window
command! -nargs=0 AAgenda call s:AgendaBufferOpen(1)

command! -nargs=0 OrgToPDF :call s:ExportToPDF()
command! -nargs=0 OrgToHTML :call s:ExportToHTML()
function! s:ExportToPDF()
    let mypath = '"c:\program files (x86)\emacs\emacs\bin\emacs.exe" -batch --load $HOME/.emacs --visit='
    let part2 = ' --funcall org-export-as-pdf'
    silent execute '!' . mypath . expand("%") . part2
    "call inputdialog("just waiting to go forward. . . ")
    silent execute '!'.expand("%:r").'.pdf'
endfunction
function! s:ExportToHTML()
    "let mypath = '"c:\program files (x86)\emacs\emacs\bin\emacs.exe" -batch --visit='
    let mypath = g:org_path_to_emacs .' -batch --visit='
    let part2 = ' --funcall org-export-as-html'
    silent execute '!'.mypath.expand("%").part2
    "call inputdialog("just waiting to go forward. . . ")
    silent execute '!'.expand("%:r").'.html'
endfunction

function! s:MailLookup()
    Utl openlink https://mail.google.com/mail/?hl=en&shva=1#search/after:2010-10-24+before:2010-10-26
    "https://mail.google.com/mail/?hl=en&shva=1#search/after%3A2010-10-24+before%3A2010-10-26
endfunction
function! Union(list1, list2)
    " returns the union of two lists
    " (some algo ...)
    let rdict = {}
    for item in a:list1
            let rdict[item] = 1
    endfor
    for item in a:list2
            let rdict[item] = 1
    endfor
    return sort(keys(rdict))
endfunc 
function! s:Intersect(list1, list2)
    " returns the intersection of two lists
    " (some algo ...)
    " fro andy wokula on vim-use mailing list
    let rdict = {}
    for item in a:list1
        if has_key(rdict, item)
            let rdict[item] += 1
        else
            let rdict[item] = 1
        endif
    endfor
    for item in a:list2
        if has_key(rdict, item)
            let rdict[item] += 1
        else
            let rdict[item] = 1
        endif
    endfor
    call filter(rdict, 'v:val==2')
    return sort(keys(rdict))
endfunc 


" This should be a setlocal but that doesn't work when switching to a new .otl file
" within the same buffer. Using :e has demonstrates this.
set foldtext=OrgFoldText()

setlocal fillchars=|, 

"*********************************************************************
"*********************************************************************
"  'endif' below is special 'endif' closing the 'if !exists(org_loaded)
"  line near top of file.  Thus the main functions are loaded
"  only once for all buffers, with settngs at begin of file
"  and mappings below this line executed for each buffer 
"  having org filetype
"*********************************************************************
"*********************************************************************
endif
let g:org_loaded=1
"*********************************************************************
"*********************************************************************
"*********************************************************************
"*********************************************************************
" below is default todo setup, anything different can be done
" in vimrc (or in future using a config line in the org file itself)
if !exists('b:v.todoitems')
    call OrgTodoSetup('TODO | DONE')
endif

" below block of 10 or 15 maps are ones collected
" from body of doc that weren't getting assigned for docs
" oepened after initial org filetype doc
nmap <silent> <buffer> <tab> :call OrgCycle()<cr>
nmap <silent> <buffer> <s-tab> :call OrgGlobalCycle()<cr>
nmap <silent> <buffer> <localleader>ci :call OrgClockIn(line("."))<cr>
nmap <silent> <buffer> <localleader>co :call OrgClockOut()<cr>
"cnoremap <space> <C-\>e(<SID>OrgDateEdit())<CR>
" dl is for the date on the current line
map <silent> <localleader>de :call OrgDateEdit('')<cr>
map <silent> <localleader>dt :call OrgDateEdit('TIMESTAMP')<cr>
map <silent> <localleader>dd :call OrgDateEdit('DEADLINE')<cr>
map <silent> <localleader>dc :call OrgDateEdit('CLOSED')<cr>
map <silent> <localleader>ds :call OrgDateEdit('SCHEDULED')<cr>
map <silent> <localleader>a* :call OrgRunAgenda(strftime("%Y-%m-%d"),7,'')<cr>
map <silent> <localleader>aa :call OrgRunAgenda(strftime("%Y-%m-%d"),7,'+ALL_TODOS')<cr>
map <silent> <localleader>at :call OrgRunAgenda(strftime("%Y-%m-%d"),7,'+UNFINISHED_TODOS')<cr>
map <silent> <localleader>ad :call OrgRunAgenda(strftime("%Y-%m-%d"),7,'+FINISHED_TODOS')<cr>
map <silent> <buffer> <localleader>tt :call OrgSequenceTodo(line('.'),'t')<cr>
map <silent> <buffer> <localleader>ts :call OrgSequenceTodo(line('.'),'s')<cr>
map <silent> <buffer> <localleader>td :call OrgSequenceTodo(line('.'),'d')<cr>
map <silent> <buffer> <localleader>tc :call OrgSequenceTodo(line('.'),'c')<cr>
map <silent> <buffer> <localleader>tn :call OrgSequenceTodo(line('.'),'n')<cr>
map <silent> <buffer> <localleader>tx :call OrgSequenceTodo(line('.'),'x')<cr>
map <silent> <buffer> <localleader>nt :call OrgSequenceTodo(line('.'))<cr>
map <silent> <localleader>ag :call OrgAgendaDashboard()<cr>
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
map <silent> <localleader>b  :call ShowBottomCal()<cr> 

nmap <silent> <buffer> <localleader>et :call OrgTagsEdit()<cr>

" clear search matching
nmap <silent> <buffer> <localleader>cs :let @/=''<cr>

map <buffer>   <C-K>         <C-]>
map <buffer>   <C-N>         <C-T>
map <silent> <buffer>   <localleader>0          :call OrgExpandWithoutText(99999)<CR>
map <silent> <buffer>   <localleader>9          :call OrgExpandWithoutText(9)<CR>
map <silent> <buffer>   <localleader>8          :call OrgExpandWithoutText(8)<CR>
map <silent> <buffer>   <localleader>7          :call OrgExpandWithoutText(7)<CR>
map <silent> <buffer>   <localleader>6          :call OrgExpandWithoutText(6)<CR>
map <silent> <buffer>   <localleader>5          :call OrgExpandWithoutText(5)<CR>
map <silent> <buffer>   <localleader>4          :call OrgExpandWithoutText(4)<CR>
map <silent> <buffer>   <localleader>3          :call OrgExpandWithoutText(3)<CR>
map <silent> <buffer>   <localleader>2          :call OrgExpandWithoutText(2)<CR>
map <silent> <buffer>   <localleader>1          :call OrgExpandWithoutText(1)<CR>
map <silent> <buffer>   <localleader>,0           :set foldlevel=99999<CR>
map <silent> <buffer>   <localleader>,9           :call OrgSetLevel (1,9)<CR>
map <silent> <buffer>   <localleader>,8           :call OrgSetLevel (1,8)<CR>
map <silent> <buffer>   <localleader>,7           :call OrgSetLevel (1,7)<CR>
map <silent> <buffer>   <localleader>,6           :call OrgSetLevel (1,6)<CR>
map <silent> <buffer>   <localleader>,5           :call OrgSetLevel (1,5)<CR>
map <silent> <buffer>   <localleader>,4           :call OrgSetLevel (1,4)<CR>
map <silent> <buffer>   <localleader>,3           :call OrgSetLevel (1,3)<CR>
map <silent> <buffer>   <localleader>,2           :call OrgSetLevel (1,2)<CR>
map <silent> <buffer>   <localleader>,1           :call OrgSetLevel (1,1)<CR>

imap <silent> <buffer>   <s-c-CR>               <c-r>=OrgNewHead('levelup',1)<CR>
imap <silent> <buffer>   <c-CR>               <c-r>=OrgNewHead('leveldown',1)<CR>
imap <silent> <buffer>   <s-CR>               <c-r>=OrgNewHead('same',1)<CR>
nmap <silent> <buffer>   <s-c-CR>               :call OrgNewHead('levelup')<CR>
nmap <silent> <buffer>   <c-CR>               :call OrgNewHead('leveldown')<CR>
nmap <silent> <buffer>   <s-CR>               :call OrgNewHead('same')<CR>
nmap <silent> <buffer>   <CR>               :call OrgNewHead('same')<CR>
map <silent> <buffer>   <c-left>               :call OrgShowLess(line("."))<CR>
map <silent> <buffer>   <c-right>            :call OrgShowMore(line("."))<CR>
map <silent> <buffer>   <c-a-left>               :call OrgMoveLevel(line("."),'left')<CR>
map <silent> <buffer>   <c-a-right>             :call OrgMoveLevel(line("."),'right')<CR>
map <silent> <buffer>   <c-a-up>               :call OrgMoveLevel(line("."),'up')<CR>
map <silent> <buffer>   <c-a-down>             :call OrgMoveLevel(line("."),'down')<CR>
map <silent> <buffer>   <a-end>                 :call OrgNavigateLevels("end")<CR>
map <silent> <buffer>   <a-home>                 :call OrgNavigateLevels("home")<CR>
map <silent> <buffer>   <a-up>                 :call OrgNavigateLevels("up")<CR>
map <silent> <buffer>   <a-down>               :call OrgNavigateLevels("down")<CR>
map <silent> <buffer>   <a-left>               :call OrgNavigateLevels("left")<CR>
map <silent> <buffer>   <a-right>              :call OrgNavigateLevels("right")<CR>
nmap <silent> <buffer>   <localleader>,e    :call OrgSingleHeadingText("expand")<CR>
nmap <silent> <buffer>   <localleader>,E    :call OrgBodyTextOperation(1,line("$"),"expand")<CR>
nmap <silent> <buffer>   <localleader>,C    :call OrgBodyTextOperation(1,line("$"),"collapse")<CR>
nmap <silent> <buffer>   <localleader>,c    :call OrgSingleHeadingText("collapse")<CR>
nmap <silent> <buffer>   zc    :call OrgDoSingleFold(line("."))<CR>
"map <buffer>             <localleader>tt    :call ToggleText(line("."))<CR>
map <buffer>   <localleader>,,          :source $HOME/.vim/ftplugin/org.vim<CR>
map! <buffer>  <localleader>w           <Esc>:w<CR>a


" Org Menu Entries
amenu &Org.Expand\ Level\ &1 :set foldlevel=0<cr>
amenu &Org.Expand\ Level\ &2 :set foldlevel=1<cr>
amenu &Org.Expand\ Level\ &3 :set foldlevel=2<cr>
amenu &Org.Expand\ Level\ &4 :set foldlevel=3<cr>
amenu &Org.Expand\ Level\ &5 :set foldlevel=4<cr>
amenu &Org.Expand\ Level\ &6 :set foldlevel=5<cr>
amenu &Org.Expand\ Level\ &7 :set foldlevel=6<cr>
amenu &Org.Expand\ Level\ &8 :set foldlevel=7<cr>
amenu &Org.Expand\ Level\ &9 :set foldlevel=8<cr>
amenu &Org.Expand\ Level\ &All :set foldlevel=99999<cr>
amenu &Org.-Sep1- :
amenu &Org.Expand\ Level\ &1\ w/oText :call OrgExpandWithoutText(1)<cr>
amenu &Org.Expand\ Level\ &2\ w/oText :call OrgExpandWithoutText(2)<cr>
amenu &Org.Expand\ Level\ &3\ w/oText :call OrgExpandWithoutText(3)<cr>
amenu &Org.Expand\ Level\ &4\ w/oText :call OrgExpandWithoutText(4)<cr>
amenu &Org.Expand\ Level\ &5\ w/oText :call OrgExpandWithoutText(5)<cr>
amenu &Org.Expand\ Level\ &6\ w/oText :call OrgExpandWithoutText(6)<cr>
amenu &Org.-Sep1- :

command! PreLoadTags :silent  call <SID>GlobalConvertTags()
command! PreWriteTags :silent call <SID>GlobalUnconvertTags(changenr())
command! PostWriteTags :silent call <SID>UndoUnconvertTags()


" below is autocmd to change tw for lines that have comments on them
" I think this should go in vimrc so i runs for each buffer load
"  :autocmd CursorMoved,CursorMovedI * :if match(getline(line(".")), '^*\*\s') == 0 | :setlocal textwidth=99 | :else | :setlocal textwidth=79 | :endif 
set com=sO::\ -,mO::\ \ ,eO:::,::,sO:>\ -,mO:>\ \ ,eO:>>,:>
set fo=qtcwn
let b:v.current_syntax = "org"

" vim600: set tabstop=4 shiftwidth=4 smarttab expandtab fdm=expr foldexpr=getline(v\:lnum)=~'^func'?0\:1:
