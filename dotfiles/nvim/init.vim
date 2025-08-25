:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

call plug#begin()

Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/ap/vim-css-color.git'
Plug 'https://github.com/rafi/awesome-vim-colorschemes.git'
Plug 'https://github.com/ryanoasis/vim-devicons.git'

call plug#end()

source ~/.local/share/nvim/plugged/awesome-vim-colorschemes/colors/iceberg.vim

:set completeopt-=preview

nnoremap <C-p> :PlugInstall<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-b> :NERDTreeToggle<CR>
