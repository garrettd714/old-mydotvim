" This is Garrett Davis' .vimrc file
" Thanks to alot of folks for this

set nocompatible                  " Must come first because it changes other options.
filetype off
execute pathogen#infect()
filetype plugin indent on         " Turn on file type detection.
set history=10000                 " remember more commands and search history
set modelines=0			              " per http://stevelosh.com/blog/2010/09/coming-home-to-vim/
syntax enable                     " Turn on syntax highlighting.
" runtime macros/matchit.vim        " Load the matchit plugin.
set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.
set backspace=indent,eol,start    " Intuitive backspacing.
set hidden                        " Handle multiple buffers better.
set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.
set ignorecase smartcase          " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.
set number                        " Show line numbers.
set ruler                         " Show cursor position.
set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.
set wrap                          " Turn on line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.
set title                         " Set the terminal's title
set visualbell                    " No beeping.
set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set directory=$HOME/.vim/tmp//,.  " Keep swap files in one location
set tabstop=4                     " Global tab width.
set shiftwidth=4                  " And again, related.
set softtabstop=4                 " tab related.
set autoindent
set showmatch
set cursorline
set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79
set shell=bash
set t_ti= t_te=                   " Prevent Vim from clobbering the scrollback buffer. GB
set expandtab                     " Use spaces instead of tabs

set laststatus=2                  " Show the status line all the time
" Useful status information at bottom of screen
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

" Or use vividchalk
colorscheme topfunky-light

" Map leader to comma for easier typing than \
let mapleader = ","

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  autocmd! FileType mkd setlocal syn=off
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPS TO JUMP TO SPECIFIC COMMAND-T TARGETS AND FILES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . _ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
map <leader>gR ;call ShowRoutes()<cr>
map <leader>gv ;CommandTFlush<cr>\|;CommandT app/views<cr>
map <leader>gc ;CommandTFlush<cr>\|;CommandT app/controllers<cr>
map <leader>gm ;CommandTFlush<cr>\|;CommandT app/models<cr>
map <leader>gh ;CommandTFlush<cr>\|;CommandT app/helpers<cr>
map <leader>gl ;CommandTFlush<cr>\|;CommandT lib<cr>
map <leader>gp ;CommandTFlush<cr>\|;CommandT public<cr>
map <leader>gs ;CommandTFlush<cr>\|;CommandT public/stylesheets/sass<cr>
map <leader>gf ;CommandTFlush<cr>\|;CommandT features<cr>
map <leader>gg ;topleft 100 ;split Gemfile<cr>
map <leader>gt ;CommandTFlush<cr>\|;CommandTTag<cr>
map <leader>f ;CommandTFlush<cr>\|;CommandT<cr>
map <leader>F ;CommandTFlush<cr>\|;CommandT %%<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

" Tab mappings.
map <leader>tt :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>to :tabonly<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
map <leader>tf :tabfirst<cr>
map <leader>tl :tablast<cr>
map <leader>tm :tabmove

" Uncomment to use Jamis Buck's file opening plugin
"map <Leader>t :FuzzyFinderTextMate<Enter>
imap <c-l> <space>=><space>

" using Wincet's file opening plugin command-t
map <Leader>t ;CommandT<Enter>
map <Leader>n ;NERDTree<Enter>

" set NERDTree window size
let NERDTreeWinSize=20

" set NERDTree window size
let NERDTreeWinSize=20

" Controversial...swap colon and semicolon for easier commands
nnoremap ; :
nnoremap : ;

vnoremap ; :
vnoremap : ;

nnoremap <CR> :nohlsearch<cr>

" Clear out search after instead of /nnnnn
nnoremap <leader><space> :noh<cr>

" Teach newb(me) to stay away from arrows
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" get rid of help key while aiming for escape
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" remap caps lock to esc (after caps lock is mapped to help key)
" inoremap <Help> <ESC>
" nnoremap <Help> <ESC>
" vnoremap <Help> <ESC>

" remap jj to esc, so caps lock can be remapped to ctrl
inoremap jj <ESC>

" Automatic fold settings for specific files. Uncomment to use.
" autocmd FileType ruby setlocal foldmethod=syntax
" autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2

" Like TextMate's save on losing focus
au FocusLost * :wa
