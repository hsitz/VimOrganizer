let b:prevlev = 0
let maplocalleader = ","        " Org key mappings prepend single comma

setlocal ignorecase         " searches ignore case
setlocal smartcase          " searches use smart case
set guioptions-=L

" below is match string that will match all body text lines
"           t1      t1'      t2     t7   t3-4    t5-6 
let g:templist = []
let b:textMatch = '\(^\s*.*\|^\t*:\|^\t* \|^\t*;\|^\t*|\|^\t*>\)'
let b:dateMatch = '\(\d\d\d\d-\d\d-\d\d\)'
let b:headMatch = '^\*\+\s'
let g:headMatch = '^\*\+\s'
let g:first_sparse=0
let b:headMatchLevel = '^\(\*\)\{level}\s'
let b:propMatch = '^\s*:\s*\(PROPERTIES\)'
let b:propvalMatch = '^\s*:\s*\(\S*\)\s*:\s*\(\S.*\)\s*$'
let b:drawerMatch = '^\s*:\s*\(PROPERTIES\|LOGBOOK\)'
let s:remstring = '^\s*:'
let s:headline = ''
let b:levelstars = 1
let g:ColumnHead = 'Lines'
"let b:todoitems = ['TODO','NEXT','STARTED','DONE','CANCELED']
"let b:todoitems = ['TODO','NEXT','STARTED','DONE','CANCELED']
let g:sparse_lines_after = 10
let g:capture_file=''
let g:log_todos=0
let b:effort=['0:05','0:10','0:15','0:30','0:45','1:00','1:30','2:00','4:00']
let g:timegrid=[8,17,1]
"let b:todoMatch = '^\*\+\s*\(TODO\|DONE\|STARTED\|CANCELED\|NEXT\)'
"let b:todoNotDoneMatch = '^\*\+\s*\(TODO\|STARTED\|NEXT\)'
let b:tagMatch = '\(:\S*:\)\s*$'
let b:mytags = ['buy','home','work','URGENT']
let b:foldhi = ''
let g:colview_list = []
let s:firsttext = ''

let g:item_len=100
let w:sparse_on = 0
let b:columnview = 0
let b:clock_to_logbook = 1
let b:messages = []
let b:global_cycle_levels_to_show=4
let b:src_fold=0
let g:folds = 1
let b:foldhilines = []
let b:cycle_with_text=1
let g:show_fold_lines = 1
let g:colview_list=['tags',30]
let g:show_fold_dots = 0
let g:org_show_matches_folded=1
let g:org_indent_from_head = 0
let g:org_agenda_skip_gap = 2
let g:agenda_days=7
let g:org_agenda_minforskip = 8
let b:foldcolors=['Normal','SparseSkip','Folded','WarningMsg','WildMenu','DiffAdd','DiffChange','Normal','Normal','Normal','Normal']
let b:foldcolors_orig=['Normal','SparseSkip','Folded','WarningMsg','WildMenu','DiffAdd','DiffChange','Normal','Normal','Normal','Normal']
" list to hold columns to be added to fold text
let b:foldcolors_bad=['Normal','Folded','Folded','Folded','Folded','Folded','Folded','Folded','Folded','Folded','Folded']
" currently can hold 'cost' or 'r'(eminder date)
let b:cols = []
set list
set listchars=tab:»\ ,eol:¬
set cfu=Mycfu
set noswapfile
hi MatchGroup guibg=yellow guifg=black

setlocal autoindent 
setlocal backspace=2
"setlocal wrapmargin=5
"setlocal wrap!
setlocal nowrap
setlocal tw=78
setlocal expandtab
setlocal nosmarttab
setlocal softtabstop=0 
setlocal foldlevel=20
setlocal foldcolumn=1       " turns on "+" at the begining of close folds
setlocal tabstop=4          " tabstop and shiftwidth must match
setlocal shiftwidth=4       " values from 2 to 8 work well
set formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\\-\\s\\+
setlocal foldmethod=manual
"setlocal foldmethod=expr
setlocal foldexpr=MyFoldLevel(v:lnum)
setlocal indentexpr=
setlocal nocindent
setlocal iskeyword=@,39,45,48-57,_,129-255


let b:basedate = strftime("%Y-%m-%d %a")
let b:sparse_list = []
let g:datelist = []
let g:agenda_date_dict = {}
let g:agenda_head_lookup = {}
let g:search_spec = '+TODO+URGENT'
let b:fold_list = []
let b:suppress_indent=0
let b:suppress_list_indent=0
let g:adict = {}
let g:search_type = 'regular'
let g:org_deadline_warning_days = 3
let g:weekdays = ['mon','tue','wed','thu','fri','sat','sun']
let g:weekdaystring = '\cmon\|tue\|wed\|thu\|fri\|sat\|sun'
let g:months = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']
let g:monthstring = '\cjan\|feb\|mar\|apr\|may\|jun\|jul\|aug\|sep\|oct\|nov\|dec'
"let g:agenda_files=['newtest3.org','test3.org', 'test4.org', 'test5.org','test6.org', 'test7.org']
let g:agenda_files=[]
let s:AgendaBufferName = "__Agenda__"

if !exists('g:org_loaded')

function! TodoSetup(todolist)
    "set up list and patterns for use throughout
    let b:todoitems=[]
    let b:fulltodos=a:todolist
    let b:todocycle=[]
    let b:todoMatch=''
    let b:todoNotDoneMatch=''
    let b:todoDoneMatch=''
    let i = 0
    while i < len(a:todolist) 
        if type(a:todolist[i]) == type('abc')
            call add(b:todoitems,a:todolist[i])
            call add(b:todocycle,a:todolist[i])
            " add to patterns
            let newtodo = b:todoitems[len(b:todoitems)-1]
            let b:todoMatch .= newtodo . '\|'
            if i < len(a:todolist) - 1
                let b:todoNotDoneMatch .= newtodo . '\|'
            else
                let b:todoDoneMatch .= newtodo . '\|'
            endif
            else
            let j = 0
            while j < len(a:todolist[i])
                call add(b:todoitems,a:todolist[i][j])
                if j == 0
                    call add(b:todocycle,a:todolist[i][0])
                endif
                " add to patterns
                let b:todoMatch .= a:todolist[i][j] . '\|'
                if i < len(a:todolist) - 1
                    let b:todoNotDoneMatch .= a:todolist[i][j] . '\|'
                else
                    let b:todoDoneMatch .= a:todolist[i][j] . '\|'
                endif
                let j += 1
            endwhile
        endif
        let i += 1
    endwhile
    let b:todoMatch = '^\*\+\s*\('.b:todoMatch[:-2] . ')'
    let b:todoDoneMatch = '^\*\+\s*\('.b:todoDoneMatch[:-2] . ')'
    let b:todoNotDoneMatch = '^\*\+\s*\('.b:todoNotDoneMatch[:-2] . ')'

endfunction
function! CurfileAgenda()
    exec "let g:agenda_files=['".expand("%")."']"
endfunction

function! GetBufferTags()
    let save_cursor = getpos(".") 
    let b:tagdict = {}
    " call addtags for each headline in buffer
    g/^\*/call AddTagsToDict(line("."))
    call setpos('.',save_cursor)
    return sort(keys(b:tagdict))
endfunction
inoremap <F5> <C-R>=Effort()<CR>
noremap <F5> A<C-R>=Effort()<CR>
function! Effort()
    if getline(line('.'))=~':Effort:'
        call setline(line('.'), substitute(getline(line('.')),'ort:\zs.*','',''))
        normal A  
        call complete(col('.'),b:effort)
    endif
    return ''
endfunction
function! AddTagsToDict(line)
    "call add(g:donelines,line('.'))
    let taglist = GetTagList(a:line)
    if !empty(taglist)
        for item in taglist
            "if has_key(b:tagdict, item)
            "execute "let b:tagdict['" . item . "'] += 1"
            "else
            execute "let b:tagdict['" . item . "'] = 1"
            "endif
        endfor
    endif
endfunction

function! GetTagList(line)
    let text = getline(a:line+1)
    if (text !~ b:drawerMatch) && (text !~ b:dateMatch) && (text =~ s:remstring)
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
function! IsTagLine(line)
    let text = getline(a:line)
    return (text !~ b:drawerMatch) && (text !~ b:dateMatch) && (text =~ s:remstring)
endfunction
function! GetTags(line)
    if IsTagLine(a:line+1)
        return matchstr(getline(a:line+1),':.*$')
    else
        return ''
    endif
endfunction
function! AddTag(tag,line)
    if IsTagLine(a:line + 1)
        if matchstr(getline(a:line+1),':'.a:tag.':') == ''
            call setline(a:line+1,getline(a:line+1) . ':' .a:tag. ':')
        endif
    else
        call append(a:line, '     :' . a:tag . ':')
    endif
endfunction
function! TagInput(line)
    let linetags = GetTagList(a:line)
    if empty(linetags)
        call append(a:line,':')
    endif   
    let buftags = GetBufferTags()
    let displaytags = deepcopy(buftags)
    call insert(displaytags,'  Exit Menu')
    while 1
        let curstatus = []
        call add(curstatus,0)
        let i = 1
        let linetags = GetTagList(a:line)
        while i < len(buftags) + 1 
            if index(linetags, buftags[i-1]) >= 0 
                let cbox = '[ X ]'
                call add(curstatus,1)
            else
                let cbox = '     '
                call add(curstatus,0)
            endif

            let displaytags[i] = cbox . PrePad('&'.buftags[i-1],28)
            let i += 1
        endwhile

        let @/=''
        if foldclosed(a:line) > 0
            let b:sparse_list = [a:line]
        else
            normal V
        endif
        redraw
        if foldclosed(a:line) > 0
            let b:sparse_list = []
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
        call setline(a:line+1, repeat(' ',Starcount(a:line)+1) . newtags)

    endwhile
    if empty(GetTagList(a:line))
        execute a:line+1 .'d'
        execute a:line
    endif   
endfunction

function! UnconvertTags(line)
    if IsTagLine(a:line+1)
        normal J
    endif
endfunction
function! <SID>GlobalUnconvertTags()
    "let g:save_cursor = getpos(".")
    "g/^\*\+\s/call UnconvertTags(line("."))
endfunction
function! <SID>UndoUnconvertTags()
    "normal u
    "call setpos(".",g:save_cursor)
    
endfunction

function! ConvertTags(line)
    let tags = matchstr(getline(a:line), '\(:\S*:\)\s*$')
    if tags > ''
        s/\s\+:.*:\s*$//
        call append(a:line, repeat(' ',Starcount(a:line)+1) . tags)
    endif
endfunction
function! <SID>GlobalConvertTags()
    let save_cursor = getpos(".")
    g/^\*\+\s/call ConvertTags(line("."))
    call setpos(".",save_cursor)
endfunction
function! GlobalFormatTags()
    let save_cursor = getpos(".")
    g/^\*\+\s/call FormatTags(line("."))
    call setpos(".",save_cursor)
endfunction
function! FormatTags(line)
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

function! FCTest(line)
    if foldclosed(a:line) != a:line
        return a:line . ' ---  ' . foldclosed(a:line)
    endif
endfunction

function! OrgToggleTodo(line,...)
    if a:0 == 1
        if a:1 == 'x'
            let newtodo = ''
        else
            for item in b:todoitems
                if item[0] ==? a:1
                    let newtodo = item
                endif
            endfor
        endif
    endif
    let linetext = getline(a:line)
    if (linetext =~ g:headMatch) 
        " get first word in line and its index in todoitems
        let tword = matchstr(linetext,'\*\+\s\+\zs\S\+\ze')
        if a:0 == 1
            call ReplaceTodo(tword,newtodo)
        else
            call ReplaceTodo(tword)
        endif
    endif
endfunction
function! NewTodo(curtodo)
    let curtodo = a:curtodo
    " check whether word is in todoitems and make appropriate
    " substitution
    let j = -1
    let newi = -1
    let i = index(b:fulltodos,curtodo)
    if i == -1 
        let i = 0
        while i < len(b:fulltodos)
            if type(b:fulltodos[i])==type([])
                let j = index(b:fulltodos[i],curtodo)
                if j > -1
                    break
                endif
            endif
            let i += 1
        endwhile
    endif

    if i == len(b:fulltodos)-1
        let newtodo = ''
    else
        if (i == len(b:fulltodos))
            " not found, newtodo is index 0
            let newi = 0
        elseif (i >= 0) 
            let newi = i+1
        endif

        if type(b:fulltodos[newi]) == type([])
            let newtodo = b:fulltodos[newi][0]
        else
            let newtodo = b:fulltodos[newi]
        endif
    endif
    return newtodo
endfunction

function! ReplaceTodo(todoword,...)
    let save_cursor = getpos('.')
    let todoword = a:todoword
    if a:0 == 1
        let newtodo = a:1
    else
        let newtodo = NewTodo(todoword)
    endif
    if newtodo > ''
        let newtodo .= ' '
    endif
    if (index(b:todoitems,todoword) >= 0) 
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

    "if g:log_todos && (bufnr("%") != bufnr('Agenda'))
     "   call ConfirmDrawer("LOGBOOK")
     "   let str = ": - State: " . Pad(newtodo,10) . "   from: " . Pad(a:todoword,10) .
     "               \ '    [' . Timestamp() . ']'
     "   call append(line("."), repeat(' ',len(matchstr(getline(line(".")),'^\s*'))) . str)
     "   execute OrgGetHead()
    "endif
    call setpos('.',save_cursor)
endfunction

function! Timestamp()
    return strftime("%Y-%m-%d %a %H:%M")
endfunction


function! OrgSubtreeLastLine()
    " Return the line number of the next head at same level, 0 for none
    return OrgSubtreeLastLine_l(line("."))
endfunction

function! OrgSubtreeLastLine_l(line)
    if a:line == 0
        return line("$")
    endif
    let l:starthead = OrgGetHead_l(a:line)
    let l:stars = Starcount(l:starthead) 
    let l:mypattern = substitute(b:headMatchLevel,'level', '1,'.l:stars, "")    
    let l:lastline = Range_Search(l:mypattern,'nW', line("$"), l:starthead) 
    " lastline now has NextHead on abs basis so return end of subtree
    if l:lastline != 0 
        let l:lastline -= 1
    else
        let l:lastline = line("$")
    endif
    return l:lastline

endfunction

function! OrgUltimateParentHead()
    " Return the line number of the parent heading, 0 for none
    return OrgUltimateParentHead_l(line("."))
endfunction

function! OrgUltimateParentHead_l(line)
    " returns 0 for main headings, main heading otherwise
    let l:starthead = OrgGetHead_l(a:line)

    if Ind(l:starthead) >  1
        return Range_Search('^* ','bnW',1,l:starthead)
    else
        return 0
    endif
endfunction

function! OrgParentHead()
    " Return the line number of the parent heading, 0 for none
    return OrgParentHead_l(line("."))
endfunction

function! OrgParentHead_l(line)
    " todo -- get b:levelstars in here
    let l:starthead = OrgGetHead_l(a:line)
    let l:parentheadlevel = Starcount(l:starthead) - b:levelstars
    if l:parentheadlevel <= 0 
        return 0
    else
        let l:mypattern = substitute(b:headMatchLevel,'level',l:parentheadlevel,'')
        return Range_Search(l:mypattern,'bnW',1,l:starthead)
    endif
endfunction


function! Range_Search(stext, flags, ...)
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

function! OrgGetHead()
    return OrgGetHead_l(line("."))
endfunction

function! OrgGetHead_l(line)
    if IsText(a:line)   
        return Range_Search(b:headMatch,'nb', 1, a:line)
    else
        return a:line
    endif
endfunction

function! OrgPrevSiblingHead()
    return OrgPrevSiblingHead_l(line("."))
endfunction
function! OrgPrevSiblingHead_l(line)
    if Ind(a:line) > 0
        let upperline = OrgParentHead_l(a:line)
    else
        let upperline = 0
    endif
    let sibline = OrgPrevHeadSameLevel_l(a:line)
    if (sibline <= upperline) 
        let sibline = 0
    endif
    return sibline
endfunction

function! OrgNextSiblingHead()
    return OrgNextSiblingHead_l(line("."))
