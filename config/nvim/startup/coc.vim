command! Rename call CocActionAsync('rename')
command! FixLint CocCommand eslint.executeAutofix

function! FocusInExplorer()
  for window in getwininfo()
    if getbufvar(window.bufnr, '&ft') == 'coc-explorer'
      execute window.winnr . 'wincmd q'
    endif
  endfor
  execute 'CocCommand explorer --reveal '.expand('%:p')
endfunction
"refactor visual selection
nmap 1n :<c-u>CocCommand explorer<cr>
nmap <space>nf :call FocusInExplorer()<cr>

nmap <space>cd <Plug>(coc-definition)
xmap <space>rf <Plug>(coc-codeaction-selected)
nmap <space>lo :CocDiagnostics<cr>
nmap <C-c> <Plug>(coc-float-hide)
nmap <space>cf <Plug>(coc-fix-current)
imap <C-e> <Esc>:call coc#float#close_all()<cr>:call feedkeys('a')<cr>
inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ?
  \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  let result = !col || getline('.')[col - 1]  =~# '\s'
  echom 'checkbackspace'
  echom col
  echom result
  return result
endfunction

let g:coc_global_extensions = [
      \'coc-git',
      \'coc-explorer',
      \'coc-eslint',
      \'coc-tsserver',
      \'coc-vimlsp',
      \'coc-marketplace',
      \'coc-snippets'
      \]
let g:coc_snippet_next = '<tab>'
