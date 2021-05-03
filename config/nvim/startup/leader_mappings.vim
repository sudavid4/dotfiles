" function! SaveOrReload()
"     if &mod
"         write
"     else
"         edit
"     endif
" endfunction
" nmap <space><space> :call SaveOrReload()<cr>
nmap <space><space> :update<cr>:update<cr>
vmap <space><space> :update<cr>:update<cr>
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

nmap ' ` |"when goto mark, allways take cursor position
nmap m, :call utils#restoreAlternateFile()<cr><c-^>
nmap sa :call utils#restoreAlternateFile()<cr><c-^>

nmap <space>gx m`0y$:@"<cr><c-o>  |" execute current line
nmap <space>qq :helpclose<cr>:pclose<cr>:cclose<cr>:lclose<cr>
nmap <space>ql :lclose<cr>
nmap <space>qc :cclose<cr>
nmap <space>qp :pclose<cr>
nmap <space>qh :helpclose<cr>
noremap <space>oc :copen<cr>
noremap <space>ol :lopen<cr>
noremap <space>tt :GFiles!<cr>
nmap <silent> \t :call hzf#g_files(1)<cr>
nnoremap - :let currfile = expand('%:p:t')<cr>:edit %:p:h<cr>:call search(currfile)<cr>
nnoremap \\ "_
vnoremap \\ "_

noremap <space>fd :filetype detect<cr>
"find variable assignment - `a=b` or `a:b` - fails for es6
nnoremap <silent> <space>fva :call FindAssignment(expand("<cword>"))<cr>
nnoremap <silent> <space>ff :call FindFunction(expand("<cword>"))<cr>
nnoremap <silent> <space>ft "fyaw:FindText '<C-r>f'<cr>
nnoremap <silent> <space>fu :call FindUsage(expand("<cword>"))<cr>
" find word - we spoil the f register which is ... unescessary
" nnoremap <silent> <space>fw "fyaw:FindText '<C-r>f'<cr>
nnoremap <silent> <space>fw :execute "Ag ".expand("<cword>")<cr>
" find not test hast fnt prefix
nnoremap <silent> <space>fnta :FindNoTestAssignment expand("<cword>")<cr>
nnoremap <silent> <space>fntf :FindNoTestFunction expand("<cword>")<cr>
nnoremap <silent> <space>fntt "fyaw:FindNoTestText '<C-r>f'<cr>
nnoremap <silent> <space>fntw "fyaw:FindNoTestText '<C-r>f'<cr>
nnoremap <silent> <space>fntu :FindNoTestUsage expand("<cword>")<cr>
"find only test has fot prefix
nnoremap <silent> <space>fota :FindOnlyTestAssignment expand("<cword>")<cr>
nnoremap <silent> <space>fotf :FindOnlyTestFunction expand("<cword>")<cr>
nnoremap <silent> <space>fott "fyaw:FindOnlyTestText '<C-r>f'<cr>
nnoremap <silent> <space>fotw "fyaw:FindOnlyTestText '<C-r>f'<cr>
nnoremap <silent> <space>fotu :FindOnlyTestUsage expand("<cword>")<cr>
vmap / /\v
vmap ? ?\v
nnoremap <c-q> :q<cr>
let g:shortstatusline = 0
nnoremap <space>at :let g:shortstatusline=(g:shortstatusline + 1)%2<cr>:lua require("galaxyline").load_galaxyline()<cr>
nnoremap \c :Commands<cr>
nnoremap 1: :History:<cr>
nnoremap 1; :History:<cr>
nnoremap 1/ :History/<cr>
" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
nmap <space>be :BufExplorer<cr>
function! BufferHistory()
    set eventignore=BufWinEnter,WinEnter,DirChanged
    GV!
    set eventignore&
endfunction
nmap <space>bh :call BufferHistory()<cr>

nmap <space>bl :BLines!<cr> |"view buffer lines

nnoremap <silent><space>vl :AgAllBLines<cr> |"view loaded(all) buffer lines
nmap <space>bd :call utils#buf_delete_current()<cr>
"end diff --- clean close diff window
map <space>ev :source ~/.dotfiles/config/nvim/init.vim<cr> 
"add explanation inside code
nnoremap <space>ex O<esc>120i-<esc>o-<cr><esc>120i-<esc>V2k:Commentary<cr>j$xA
" find any file
nmap <silent><space>fa :FZFFiles<cr>
nmap <silent><space>fh :Helptags<cr>
" find line in open buffers
nnoremap <silent><space>fl :Lines<cr>
"fugitive
nmap <silent><space>wd :call DiffInWebstorm()<cr>
nmap <silent><space>ws :OpenInWebstorm()<cr>
nmap <silent><space>ow :OpenInWebstorm<cr>
nmap <silent><space>oa :call utils#open_in_atom()<cr>
nmap <silent><space>ov :call utils#open_in_visual_studio_code()<cr>
nmap <silent><space>gb :Gblame<cr>nmap <silent>,gd :Gdiff<cr>
nmap <silent><space>gb :Gblame<cr>
nmap <silent>gb :Gblame<cr>
nmap <silent><space>gr :Gread<cr>
nmap <silent><space>gs :Gstatus<cr><C-n>
nmap <silent><space>gc :Gcommit -v<cr>
nmap <silent><space>gl :call hzf#git_log()<cr>
"gf cuz the git command is 'git log --follow $FileName' 
nmap <silent><space>gf :call hzf#git_log_follow()<cr>
nmap <silent><space>bc :call hzf#git_log_follow()<cr>
nmap <silent>gs :Gstatus<cr><C-n>

nmap <silent><space>gd :Gdiff<cr>
nmap <space>ed <C-w><C-j><C-w><C-l><C-w><C-o>
nmap <space>ge :Gedit<cr>

nmap <space>hu :CocCommand git.chunkUndo<cr>
nmap <space>hs :CocCommand git.chunkStage<cr>
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
nmap <space>gt :Buffers<cr>term://
" moving up and down work as you would expect
nnoremap <silent> j gj
nnoremap <silent> k gk
map <silent> gh :call utils#win_move('h')<cr>
map <silent> gj :call utils#win_move('j')<cr>
map <silent> gk :call utils#win_move('k')<cr>
map <silent> gl :call utils#win_move('l')<cr>
nmap \w :wincmd q<cr>
nmap \s :%s/\v
vmap \s :s/\v
nmap \d :redraw!<cr>
nmap <silent> 1t :execute '25Lexplore '.expand('%:p:h')<cr>
nmap 1o :only<cr>

"VIM-MARK: <space>hi for highlight interesting word
nmap <silent><space>hi <Plug>MarkSet
vmap <silent><space>hi <Plug>MarkSet
" <space>hc for "highlight clear" clear all "interesting words" highlighting
nmap <space>hc :silent MarkClear<cr>
nmap 1zDisableVimMarkStarMap <Plug>MarkSearchNext
nmap 1zDisableVimMarkHashMap <Plug>MarkSearchPrev
nmap 1zDisableVimMarkMarkClear  <Plug>MarkClear

nmap <space>cp :call utils#cursor_ping()<cr>
"disable automatic mappings for surround.vim and write the here cuz I want `ds{motion}` and `cs{motion}` to use easymotion instead
let g:surround_no_mappings = 1
"delete surrounding
nmap <space>ds  <Plug>Dsurround
nmap ds  <Plug>Dsurround
"change surrounding
nmap <space>cs  <Plug>Csurround
nmap cs  <Plug>Csurround
"??
nmap <space>cS  <Plug>CSurround
"motion + surrounding
nmap <space>ys  <Plug>Ysurround
nmap ys  <Plug>Ysurround
"put created surrounding in its own line
nmap <space>yS  <Plug>YSurround
"surround entire line
nmap <space>yss <Plug>Yssurround
"surrond {start}\n{currentline}\n{end}
nmap <space>ySs <Plug>YSsurround
"same as ySs
nmap <space>ySS <Plug>YSsurround
"surround visual selection
xmap S <Plug>VSurround
"surround visual selection
xmap <space>s <Plug>VSurround
"surroung visual into it's own line
xmap gS  <Plug>VgSurround

"using map from <Plug>(easymotion...) is cool, the plugin worries to do the right thing with my mappings
" let g:EasyMotion_keys='abcdefghijklmnopqrstuvwxyz'
" map ss <Plug>(easymotion-s)
" map sn <Plug>(easymotion-sn)
" map s; <Plug>(easymotion-next)
" map s, <Plug>(easymotion-prev)
" map s. <Plug>(easymotion-repeat)
" map sd <Plug>(easymotion-s2)

map <space>tc :tabclose<cr>
map <space>te :call utils#toTerminal()<cr>
map <space>sn :UltiSnipsEdit<cr>
map <space>st :Scripts<cr>

"visual mode on pasted text
nnoremap <space>vp `[v`]
"same as :quit
nmap \w :wincmd q<cr>
nmap \q :wincmd q<cr>
nmap <S-Up> v<Plug>(expand_region_expand)
vmap <S-UP> <Plug>(expand_region_expand)
vmap <S-DOWN> <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'a"'  :0,
      \ 'i''' :0,
      \ 'a''' :0,
      \ 'i]'  :1, 
      \ 'a]'  :1, 
      \ 'ib'  :1, 
      \ 'ab'  :1, 
      \ 'iB'  :1, 
      \ 'aB'  :1, 
      \ 'il'  :0, 
      \ 'ip'  :0,
      \ 'ie'  :0, 
      \ }
" map <UP> <Plug>(wildfire-fuel)
" vmap <DOWN> <Plug>(wildfire-water)
nnoremap <silent> <space>zj :call NextClosedFold('j')<cr>
nnoremap <silent> <space>zk :call NextClosedFold('k')<cr>
function! GFilesIfNotHelp()
    if &ft == 'help'
        execute "normal! \<c-t>"
    else
        call hzf#g_files(0)
    endif
endfunction
nnoremap <c-t> :call GFilesIfNotHelp()<cr>
imap <C-s>  <Esc>:w<cr>
map <C-s>  <Esc>:w<cr>
nnoremap <C-s> :Snippets<cr>

nmap <silent> \b :Buffers<cr>
nmap <silent> 1b :Buffers<cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap <space>cm :ClearMessages<cr>
nmap <space>lc :LetterCommands<cr>
nmap <space>lm :LeaderMappingsDeclaration<cr>
nmap <space>cl :LetterCommands<cr>
nmap <space>cc :CommandLineCommands<cr>
nmap <space>cr :CocRestart<cr>
nmap ]i :execute "BLines ".expand('<cword>')<cr>
nmap [i :execute "BLines ".expand('<cword>')<cr>
nmap ]I :execute 'AgAllBLines \b'.expand('<cword>').'\b'<cr>
nmap [I :execute 'AgAllBLines \b'.expand('<cword>').'\b'<cr>
" i don't like the unimpaired ]l, [l commands, it's too much little finger
nmap <space>lj :lnext<cr>
nmap <space>lk :lprev<cr>

" run test (well, if available)
nmap <space>rt :Shell! export MOCHA_OPTIONS='--colors'; npm run test<cr>
"<c-l> complete to longest possible
"<c-d> list all possibilities
cnoremap <c-space> <C-l><C-d>
cnoremap <c-p> <up>
cnoremap <c-n> <down>