endfunction
function! OrgNextSiblingHead_l(line)
    if Ind(a:line) > 0
        let lastline = OrgSubtreeLastLine_l(OrgParentHead_l(a:line))
    else
        let lastline = line("$")
    endif
    let sibline = OrgNextHeadSameLevel_l(a:line)
    if (sibline > lastline) 
        let sibline = 0
    endif
    return sibline
endfunction

function! OrgNextHead()
    " Return the line number of the next heading, 0 for none
    return OrgNextHead_l(line("."))
endfunction
function! OrgNextHead_l(line)
    return Range_Search(b:headMatch,'n', line("$"),a:line)
endfunction

function! OrgPrevHead()
    " Return the line number of the previous heading, 0 for none

    return OrgPrevHead_l(line("."))

endfunction

function! OrgPrevHead_l(line)

    return Range_Search(b:headMatch,'nb', 1, a:line-1)

endfunction

function! OrgNextHeadSameLevel()
    " Return the line number of the next head at same level, 0 for none
    return OrgNextHeadSameLevel_l(line("."))
endfunction

function! OrgNextHeadSameLevel_l(line)
    let level = Starcount(a:line) 
    let mypattern = substitute(b:headMatchLevel,'level', level, "") 
    let foundline = Range_Search(mypattern,'nW', line("$"), a:line)
    if foundline < line ("$")
        return foundline
    else
        if Starcount(foundline) > 0
            return foundline
        else
            return 0
        endif
    endif       
endfunction

function! OrgPrevHeadSameLevel()
    " Return the line number of the previous heading, 0 for none
    return OrgPrevHeadSameLevel_l(line("."))
endfunction
function! OrgPrevHeadSameLevel_l(line)
    let l:level = Starcount(a:line)
    let l:mypattern = substitute(b:headMatchLevel,'level', l:level, "") 
    let foundline = Range_Search(mypattern,'nbW', 1, a:line-1)
    if foundline > 1
        return foundline
    else
        if (Starcount(foundline) > 0) 
            return 1
        else
            return 0
        endif
    endif       

endfunction

function! OrgFirstChildHead()
    " Return the line number of first child, 0 for none
    return OrgFirstChildHead_l(line("."))
endfunction
function! OrgFirstChildHead_l(line)
    let l:starthead = OrgGetHead_l(a:line)

    let l:level = Starcount(l:starthead) + 1
    let l:nexthead = OrgNextHeadSameLevel_l(l:starthead)
    if l:nexthead == 0 
        let l:nexthead = line("$") 
    endif
    let l:mypattern = substitute(b:headMatchLevel,'level', l:level, "") 
    return Range_Search(l:mypattern,'nW',l:nexthead, l:starthead)
endfunction

function! OrgLastChildHead()
    " Return the line number of the last child, 0 for none
    return OrgLastChildHead_l(line("."))
endfunction

function! OrgLastChildHead_l(line)
    " returns line number of last immediate child, 0 if none
    let l:starthead = OrgGetHead_l(a:line)

    let l:level = Starcount(l:starthead) + 1

    let l:nexthead = OrgNextHeadSameLevel_l(l:starthead)
    if l:nexthead == 0 
        let l:nexthead = line("$") 
    endif

    let l:mypattern = substitute(b:headMatchLevel,'level', l:level, "") 
    return Range_Search(l:mypattern,'nbW',l:starthead, l:nexthead)

endfunction

function! MyLastChild(line)
    " Return the line number of the last decendent of parent line
    let l:parentindent = Ind(a:line)
    if IsText(a:line+1)
        let l:searchline = NextLevelLine(a:line+1)
    else    
        let l:searchline = a:line+1
    endif
    while Ind(l:searchline) > l:parentindent
        let l:searchline = l:searchline+1
    endwhile
    return l:searchline-1
endfunction

function! NextVisibleHead(line)
    " Return line of next visible heanding, 0 if none
    let save_cursor = getpos(".")

    while 1
        let nh = OrgNextHead()
        if (nh == 0) || IsVisibleHeading(nh)
            break
        endif
        execute nh
    endwhile

    call setpos('.',save_cursor)
    return nh

endfunction

function! FoldStatus(line)
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

function! NewHead(type,...)
    " adds new heading or text level depending on type
    if a:0 == 1
        normal 
    endif
    execute OrgGetHead()
    let l:org_line = line(".")
    let l:linebegin = matchlist(getline(line(".")),'^\(\**\s*\)')[1]
    if IsText(line("."))==0

        let l:lastline  = OrgSubtreeLastLine()  
        if a:type == 'levelup'
            let l:linebegin = substitute(l:linebegin,'^\*\{'.b:levelstars.'}','','')
        elseif a:type == 'leveldown'
            let l:linebegin = substitute(l:linebegin,'^\*',repeat('*',b:levelstars+1),'')
        endif   
        call append( l:lastline ,l:linebegin)
        execute l:lastline + 1
        startinsert!

    endif
    return ''
endfunction

function! IsText(line)
    " checks for whether line is any kind of text block
    " test if line matches all-inclusive text block pattern
    return getline(a:line) !~ b:headMatch
endfunction 

function! NextLevelAbs(line)
    " Return line of next heading
    " in absolute terms, not just visible headings
    let l:i = 1
    " go down to next non-text line
    while IsText(a:line + l:i)
        let l:i = l:i + 1
        "if (a:line + l:i) == line("$")
        :"  return 0
        "endif  
    endwhile    
    return a:line + l:i
endfunction

function! NextLevelLine(line)
    " Return line of next heading
    let l:fend = foldclosedend(a:line)
    if l:fend == -1
        let l:i = 1
        " go down to next non-text line
        while IsText(a:line + l:i)
            let l:i = l:i + 1
        endwhile    
        return a:line + l:i
    else
        return l:fend+1
    endif
endfunction

function! HasChild(line)
    " checks for whether heading line has
    " a sublevel
    " checks to see if heading has a non-text sublevel 
    if IsText(a:line + 1) && 
                \   (Ind(NextLevelLine(a:line+1)) > Ind(a:line))
        return 1
    elseif IsText(a:line + 1) == 0 && 
                \   (Ind(NextLevelLine(a:line)) > Ind(a:line))
        return 1
    else
        return 0    
    endif   
endfunction

function! DoFullCollapse(line) 
    " make sure headline is not just 
    " text collapse
    " test if line matches all-inclusive text block pattern
    if foldclosed(a:line) == -1 && (HasChild(a:line) || IsText(a:line+1))
        normal! zc
    endif       
    if IsTextOnlyFold(a:line) && HasChild(a:line)
        normal! zc
        if IsTextOnlyFold(a:line) && HasChild(a:line)
            normal! zc
            if IsTextOnlyFold(a:line) && HasChild(a:line)
                normal! zc
            endif
        endif   
    endif   
endfunction

function! IsTextOnlyFold(line)
    " checks for whether heading line has full fold
    " or merely a text fold
    "if IsText(a:line + 1) && (foldclosed(a:line + 1) == a:line) 
    if IsText(a:line + 1) && (foldclosedend(a:line) > 0)
                \    && (Ind(foldclosedend(a:line)) <= Ind(a:line))
        return 1
    else
        return 0
    endif   
endfunction

function! MaxVisIndent(headingline)
    " returns max indent for 
    " visible lines in a heading's subtree
    " used by ShowSubs
    let l:line = a:headingline
    let l:endline = OrgSubtreeLastLine()
    "let l:endline = MyLastChild(l:line)
    let l:maxi = Ind(l:line)
    let l:textflag = 0
    while l:line <= l:endline
        if (Ind(l:line) > l:maxi) && 
                    \   ( foldclosed(l:line) == l:line 
                    \  || foldclosed(l:line) == -1  )
            let l:maxi = Ind(l:line)
            if IsText(l:line)
                let l:textflag = 1
            endif   
        endif
        let l:line = l:line + 1
    endwhile    
    return l:maxi + l:textflag
endfunction

function! ShowLess(headingline)
    " collapses headings at farthest out visible level
    let l:maxi = MaxVisIndent(a:headingline)
    let l:offset = l:maxi - Ind(a:headingline)
    if l:offset > 1 
        call ShowSubs(l:offset - 1,0)
    elseif l:offset == 1
        normal! zc  
    endif   
endfunction


function! ShowMore(headingline)
    " expands headings at furthest out 
    " visible level in a heading's subtree
    let l:maxi = MaxVisIndent(a:headingline)
    let l:offset = l:maxi - Ind(a:headingline)
    if l:offset >= 0 
        call ShowSubs(l:offset + 1,0)
        if l:maxi == MaxVisIndent(a:headingline)
            "call SingleHeadingText('expand')
        endif
    endif
endfunction

function! ShowSubs(number,withtext)
    " shows specif number of levels down from current 
    " heading, includes text
    " or merely a text fold
    let save_cursor = getpos(".")

    call DoFullCollapse(line("."))
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
        call SingleHeadingText('collapse')
    endif   

    call setpos(".",save_cursor)
endfunction

function! MoveLevel(line, direction)
    " move a heading tree up, down, left, or right
    let lastline = OrgSubtreeLastLine_l(a:line)
    if a:direction == 'up'
        let l:headabove = OrgPrevSiblingHead()
        if l:headabove > 0 
            let l:lines = getline(line("."), lastline)
            call DoFullCollapse(a:line)
            silent normal! dd
            call append(l:headabove-1,l:lines)
            execute l:headabove
            call ShowSubs(1,0)
        else 
            echo "No sibling heading above in this subtree."
        endif
    elseif a:direction == 'down'
        let l:headbelow = OrgNextSiblingHead()
        if l:headbelow > 0 
            let endofnext = OrgSubtreeLastLine_l(l:headbelow)
            let lines = getline(line("."),lastline)
            call append(endofnext,lines)
            execute endofnext + 1
            " set mark and go back to delete original subtree
            normal ma
            execute a:line
            call DoFullCollapse(a:line)
            silent normal! dd
            normal g'a
            call ShowSubs(1,0)
        else 
            echo "No sibling below in this subtree."
        endif
    elseif a:direction == 'left'
        if Ind(a:line) > 2 
            " first move to be last sibling
            let movetoline = OrgSubtreeLastLine_l(OrgParentHead_l(a:line))
            let lines = getline(line("."),lastline)
            call append(movetoline,lines)
            execute movetoline + 1
            " set mark and go back to delete original subtree
            normal ma
            execute a:line
            call DoFullCollapse(a:line)
            silent exe 'normal! dd'
            normal g'a
            " now move tree to the left
            normal ma
            silent execute line(".") ',' . OrgSubtreeLastLine() . 's/^' . repeat('\*',b:levelstars) .'//'
            call DoFullCollapse(a:line)
            normal g'a
            call ShowSubs(1,0)
            execute line(".")
        else 
            echo "You're already at main heading level."
        endif       
    elseif a:direction == 'right'
        if Ind(OrgPrevHead_l(a:line)) >= Ind(a:line)
            execute a:line . ',' . lastline . 's/^\*/'.repeat('\*',b:levelstars+1).'/'
            call DoFullCollapse(a:line)
            execute a:line
            call ShowSubs(1,0)
        else
            echo "Already at lowest level of this subtree."
        endif   
    endif
endfunction

function! NavigateLevels(direction)
    " Move among headings 
    " direction: "up", "down", "right", "left","end", or 'home'
    if IsText(line("."))
        exec OrgGetHead()
        return  
    endif

    if Ind(line(".")) > 0 
        let lowerlimit = OrgParentHead()
        let upperlimit = OrgSubtreeLastLine_l(lowerlimit)
    else
        let lowerlimit = 0
        let upperlimit = line("$")
    endif       

    if a:direction == "left"
        let dest = OrgParentHead()
        let msg = "At highest level."
    elseif a:direction == "home"
        let dest = OrgParentHead()
        let msg = "At highest level."
    elseif a:direction == "right"
        let dest = OrgFirstChildHead()
        let msg = (dest > 0 ? "Has subheadings, but none visible."
                    \  : "No more subheadings.")
    elseif a:direction == 'end'
        let dest = OrgLastChildHead()
        let msg = (dest > 0 ? "Has subheadings, but none visible."
                    \  : "No more subheadings.")
    elseif a:direction == 'up'
        let dest = OrgPrevHeadSameLevel()
        let msg = "Can't go up more here."
    elseif a:direction == 'down'
        let dest = OrgNextHeadSameLevel()
        let msg = "Can't go down more."
    endif

    let visible = IsVisibleHeading(dest) 
    if (dest > 0) && visible && (dest >= lowerlimit) && (dest <= upperlimit) 
        execute dest
    else 
        echo msg
    endif   
endfunction

function! ExpandWithoutText(tolevel)
    " expand all headings but leave Body Text collapsed 
    " tolevel: number, 0 to 9, of level to expand to
    "  expand levels to 'tolevel' with all body text collapsed
    let l:startline = 1 
    let l:endline = line("$")
    let l:execstr = "set foldlevel=" . string(a:tolevel  )
    "let l:execstr = "set foldlevel=" . (a:tolevel - 1)
    exec l:execstr  
    call BodyTextOperation(l:startline,l:endline,"collapse")
endfunction
function! OrgExpandSubtree(headline,...)
    if a:0 > 0
        let withtext = a:1
    endif
    let save_cursor = getpos(".")
    call DoFullFold(a:headline)
    "let end = foldclosedend(a:headline)
    "normal! zO
    "call BodyTextOperation(a:headline, end, 'collapse')
    call ShowSubs(3,withtext)
    call setpos(".",save_cursor)
endfunction
function! OrgExpandHead(headline)
    let save_cursor = getpos(".")
    call DoFullFold(a:headline)
    "let end = foldclosedend(a:headline)
    "normal! zO
    "call BodyTextOperation(a:headline, end, 'collapse')
    call ShowSubs(1,0)
    while foldclosed(a:headline) !=  -1
        normal! zo
    endwhile
    call setpos(".",save_cursor)
endfunction
function! DoFullFold(headline)
    let save_cursor = getpos(".")
    "normal! zo
    call DoAllTextFold(a:headline)
    let fend = foldclosedend(a:headline)
    if ((fend > a:headline) && (Ind(fend+1) > Ind(a:headline)))
                \ || (Ind(a:headline+1) > Ind(a:headline))
        normal zc
    endif
    call setpos(".",save_cursor)
endfunction
function! OrgCycle(headline)
    let save_cursor = getpos(".")
    let end = foldclosedend(a:headline)
    if (end>0) && (Ind(end+1) <= Ind(a:headline))
        call OrgExpandHead(a:headline)
    elseif ((end == -1) && (Ind(OrgNextHead_l(a:headline)) > Ind(a:headline))          
                \ && (IsText(a:headline+1))) && (foldclosed(OrgNextHead_l(a:headline)) > 0)
        "\ && (OrgSubtreeLastLine_l(a:headline) < line("$")) 
        "call OrgExpandSubtree(a:headline,b:cycle_with_text)
        let nextsamelevel = OrgNextHeadSameLevel_l(a:headline)
        let nextuplevel = OrgNextHeadSameLevel_l(OrgParentHead_l(a:headline)) 
        if (nextsamelevel > 0) && (nextsamelevel > nextuplevel)
            let endline = nextsamelevel
        elseif nextuplevel > a:headline
            let endline = nextuplevel
        else 
            let endline = line('$')
        endif
        if b:cycle_with_text
            call BodyTextOperation(a:headline+1,endline,'expand')
        else
            call OrgExpandSubtree(a:headline,0)
        endif
    else
        call DoFullFold(a:headline)
    endif
    call setpos(".",save_cursor)
endfunction
function! Cycle()
    if getline(line(".")) =~ b:headMatch
        call OrgCycle(line("."))
    elseif getline(line(".")) =~ b:drawerMatch
        normal! za
    endif
    " position to center of screen with cursor in col 0
    normal! z.
endfunction
function! GlobalCycle()
    "if getline(line(".")) =~ b:headMatch
    if (&foldlevel > 1) && (&foldlevel != b:global_cycle_levels_to_show)
        call ExpandWithoutText(1)
    elseif &foldlevel == 1
        call ExpandWithoutText(b:global_cycle_levels_to_show)
    else
        set foldlevel=9999
    endif
