"MAPPINGS{{{
"--------------------------------------------------------------------------------
" Mapping selecting mappings
nmap \<tab> <plug>(fzf-maps-n)
xmap \<tab> <plug>(fzf-maps-x)
omap \<tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)


nmap 1m :Mru<cr>
nmap 1w :Mrw<cr>
nmap \v :Vimrc<cr>
nmap \a :Ag 
nmap \r :Agraw
"-----------------------------------------------------------------------------}}}
"GLOBALS                                                                      {{{ 
"--------------------------------------------------------------------------------
let g:fzf_launcher = "$DOTFILES/bin/itermFzfVim %s"
let g:fzf_layout = { 'down': '~60%' }
" let g:fzf_command_prefix = 'Fzf'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

"-----------------------------------------------------------------------------}}}
"FUNCTIONS                                                                    {{{ 
"--------------------------------------------------------------------------------
let s:previewrb = expand('<sfile>:h:h').'/plugged/fzf.vim/bin/preview.rb'
let s:bin = expand('<sfile>:h:h').'/bin'
    
function! Noop(...)
endfunction

function! FindText(text, ...)
    let additionalParams = ( a:0 > 0 ) ? a:1 : ''
    let agcmd = ''''.a:text.''' '.additionalParams
    call fzf#vim#ag_raw(agcmd, hzf#defaultPreview())
endfunction

function! FindAssignment(variableName, ...)
    let additionalParams = ( a:0 > 0 ) ? a:1 : ''
    " (?<=...) positive lookbehind: must constain
    " (?=...) positive lookahead: must contai
    let agcmd = '''(=|:).*\b'.a:variableName.'\b'' | ag -v ''\('' '.additionalParams
    " call histadd('cmd', 'Agraw '''''.agcmd.''' -A 0 -B 0''')
    call fzf#vim#ag_raw(agcmd, hzf#defaultPreview())
endfunction

function! FindUsage(variableName, ...)
    let additionalParams = ( a:0 > 0 ) ? a:1 : ''
    let agcmd = '''(?<!function\s)\b'.a:variableName.'(?=\()'' '.additionalParams
    " call histadd('cmd', 'Agraw '''''.agcmd.''' -A 0 -B 0''')
    call fzf#vim#ag_raw(agcmd, hzf#defaultPreview())
endfunction

"-----------------------------------------------------------------------------}}}
"COMMANDS                                                                     {{{
"--------------------------------------------------------------------------------
command! -nargs=+ FindFunction call FindFunction(<args>)
command! -nargs=+ FindAssignment call FindAssignment(<args>)
command! -nargs=+ FindUsage call FindUsage(<args>)
command! -nargs=+ FindText call FindText(<args>)
command! -nargs=+ FindNoTestFunction call FindFunction(<args>, $IGNORE_TESTS)
command! -nargs=+ FindNoTestAssignment call FindAssignment(<args>, $IGNORE_TESTS)
command! -nargs=+ FindNoTestUsage call FindUsage(<args>, $IGNORE_TESTS)
command! -nargs=+ FindNoTestText call FindText(<args>, $IGNORE_TESTS)
command! -nargs=+ FindOnlyTestFunction call FindFunction(<args>, onlyTest)
command! -nargs=+ FindOnlyTestAssignment call FindAssignment(<args>, onlyTest)
command! -nargs=+ FindOnlyTestUsage call FindUsage(<args>, onlyTest)
command! -nargs=+ FindOnlyTestText call FindText(<args>, onlyTest)
command! -nargs=+ Agraw call hzf#ag_raw(<q-args>)

command! ChangeColorScheme :call fzf#run({
    \   'source':
    \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
    \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
    \   'sink':    'colo',
    \   'options': '+m',
    \   'left':    30
    \ })<CR>

command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \                 hzf#defaultPreview(),
    \                 1)


command! FZFFiles call fzf#run({
    \  'source': 'find -L . | egrep -v \.git',
    \  'sink':    'e',
    \  'options': '-m -x +s'})

let onlyTest=' | ag ''(unit|spec).js'''

command! CommandLineCommands call fzf#vim#ag_raw('--nobreak --noheading '.
            \'--ignore ''howto*'' '.
            \'--ignore ''intro*'' '.
            \'--ignore ''edit*'' '.
            \'--ignore ''help*'' '.
            \'--ignore ''if_*'' '.
            \'--ignore ''ft_*'' '.
            \'--ignore ''autoc*'' '.
            \'--ignore ''change*'' '.
            \'--ignore ''gui_*'' '.
            \'--ignore ''eval'' '.
            \'''^\s*\|:''', 
            \{'dir':$VIMRUNTIME.'/doc',
            \'options': ' --preview-window up:50% --preview "'''.s:previewrb.'''"\ \ {} --bind ''ctrl-g:toggle-preview'''})


command! LetterCommands call fzf#vim#ag_raw('--nobreak --noheading '.
            \'--ignore ''howto*'' '.
            \'--ignore ''intro*'' '.
            \'--ignore ''edit*'' '.
            \'--ignore ''help*'' '.
            \'--ignore ''if_*'' '.
            \'--ignore ''ft_*'' '.
            \'--ignore ''autoc*'' '.
            \'--ignore ''change*'' '.
            \'--ignore ''gui_*'' '.
            \'--ignore ''eval'' '.
            \'''^\|[^-:0-9](\|?|[^:]{0,6}[^)])\|''', 
            \{'dir':$VIMRUNTIME.'/doc',
            \'options': ' --preview-window up:50%:hidden --preview "'''.s:previewrb.'''"\ \ {} --bind ''ctrl-g:toggle-preview,ctrl-s:toggle-sort'''}, 1)

"todo give this sink function (+ preview?)
command! LeaderMappingsDeclaration call hzf#leader_mappings_declarations()
let s:leaderOrAltChars = '[,`¡™£¢∞§¶•ªº≠œ∑´®†¥¨ˆøπ“‘«åß∂ƒ©˙∆˚¬…æΩ≈ç√∫˜µ≤≥÷q]'
command! -nargs=? AgBLines call hzf#ag_bLines(<q-args>)
command! -nargs=? AgAllBLines call hzf#ag_all_blines(<q-args>)
" command! LeaderMappingsDeclaration call fzf#vim#ag('^\s*[^"\s]*map.*' . s:leaderOrAltChars . '[!-~]*', fzf#vim#with_preview({'dir':'$DOTFILES/config/nvim/startup', 'down': '100%'},'up:30%', 'ctrl-g'))
command! Options call hzf#options()
command! Variables call hzf#variables()
command! Scripts call fzf#run({
            \'source': map(scriptease#scriptnames_qflist(), 'v:val.filename'),
            \'sink': 'e',
            \})

"-----------------------------------------------------------------------------}}}
"AUTOCOMMANDS                                                                 {{{
"--------------------------------------------------------------------------------
augroup myfzfgroup
    autocmd!
    autocmd FileType javascript nnoremap <buffer>gd :call GoToDeclaration()<cr>
    autocmd FileType nerdtree nnoremap <buffer>,<Tab> :call  FzfNerdTreeMappings()<cr>
    autocmd FileType gitcommit nnoremap <buffer>,<Tab> :call FugitiveMappings()<cr>
    autocmd FileType nerdtree nnoremap <buffer>\<Tab> :call  FzfNerdTreeMappings()<cr>
    autocmd FileType gitcommit nnoremap <buffer>\<Tab> :call FugitiveMappings()<cr>
augroup END
"-----------------------------------------------------------------------------}}}