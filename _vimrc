" Initialization {{{
set nocompatible
filetype on
filetype indent on
filetype plugin on
set textwidth=100
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
call pathogen#infect() "This is for the Pathogen to work
call pathogen#helptags()
set encoding=utf-8 "This is for the powerline
let $MYVIMRC='$VIM/../../projects/config/_vimrc'
"}}}
" Basic Settings {{{
se nu
set clipboard=unnamed
set nowrap
set nobackup
set backupcopy=yes
set ignorecase
set hidden "This makes buffer switching easier, without saving
"set visualbell " donot beep
set vb t_vb=
set noerrorbells " donot beep
set autoindent " always set autoindenting on
set smartindent
set shiftround " use multiple of shiftwidth when indenting
set showmatch " set show matching parenthesis
set nowrap " don't wrap lines
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set shiftwidth=4 " number of spaces to use for autoindenting
set tabstop=4 " a tab is four spaces
set softtabstop=4
set synmaxcol=200 "Syntax highlighting on long lines are very slow so removing the syntax highlighing after 200 columns
set expandtab
autocmd VimEnter * NumbersToggle
"autocmd BufNewFile, BufRead *.txt set fo+=t tw=100 | normal gggqG 
"autocmd BufNewFile, BufRead *.mkd set fo+=t tw=100 | normal gggqG 
"autocmd FileType txt setlocal textwidth=100 
"autocmd FileType mkd setlocal textwidth=100 
"}}}
" ColorScheme and GuiOptions {{{
" ----------------------------------------
" GUI configuration
" ----------------------------------------
" m = Menubar
" T = Toolbar
" t = tearoff menus
" a = autoselect
" A = -"- only for modeless
" c = use console dialogs
" f = foreground
" g = Grey Menu Items
" i = Icon
" v = buttons are vertical
" e = tabs in gui
" This has to be set early
" r = show right scroll bar
" L = show left scrollbar on split
" i = icon
"set guioptions=fatig
se guioptions-=rL "Removes the right scrollbar
"set guioptions-=T "Remove the toolbar
"set guioptions-=m "Remove the toolbar
"au GUIEnter * simalt ~x "this is for full screen
"Below will set the initial position and fixed width
"Just in case if you don't want the full screen option
set cindent
set cinkeys=0{,0},!^F,o,O,e " default is: 0{,0},0),:,0#,!^F,o,O,e
set showtabline=1
set cmdheight=1
if has('gui_running')
    ":winpos 50 3
    :winpos 550 0
    :set lines=55
    :set columns=130
    "colorscheme myxoria256
    "colorscheme autumnleaf
    "colorscheme mayansmoke
    "colorscheme porton
    colorscheme molokaiplain
    "colorscheme habilight
    "colorscheme xoria256
    "colorscheme wombat
    "colorscheme darkblue
    "colorscheme Powerblue
    "se cursorline "This will highlight the current line
endif
set linespace=0 " Pixels of space between lines
"set guifont=consolas:h11:cDEFAULT
set guifont=Monaco:h10:cDEFAULT
" }}}
" Key Mapping {{{
"let mapleader=","
imap jk <Esc>
"imap ) )<Esc>i
"imap } }<Esc>i<CR><CR><Esc>ki<TAB>
"My Keymapping nnoremap ; :
noremap ,, ,
map <up> <nop>
map <down> <nop>
map <left> :bprevious<cr>
map <right> :bnext<cr>
map <Q> gq 
map <Leader>ca :%y<CR>
map <Leader>q "qy
map <F2> :e $MYVIMRC<CR>
map <F3> :e $VIM/../../projects/config/xptemplate/c/c.xpt.vim<CR>
"map <F3> :so $MYVIMRC<CR>
nmap <silent> ,/ :nohlsearch<CR>
"Putting a newline without entering into insert mode
map <S-Enter> o<Esc>
"Mapping capital H and L
map H ^
map L $
"deleting all empty lines
nmap <silent> ,de :g/^\s*$/d<CR>

map <Leader>bn :bn<CR>
map <Leader><bs> gggqG 
map <Leader>bp :bp<CR>
map <Leader>bb :b#<CR>
map <Leader>bd :bd<CR>
map <Leader>ls :ls<CR>
"}}}
" Plugins {{{
" Powerline {{{
if has('gui_running')
    se laststatus=2 "This is for the powerline
endif
" }}}
" SnipMate {{{
let g:snippets_dir = "$vim/runtime/bundle/snipMate/snippets"
" }}}
" BufferExplorer {{{
map <Leader><TAB> ,be
" }}}
" NERDTree {{{
map <Leader>n :NERDTree<CR>
" }}}
" VimWiki{{{
vnoremap <leader>ww y:s/<C-R>"/[[<C-R>"]]/<CR>:nohlsearch<CR>
" }}}
" }}}
" Folding {{{
set foldlevelstart=0
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
" "Refocus" folds
nnoremap ,z zMzvzz
" cursor happens to be.
nnoremap zO zCzO
"Folding for FileTypes {{{
"Vim {{{

augroup ft_vim
au!
au FileType vim setlocal foldmethod=marker foldmarker={{{,}}}
"au FileType help setlocal textwidth=78
"au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}
""Powershell {{{
""My files are very small and doesnot really require folding just in case for future
augroup ft_powershell
au!
"au BufRead,BufNewFile *.ps1 set ft=ps1
au FileType ps1 setlocal foldmethod=marker foldmarker={{{,}}}
au FileType psm1 setlocal foldmethod=marker foldmarker={{{,}}}
augroup END
"" }}}
"" }}}
"" }}}
