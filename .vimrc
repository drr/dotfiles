"drr 2009/06/06

set ignorecase
set nowrapscan
set number

set shiftwidth=4
set softtabstop=4
set expandtab       "expand tabs to spaces
set textwidth=72
set autoindent      "will generally be overridden by the filetype indent

" Experiment with these features
set nocompatible    "use vim defaults
set history=100
set laststatus=2    "always have a status bar
set backspace=2     "allow backspacing over everything
set incsearch       "start showing search result
set ruler           "display position in the lower right
set showcmd         "dispaly incremental command
set showmatch       "show matching brackets
"set list           "show tabs and trailing charaters

syntax enable

" Use the solarized color scheme https://github.com/altercation/vim-colors-solarized
if has('gui_running')
    set background=dark
    colorscheme solarized
else
    set background=light
    colorscheme desert
endif


"From $VIMRUNTIME/vimrc_example.vim
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=74

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on
  set textwidth=72

endif " has("autocmd")

