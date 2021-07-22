"https://realpython.com/vim-and-python-a-match-made-in-heaven/
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)
Plugin 'gmarik/Vundle.vim'
" fait nimp, indente de 16...
"Plugin 'vim-scripts/indentpython.vim'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'



" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

au BufNewFile,BufRead *.py
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix

"Marche pas 'cannot find color scheme 'zenburn'
"et unknown function togglebg#map
" if has('gui_running')
"   set background=dark
"   colorscheme solarized
" else
"   colorscheme zenburn
" endif
" 
" call togglebg#map("<F5>")



set nu
" https://debian-facile.org/utilisateurs:captnfab:config:vimrc
" Encodage par défaut des buffers en utf-8
set encoding=utf-8
" Encodage par défaut des fichiers en utf-8
set fileencoding=utf-8

" Fait une copie de sauvegarde lors de l'écrasement d'un fichier
set backup

" Dossier contenant la sauvegarde. N'oubliez pas de le créer et de lui faire un
" chmod 700
set backupdir=~/vim_backup

set mouse

" Taille maximale d'une ligne
set textwidth=80

syntax on


" Pour les fichiers shell script
" - corrige la coloration syntaxique
autocmd FileType sh let g:is_posix = 1

" La recherche reprend au début du fichier (resp à la fin) une fois la fin (resp
" le début) atteint.
set wrapscan

" Highlight les paterns recherchés
set hlsearch

"https://www.fullstackpython.com/vim.html

" enable syntax highlighting
syntax enable

" show a visual line under the cursor's current line
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" enable all Python syntax highlighting features
let python_highlight_all = 1