endfunction
function! LastTextLine(headingline)
    " returns last text line of text under
    " a heading, or 0 if no text
    let l:retval = 0
    if IsText(a:line + 1) 
        let l:i = a:line + 1
        while IsText(l:i)
            let l:i = l:i + 1
        endwhile
        let l:retval = l:i - 1
    endif
    return l:retval
endfunction

function! ShowSynStack()
    for id in synstack(line("."),col("."))
        echo synIDattr(id,"name")
    endfor  
endfunction
function! SignList()
    let signlist = ''
    redir => signlist
    silent execute "sign list"
    redir END
    return split(signlist,'\n')
endfunction
function! DeleteSigns()
    " first delete all placed signs
    sign unplace *
    let signs = SignList()
    for item in signs
        silent execute "sign undefine " . matchstr(item,'\S\+ \zs\S\+\ze ') 
    endfor
    sign define piet text=>>
    sign define fbegin text=>
    sign define fend text=<
endfunction

function! GetPlacedSignsString(buffer)
    let placedstr = ''
    redir => placedstr
    silent execute "sign place buffer=".a:buffer
    redir END
    return placedstr

endfunction
function! GetProperties(hl,withtextinfo,...)
    let save_cursor = getpos(".")
    if a:0 >=1
        let curtab = tabpagenr()
        let curwin = winnr()
    " optional args are: a:1 - lineno, a:2 - file
        call LocateFile(a:1)
    endif
    let hl = OrgGetHead_l(a:hl)
    let datesdone = 0
    let result1 = {}
    let result = {}
    let result1['l'] = hl
    " get date on headline, if any
    let result1['htext']=getline(hl)
    let result1['file']=expand("%:t:r")
    if getline(hl) =~ b:dateMatch
        let result1['ld'] = matchlist(getline(hl),b:dateMatch)[1]
    endif
    if (getline(hl+1) =~ b:tagMatch) && (getline(hl+1) !~ b:drawerMatch)
        let result1['tags'] = matchlist(getline(hl+1),b:tagMatch)[1]
    endif
    if getline(hl) =~ b:todoMatch
        let result1['todo'] = matchlist(getline(hl),b:todoMatch)[1]
    endif

    let line = hl + 1
    "let firsttext=0
    while 1
        let ltext = getline(line)
        if ltext =~ b:propMatch
            let result = GetPropVals(line+1)        
        elseif (ltext =~ b:dateMatch) && !datesdone
            let dateresult = GetDateVals(line)
            let datesdone = 1
            " no break, go back around to check for props
        elseif  (ltext =~ b:headMatch) || (line >= hl + 8)
            call extend(result, result1)
            if datesdone
                call extend(result, dateresult)
            endif
            break
        endif
        let line += 1
    endwhile
    if a:withtextinfo
        let result['tbegin'] = hl + 1
        let result['tend'] = OrgNextHead_l(hl) - 1
    endif
    if a:0 >= 1
        execute "tabnext ".curtab
        execute curwin . "wincmd w"
    endif
    call setpos(".",save_cursor)
    return result
endfunction

function! GetDateVals(line)
    "result is dict with all date vals 
    let myline = a:line
    let result = {}
    while 1
        let ltext = getline(myline)
        if ltext =~ b:dateMatch
            let mydate = matchlist(ltext, b:dateMatch)[1]
            if ltext =~ 'DEADLINE'
                let dtype = 'dd'
            elseif ltext =~ 'SCHEDULED'
                let dtype = 'sd'
            elseif ltext =~ 'CLOSED'
                let dtype = 'cd'
            else
                let dtype = 'ud'
            endif
        else
            break
        endif

        try
            let result[dtype] = mydate  
        catch /^Vim\%((\a\+)\)\=:E/ 
        endtry
        let myline += 1
    endwhile
    return result
endfunction

function! GetPropVals(line)
    "result is dict with all prop vals 
    let myline = a:line
    let result = {}
    while 1
        let ltext = getline(myline)
        if ltext =~ b:propvalMatch
            let mtch = matchlist(ltext, b:propvalMatch)
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


function! RedoTextIndent()
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

function! LoremIpsum()
    let lines = ["Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?","At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."]
    return split(lines[Random(3)-1],'\%70c\S*\zs \ze')
endfunction

function! Random(range)
    "returns random integer from 1 to range
    return (Rndm() % a:range) + 1
endfunction

function! RandomDate()
    let date = string((2010 + Random(2) - 1)).'-'.Pre0(Random(12)).'-'.Pre0(Random(28))
    if Random(2)==2
        return '<'.date. ' ' . calutil#dayname(date).'>'
    else
        return '<'.date. ' ' . calutil#dayname(date).' '.Pre0(Random(23)).':'.Pre0((Random(12)-1)*5).'>'
    endif
    "if a:date_type != ''
    "    call SetProp(a:date_type,date)
    "else
    "    silent execute "normal A".date
    "endif
endfunction
function! SetRandomDate(...)
    call OrgGetHead()
    if a:0 == 1
        let date_type = a:1
    else
        let date_type = ['DEADLINE','','SCHEDULED'][Random(3)-1]
    endif
    if date_type != ''
        call SetProp(date_type,RandomDate())
    else
        let hl = line('.')
        let dmatch = match(getline(hl),'\s*<\d\d\d\d-\d\d-\d\d')
        if dmatch > 0
            let dmatch = dmatch - 1
            call setline(hl,getline(hl)[:dmatch])
        endif
        let newd = RandomDate()
        execute hl
        execute "normal A ". newd
    endif
endfunction
function! SetRandomTodo()
    let newtodo = b:todoitems[Random(3)-1]
    if index(b:todoitems,matchstr(getline(line('.')),'^\*\+ \zs\S*\ze ')) >= 0
        call setline(line('.'),matchstr(getline(line('.')),'^\*\+ ') . newtodo . 
                    \    ' '. matchstr(getline(line('.')),'^\*\+ \S* \zs.*')) 
    else
        call setline(line('.'),matchstr(getline(line('.')),'^\*\+ ') . newtodo . 
                    \    ' '.  matchstr(getline(line('.')),'^\*\+ \zs.*')) 
    endif

endfunction


function! UpdateHeadlineSums()
    call MakeOrgDict()
    let tempdict = {}
    g/\*\+ /let tempdict[line('.')] = b:org_dict.SumTime(line('.'),'ClockSum')
    let items = sort(keys(tempdict))
    let i = len(items) - 1
    while i >= 0
        call SetProp('TreeTime',tempdict[items[i]],items[i])
        let i = i-1
    endwhile
endfunction

function! MakeOrgDict()
    let b:org_dict = {}
	function! b:org_dict.SumTime(ndx,property) dict
        let prop = a:property
        let result = get(self[a:ndx].props , prop)
        " now some nifty recursion down the subtree
        for item in self[a:ndx].c
            let result = AddTime(result,b:org_dict.SumTime(item,prop))
        endfor
        return result
	endfunction	
	function! b:org_dict.Sum(ndx,property) dict
        let prop = a:property
        let result = get(self[a:ndx].props , prop)
        " now some nifty recursion down the subtree
        for item in self[a:ndx].c
            let result += b:org_dict.Sum(item,prop)
        endfor
        return result
	endfunction	
    execute 1
   let next = 1
   if IsText(line('.'))
      let next = OrgNextHead()
   endif
   while next > 0
      execute next
      let b:org_dict[line('.')] = {'c':[]}
      let b:org_dict[line('.')].props = GetProperties(line('.'),1)
      let parent = OrgParentHead()
      if parent > 0
          call add(b:org_dict[parent].c ,line('.'))
      endif
      let next = OrgNextHead()
   endwhile 
endfunction

function! MakeDict2()

    exec 1
    let b:doclist = []
    let dict =  {}
    let b:dict = {}

    while 1
        let nh = OrgNextHead()
        if nh < 1 
            break
        endif
        let myline = getline(nh)    
        let todo = matchlist(myline,b:todoMatch)
        let tags = matchlist(myline+1,'\(:\S*:\)\s*$')
        call add(b:doclist,{'line': nh , 'lev': Ind(nh), 
                    \'todo': todo != [] ? todo[1] : '', 'tags': tags != [] ? tags[1] : '' } )
        execute nh
    endwhile

endfunction

function! MakeDict(dict,list)
    " make dictionary of outline
    " document's outline
    let l:dict = a:dict 
    for item in a:list
        let l:childlist = []
        let l:sublist = item[1]
        for subi in l:sublist
            call add(l:childlist,subi[0])
        endfor
        execute "let l:dict[".string(item[0])."]={'c':".string(l:childlist)."}"
    endfor  
endfunction

function! ClearSparseTreeOld()
    set fdm=manual
    silent exe '%s/^*x//'
    silent exe 'undojoin | %s/^*o//'
    "g/^*x/call substitute(getline(line(".")),'^*x',''))
    "g/^*o/call substitute(getline(line(".")),'^*o',''))

    call clearmatches()
    set fdm=expr
    echo "sparse tree view cleared"
endfunction

function! SparseTreeRun(term)

    call ClearSparseLists()
    let w:sparse_on = 1
    execute 'g/' . a:term . '/call add(b:sparse_list,line("."))'
    call SparseTreeDoFolds()
    call clearmatches()
    let g:first_sparse=1
    let b:signstring= GetPlacedSignsString(bufnr("%")) 
    set fdm=expr
    set foldlevel=0
    let g:first_sparse=0
    execute 'let @/ ="' . a:term .'"'
    execute 'g/' . a:term . '/normal zv'
    set hlsearch
    execute 1
endfunction

function! SparseTreeDoFolds()
    let i = len(b:sparse_list) - 1
    while i >= 0
        "if b:sparse_list[i] + g:sparse_lines_after > line("$")
        if b:sparse_list[i] + 10 > line("$")
            call remove(b:sparse_list, i) "insert(b:fold_list,0)
            let i -= 1
            continue
        "elseif (i>0) && (b:sparse_list[i] < b:sparse_list[i-1] + g:sparse_lines_after)
        elseif (i>0) && (b:sparse_list[i] < b:sparse_list[i-1] + 10)
            call remove(b:sparse_list, i) "insert(b:fold_list,0)
            let i -= 1
            continue
        else
            let phead = OrgUltimateParentHead_l(b:sparse_list[i])
            if phead >= 1 
                call insert(b:fold_list,phead-1)
            else
                " match is already on level 1 head
                call insert(b:fold_list,b:sparse_list[i]-1)
            endif
        endif

        let i -= 1
    endwhile        
    "call map(b:sparse_list,"v:val + g:sparse_lines_after")
    call map(b:sparse_list,"v:val + 10")
    call insert(b:sparse_list, 1)
    call add(b:fold_list, line("$"))

    " sign method to potentially supersede list based method above
    call DeleteSigns()
    for item in b:sparse_list
        execute "sign place " . item ." line=".item." name=fbegin buffer=".bufnr("%")
    endfor
    for item in b:fold_list
        execute "sign place " . item ." line=".item." name=fend buffer=".bufnr("%")
    endfor
    " FoldTouch below instead of fdm line above to save time
    " updating folds for just newly changed foldlevel lines
    "call FoldTouch()

endfunction

function! ClearSparseLists()
    " mylist with lines of matches
    let b:sparse_list = []
    " foldlist with line before previous level 1 parent
    let b:fold_list = []
    let b:sparse_heads = []
endfunction
function! ClearSparseTree()
    " mylist with lines of matches
    let w:sparse_on = 0
    let b:sparse_list = []
    " foldlist with line before previous level 1 parent
    let b:fold_list = []
    set fdm=expr
    set foldlevel=1
    execute 1
endfunction

function! FoldTouch()
    " not used right now, since speed increase over 
    " set fdm=expr is uncertain, and was having problems
    " in cleanly undoing it.
    "
    " touch each line in lists to update their fold levels  
    let i = 0
    while i < len(b:sparse_list)
        execute b:sparse_list[i]
        " insert letter 'b' to  force level update and then undo
        silent execute "normal! ib"
        silent execute "normal! u"
        execute b:fold_list[i]
        silent execute "normal! ib"
        silent execute "normal! u"
        let i += 1
    endwhile
endfunction

function! OrgIfExpr()
    " right now just does search for any todo tags
    "let g:search_spec = '+TODO+URGENT-home'
    let mypattern = ''
    " two wrapper subst statements around middle 
    " subst are to make dates work properly with substitute/split
    " operation
    let str = substitute(g:search_spec,'\(\d\{4}\)-\(\d\d\)-\(\d\d\)','\1xx\2xx\3','g')
    let str = substitute(str,'\([+-]\)','~\1','g')
    let str = substitute(str,'\(\d\{4}\)xx\(\d\d\)xx\(\d\d\)','\1-\2-\3','g')
    let g:str = str
    let b:my_if_list = split(str,'\~')
    let ifexpr = ''
    " okay, right now we have split list with each item prepended by + or -
    " now change each item to be a pattern match equation in parens
    " e.g.,'( prop1 =~ propval) && (prop2 =~ propval) && (thisline =~tag)
    let i = 0
    "using while structure because for structure doesn't allow changing
    " items?
    while i < len(b:my_if_list)
        let item = b:my_if_list[i]
        " Propmatch has '=' sign and something before and after
        if item[1:] =~ 'TEXT=\S.*'
            let mtch = matchlist(item[1:],'\(\S.*\)=\(\S.*\)')
            let b:my_if_list[i] = "(Range_Search('" . mtch[2] . "','nbW'," 
            let b:my_if_list[i] .= 'tbegin,tend)> 0)'
            let i += 1
            " loop to next item
            continue
        endif
        if item[1:] =~ '\S.*=\S.*'
            let pat = '\(\S.*\)\(==\|>=\|<=\|!=\)\(\S.*\)'
            let mtch = matchlist(item[1:],pat)
            "let b:my_if_list[i] = '(lineprops["' . mtch[1] . '"] ' . mtch[2]. '"' . mtch[3] . '")'
            if mtch[3] =~ '^\d\+$'
                let b:my_if_list[i] = '(get(lineprops,"' . mtch[1] . '") ' . mtch[2]. mtch[3] . ')'
            else
                let b:my_if_list[i] = '(get(lineprops,"' . mtch[1] . '","") ' . mtch[2]. '"' . mtch[3] . '")'
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
        if index(b:todoitems,item[1:]) >= 0
            let item = '(thisline ' . op . " '^\\*\\+\\s*" . item[1:] . "')"
            let b:my_if_list[i] = item
        elseif item[1:] == 'UNFINISHED_TODOS'
            let item = '(thisline ' . op . " '" . b:todoNotDoneMatch . "')"
            let b:my_if_list[i] = item
        elseif item[1:] == 'FINISHED_TODOS'
            let item = '(thisline ' . op . " '" . b:todoDoneMatch . "')"
            let b:my_if_list[i] = item
        elseif item[1:] == 'ALL_TODOS'
            let item = '(thisline ' . op . " '" . b:todoMatch . "')"
            let b:my_if_list[i] = item
        else
            let item = '(thisline ' . op . " ':" . item[1:] . ":')"
            let b:my_if_list[i] = item
        endif
        let i += 1 
    endwhile    
    let i = 0
    let b:check1 = b:my_if_list
    let ifexpr = ''
    while i < len(b:my_if_list) 
        let ifexpr .= b:my_if_list[i]
        if i < len(b:my_if_list) - 1
            let ifexpr .= ' && '
        endif
        let i += 1
    endwhile

    return ifexpr

endfunction

function! CheckIfExpr(line,ifexpr,...)
    " this is 'ifexpr' eval func used for agenda date searches
    let headline = OrgGetHead_l(a:line)
    " 0 arg is to not get start and end line numbers
    let lineprops=GetProperties(headline,0)
    " _thisline_ is variable evaluated in myifexpr
    let thisline = getline(headline)
    if IsTagLine(headline + 1)
        let thisline .= ' ' . getline(headline+1)
    endif
    return eval(a:ifexpr)

endfunction

