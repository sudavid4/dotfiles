"--------------------------------------------------------------------------------
"MAPPINGS{{{
"--------------------------------------------------------------------------------
function! s:setIndentMapping()
    " Moving back and forth between lines of same or lower indentation.
    " nnoremap <buffer><silent> [l :call indent_utils#next_indent(0, 0, 0, 1)<CR>
    " nnoremap <buffer><silent> ]l :call indent_utils#next_indent(0, 1, 0, 1)<CR>
    nnoremap <buffer><silent> [[ m`:call indent_utils#prev_indent()<CR>
    nnoremap <buffer><silent> ]] m`:call indent_utils#next_indent()<CR>
    " vnoremap <buffer><silent> [l <Esc>:call indent_utils#next_indent(0, 0, 0, 1)<CR>m'gv''
    " vnoremap <buffer><silent> ]l <Esc>:call indent_utils#next_indent(0, 1, 0, 1)<CR>m'gv''
    vnoremap <buffer><silent> [[ <Esc>:call indent_utils#prev_indent()<CR>m'gv''
    vnoremap <buffer><silent> ]] <Esc>:call indent_utils#next_indent()<CR>m'gv''
    " onoremap <buffer><silent> [l :call indent_utils#next_indent(0, 0, 0, 1)<CR>
    " onoremap <buffer><silent> ]l :call indent_utils#next_indent(0, 1, 0, 1)<CR>
    onoremap <buffer><silent> [[ :call indent_utils#prev_indent()<CR>
    onoremap <buffer><silent> ]] :call indent_utils#next_indent()<CR>
endfunction

function! s:setmapping()
    nmap <buffer><space>ji :call utils#run_shell_command('runjest --inspect-brk '.expand('%'), 0)<cr>
    " run jest with ndb
    nmap <buffer><space>jn :call utils#run_shell_command('FORCE_COLOR=1 ndb `yarn bin jest` '.expand('%'), 0)<cr>
    nmap <buffer><space>jr :call utils#run_shell_command('runjest  '.expand('%'), 0)<cr>
    nmap <buffer><space>jw :call utils#run_shell_command('runjest  '.expand('%').' --watch', 0)<cr>
    nmap <buffer><space>ni :call utils#run_shell_command('node --inspect-brk '.expand('%:p'), 0)<cr>
    nmap <buffer><space>nr :call utils#run_shell_command('node  '.expand('%:p'), 0)<cr>
    nmap <buffer><space>nn :call utils#run_shell_command('node  '.expand('%:p'), 0)<cr>
    nnoremap <buffer>{ :call GoToNextFunction(-1, 0, 1)<cr>
    nnoremap <buffer>} :call GoToNextFunction(-1, 0, 0)<cr>
    nmap <buffer>K :call CocAction('doHover')<cr>
endfunction

"--------------------------------------------------------------------------------
"FUNCTIONS{{{
"--------------------------------------------------------------------------------

function! GetCurrLineIndentation()
    return len(substitute(getline('.'), '\(\s*\).*', '\1', '')) 
endfunction

function! GoToNextFunction(originalLineIndentation, recurseCount, searchBackward)
    echo 'GoToNextFunction - recurseCount = '.a:recurseCount
    set nohlsearch
    let originalLineIndentation = a:originalLineIndentation
    if a:recurseCount > 8
        return
    endif
    let flags = 'eW'
    if originalLineIndentation == -1
        let originalLineIndentation = GetCurrLineIndentation()
        let flags = 'eWs'
    endif
    if a:searchBackward == 1
        let flags = 'b'.flags
    endif
    let functionLineRegex = 'function\s*\w*(.*{'
    let blockStartLineRegex = '\w*([^)]*)\s*{'
    call search(functionLineRegex.'\|'.blockStartLineRegex, flags)
    let currLine = getline('.')
    if (GetCurrLineIndentation() > originalLineIndentation) && (originalLineIndentation > 0)
        call GoToNextFunction(originalLineIndentation, a:recurseCount + 1, a:searchBackward)
    else
        call feedkeys("zz")
	if getpos('.')[1] > 20
	    call feedkeys("\<c-e>\<c-e>\<c-e>")
	endif
    endif
endfunction

" function! JSToggleFoldMethod()
"     if &foldmethod=='syntax' 
"         set foldmethod=manual 
"     else 
"         set foldmethod=syntax 
"     endif
" endfunction

"-----------------------------------------------------------------------------}}}
"AUTOCOMMANDS                                                                 {{{
"--------------------------------------------------------------------------------
augroup javascript
    autocmd!
    " autocmd FileType javascript silent! call LimeLightExtremeties()
    " autocmd BufNewFile,BufRead *.js set filetype=typescript
    autocmd BufReadPost *.jsx,*.tsx set filetype=typescript.tsx
    let g:markdown_fenced_languages = ['css', 'javascript', 'js=javascript', 'json=javascript', 'stylus', 'html']
    autocmd BufWritePost *.jsx,*.tsx set filetype=typescript " hack to make go-to-declaration work AND coc tsx files work
    autocmd FileType javascript,json,typescript,typescript.tsx call <SID>setIndentMapping()
    autocmd FileType javascript,typescript,typescript.tsx call <SID>setmapping()
    " autocmd FileType javascript nnoremap <buffer>cof :call JSToggleFoldMethod()<cr>
    " autocmd Filetype javascript vnoremap <buffer>1= :<C-u>setf jsx<cr>gv=:<C-u>setf javascript<cr>
augroup END
"-----------------------------------------------------------------------------}}}
