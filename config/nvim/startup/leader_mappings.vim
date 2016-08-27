function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction
" Window movement shortcuts
" move to the window in the direction shown, or create a new window
function! WinMove(key)
    let t:curwin = winnr()
    echo 'windMove'
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

function! ToggleCurrsorLineColumn()
    if(&cursorline)
        set nocursorline nocursorcolumn
        let g:normal_cursor_line_column = 0
        return
    endif
    let g:normal_cursor_line_column = 1
    set cursorline nocursorcolumn
endfunction

function! FindFunctionUnderCursor(functionName)
    " (?<=...) positive lookbehind: must constain
    " (?=...) positive lookahead: must contain
    let agcmd = '''(?<=function\s)'.a:functionName.'(?=\()|'.a:functionName.'\s*:'''
    call histadd('cmd', 'Agraw '''''.agcmd.''' -A 0 -B 0''')
    call fzf#vim#ag_raw(agcmd)
endfunction

function! FindAssignment(variableName)
    " (?<=...) positive lookbehind: must constain
    " (?=...) positive lookahead: must contai
    let agcmd = '''(=|:).*\b'.a:variableName.'\b'' | ag -v ''\('''
    " call histadd('cmd', 'Agraw '''''.agcmd.''' -A 0 -B 0''')
    call fzf#vim#ag_raw(agcmd)
endfunction
nmap ,. <c-^>

nnoremap <silent> ,aa :call FindAssignment(expand("<cword>"))<cr>
nnoremap <silent> ,af :call FindFunctionUnderCursor(expand("<cword>"))<cr>
nnoremap <silent> ,au :call fzf#vim#ag_raw('''(?<!function\s)\b'.expand("<cword>").'(?=\()''')<cr>
nnoremap <silent> ,aw "fyaw:Ag<C-r>f<cr>
" http://unix.stackexchange.com/questions/88714/vim-how-can-i-do-a-change-word-using-the-current-paste-buffer
" delete without changing registers
nnoremap ,c "_c
nnoremap ,d "_d
" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
xnoremap ,p "_dP
nmap ,b :bn<cr>:bd #<cr>
nmap ,ee :!
"end diff --- clean close diff window
nmap ,ed <C-w><C-h><C-w><C-c>
map ,ev :source ~/.dotfiles/config/nvim/init.vim<cr> 
" toggle Limelight
nmap ,f :Limelight!!<cr>
" find any file
nmap <silent> ,fa :FZFFiles<cr>
" find open buffer
nmap <silent> ,fb :Buffers<cr>
"find line in current buffer
nmap <silent> ,fc :BLines<cr>
" find file tracked by git
nmap <silent> ,ff :GFiles<cr>
" find function definition accross the project
" '(function\s+' <c-r>f ')|('<c-r>f'\s*:)'

" find file tracked by git
nmap <silent> ,fg :GFiles<cr>
" find help tag
nmap <silent> ,fh :Helptags<cr>
" find line in open buffers
nmap <silent> ,fl :Lines<cr>
" find uncommited file
nmap <silent> ,fu :GFiles?<cr>
"fugitive
nmap <silent>,gb :Gblame<cr>
nmap <silent>,gd :Gdiff<cr>
nmap ,ge :Gedit<cr>
nmap <silent>,gr :Gread<cr>
nmap <silent>,gs :Gstatus<cr>
nmap ,gt :Buffers<cr>term://
"map ,fs FoldSearch
map <silent> ,h :call WinMove('h')<cr>
" toggle cursor line
nnoremap ,I :call ToggleCurrsorLineColumn()<cr> 
nnoremap  ,i :call CursorPing()<CR>
map <silent> ,j :call WinMove('j')<cr>
map <silent> ,k :call WinMove('k')<cr>
map <silent> ,l :call WinMove('l')<cr>
" Toggle NERDTree
nmap <silent> ,n :NERDTreeToggle<cr>
" expand to the path of the file in the current buffer
nmap <silent> ,N :NERDTreeFind<cr>
"set limelight
"begin
nnoremap ,slb :let g:limelight_bop='^'.getline('.').'$'<cr>
"decrement
nnoremap ,sld :call SetLimeLightIndent(g:limelightindent - 4)<cr>
"end
nnoremap ,sle :let g:limelight_eop='^'.getline('.').'$'<cr>
"increment
nnoremap ,sli :call SetLimeLightIndent(g:limelightindent + 4)<cr>
"reset indent to default 4
nnoremap ,slr :call SetLimeLightIndent(4)<cr>
" set limelight toggle
nnoremap ,sls :call SetLimeLightIndent 
nnoremap ,slt :Limelight!!<cr>
nmap ,s <Plug>(easymotion-s)
nmap ,ss <Plug>(easymotion-s)
nmap ,/ <Plug>(easymotion-sn)

" 'quick git status' give status with fzf
map ,qgs :GFiles?<cr>
map ,qa :qa<cr>
map <silent> ,sl <Nop>
map ,tc :tabclose<cr>
map ,te :tabedit %<cr>
"same as :quit
nmap ,w :wincmd q<cr>
map ,, :w<cr>
nnoremap <silent> ,zj :call NextClosedFold('j')<cr>
nnoremap <silent> ,zk :call NextClosedFold('k')<cr>
inoremap ,, <Esc>:w<cr>

nmap <silent> ,m :GFiles<cr>
nmap <silent> ,M :Buffers<cr>
nmap <silent> ,<Space>m :GFiles?<cr>