function! OrgIfExprResults(ifexpr,...)
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
        let headline = OrgNextHead()
    else
        let headline = 1
    endif
    let g:checkexpr = a:ifexpr
    while 1
        if headline > 0 
            execute headline
            " _thisline_ is variable evaluated in myifexpr
            let thisline = getline(headline)
            if IsTagLine(headline + 1)
                let thisline .= ' ' . getline(headline+1)
            endif
            " lineprops is main variable tested in 'ifexpr' 
            " expression that gets evaluated
            let lineprops = GetProperties(headline,1)
            " next line is to fix for text area search
            " now that we can reference tbegin and tend
            let myifexpr = substitute(a:ifexpr,'tbegin,tend',get(lineprops,'tbegin') .','. get(lineprops,'tend'),"")

            "********  eval() is what does it all ***************
            if eval(myifexpr)
                if sparse_search
                    let keyval = headline
                else
                    let keyval = lineprops.file . "_" . PrePad(headline,5,'0')
                endif

                let g:adict[keyval]=lineprops

            endif
            normal l
            let headline = OrgNextHead() 
        else
            break
        endif
    endwhile
endfunction

function! MakeResults(search_spec,...)
    let sparse_search = 0
    if a:0 > 0
        let sparse_search = a:1
    endif
    let save_cursor = getpos(".")
    let curfile = expand("%:t")
    let g:search_spec = a:search_spec
    let g:adict = {}
    let g:datedict = {}
    let ifexpr = OrgIfExpr()

    if sparse_search 
        "execute 'let myfiles=["' . curfile . '"]'
        call OrgIfExprResults(ifexpr,sparse_search)
    else
        for file in g:agenda_files
            execute "tab drop " . file
            call OrgIfExprResults(ifexpr,sparse_search)
        endfor
        execute "tab drop " . curfile
    endif
    call setpos(".",save_cursor)
endfunction

function! DaysInMonth(date)
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

function! MakeAgenda(date,count,...)
    if a:0 >= 1
        let g:search_spec = a:1
    else
        let g:search_spec = ''
    endif
    let save_cursor = getpos(".")
    let curfile = expand("%:t")
    if a:count == 7
        let g:agenda_startdate = calutil#cal(calutil#jul(a:date) - calutil#dow(a:date))
        let g:agenda_days=7
    elseif (a:count>=28) && (a:count<=31)
        let g:agenda_startdate = a:date[0:7].'01'
        let g:agenda_days = DaysInMonth(a:date)
    else 
        let g:agenda_startdate = a:date
        let g:agenda_days=a:count
    endif
    "let myfiles=['newtest3.org','test3.org', 'test4.org', 'test5.org','test6.org', 'test7.org']
    let g:adict = {}
    let g:datedict = {}
    call MakeCalendar(g:agenda_startdate,g:agenda_days)
    let g:in_agenda_search=1
    for file in g:agenda_files
        "execute "tab drop " . file
        call LocateFile(file)
        let t:agenda_date=a:date
        if a:0 == 2
            call GetDateHeads(g:agenda_startdate,a:count,a:2)
        else 
            call GetDateHeads(g:agenda_startdate,a:count)
        endif
    endfor
    unlet g:in_agenda_search
    "execute "tab drop " . curfile
    call LocateFile(curfile)
    call setpos(".",save_cursor)
endfunction

function! NumCompare(i1, i2)
    return a:i1 == a:i2 ? 0 : a:i1 > a:i2 ? 1 : -1
endfunc

function! RunSearch(search_spec,...)
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
    call MakeResults(a:search_spec,sparse_search)

    if sparse_search
        call ClearSparseTree()
        let w:sparse_on = 1
        let temp = []
        for key in keys(g:adict)
            call add(temp,g:adict[key].l)
        endfor
        let b:sparse_list = sort(temp,'NumCompare')
        "for key in keys(g:adict)
        "   call add(b:sparse_heads,str2nr(key))
        "endfor
        "for item in sort(b:sparse_heads,'NumCompare')
        call sort(b:fold_list,"NumCompare")
        call SparseTreeDoFolds()
        "for item in sort(b:fold_list,'NumCompare')
        set fdm=expr
        set foldlevel=0
        for item in b:sparse_list
            if item > 11
                execute item - g:sparse_lines_after
                normal! zv
            endif
            "execute 'call matchadd("MatchGroup","\\%' . line(".") . 'l")'
        endfor
        execute 1
    else
        " make agenda buf have its own todoitems, need
        " to get rid of g:... so each agenda_file can have
        " its own todoitems defined. . . "
        let todos = b:todoitems
        let todoNotDoneMatch = b:todoNotDoneMatch
        let todoDoneMatch = b:todoDoneMatch
        let todoMatch = b:todoMatch
        let fulltodos = b:fulltodos
        :AAgenda
        let b:todoitems = todos
        let b:todoNotDoneMatch = todoNotDoneMatch
        let b:todoDoneMatch = todoDoneMatch
        let b:todoMatch = todoMatch
        let b:fulltodos = fulltodos
        %d
        set nowrap
        map <buffer> <silent> <tab> :call AgendaGetText()<CR>
        map <buffer> <silent> <s-CR> :call AgendaGetText(1)<CR>
        map <silent> <buffer> <c-CR> :MyAgendaToBuf<CR>
        map <silent> <buffer> <CR> :AgendaMoveToBuf<CR>
        nmap <silent> <buffer> r :call RunSearch(matchstr(getline(1),'spec: \zs.*$'))<CR>
        nmap <silent> <buffer> <s-up> :call DateInc(1)<CR>
        nmap <silent> <buffer> <s-down> :call DateInc(-1)<CR>
        call matchadd( 'OL1', '\s\+\*\{1}.*$' )
        call matchadd( 'OL2', '\s\+\*\{2}.*$') 
        call matchadd( 'OL3', '\s\+\*\{3}.*$' )
        call matchadd( 'OL4', '\s\+\*\{4}.*$' )

        wincmd J
        let i = 0
        call ADictPlaceSigns()
        call setline(1, ["Headlines matching search spec: ".g:search_spec,''])
        if exists("search_type") && (search_type=='agenda_todo')
            let msg = "Press num to redo search: "
            let numstr= ''
            let tlist = ['ALL_TODOS','UNFINISHED_TODOS', 'FINISHED_TODOS'] + b:todoitems
            for item in tlist
                let num = index(tlist,item)
                let numstr .= '('.num.')'.item.'  '
                execute "nmap <buffer> ".num."  :call RunSearch('+".tlist[num]."','agenda_todo')<CR>"
            endfor
            call append(1,split(msg.numstr,'\%72c\S*\zs '))
        endif
        for key in sort(keys(g:adict))
            call setline(line("$")+1, g:adict[key].l . repeat(' ',6-len(g:adict[key].l)) . 
                        \ Pad(g:adict[key].file,13)  . 
                        \ PrePad(matchstr(g:adict[key].htext,'^\*\+ '),8) .
                        \ matchstr(g:adict[key].htext,'\* \zs.*$'))
            let i += 1
        endfor
    endif
endfunction

function! TestTime()
    let g:timestart=join(reltime(), ' ') 
    let g:start = strftime("%")
    let i = 0
    set fdm=expr
    let g:timefinish=join(reltime(), ' ')
    echo g:timestart . ' --- ' . g:timefinish
endfunction
function! TestTime2(fu)
    let g:timestart=join(reltime(), ' ') 
    let g:start = strftime("%")
    let i = 0
    execute a:fu
    let g:timefinish=join(reltime(), ' ')
    echo g:timestart . ' --- ' . g:timefinish
endfunction

function! ADictPlaceSigns()
    let myl=[]
    call DeleteSigns()  " signs placed in GetDateHeads
    for key in keys(g:adict)
        let headline = matchstr(key, '_\zs\d\+$')
        let buf = bufnr(matchstr(key,'^.*\ze_\d\+$').'.org')
        try
            silent execute "sign place " . headline . " line=" 
                        \ . headline . " name=piet buffer=" . buf  
        catch 
            echo "ERROR: headline " . headline . ' and buf ' . buf . ' and dateline ' . dateline
        finally
        endtry
    endfor
endfunction
function! DateDictPlaceSigns()
    let myl=[]
    call DeleteSigns()  " signs placed in GetDateHeads
    for key in keys(g:agenda_date_dict)
        let myl = get(g:agenda_date_dict[key], 'l')
        if len(myl) > 0
            for item in myl
                let dateline = matchstr(item,'^\d\+')
                let headline = g:agenda_head_lookup[dateline]
                let buf = bufnr(matchstr(item,'^\d\+\s\+\zs\S\+') . '.org')
                try
                    silent execute "sign place " . headline . " line=" 
                                \ . headline . " name=piet buffer=" . buf  
                catch 
                    echo "ERROR: headline " . headline . ' and buf ' . buf . ' and dateline ' . dateline
                finally
                endtry
            endfor
        endif
    endfor
endfunction

function! DateDictToScreen()
    let message = ["Press <f> or <b> for next or previous period." ,
                \ "<Enter> on a heading to synch main file, <ctl-Enter> to goto line," ,
                \ "<tab> to cycle heading text, <shift-Enter> to cycle Todos.",'']
    let search_spec = g:search_spec > '' ? g:search_spec : 'None - include all heads'
    call add(message,"Agenda view for " . g:agenda_startdate 
                \ . " to ". calutil#cal(calutil#jul(g:agenda_startdate)+g:agenda_days-1)
                \ . ' with SearchSpec=' . search_spec  )
    call add(message,'')
    call setline(1,message)
    call DateDictPlaceSigns()
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
            if ((g:agenda_days==1) || (key==strftime("%Y-%m-%d"))) && exists('g:timegrid') && (g:timegrid != [])
                call PlaceTimeGrid(g:agenda_date_dict[key].marker)
            endif
        endif
    endfor
    if (gap > g:org_agenda_skip_gap) && (g:org_agenda_minforskip <= mycount)
        silent execute line("$")-gap+2 . ',$d'
        call setline(line("$"), ['','  [. . . ' .gap. ' empty days omitted ]',''])
    endif
endfunction
function! PlaceTimeGrid(marker)
    let grid = TimeGrid(g:timegrid[0],g:timegrid[1],g:timegrid[2])
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
function! RunAgenda(date,count,...)
    let win = bufwinnr('Calendar')
    if win >= 0 
        execute win . 'wincmd w'
        normal ggjjj
        wincmd l
        execute 'bd' . bufnr('Calendar')

    endif   
    " a:1 is search_spec, a:2 is "today" for search
    if a:0 == 1
        call MakeAgenda(a:date,a:count,a:1)
    elseif a:0 == 2
        call MakeAgenda(a:date,a:count,a:1,a:2)
    else
        call MakeAgenda(a:date,a:count)
    endif
    let todos = b:todoitems
    let todoNotDoneMatch = b:todoNotDoneMatch
    let todoDoneMatch = b:todoDoneMatch
    let todoMatch = b:todoMatch
    let fulltodos = b:fulltodos
    :AAgenda
    let b:todoitems = todos
    let b:todoNotDoneMatch = todoNotDoneMatch
    let b:todoDoneMatch = todoDoneMatch
    let b:todoMatch = todoMatch
    let b:fulltodos = fulltodos
    silent exe '%d'
    set nowrap
    map <silent> <buffer> <c-CR> :MyAgendaToBuf<CR>
    map <silent> <buffer> <CR> :AgendaMoveToBuf<CR>
    "map <silent> <buffer> f :call RunAgenda(calutil#cal(calutil#jul(g:date1)+7),7,g:search_spec)<CR>
    "map <silent> <buffer> b :call RunAgenda(calutil#cal(calutil#jul(g:date1)-7),7,g:search_spec)<CR>
    map <silent> <buffer> vd :call RunAgenda(g:agenda_startdate, 1,g:search_spec)<CR>
    map <silent> <buffer> vw :call RunAgenda(g:agenda_startdate, 7,g:search_spec)<CR>
    map <silent> <buffer> vm :call RunAgenda(g:agenda_startdate, 30,g:search_spec)<CR>
    map <silent> <buffer> f :call AgendaMove('forward')<cr>
    map <silent> <buffer> b :call AgendaMove('backward')<cr>
    map <silent> <buffer> <tab> :call AgendaGetText()<CR>
    map <silent> <buffer> <s-CR> :call AgendaGetText(1)<CR>
    nmap <silent> <buffer> r :call RunAgenda(g:agenda_startdate, g:agenda_days,g:search_spec)<CR>
    nmap <silent> <buffer> <s-up> :call DateInc(1)<CR>
    nmap <silent> <buffer> <s-down> :call DateInc(-1)<CR>

    wincmd J
    for key in keys(g:agenda_date_dict)
        call sort(g:agenda_date_dict[key].l, 'AgendaCompare')
    endfor
    call DateDictToScreen()
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
endfunction
function! Resize()
    let cur = winheight(0)
    resize 
    resize cur
endfunction

function! GetDateHeads(date1,count,...)
    let save_cursor=getpos(".")
    if g:search_spec > ''
        let b:agenda_ifexpr = OrgIfExpr()
    endif
    let g:date1 = a:date1
    let date1 = a:date1
    let date2 = calutil#Jul2Cal(calutil#Cal2Jul(split(date1,'-')[0],split(date1,'-')[1],split(date1,'-')[2]) + a:count)
    execute 1
    while search('<\d\d\d\d-\d\d-\d\d','W') > 0
        let repeatlist = []
        let line = getline(line("."))
        "let datematch = matchlist(line,'<\(\d\d\d\d-\d\d-\d\d\)')[1]
        let datematch = matchstr(line,'<\zs\d\d\d\d-\d\d-\d\d\ze')
        "if (g:search_spec == '') || (CheckIfExpr(line("."),ifexpr))
        let repeatmatch = matchstr(line, '<\zs\d\d\d\d-\d\d-\d\d.*+\d\+\S\+.*>\ze')
        if repeatmatch != ''
            let repeatlist = RepeatMatch(repeatmatch,date1,date2)
            for dateitem in repeatlist
                if a:0 == 1
                    call ProcessDateMatch(dateitem,date1,date2,a:1)
                else
                    call ProcessDateMatch(dateitem,date1,date2)
                endif
            endfor
        else
            if a:0 == 1
                call ProcessDateMatch(datematch,date1,date2,a:1)
            else
                call ProcessDateMatch(datematch,date1,date2)
            endif
        endif
        "endif
    endwhile
    call setpos(".",save_cursor)
endfunction

