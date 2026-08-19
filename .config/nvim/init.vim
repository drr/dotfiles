" --- General -----------------------------------------------------------
syntax on
filetype plugin indent on

" --- Indentation ---------------------------------------------------------
set expandtab                 " spaces, not tabs, for indentation
set shiftwidth=4
set softtabstop=4
set tabstop=8                 " literal preserved tab characters still render full-width
set autoindent
set smartindent

" Lists/markup-style filetypes conventionally indent 2 spaces, not 4.
augroup filetype_indent
  autocmd!
  autocmd FileType markdown,yaml,html,json setlocal shiftwidth=2 softtabstop=2
augroup END

" --- Markdown --------------------------------------------------------------
augroup filetype_markdown
  autocmd!
  autocmd FileType markdown setlocal wrap linebreak spell spelllang=en_us conceallevel=2
augroup END

" --- Search ----------------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch

" --- Splits & navigation ----------------------------------------------------
set splitright
set splitbelow
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Quality of life ---------------------------------------------------------
set number
set mouse=a                   " click to switch/resize splits
set clipboard=unnamed         " yank/paste through the macOS system clipboard
set backspace=indent,eol,start
set scrolloff=3
set wildmenu

" --- Optional external tools (Homebrew CLI tools, not vim plugins) ----------
" Deliberately not using a vim plugin manager: it adds a dependency this
" config won't have on a fresh/remote machine. See planning/PLAN.md for the
" tradeoff — revisit if more is wanted later (LSP, treesitter, etc).
if executable('glow')
  command! MarkdownPreview execute '!glow ' . shellescape(expand('%'))
endif
if executable('fzf')
  function! FzfEdit()
    let l:file = system('fzf')
    if v:shell_error == 0 && !empty(l:file)
      execute 'edit ' . fnameescape(substitute(l:file, '\n', '', ''))
    endif
    redraw!
  endfunction
  nnoremap <C-p> :call FzfEdit()<CR>
endif
