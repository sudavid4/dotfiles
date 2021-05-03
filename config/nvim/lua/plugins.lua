local hasPacker = require 'utils'.hasPacker
if not hasPacker() then
  os.execute('git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim')
end
vim.api.nvim_command('packadd packer.nvim')


function cocTable(cocPlugin)
  return {
    cocPlugin,
    branch = 'master',
    run = 'yarn install --frozen-lockfile && yarn build --if-present'
  }
end
return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'neoclide/coc.nvim'
--   use(cocTable('neoclide/coc.nvim'))
--   use(cocTable('neoclide/coc-git'))
--   use(cocTable('neoclide/coc-eslint'))
--   use(cocTable('neoclide/coc-tsserver'))
--   use(cocTable('iamcco/coc-vimlsp'))
--   use(cocTable('fannheyward/coc-marketplace'))
--   use(cocTable('neoclide/coc-snippets'))
--   use(cocTable('neoclide/coc-git'))
--   use(cocTable('weirongxu/coc-explorer'))
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'

  -- use { --not stable, see https://github.com/lewis6991/gitsigns.nvim/issues/44
  --   'lewis6991/gitsigns.nvim',
  --   requires = {
  --     'nvim-lua/plenary.nvim'
  --   },
  --   config = function()
  --     require('gitsigns').setup()
  --   end
  -- }

  if vim.loop.fs_stat('/usr/local/opt/fzf') then
    use '/usr/local/opt/fzf' 
    use 'davidsu/fzf.vim'                 
  else
    use { 'junegunn/fzf', run = ':call fzf#install()' }
    use 'davidsu/fzf.vim'
  end

  use {'glacambre/firenvim', run = ':call firenvim#install(0)' }
  use 'ssh://git@git.walkmedev.com:7999/~david.susskind/walkme-vim-gbrowse.git'
  -- use 'davidsu/comfortable-motion.vim'                               
  use 'psliwka/vim-smoothie'
  use( os.getenv('DOTFILES') .. '/js/vim-js' )
  use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }  
  use 'tommcdo/vim-exchange'                                           -- exchange text with cx
  use 'davidsu/vim-visual-star-search'                                 -- extends */# to do what you would expect in visual mode
  -- use 'davidsu/vim-bufkill'                                         -- wipe buffer without closing it's window
  use 'tpope/vim-scriptease'                                           -- utilities for vim script authoring. Installed to use ':PP'=pretty print dictionary
  use { 'idbrii/vim-mark', requires = { 'inkarkat/vim-ingo-library' }} -- highlighting of interesting words
  use { 'schickling/vim-bufonly', cmd = 'BufOnly' }                    -- delete all buffers but current
  use { 'davidsu/vim-plugin-AnsiEsc', cmd = 'AnsiEsc' }                -- type :AnsiEsc to get colors as terminal
  use 'blueyed/vim-diminactive' 
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }          -- We recommend updating the parsers on update
  use 'nvim-treesitter/playground'
  -- use 'neovim/nvim-lspconfig'
  use 'dahu/vim-fanfingtastic'                                         -- improved f F t T commands
  use 'davidsu/nvcode-color-schemes.vim'

  use { 'glepnir/galaxyline.nvim', branch = 'main' }
  use 'tpope/vim-commentary'                                           -- comment stuff out
  use 'davidsu/vim-unimpaired'                                         -- mappings which are simply short normal mode aliases for commonly used ex commands
  use 'tpope/vim-surround'                                             -- mappings to easily delete, change and add such surroundings in pairs, such as quotes, parens, etc.
  use 'tpope/vim-fugitive'                                             -- amazing git wrapper for vim
  use 'tpope/vim-rhubarb'                                              -- for `:Gbrowse`
  use 'tpope/vim-repeat'                                               -- enables repeating other supported plugins with the . command
  use { 'davidsu/gv.vim', cmd = 'GV' }                                 -- :GV browse commits like a pro
  use 'tpope/vim-sleuth'                                               -- detect indent style (tabs vs. spaces)
  use 'sickill/vim-pasta'                                              -- fix indentation when pasting
  use { 'junegunn/limelight.vim', cmd = 'Limelight' }                  -- focus tool. Good for presentating with vim
  use { 'mattn/emmet-vim', ft = 'html' }                               -- emmet support for vim - easily create markdup wth CSS-like syntax
  use 'alvan/vim-closetag'
  use { 'othree/html5.vim', ft = 'html' }                              -- html5 support
  use { 'cakebaker/scss-syntax.vim', ft = 'scss' }                     -- sass scss syntax support
  use 'norcalli/nvim-colorizer.lua'
  use { 'hail2u/vim-css3-syntax', ft = 'css' }                         -- CSS3 syntax support
  use 'iloginow/vim-stylus' -- for some reason markdown files throw on enter without this
  -- use { 'wavded/vim-stylus', ft = {'stylus', 'markdown'} }           -- markdown support
  -- use { 'dhruvasagar/vim-table-mode', ft = 'markdown'}
  use { -- render mardown html in browser
    'iamcco/markdown-preview.nvim', 
    ft = { 'markdown' }, 
    run = 'cd app && yarn install'  
  }
  use {
    'gabrielelana/vim-markdown',
    run = 'git submodule update --init --recursive'
  }
  -- use {'plasticboy/vim-markdown', ft = 'markdown'}                   -- markdown
  -- use {'godlygeek/tabular', ft = 'markdown'}                         -- related to vim-markdown
end)