function! ProcessDateMatch(datematch,date1,date2,...)
    if a:0 > 0
        let today = a:1
    else
        let today = strftime("%Y-%m-%d")
    endif
    let datematch = a:datematch
    let rangedate = matchstr(getline(line(".")),'--<\zs\d\d\d\d-\d\d-\d\d')
    let filename = Pad(expand("%:t:r"), 13 )
    let line = getline(line("."))
    let date1 = a:date1
    let date2 = a:date2
    if (datematch >= date1) && (datematch < date2)
                \ && ((g:search_spec == '') || (CheckIfExpr(line("."),b:agenda_ifexpr)))
        let mlist = matchlist(line,'\(DEADLINE\|SCHEDULED\|CLOSED\)')
        call SetHeadInfo()
        if empty(mlist)
            " it's a regular date, first check for time parts
            let tmatch = matchstr(line,'\d\d:\d\d\ze>')
            if tmatch > ''
                let tmatch2 = matchstr(line,'--<.*\zs\d\d:\d\d\ze>')
                if tmatch2 > ''
                    let tmatch .= '-' . tmatch2
                else
                    let tmatch .= '......'
                endif
            endif
            call add(g:agenda_date_dict[datematch].l,  line(".") . repeat(' ',6-len(line("."))) . filename . Pad(tmatch,11) . s:headtext)
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
                        call add(g:agenda_date_dict[rangedate].l,  line(".") . repeat(' ',6-len(line("."))) . 
                                    \ filename . Pad(rangestr,11) . s:headtext)
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
            let type = Pad(mlist[1][0] . tolower(mlist[1][1:]) . ':' , 11)
            call add(g:agenda_date_dict[datematch].l,  line(".") . repeat(' ',6-len(line("."))) . filename . type  . s:headtext)
        endif
    endif
    " Now test for late and upcoming warnings if 'today' is in range
    if (today >= date1) && (today < date2)
        if (datematch < today) && (match(line,'\(DEADLINE\|SCHEDULED\)')>-1)
                    \ && ((g:search_spec == '') || (CheckIfExpr(line("."),b:agenda_ifexpr)))
            let mlist = matchlist(line,'\(DEADLINE\|SCHEDULED\)')
            call SetHeadInfo()
            if !empty(mlist)
                let dayspast = calutil#jul(today) - calutil#jul(datematch)
                if mlist[1] == 'DEADLINE'
                    let newpart = Pad('In',6-len(dayspast)) . '-' . dayspast . ' d.:' 
                else
                    let newpart = Pad('Sched:',9-len(dayspast)) . dayspast . 'X:'
                endif
                call add(g:agenda_date_dict[today].l,  line(".") . repeat(' ',6-len(line("."))) . filename . newpart . s:headtext)
            endif
            " also put in warning entry for deadlines when appropriate
        elseif (datematch > today) && (match(line,'DEADLINE')>-1)
                    \ && ((g:search_spec == '') || (CheckIfExpr(line("."),b:agenda_ifexpr)))
            let mlist = matchlist(line,'DEADLINE')
            call SetHeadInfo()
            if !empty(mlist)
                let daysahead = calutil#jul(datematch) - calutil#jul(today)
                let g:specific_warning = str2nr(matchstr(line,'<\S*\d\d.*-\zs\d\+\zed.*>'))
                if (daysahead <= g:org_deadline_warning_days) || (daysahead <= g:specific_warning)
                    let newpart = Pad('In',7-len(daysahead)) . daysahead . ' d.:' 
                    call add(g:agenda_date_dict[today].l,  line(".") . repeat(' ',6-len(line("."))) . filename . newpart . s:headtext)
                endif
            endif
        endif
    endif
    " finally handle things for a range that began before date1
    if (rangedate != '')  && (datematch < date1)
                \ && ((g:search_spec == '') || (CheckIfExpr(line("."),b:agenda_ifexpr)))
        let days_in_range = calutil#jul(rangedate) - calutil#jul(datematch) + 1
        if rangedate >= date2
            let last_day_to_add = calutil#jul(date2) - calutil#jul(datematch) 
            let rangedate = calutil#cal(calutil#jul(date2)-1)
        else
            let last_day_to_add = days_in_range
        endif

        call SetHeadInfo()
        let i = last_day_to_add
        while (rangedate >= date1)
            let rangestr = '('.i.'/'.days_in_range.')'
            call add(g:agenda_date_dict[rangedate].l,  line(".") . repeat(' ',6-len(line("."))) . 
                        \ filename . Pad(rangestr,11) . s:headtext)
            let rangedate = calutil#cal(calutil#jul(rangedate) - 1)
            let i = i - 1
        endwhile
        "endif
        "past match to avoid double treatment
        normal $
    endif
    let g:agenda_head_lookup[line(".")]=s:headline
endfunction

function! SetHeadInfo()
    let s:headline = OrgGetHead_l(line("."))
    let s:headtext = getline(s:headline)
    let s:mystars = matchstr(s:headtext,'^\*\+')
    let s:headstars = PrePad(s:mystars,6)
    let s:headtext = s:headstars . ' ' . s:headtext[len(s:mystars)+1:]
endfunction

function! RepeatMatch(rptdate, date1, date2)
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
                        \ Pre0( date1[5:6] - 1) . '-01')
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
            let first_of_month_jul = calutil#jul(string(year) . '-' . Pre0(nextmonth) . '-01')
        endwhile
    endif

    return g:rptlist

endfunction

function! BufMinMaxDate()
    let b:MinMaxDate=['2099-12-31','1900-01-01']
    g/<\d\d\d\d-\d\d-\d\d/call CheckMinMax()

endfunction
function! CheckMinMax()
    let date = matchstr(getline(line(".")),'<\zs\d\d\d\d-\d\d-\d\d')
    if (date < b:MinMaxDate[0])
        let b:MinMaxDate[0] = date
    endif
    if (date > b:MinMaxDate[1])
        let b:MinMaxDate[1] = date
    endif
endfunction        
function! Timeline(...)
    if a:0 > 0
        let spec = a:1
    else
        let spec = ''
    endif
    if bufname("%") == '__Agenda__'
        "go back up to main org buffer
        wincmd k
    endif
    let prev_spec = g:search_spec
    let prev_files = g:agenda_files
    exec "let g:agenda_files=['".expand("%")."']"
    call BufMinMaxDate()
    let num_days = 1 + calutil#jul(b:MinMaxDate[1]) - calutil#jul(b:MinMaxDate[0])
    try
        call RunAgenda(b:MinMaxDate[0], num_days,spec)
    finally
        let g:search_spec = prev_spec
        let g:agenda_files = prev_files
    endtry
endfunction

function! Pre0(s)
    return repeat('0',2 - len(a:s)) . a:s
endfunction

function! PrePad(s,amt,...)
    if a:0 > 0
        let char = a:1
    else
        let char = ' '
    endif
    return repeat(char,a:amt - len(a:s)) . a:s
endfunction
function! Pad(s,amt)
    return a:s . repeat(' ',a:amt - len(a:s))
endfunction

function! AgendaCompare(i0, i1)
    let mymstr = '^\(\d\+\)\s\+\(\S\+\)\s\+\(\%20c.\{11}\).*\(\*\+\)\s\(.*$\)'
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
                let str_ord = 'aa' . PrePad(1000-str2nr(item[3][6:8]),' ', '0')
            else
                let str_ord = 'ab000'
            endif
        elseif item[3][0] == 'I' 
            if matchstr(item[3],'-') > ''
                let str_ord = 'd-'.PrePad(1000-str2nr(matchstr(item[3],'\d\+')),3,'0')
            else
                let str_ord = 'da'.PrePad(matchstr(item[3],'\d\+'),3,'0')
            endif
        elseif item[3][0] == 'D'
            let str_ord = 'd0000'
        elseif item[3][0] == ' '
            let str_ord = 'zzzzz'
        else
            let str_ord = item[3][:4]
        endif
        call add(sched_comp,str_ord.item[2].PrePad(item[1],5,'0'))
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

function! DateListAdd(valdict)
    let namelist = [' GENERAL','SCHEDULED','CLOSED','DEADLINE']
    let templist = []
    call add(templist, get(a:valdict,'ud',0))
    call add(templist, get(a:valdict,'sd',0))
    call add(templist, get(a:valdict,'cd',0))
    call add(templist, get(a:valdict,'dd',0))
    let i = 0
    while i < 4
        if templist[i] != 0
            call add(g:datelist, templist[i] . ' ' . namelist[i] . ' ' . a:valdict.l )
        endif
        let i += 1
    endwhile
    return a:valdict
endfunction 

function! AgendaMove(direction)
    if a:direction == 'forward'
        if g:agenda_days == 1
            let g:agenda_startdate = calutil#cal(calutil#jul(g:agenda_startdate)+1)
        elseif g:agenda_days == 7
            let g:agenda_startdate = calutil#cal(calutil#jul(g:agenda_startdate)+7)
        else
            if g:agenda_startdate[5:6] == '12'
                let g:agenda_startdate = string(g:agenda_startdate[0:3] + 1).'-01-01'
            else
                let g:agenda_startdate = g:agenda_startdate[0:4].
                            \ Pre0(string(str2nr(g:agenda_startdate[5:6])+1)) .'-01'
            endif
            let g:agenda_days = DaysInMonth(g:agenda_startdate)
        endif
    else
        if g:agenda_days == 1
            let g:agenda_startdate = calutil#cal(calutil#jul(g:agenda_startdate)-1)
        elseif g:agenda_days == 7
            let g:agenda_startdate = calutil#cal(calutil#jul(g:agenda_startdate)-7)
        else
            if g:agenda_startdate[5:6] == '01'
                let g:agenda_startdate = string(g:agenda_startdate[0:3] - 1).'-12-01'
            else
                let g:agenda_startdate = g:agenda_startdate[0:4].
                            \ Pre0(string(str2nr(g:agenda_startdate[5:6]) - 1)) .'-01'
            endif
            let g:agenda_days = DaysInMonth(g:agenda_startdate)
        endif

    endif
    call RunAgenda(g:agenda_startdate,g:agenda_days,g:search_spec)
endfunction

function! TimeGrid(starthour,endhour,inc)
    let result = []
    for i in range(a:starthour, a:endhour,a:inc)
        call add(result,repeat(' ',19).Pre0(i).':00......       ------------')
    endfor
    return result
endfunction

function! MakeCalendar(date, daycount)
    "function! MakeCalendar(year, month, day, daycount)
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

        let g:agenda_date_dict[year . '-' . Pre0(month) .  '-' .  (day<10 ? '0'.day : day) ]
                    \ = {'marker': datetext, 'l': [] }
        let index = index + 1
        let day = day + 1
        let wd = wd + 1
    endwhile

endfunction

function! AgendaPutText(...)
    let save_cursor = getpos(".")
    let thisline = getline(line("."))
    if thisline =~ '^\d\+\s\+'
        if (getline(line(".") + 1) =~ '^\*\+ ')
            let file = matchstr(thisline,'^\d\+\s\+\zs\S\+\ze')
            let lineno = matchstr(thisline,'^\d\+\ze\s\+')
            let starttab = tabpagenr() 
            if bufwinnr(file) > -1
                execute bufwinnr(file).'wincmd w'
            else
                execute "tab drop " . file . '.org'
            endif
            "let confirmhead = g:agenda_head_lookup[dateline]
            if g:agenda_date_dict != {}
                let confirmhead = g:agenda_head_lookup[lineno]
            elseif g:adict != {}
                let confirmhead = lineno
            endif
            let newhead = matchstr(GetPlacedSignsString(bufnr("%")),'line=\zs\d\+\ze\s\+id='.confirmhead)
            execute newhead
            let lastline = OrgNextHead_l(newhead) - 1
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
                let resp = confirm("Heading has changed, save changes?","&Save\n&Cancel",1)
                if resp == 1
                    call SaveHeadline(file, confirmhead,getline(firstline,lastline))
                else
                    echo "Changes were _not_ saved."
                endif
            endif
        endif
    else
        echo "You're not on a headline line."
    endif
    call setpos(".",save_cursor)
endfunction
function! SaveHeadline(file, headline, lines)
    let file = a:file
    let headline = a:headline
    let lines=a:lines
    let starttab = tabpagenr() 
    if bufwinnr(file) > -1
        execute bufwinnr(file).'wincmd w'
    else
        execute "tab drop " . file . '.org'
    endif
    "let confirmhead = OrgGetHead_l(newhead)
    let newhead = matchstr(GetPlacedSignsString(bufnr("%")),'line=\zs\d\+\ze\s\+id='.headline)
    execute newhead

    let lastline = OrgNextHead_l(newhead) - 1
    execute newhead+1.','.lastline.'d'
    " don't delete orig headline b/c that's where sign is placed
    call setline(newhead,lines[0])
    call append(newhead,lines[1:])

    execute 'tabnext ' . starttab
    execute bufwinnr('Agenda').'wincmd w'

endfunction
function! AgendaGetText(...)
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
            let file = matchstr(thisline,'^\d\+\s\+\zs\S\+\ze')
            let lineno = matchstr(thisline,'^\d\+\ze\s\+')
            let starttab = tabpagenr() 
            if bufwinnr(file) > -1
                execute bufwinnr(file).'wincmd w'
            else
                execute "tab drop " . file . '.org'
            endif
            let save_cursor2 = getpos(".")
            "let confirmhead = OrgGetHead_l(headline)
            if g:agenda_date_dict != {}
                let confirmhead = g:agenda_head_lookup[lineno]
            elseif g:adict != {}
                let confirmhead = lineno
            endif
            let newhead = matchstr(GetPlacedSignsString(bufnr("%")),'line=\zs\d\+\ze\s\+id='.confirmhead)
            execute newhead
            if cycle_todo
                if a:0 >= 2
                    call ReplaceTodo(curTodo,newtodo)
                else
                    call ReplaceTodo(curTodo)
                endif
            else
                let lastline = OrgNextHead_l(newhead) - 1
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
            call AgendaPutText()
            silent execute firstline . ', ' . lastline . 'd'
        endif
    else
        echo "You're not on a headline line."
    endif
    call setpos(".",save_cursor)
    if cycle_todo
        if a:0 >= 2
            call ReplaceTodo(curTodo, newtodo)
        else
            call ReplaceTodo(curTodo)
        endif
        echo "Todo cycled."
    endif

endfunction

function! IsVisibleHeading(line)
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
                \ || ((fc < a:line) &&  IsText(fc) )
                \ || ((fc < a:line) &&  (foldclosedend(fc) < a:line) )
        "   \ || (Ind(a:line) == 2)
        return 1
    else    
        return 0
    endif
endfunction

function! SingleHeadingText(operation)
    " expand or collapse all visible Body Text
    " under Heading fold that cursor is in
    " operation:  "collapse" or "expand"
    " expand or collapse all Body Text 
    " currently visible under current heading
    let l:startline = line(".")
    let l:endline = OrgSubtreeLastLine_l(l:startline) - 1
    call BodyTextOperation(l:startline,l:endline,a:operation)
endfunction

function! StarLevelFromTo(from, to)
    let save_cursor = getpos(".")
    set fdm=manual
    let b:levelstars = a:to
    ChangeSyn
    g/^\*\+/call setline(line("."),substitute(getline(line(".")),'^\*\+','*' . 
                \ repeat('*',(len(matchstr(getline(line(".")),'^\*\+')) - 1) * a:to / a:from),''))
    set fdm=expr
    call setpos(".",save_cursor)
endfunction

function! StarsForLevel(level)
    return 1 + (a:level - 1) * b:levelstars
endfunction

function! OrgExpandLevelText(startlevel, endlevel)
    " expand regular text for headings by level
    let save_cursor = getpos(".")

    normal gg
    let startlevel = StarsForLevel(a:startlevel)
    let endlevel = StarsForLevel(a:endlevel)
    let l:mypattern = substitute(b:headMatchLevel,'level', startlevel . ',' . endlevel, "") 
    while search(l:mypattern, 'cW') > 0
        execute line(".") + 1
        while getline(line(".")) =~ b:drawerMatch
            execute line(".") + 1
        endwhile
        if IsText(line(".")) 
            normal zv
        endif
        "normal l
    endwhile

    call setpos('.',save_cursor)

endfunction

" just an idea using 'global' not used anywhere yet
" visible is problem, must operate only on visible, doesn't do ths now
function! BodyTextOperation3(startline,endline, operation)
    let l:oldcursor = line(".")
    let nh = 0
    call cursor(a:startline,0)
    g/\*\{4,}/DoAllTextFold(line("."))
    call cursor(l:oldcursor,0)

endfunction


function! BodyTextOperation(startline,endline, operation)
    " expand or collapse all Body Text from startline to endline
    " operation:  "collapse" or "expand"
    " save original line 
    let l:oldcursor = line(".")
    let nh = 0
    " go to startline
    call cursor(a:startline,0)
    " travel from start to end operating on any
    while 1
        if getline(line(".")) =~ b:headMatch
            if a:operation == "collapse"
                call DoAllTextFold(line("."))
            elseif a:operation == 'expand'
                normal zv
            endif
            "elseif IsText(line(".")+1) && foldclosed(line("."))==line(".")
            "elseif foldclosed(line("."))==line(".")
            "   "echo 'in expand area'
            "   if a:operation == 'expand'
            "       normal zv
            "   endif   
        endif
        let lastnh = nh
        let nh = NextVisibleHead(line("."))
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
  if a:year .'-'.Pre0(a:month).'-'.Pre0(a:day) == g:org_cal_date
	  return 1
  else
	  return 0
  endif
endfunction

function! DateEdit(type)
        let text = a:type
        let b:basetime=''
        let str = ''
        let filestr = ''
        let lineno=line('.')
        if bufname("%")==('__Agenda__')
            let lineno = matchstr(getline(line('.')),'^\d\+')
            let file = matchstr(getline(line('.')),'^\d\+\s*\zs\S\+').'.org'
            let str = ','.lineno.',"'.file.'"'
            let filestr = ',"'.file.'"'
        endif
        if text =~ 'DEADLINE'
            execute "let b:mdate = GetProp('DEADLINE'".str .")[1:-2]"
        elseif text =~ 'SCHEDULED'
            execute "let b:mdate = GetProp('SCHEDULED'".str .")[1:-2]"
        elseif text =~ 'CLOSED'
            execute "let b:mdate = GetProp('CLOSED'".str .")[1:-2]"
        else
            execute "let b:mdate = get(GetProperties(lineno,0".filestr."),'ud','')"
            if b:mdate > '' | let b:mdate .= ' '.calutil#dayname(b:mdate) | endif 
        endif
        let b:mdate = matchstr(b:mdate,'\d\d\d\d-\d\d-\d\d \S\S\S\( \d\d:\d\d\)\{}') 
        if b:mdate > ''
            let b:basedate = b:mdate[0:9]
            let b:baseday = b:mdate[11:13]
            if len(b:mdate) > 14
                let b:basetime = b:mdate[15:19]
            else
                let b:basetime = ''
            endif
        else
            let b:mdate=strftime("%Y-%m-%d %a")
        endif

        let basedate = b:basedate[0:9]
        let basetime = b:basetime
        let newdate = '<'.b:mdate[0:13].'>'
        let newtime = b:basetime
        hi Cursor guibg=black
        let cue = ''
        while 1
            echohl LineNr | echon 'Date+time ['.basedate . ' '.basetime.']: ' 
            echohl None | echon cue.'_   =>' | echohl WildMenu | echon ' '.newdate.' '.newtime
            let nchar = getchar()
            let newchar = nr2char(nchar)
            if newdate !~ 'interpret'
                let curdif = calutil#jul(newdate[1:10])-calutil#jul(Today())
                "call confirm ("newdate: ".newdate[1:10]."\nbasedate: ".basedate[0:9]."\ncurdif: ".curdif)
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
                redraw
                return
            else
                let cue .= newchar
            endif
            let newdate = GetNewDate(cue,basedate)
            if g:use_calendar && (match(newdate,'\d\d\d\d-\d\d')>=0)
                let g:org_cal_date = newdate[1:10]
                call Calendar(1,newdate[1:4],str2nr(newdate[6:7]))
            endif
            echon repeat(' ',72)
            redraw
        endwhile
        hi Cursor guibg=gray
        bdelete __Calendar
        if text =~ 'DEADLINE'
            silent execute "call SetProp('DEADLINE'".",'".newdate."'".str .")"
        elseif text =~ 'SCHEDULED'
            silent execute "call SetProp('SCHEDULED'".",'".newdate."'".str .")"
        elseif text =~ 'CLOSED'
            silent execute "call SetProp('CLOSED'".",'".newdate."'".str .")"
        else
            silent execute "call SetProp('ud'".",'".newdate."'".str .")"
        endif
        "echon repeat(' ',72)
        redraw
        echo 
        "call feedkeys("\<CR>")
endfunction

function! GetNewDate(cue,basedate)
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
                let newdate = calutil#cal(calutil#jul(basedate[0:7].Pre0(cue)))
            else 
                let newmonth = Pre0(basedate[5:6]+1)
                let newdate = calutil#cal(calutil#jul(basedate[0:4].newmonth.'-'.Pre0(cue)))
            endif
        elseif cue =~ '^\d\+[-/]\d\+$'
            " month/day string
            let month = matchstr(cue,'^\d\+')
            let day = matchstr(cue,'\d\+$')
            let year = basedate[0:3]
            if basedate[0:4] . Pre0(month) . '-' . Pre0(day) < basedate
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

            "       elseif cue =~ g:monthstring
            "           let mycount = matchstr(cue,'^\d\+')
            "           let mymonth = 
            "           let newday = index(g:weekdays,cue)
            "           let oldday = calutil#dow(basedate)
            "           if newday > oldday
            "               let amt=newday-oldday
            "           elseif newday < oldday
            "               let amt =7-oldday+newday
            "           else
            "               let amt = 7
            "           endif
            "           let newdate=calutil#cal(calutil#jul(basedate)+amt)
        elseif cue =~ g:weekdaystring
            " wed, 3tue, 5fri, i.e., dow string
            let mycount = matchstr(cue,'^\d\+')
            let myday = matchstr(cue,g:weekdaystring) 
            let newday = index(g:weekdays,myday)
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
                while calutil#cal(calutil#jul(year.'-'.Pre0(month).'-'.Pre0(day)))[5:6] != month
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

            let newdate = year . '-' . Pre0(month) . '-' . Pre0(day)
        else
            return " ?? can't interpret your spec"
        endif
        if timecue =~ '\d\d:\d\d'
            let mytime = ' '.timecue
        else
            let mytime = ''
        endif
        let mydow = calutil#dayname(newdate)
        return '<'.newdate.' '.mydow.mytime.'>'
endfunction

function! TimeInc(direction)
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
            "call DateInc(a:direction)
            "call setpos(".",tempsave)         
        endif
        let matchcol = col-i+2
        execute 's/\%'.matchcol.'c\zs\d\d:\d\d/' . Pre0(newhours) . ':' . Pre0(newminutes).'/'
    endif
    call setpos(".",save_cursor)
endfunction
function! DateInc(direction)
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
            call TimeInc(a:direction)
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
        execute 's/\%'.matchcol.'c\zs\d\d\d\d-\d\d-\d\d/' . newyear . '-' . Pre0(newmonth) . '-' . Pre0(newday).'/'
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

function! GetClock()
    return '['.strftime("%Y-%m-%d %a %H:%M").']'
endfunction 
function! ClockIn(...)
    let save_cursor=getpos(".")
    if a:0 > 1
        execute a:1
    endif
    execute OrgGetHead()
    if IsTagLine(line(".")+1)
        normal j
    endif
    exe 'normal o:CLOCK: ' . GetClock()

    call setpos(".",save_cursor)
endfunction
function! GotoOpenClock()
    "redir @x
    "silent marks C
    "redir END
    "let markfind = matchlist(@x,' \S\s\+\(\d\+\)\s\+\d\+\s\(.*\)')
    "if markfind[2] =~ '.*\.org' 
    "    call LocateFile(markfind[2])
    "endif:
    "silent execute markfind[1]
    let found = 0
    for file in g:agenda_files
        call LocateFile(file)
        let found = search('CLOCK: \[\d\d\d\d-\d\d-\d\d \S\S\S \d\d:\d\d\]\($\|\s\)','w')
        if found > 0
            execute found
            break
        endif
    endfor
    if found == 0
        call confirm("No open clock found.")
    endif
endfunction
function! ClockOut(...)
    if a:0 > 1
        execute a:1
    else
        call GotoOpenClock()
    endif
    execute OrgGetHead()
    let bottom = OrgNextHead() > 0 ? OrgNextHead() - 1 : line("$")
    let str = 'CLOCK: \[\d\d\d\d-\d\d-\d\d \S\S\S \d\d:\d\d\]\($\|\s\)'
    let found = Range_Search(str,'n',bottom,line("."))
    if found
        execute found
        execute 'normal A--' . GetClock() 
        if b:clock_to_logbook 
            let headline = OrgGetHead()
            let clockline = getline(line(".")) . ' -> ' . ClockTime(line("."))
            normal! dd
            call ConfirmDrawer("LOGBOOK",headline)
            let clockline = matchstr(getline(line(".")),'^\s*') . matchstr(clockline,'\S.*')
            call append(line("."),clockline )
        endif
    else
        echo 'No open clock found for this headline.'
    endif
endfunction
function! UpdateAllClocks()
    %g/^\s*:CLOCK:/call AddClockTime(line("."))
endfunction
function! AddClockTime(line)
    call setline(a:line,matchstr(getline(a:line),'.*\]') . ' -> ' . ClockTime(a:line))
endfunction

function! UpdateClockSums()
    let save_cursor = getpos(".")
    call UpdateAllClocks()
    g/^\s*:CLOCK:/call SetProp('ClockSum', SumClockLines(line(".")))
    call setpos(".",save_cursor)
endfunction

function! SumClockLines(line)
    let save_cursor = getpos(".")
    execute OrgGetHead_l(a:line) + 1
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
        normal j
    endwhile
    let totalminutes = (60 * hours) + minutes
    call setpos(".",save_cursor)
    return (totalminutes/60) . ':' . Pre0(totalminutes % 60)

endfunction

function! ClockTime(line)
    let ctext = getline(a:line)
    let start = matchstr(ctext,'CLOCK:\s*\[\zs\S\+\s\S\+\s\S\+\ze\]')
    let end = matchstr(ctext,'--\[\zs.*\ze\]')
    let daydifference = calutil#jul(end[0:9])-calutil#jul(start[0:9])
    let startmin = 60*start[15:16] + start[18:19]
    let endmin = 60*end[15:16] + end[18:19]
    let totalmin = (daydifference * 1440) + (endmin - startmin)
    return string(totalmin/60) . ':' . Pre0(totalmin % 60)
endfunction
function! AddTime(time1, time2)
    let hours = str2nr(matchstr(a:time1,'^.*\ze:')) + str2nr(matchstr(a:time2,'^.*\ze:'))
    let minutes = (60*hours) + a:time1[-2:] + a:time2[-2:]
    return (minutes/60) . ':' . (minutes % 60)
endfunction
function! GetProp(key,...)
    let save_cursor = getpos(".")
    if a:0 >=2
        let curtab = tabpagenr()
        let curwin = winnr()
    " optional args are: a:1 - lineno, a:2 - file
        call LocateFile(a:2)
    endif
    if (a:0 >= 1) && (a:1 > 0)
        execute a:1 
    endif
    execute OrgGetHead() + 1
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
function! SetDateProp(type,newdate,...)
    " almost identical to GetProp() above, need to refactor
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
function! SetProp(key, val,...)
    let save_cursor = getpos(".")
    if a:0 >=2
        let curtab = tabpagenr()
        let curwin = winnr()
        " optional args are: a:1 - lineno, a:2 - file
        call LocateFile(a:2)
    endif
    if (a:0 >= 1) && (a:1 > 0)
        execute a:1 
    endif
    let key = a:key
    let val = a:val
    execute OrgGetHead() 
    if key !~ 'DEADLINE\|SCHEDULED\|CLOSED\|ud'
        call ConfirmDrawer("PROPERTIES")
        while (getline(line(".")) !~ '^\s*:\s*' . key) && 
                    \ (getline(line(".")) =~ s:remstring)
            execute line(".") + 1
        endwhile

        if getline(line(".")) =~ s:remstring
            call setline(line("."), matchstr(getline(line(".")),'^\s*:') .
                        \ key . ': ' . val)
        else
            execute line(".") - 1
            call ConfirmDrawer("PROPERTIES")
            let curindent = matchstr(getline(line(".")),'^\s*')
            let newline = curindent . ':' . key . ': ' . val
            call append(line("."),newline)
        endif
    else
        if key=='ud' | let key='' | endif
        " find existing date line if there is one
        let foundline = Range_Search('^\s*\(:\)\{}'.key.'\s*:','n',OrgNextHead(),line("."))
        if foundline > 0
            exec foundline
            exec 's/:\s*<\d\d\d\d.*$/'.':'.a:val
        else
            let line_ind = len(matchstr(getline(line(".")),'^\**'))+1 + g:org_indent_from_head
            if IsTagLine(line('.')+1)
                normal j
            endif
            call append(line("."),Pad(' ',line_ind)
                        \ .':'.key.':'.a:val)
        endif
    endif

    "if exists("*Org_property_changed_functions") && (bufnr("%") != bufnr('Agenda'))
    "    let Hook = function("Org_property_changed_functions")
    "    silent execute "call Hook(line('.'),a:key, a:val)"
    "endif
    if a:0 >=2
        execute "tabnext ".curtab
        execute curwin . "wincmd w"
    endif
    call setpos(".",save_cursor)
endfunction

function! LocateFile(filename)
    let myvar = ''
    tabdo let myvar = bufwinnr(a:filename) > 0 ? tabpagenr() . ' ' . bufwinnr(a:filename) : myvar
    if myvar > ''
        silent execute split(myvar)[0] . "tabn"
        silent execute split(myvar)[1] . "wincmd w"
    else
        execute 'tab drop ' . a:filename
    endif
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

function! ConfirmDrawer(type,...)
    let line = OrgGetHead()
    if a:0 == 1
        let line = a:1
    endif
    execute line
    let bottom = OrgNextHead() > 0 ? OrgNextHead() - 1 : line("$")
    let found = Range_Search(':\s*'. a:type . '\s*:','n',bottom,line)
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

function! MouseDate()
    let @x=''
    let date=''
    let save_cursor = getpos(".")
    let found = ''
    let col = getpos(".")[2]
    "  check for date string within brackets
    normal! vi<"xy
    if len(@x) < 7 
        normal! vi["xy
    endif
    if (len(@x)>=10) && (len(@x)<20)
        let date = matchstr(@x,'\d\d\d\d-\d\d-\d\d')
    endif
    if date > ''
        let found='date'
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
        call RunAgenda(date,7)
        call feedkeys("")
    elseif found == 'tag'
        call RunSearch('+'.@x)
        call feedkeys("")
    else
        echo 'Nothing found to search for.'
    endif

endfunction
function! SetColumnHead()

    let result = ''
    let i = 0
    while i < len(g:colview_list)
        let result .= '|' . PrePad(g:colview_list[i] , g:colview_list[i+1]) . ' ' 
        let i += 2
    endwhile
    let g:ColumnHead = result[:-2]
endfunction

function! GetColumns(line)
    let props = GetProperties(a:line,0)
    let result = ''
    let i = 0
    while i < len(g:colview_list)
        let result .= '|' . PrePad(get(props,g:colview_list[i],'') , g:colview_list[i+1]) . ' ' 
        let i += 2
    endwhile
    if get(props,'Columns') > ''
        let g:colview_list=split(props['Columns'],',')
    endif
    return result[:-2]

endfunction
function! ToggleColumnView()

    "au! BufEnter ColHeadBuffer call ColHeadBufferEnter()
    if b:columnview
        let winnum = bufwinnr('ColHeadBuffer')
        if winnum > 0 
            execute "bd" . bufnr('ColHeadBuffer')
            "wincmd c
        endif
        let b:columnview = 0
    else
        call ColHeadWindow()
        let b:columnview = 1
    endif   
endfunction
function! <SID>ColumnStatusLine()
    let part2 = PrePad(g:ColumnHead, winwidth(0)-12) 
    return '      ITEM ' .  part2
endfunction
function! AdjustItemLen()
    "if exists('b:columnview') && b:columnview 
    let g:item_len = winwidth(0) - 10 - len(g:ColumnHead)
    "endif
endfunction
au VimResized * call AdjustItemLen()

function! <SID>CalendarChoice(day, month, year, week, dir)
    "call add(g:templist,a:year.'-' . a:month.'-'.a:day.'-'.a:week)
    let g:agenda_startdate = a:year.'-' . Pre0(a:month).'-'.Pre0(a:day) 
    call RunAgenda(g:agenda_startdate, g:agenda_days,g:search_spec)
endfunction
function! <SID>CalendarInsertDate(day, month, year, week, dir)
    execute bufwinnr(g:calbuffer).'wincmd w'
    let date = a:year.'-' . Pre0(a:month).'-'.Pre0(a:day)
    let day = calutil#dayname(date)
    let dateval = '<'.date.' '.day.'>'
    if @d =~ 'DEADLINE\|SCHEDULED\|CLOSED'
        call SetProp(@d,dateval)
    else
        let @d = '<'.date.' '.day.'>'
        normal "dp
    endif
    execute "bd".bufnr('__Calendar')
    normal 0
endfunction
function! s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

function! MyPopup()
    call feedkeys("i\<c-x>\<c-u>")
endfunction

let g:calendar_action = '<SNR>' . s:SID() .'_CalendarChoice'
let b:ColorList=['purple', 'green', 'white', 'black','blue','red','orange','green']
function! CompleteOrg(findstart, base)
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
        execute "let proplist = b:" . prop . 'List' 
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


function! MyFoldText(...)
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
    let myind = Ind(foldstart)

    let v:foldhighlight = hlID(b:foldcolors[myind])

    "if Ind(v:foldstart) == v:foldlevel - 3
    "   let l:txtmrk = 'd-'
    "elseif Ind(v:foldstart) == v:foldlevel - 2
    "   let l:txtmrk = 't-'
    "   if getline(v:foldstart + 1)  =~ '^\s*:'
    "       let l:txtmrk = 'd' . l:txtmrk
    "   endif
    "else
    let l:txtmrk = ''
    "endif  
    " get rid of header prefix
    let l:line = substitute(l:line,'^\*\+\s*','','g')
    let l:line = repeat(' ', Starcount(foldstart)+1) . l:line 

    if l:line =~ b:drawerMatch
        let v:foldhighlight = hlID('Title')
        let l:line = repeat(' ', len(matchstr(l:line,'^ *'))-1)
                    \ . matchstr(l:line,'\S.*$') 
        "elseif origline !~ b:headMatch
        "   let v:foldhighlight = hlID('Normal')
        "   let l:line = repeat(' ', len(matchstr(l:line,'^ *'))-1)
        "           \ . '(TEXT)'
    elseif l:line[0] == '#'
        let v:foldhighlight = hlID('VisualNOS')
    else
        let l = g:item_len
        let line = line[:l]
    endif
    if exists('w:sparse_on') && w:sparse_on && (a:0 == 0) 
        let b:signstring= GetPlacedSignsString(bufnr("%")) 
        if match(b:signstring,'line='.v:foldstart.'\s\sid=\d\+\s\sname=fbegin') >=0
        "if index(b:sparse_list,v:foldstart) > -1            "v:foldstart == 10
            let l:line = '* * * * * * * * * * * ' . (v:foldend - v:foldstart) . ' lines skipped here * * * * * * *'
            let l:line .= repeat(' ', winwidth(0)-len(l:line)-28) . 'SPARSETREE SKIP >>'
            let v:foldhighlight = hlID('TabLineFill')
        endif
    endif
    if g:show_fold_dots 
        let l:line .= '...'
    endif
    if b:columnview && (origline =~ b:headMatch) 
        let l:line .= PrePad(GetColumns(foldstart), winwidth(0)-len(l:line) -3)
    endif
    if !a:0 && g:show_fold_lines && !b:columnview 
        let l:line .= PrePad("(" . PrePad(l:txtmrk . (v:foldend - v:foldstart) . ")",5),
                    \ winwidth(0)-len(l:line) - 3) 
    endif

    return l:line
endfunction
function! MySort(comppattern) range
    let b:sortcompare = a:comppattern
    let b:complist = ['\s*\S\+','\s*\S\+\s\+\zs\S\+','\s*\(\S\+\s\+\)\{2}\zs\S\+'
                \ , '\s*\(\S\+\s\+\)\{3}\zs\S\+'
                \ , '\s*\(\S\+\s\+\)\{4}\zs\S\+'
                \ , '\s*\(\S\+\s\+\)\{5}\zs\S\+'
                \ , '\s*\(\S\+\s\+\)\{6}\zs\S\+']
    let mylines = getline(a:firstline, a:lastline)
    let mylines = sort(mylines,"BCompare")
    call setline(a:firstline, mylines)
    unlet b:sortcompare
    unlet b:complist
endfunction

function! BCompare(i1,i2)
    if !exists('b:sortcompare')
        echo 'b:sortcompare is not defined'
        return
    endif
    let i = 0

    while i < len(b:sortcompare)
        " prefix an item by 'n' if you want numeric sorting
        if (i < len(b:sortcompare) - 1) && (b:sortcompare[i] == 'n')
            let i = i + 1
            let m1 = str2nr(matchstr(a:i1,b:complist[b:sortcompare[i]-1])) 
            let m2 = str2nr(matchstr(a:i2,b:complist[b:sortcompare[i]-1]))
        else
            let m1 = matchstr(a:i1,b:complist[b:sortcompare[i]-1]) 
            let m2 = matchstr(a:i2,b:complist[b:sortcompare[i]-1])
        endif
        if m1 == m2
            if i == len(b:sortcompare) - 1
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
function! InsertDate(ba)
    " Insert today's date.
    let @x = strftime("%Y-%m-%d")
    if a:ba == "0"
        normal! "xp
    else
        normal! "xP
    endif
endfunction

function! InsertSpaceDate()
    " Insert a space, then today's date.
    let @x = " "
    let @x = @x . strftime("%Y-%m-%d")
    normal! "xp
endfunction

function! InsertTime(ba)
    " Insert the time.
    let @x = strftime("%T")
    if a:ba == "0"
        normal! "xp
    else
        normal! "xP
    endif
endfunction

function! InsertSpaceTime()
    " Insert a space, then the time.
    let @x = " "
    let @x = @x . strftime("%T")
    normal! "xp
endfunction

function! s:OrgShowMatch(cycleflag)
    "wincmd k
    " first, make sure agenda buffer has same heading pattern
    " and todo list as main buffer
    call GotoMainWindow()
    let l:headMatch = b:headMatch
    let l:todoitems = b:todoitems
    "wincmd j
    call GotoAgendaWindow()
    let b:headMatch = l:headMatch
    let b:todoitems = l:todoitems
    if a:cycleflag
        call OrgToggleTodo(line("."))
    endif
    "let g:showndx = line(".")-1
    if getline(line(".")) =~ '^\d\+'
        let g:showndx = matchlist(getline(line(".")),'^\d\+')[0]
        execute "let b:sparse_list = [" . g:showndx . ']'
    endif
    "wincmd k
    call GotoMainWindow()
    call ExpandWithoutText(1)
    execute g:showndx
    "execute g:alines[g:showndx]
    normal zv
    if a:cycleflag
        call OrgToggleTodo(line("."))
    endif
    if getline(line(".")) =~ b:headMatch
        call BodyTextOperation(line("."),OrgNextHead(),'collapse')
    endif
    "wincmd j
    call GotoAgendaWindow()
endfunction
command! MySynch call <SID>OrgShowMatch(0)
command! MySynchCycle call <SID>OrgShowMatch(1)
command! MyAgendaToBuf call <SID>OrgAgendaToBufTest()
command! AgendaMoveToBuf call OrgAgendaToBuf()

function! s:OrgAgendaToBufTest()
    " this loads unfolded buffer into same window as Agenda
    if getline(line(".")) =~ '^\d\+'
        let g:showndx = matchlist(getline(line(".")),'^\d\+')[0]
        let g:tofile = matchlist(getline(line(".")),'^\d\+\s*\(\S\+\)')[1]
    endif
    let cur_buf = bufnr("%")
    let g:folds=0
    let newbuf = bufnr(g:tofile)
    execute "b"newbuf
    execute g:showndx
    let g:folds=1
endfunction
function! OrgAgendaToBuf()
    let win = bufwinnr('Calendar')
    if win >= 0 
        execute win . 'wincmd w'
        wincmd c
        execute bufwinnr('Agenda').'wincmd w'
    endif   

    if getline(line(".")) =~ '^\d\+'
        let g:showndx = matchlist(getline(line(".")),'^\d\+')[0]
        let g:tofile = matchlist(getline(line(".")),'^\d\+\s*\(\S\+\)')[1]
    endif
    let ag_line = line(".")
    let ag_height = winheight(0)
    let cur_buf = bufnr("%")  " should be Agenda
    close!
    "execute "tab drop " . g:tofile . '.org'
    call LocateFile(g:tofile . '.org')
    if &fdm != 'expr'
        set fdm=expr
    endif
    split
    "wincmd J
    execute "b"cur_buf
    "execute "tab drop " . g:tofile . '.org'
    "call LocateFile(g:tofile . '.org')
    wincmd x
    "let new_buf=bufnr("%")
    execute g:showndx
    "setlocal cursorline
    set foldlevel=1
    normal! zv
    normal! z.
    wincmd j
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

function! OrgSource()
    unlet g:org_loaded
    source $VIM/vimfiles/ftplugin/org.vim
endfunction

function! OrgSetLevel(startlevel, endlevel)
    "call ExpandWithoutText(a:endlevel)
    call OrgExpandLevelText(a:startlevel, a:endlevel)
endfunction

function! Starcount(line)
    " used to get number of stars for a heading
    return (len(matchstr(getline(a:line),'^\**\s'))-1)
endfunction

function! GotoAgendaWindow()
    wincmd b
    silent execute "b __Agenda__"
endfunction

function! GotoMainWindow()
    wincmd t
endfunction

function! Ind(line) 
    " used to get level of a heading (todo : rename this function)
    "return 1 + (len(matchstr(getline(a:line),'^\**\s'))-1)/b:levelstars  
    return 2 + (len(matchstr(getline(a:line),'^\**\s'))-2)/b:levelstars  

endfunction

function! DoAllTextFold(line)
    "let d = inputdialog('in fullfold')
    if IsText(a:line+1) == 0
        return 
    endif
    while ((NextVisibleHead(a:line) != foldclosedend(a:line) + 1) 
                \ && (foldclosedend(a:line) <= line("$"))
                \ && (NextVisibleHead(a:line) != 0)
                \ && (MyFoldLevel(a:line) =~ '>')) 
                \ || (foldclosedend(a:line) < 0)  
                \ || ((NextVisibleHead(a:line)==0) && (OrgSubtreeLastLine() == line('$')) && (foldclosedend(a:line)!=line('$')))
        call DoSingleFold(a:line)
    endwhile
endfunction

function!  DoSingleFold(line)
    if (foldclosed(a:line) == -1) "&& (getline(a:line+1) !~ b:headMatch)
        if (getline(a:line+1) !~ b:headMatch) || (Ind(a:line+1) > Ind(a:line))
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
        if (cur_end >= line("$")) || (MyFoldLevel(cur_end+1) == '<0')
            return
        endif
        if getline(cur_end+1) =~ b:drawerMatch
            "while (foldclosedend(a:line) == cur_end) && (runaway_count < 10)
            while (foldclosedend(a:line) == cur_end) && (cur_end != line("$"))
                let runaway_count += 1
                normal! zc
            endwhile
        elseif getline(cur_end+1) !~ b:headMatch
            "while (foldclosedend(a:line) == cur_end) && (runaway_count < 10)
            while (foldclosedend(a:line) == cur_end) && (cur_end <= line("$"))
                let runaway_count += 1
                normal! zc
            endwhile
        elseif (getline(cur_end+1) =~ b:headMatch) && (Ind(cur_end+1) > Ind(a:line))
            while (foldclosedend(a:line) == cur_end) && (cur_end != line("$"))
                "   let runaway_count += 1
                normal! zc
            endwhile
        endif
    endif
endfunction


function! MyFoldLevel(line)
    " Determine the fold level of a line.
    if g:folds == 0
        return 0
    endif
    let l:text = getline(a:line)
    "if l:text =~ b:headMatch
    if l:text[0] == '*'
        let b:myAbsLevel = Ind(a:line)
    endif
    let l:nextAbsLevel = Ind(a:line+1)
    let l:nexttext = getline(a:line + 1)

    " STUFF FOR SPARSE TREE LEVELS
    if exists('w:sparse_on') && w:sparse_on  
        if g:first_sparse==0    
            let b:signstring= GetPlacedSignsString(bufnr("%")) 
            if match(b:signstring,'line='.(a:line+1).'\s\sid=\d\+\s\sname=fbegin') >=0
                return '<0'
            endif
            if match(b:signstring,'line='.a:line.'\s\sid=\d\+\s\sname=fbegin') >=0
                return '>99'
            elseif match(b:signstring,'line='.a:line.'\s\sid=\d\+\s\sname=fend') >=0
                return '<0'
            endif
        else
            if index(b:sparse_list,a:line+1) >= 0
                return '<0'
            endif
            let sparse = index(b:sparse_list,a:line)
            if sparse >= 0
                return '>20'
            endif
            let sparse = index(b:fold_list,a:line)
            if sparse >= 0
                return '<0' 
            endif
        endif
    endif

    "if l:text =~ b:headMatch
    if l:text[0] == '*'
        " we're on a heading line

        " propmatch line is new (sep 27) need ot test having different
        " value for propmatch and deadline lines
        if l:nexttext =~ b:drawerMatch
            let b:lev = '>' . string(b:myAbsLevel + 4)
        elseif l:nexttext =~ s:remstring
            let b:lev = '>' . string(b:myAbsLevel + 6)
        elseif l:nexttext !~ b:headMatch
            let b:lev = '>' . string(b:myAbsLevel + 3)
        elseif l:nextAbsLevel > b:myAbsLevel
            "let b:lev = '>20'
            "let b:lev = '>' . string(l:nextAbsLevel)
            let b:lev = '>' . string(b:myAbsLevel)
        elseif l:nextAbsLevel < b:myAbsLevel
            let b:lev = '<' . string(l:nextAbsLevel)
        else
            let b:lev = '<' . b:myAbsLevel
        endif
        let b:prevlev = b:myAbsLevel

    else    
        "we have a text line 
        if b:lastline != a:line - 1    " backup to headline to get bearings
            let b:prevlev = Ind(OrgPrevHead_l(a:line))
        endif

        if l:text =~ b:drawerMatch
            let b:lev = '>' . string(b:prevlev + 4)
        elseif l:text =~ s:remstring
"            if (getline(a:line - 1) =~ b:headMatch) && (l:nexttext =~ s:remstring)
"                let b:lev =  string(b:prevlev + 5)
"                "let b:lev = '>' . string(b:prevlev + 5)
"            elseif (l:nexttext !~ s:remstring) || 
"                        \ (l:nexttext =~ b:drawerMatch) 
"                let b:lev = '<' . string(b:prevlev + 4)
"                "let s:firsttext = '>'
            if (getline(a:line - 1) =~ b:headMatch) 
                let b:lev = '>' . string(b:prevlev + 4)
            else
                let b:lev = b:prevlev + 4
            endif
        elseif l:text[0] != '#'
            let b:lev = (b:prevlev + 2)
        elseif b:src_fold  
            if l:text =~ '^#+begin_src'
                let b:lev = '>' . (b:prevlev + 2)
            elseif l:text =~ '^#+end_src'
                let b:lev = '<' . (b:prevlev + 2)
            endif
        else 
            let b:lev = (b:prevlev + 2)
        endif   

        "if l:nexttext =~ b:headMatch
        if l:nexttext[0] == '*'
            let b:lev = '<' . string(l:nextAbsLevel)
        endif
    endif   
    let b:lastline = a:line
    return b:lev    

endfunction

function! AlignSection(regex,skip,extra) range
    " skip is first part of regex, 'regex' is part to match
    " they must work together so that 'skip.regex' is matched
    " and the point where they connect is where space is inserted
    let extra = a:extra
    let sep = empty(a:regex) ? '=' : a:regex
    let minst = 999
    let maxst = 0
    let b:stposd = {}
    let section = getline(a:firstline, a:lastline)
    for line in section
        let stpos = matchend(line,a:skip)   
        let b:stposd[index(section,line)]=stpos
        if maxst < stpos
            let maxst = stpos
        endif
        let stpos = len(matchstr(matchstr(line,a:skip),'\s*$'))
        if minst > stpos
            let minst = stpos
        endif
    endfor
    call map(section, 'AlignLine(v:val, sep, a:skip, minst, maxst - matchend(v:val,a:skip), extra)')
    call setline(a:firstline, section)
endfunction

function! AlignLine(line, sep, skip, maxpos, offset, extra)
    let b:m = matchlist(a:line, '\(' .a:skip . '\)\('.a:sep.'.*\)')
    if empty(b:m)
        return a:line
    endif
    let spaces = repeat(' ',  a:offset + a:extra)
    exec 'return b:m[1][:-' . a:maxpos .'] . spaces . b:m[3]'
endfunction
function! AlignSectionR(regex,skip,extra) range
    let extra = a:extra
    let sep = empty(a:regex) ? '=' : a:regex
    let minst = 999
    let maxpos = 0
    let maxst = 0
    let b:stposd = {}
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
    call map(section, 'AlignLine(v:val, sep, a:skip, minst, maxpos - matchend(v:val,a:skip.sep) , extra)')
    call setline(a:firstline, section)
endfunction
function! ColHeadWindow()
    au! BufEnter ColHeadBuffer
    let s:AgendaBufferName = 'ColHeadBuffer'
    call s:AgendaBufferOpen(1)
    let s:AgendaBufferName = '__Agenda__'
    call s:AgendaBufSetup()
    "set nobuflisted
    call SetColumnHead()
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
    au BufEnter ColHeadBuffer call ColHeadBufferEnter()
endfunction

function! ColHeadBufferEnter()
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
            exe "new " . s:AgendaBufferName
        else
            exe "edit " . s:AgendaBufferName
        endif
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
            " Create a new scratch buffer
            if split_win
                exe "split +buffer" . scr_bufnum
            else
                exe "buffer " . scr_bufnum
            endif
        endif
    endif
endfunction

function! CaptureBuffer()
    let w:prevbuf=bufnr("%")
    sp _Capture_
    normal ggVGd
    normal i** 
    silent exec "normal o<".Timestamp().">"
    call s:AgendaBufSetup()
    command! -buffer W :call ProcessCapture()
    normal gg$a
    
endfunction
function! ProcessCapture()
    normal ggVG"xy
    execute "tab drop ".g:capture_file
    normal gg
    call search('^\* Agenda')
    execute OrgSubtreeLastLine()
    normal p
    normal gg
    silent write
    redo
    call LocateFile('_Capture_')
    execute "bd"
endfunction

function! s:AgendaBufSetup()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
    setlocal fdc=1
endfunction
function! Emacs2PDF()
    silent !"c:program files (x86)\emacs\emacs\bin\emacs.exe" -batch --visit=newtest3.org --funcall org-export-as-pdf
    "silent !c:\sumatra.exe newtest3.org
endfunction
function! Today()
    return strftime("%Y-%m-%d")
endfunction
function! AgendaDashboard()
	echo " Press key for an agenda command:"
	echo " --------------------------------"
	echo " a   Agenda for current week or day"
	echo " t   List of all TODO entries"
	echo " m   Match a TAGS/PROP/TODO query"
	echo " L   Timeline for current buffer"
	echo " s   Search for keywords"
	echo " "
	echo " f   Sparse tree of: " . g:search_spec
	echo " "
    let key = nr2char(getchar())

    if key == 't'
        redraw
        silent execute "call RunSearch('+ALL_TODOS','agenda_todo')"
    elseif key == 'a'
        redraw
        silent execute "call RunAgenda(Today(),7)"
    elseif key == 'L'
        redraw
        silent execute "call Timeline()"
    elseif key == 'm'
        redraw
        let mysearch = input("Enter search string: ")
        silent execute "call RunSearch(mysearch)"
    elseif key == 'f'
        redraw
        let mysearch = input("Enter search string: ",g:search_spec)
        if bufname("%")=='__Agenda__'
            :bd
        endif
        silent execute "call RunSearch(mysearch,1)"
    endif
endfunction

function! s:AgendaBufHighlight()
    hi Overdue guifg=red
    hi Upcoming guifg=yellow
    hi DateType guifg=#dd66bb
"    hi Todos guifg=pink
    hi Dayline guifg=#44aa44 gui=underline
    hi Weekendline guifg=#55ee55 gui=underline
   " let todoMatchInAgenda = '\s*\*\+\s*\zs\(TODO\|DONE\|STARTED\)\ze'
    let daytextpat = '^[^S]\S\+\s\+\d\{1,2}\s\S\+\s\d\d\d\d.*'
    let wkendtextpat = '^S\S\+\s\+\d\{1,2}\s\S\+\s\d\d\d\d.*'
    call matchadd( 'OL1', '\*\{1} .*$' )
    call matchadd( 'OL2', '\*\{2} .*$') 
    call matchadd( 'OL3', '\*\{3} .*$' )
    call matchadd( 'OL4', '\*\{4} .*$' )
    call matchadd( 'OL5', '\*\{5} .*$' )
    
    call matchadd( 'Overdue', '^\S*\s*\S*\s*\(In\s*\zs-\S* d.\ze:\|Sched.\zs.*X\ze:\)')
    call matchadd( 'Upcoming', '^\S*\s*\S*\s*In\s*\zs[^-]* d.\ze:')
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
"syntax match TODO '^.*\* \zsTODO' containedin=OL1,OL2,OL3,OL4
"syntax match STARTED '^.*\* \zsSTARTED'
"syntax match DONE '^.*\* \zsDONE'
    hi TODO guifg=red guibg=NONE
    hi STARTED guifg=yellow
    hi DONE guifg=green
    hi CANCELED guifg=red
    map <silent> <buffer> <localleader>tt :call AgendaGetText(1,'TODO')<cr>
    map <silent> <buffer> <localleader>ts :call AgendaGetText(1,'STARTED')<cr>
    map <silent> <buffer> <localleader>td :call AgendaGetText(1,'DONE')<cr>
    map <silent> <buffer> <localleader>tc :call AgendaGetText(1,'CANCELED')<cr>
    map <silent> <buffer> <localleader>tn :call AgendaGetText(1,'NEXT')<cr>
    map <silent> <buffer> <localleader>tx :call AgendaGetText(1,'')<cr>
endfunction
function! CurTodo(line)
    let result = matchstr(getline(a:line),'.*\* \zs\S\+\ze ')`
    if index(b:todoitems,curtodo) == -1
        let result = ''
    endif
    return result
endfunction

"autocmd CursorHold * call Timer()
function! Timer()
    call feedkeys("f\e")
    " K_IGNORE keycode does not work after version 7.2.025)
    echo strftime("%c")
    " there are numerous other keysequences that you can use
endfunction

autocmd BufNewFile __Agenda__ call s:AgendaBufSetup()
autocmd BufWinEnter __Agenda__ call s:AgendaBufHighlight()
" Command to edit the scratch buffer in the current window
command! -nargs=0 Agenda call s:AgendaBufferOpen(0)
" Command to open the scratch buffer in a new split window
command! -nargs=0 AAgenda call s:AgendaBufferOpen(1)

function! ExportToPDF()
    let mypath = '"c:\program files (x86)\emacs\emacs\bin\emacs.exe" -batch --visit='
    let part2 = ' --funcall org-export-as-pdf'
    silent execute '!'.mypath.expand("%").part2
    "call inputdialog("just waiting to go forward. . . ")
    silent execute '!'.expand("%:r").'.pdf'
endfunction
function! ExportToHTML()
    let mypath = '"c:\program files (x86)\emacs\emacs\bin\emacs.exe" -batch --visit='
    let part2 = ' --funcall org-export-as-html'
    silent execute '!'.mypath.expand("%").part2
    "call inputdialog("just waiting to go forward. . . ")
    silent execute '!'.expand("%:r").'.html'
endfunction

function! MailLookup()
    Utl openlink https://mail.google.com/mail/?hl=en&shva=1#search/after:2010-10-24+before:2010-10-26
    "https://mail.google.com/mail/?hl=en&shva=1#search/after%3A2010-10-24+before%3A2010-10-26
endfunction
function! Intersect(list1, list2)
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
set foldtext=MyFoldText()

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

" Key Mappings
" insert the date
nmap <buffer> <localleader>d $:call InsertSpaceDate()<cr>
imap <buffer> <localleader>d ~<esc>x:call InsertDate(0)<cr>a
nmap <buffer> <localleader>D ^:call InsertDate(1)<cr>a <esc>

" below block of 10 or 15 maps are ones collected
" from body of doc that weren't getting assigned for docs
" oepened after initial org filetype doc
nmap <silent> <buffer> <tab> :call Cycle()<cr>
nmap <silent> <buffer> <s-tab> :call GlobalCycle()<cr>
nmap <silent> <buffer> <localleader>ci :call ClockIn(line("."))<cr>
nmap <silent> <buffer> <localleader>co :call ClockOut()<cr>
"cnoremap <space> <C-\>e(<SID>DateEdit())<CR>
map <silent> <localleader>dr :call DateEdit('ud')<cr>
map <silent> <localleader>dd :call DateEdit('DEADLINE')<cr>
map <silent> <localleader>dc :call DateEdit('CLOSED')<cr>
map <silent> <localleader>ds :call DateEdit('SCHEDULED')<cr>
map <silent> <localleader>a* :call RunAgenda(strftime("%Y-%m-%d"),7,'')<cr>
map <silent> <localleader>aa :call RunAgenda(strftime("%Y-%m-%d"),7,'+ANYTODO')<cr>
map <silent> <localleader>at :call RunAgenda(strftime("%Y-%m-%d"),7,'+NOTDONETODO')<cr>
map <silent> <localleader>ad :call RunAgenda(strftime("%Y-%m-%d"),7,'+DONE')<cr>
map <silent> <buffer> <localleader>tt :call OrgToggleTodo(line('.'),'t')<cr>
map <silent> <buffer> <localleader>ts :call OrgToggleTodo(line('.'),'s')<cr>
map <silent> <buffer> <localleader>td :call OrgToggleTodo(line('.'),'d')<cr>
map <silent> <buffer> <localleader>tc :call OrgToggleTodo(line('.'),'c')<cr>
map <silent> <buffer> <localleader>tn :call OrgToggleTodo(line('.'),'n')<cr>
map <silent> <buffer> <localleader>tx :call OrgToggleTodo(line('.'),'x')<cr>
map <silent> <localleader>ag :call AgendaDashboard()<cr>
"map <localleader>ar :startofbasedateedit 
"map <localleader>ad :start_DEADLINE_edit 
"map <localleader>ac :start_CLOSED_edit 
"map <localleader>as :start_SCHEDULED_edit 
nmap <silent> <buffer> <s-up> :call DateInc(1)<CR>
nmap <silent> <buffer> <s-down> :call DateInc(-1)<CR>
nnoremap <silent> <buffer> <2-LeftMouse> <LeftMouse>:call MouseDate()<CR>
nmap <localleader>pl :call MyPopup()<cr>
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
"map <localleader>a :CalendarH<CR>|:let g:calendar_action='<SNR>'.s:SID().'_CalendarInsertDate'<CR> | :startofbasedateedit 
map <localleader>b  :call ShowBottomCal()<cr> 
" insert the time
"nmap <buffer> <localleader>t $:call InsertSpaceTime()<cr>
"imap <buffer> <localleader>t ~<esc>x:call InsertTime(0)<cr>a
"nmap <buffer> <localleader>T ^:call InsertTime(1)<cr>a <esc>
"nmap <silent> <buffer> <localleader>t :call AddTag(line("."))<cr>
nmap <silent> <buffer> <localleader>et :call TagInput(line("."))<cr>

" clear search matching
nmap <silent> <buffer> <localleader>cs :let @/=''<cr>

map <buffer>   <C-K>         <C-]>
map <buffer>   <C-N>         <C-T>
map <buffer>   <localleader>0          :call ExpandWithoutText(99999)<CR>
map <buffer>   <localleader>9          :call ExpandWithoutText(9)<CR>
map <buffer>   <localleader>8          :call ExpandWithoutText(8)<CR>
map <buffer>   <localleader>7          :call ExpandWithoutText(7)<CR>
map <buffer>   <localleader>6          :call ExpandWithoutText(6)<CR>
map <buffer>   <localleader>5          :call ExpandWithoutText(5)<CR>
map <buffer>   <localleader>4          :call ExpandWithoutText(4)<CR>
map <buffer>   <localleader>3          :call ExpandWithoutText(3)<CR>
map <buffer>   <localleader>2          :call ExpandWithoutText(2)<CR>
map <buffer>   <localleader>1          :call ExpandWithoutText(1)<CR>
map <buffer>   <localleader>,0           :set foldlevel=99999<CR>
map <buffer>   <localleader>,9           :call OrgSetLevel (1,9)<CR>
map <buffer>   <localleader>,8           :call OrgSetLevel (1,8)<CR>
map <buffer>   <localleader>,7           :call OrgSetLevel (1,7)<CR>
map <buffer>   <localleader>,6           :call OrgSetLevel (1,6)<CR>
map <buffer>   <localleader>,5           :call OrgSetLevel (1,5)<CR>
map <buffer>   <localleader>,4           :call OrgSetLevel (1,4)<CR>
map <buffer>   <localleader>,3           :call OrgSetLevel (1,3)<CR>
map <buffer>   <localleader>,2           :call OrgSetLevel (1,2)<CR>
map <buffer>   <localleader>,1           :call OrgSetLevel (1,1)<CR>
map  <localleader>wj           :wincmd j<CR>
map  <localleader>wl           :wincmd l<CR>
map  <localleader>wh           :wincmd h<CR>
map  <localleader>wk           :wincmd k<CR>

imap <silent> <buffer>   <s-c-CR>               <c-r>=NewHead('levelup',1)<CR>
imap <silent> <buffer>   <c-CR>               <c-r>=NewHead('leveldown',1)<CR>
imap <silent> <buffer>   <s-CR>               <c-r>=NewHead('same',1)<CR>
nmap <silent> <buffer>   <s-c-CR>               :call NewHead('levelup')<CR>
nmap <silent> <buffer>   <c-CR>               :call NewHead('leveldown')<CR>
nmap <silent> <buffer>   <s-CR>               :call NewHead('same')<CR>
nmap <silent> <buffer>   <CR>               :call NewHead('same')<CR>
map <silent> <buffer>   <c-left>               :call ShowLess(line("."))<CR>
map <silent> <buffer>   <c-right>            :call ShowMore(line("."))<CR>
map <silent> <buffer>   <c-a-left>               :call MoveLevel(line("."),'left')<CR>
map <silent> <buffer>   <c-a-right>             :call MoveLevel(line("."),'right')<CR>
map <silent> <buffer>   <c-a-up>               :call MoveLevel(line("."),'up')<CR>
map <silent> <buffer>   <c-a-down>             :call MoveLevel(line("."),'down')<CR>
map <silent> <buffer>   <a-end>                 :call NavigateLevels("end")<CR>
map <silent> <buffer>   <a-home>                 :call NavigateLevels("home")<CR>
map <silent> <buffer>   <a-up>                 :call NavigateLevels("up")<CR>
map <silent> <buffer>   <a-down>               :call NavigateLevels("down")<CR>
map <silent> <buffer>   <a-left>               :call NavigateLevels("left")<CR>
map <silent> <buffer>   <a-right>              :call NavigateLevels("right")<CR>
nmap <silent> <buffer>   <localleader>,e    :call SingleHeadingText("expand")<CR>
nmap <silent> <buffer>   <localleader>,E    :call BodyTextOperation(1,line("$"),"expand")<CR>
nmap <silent> <buffer>   <localleader>,C    :call BodyTextOperation(1,line("$"),"collapse")<CR>
nmap <silent> <buffer>   <localleader>,c    :call SingleHeadingText("collapse")<CR>
nmap <silent> <buffer>   zc    :call DoSingleFold(line("."))<CR>
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
amenu &Org.Expand\ Level\ &1\ w/oText :call ExpandWithoutText(1)<cr>
amenu &Org.Expand\ Level\ &2\ w/oText :call ExpandWithoutText(2)<cr>
amenu &Org.Expand\ Level\ &3\ w/oText :call ExpandWithoutText(3)<cr>
amenu &Org.Expand\ Level\ &4\ w/oText :call ExpandWithoutText(4)<cr>
amenu &Org.Expand\ Level\ &5\ w/oText :call ExpandWithoutText(5)<cr>
amenu &Org.Expand\ Level\ &6\ w/oText :call ExpandWithoutText(6)<cr>
amenu &Org.-Sep1- :

command! PreLoadTags :silent  call <SID>GlobalConvertTags()
command! PreWriteTags :silent call <SID>GlobalUnconvertTags()
command! PostWriteTags :silent call <SID>UndoUnconvertTags()


" below is autocmd to change tw for lines that have comments on them
" I think this should go in vimrc so i runs for each buffer load
"  :autocmd CursorMoved,CursorMovedI * :if match(getline(line(".")), '^*\*\s') == 0 | :setlocal textwidth=99 | :else | :setlocal textwidth=79 | :endif 
set com=sO::\ -,mO::\ \ ,eO:::,::,sO:>\ -,mO:>\ \ ,eO:>>,:>
set fo=qtcwn
" Added an indication of current syntax as per Dillon Jones' request
let b:current_syntax = "org"

" vim600: set tabstop=4 shiftwidth=4 expandtab fdm=expr foldexpr=getline(v\:lnum)=~'^func'?0\:1:
