" --- General -----------------------------------------------------------
let mapleader = " "
" filetype detection must load before syntax: 'syntax on' registers its own
" FileType autocmd, and if it runs first, the FileType event for a file
" opened directly on the command line (e.g. `nvim foo.md`) fires before our
" own FileType autocmds below are registered, so they silently never apply.
filetype plugin indent on
syntax on

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
  autocmd FileType markdown setlocal textwidth=70 colorcolumn=+1
  autocmd FileType markdown setlocal formatoptions-=t
  autocmd FileType markdown nnoremap <buffer> <leader>w :call MarkdownSafeWrapParagraph()<CR>
  autocmd FileType markdown xnoremap <buffer> <leader>l :call MarkdownWrapSelectionAsLink()<CR>
  autocmd FileType markdown nnoremap <buffer> <leader>l :call MarkdownWrapUrlUnderCursor()<CR>
augroup END

" Fenced code blocks get real embedded syntax highlighting for these
" languages (see :help g:markdown_fenced_languages). Each entry is either
" a bare filetype name, or 'label=filetype' where `label` is what you type
" after the fence's ``` and `filetype` is the syntax file it borrows from.
let g:markdown_fenced_languages = [
      \ 'bash=sh', 'sh', 'zsh=sh', 'python', 'lua',
      \ 'javascript', 'js=javascript', 'typescript',
      \ 'json', 'yaml', 'vim', 'ruby', 'go', 'rust',
      \ 'c', 'cpp', 'html', 'css',
      \ ]

" Hard-wrap the paragraph under the cursor to 'textwidth', but refuse if
" the cursor is on a table row or inside a fenced code block -- gq has no
" awareness of markdown structure and would otherwise mangle either.
function! MarkdownSafeWrapParagraph()
  if getline('.') =~# '^\s*|'
    echohl WarningMsg | echom 'MarkdownSafeWrapParagraph: on a table row, not wrapping' | echohl None
    return
  endif
  let l:fence_count = 0
  for l:lnum in range(1, line('.'))
    if getline(l:lnum) =~# '^\s*```'
      let l:fence_count += 1
    endif
  endfor
  if l:fence_count % 2 == 1
    echohl WarningMsg | echom 'MarkdownSafeWrapParagraph: inside a code block, not wrapping' | echohl None
    return
  endif
  normal! gqip
endfunction

" Wrap a visual selection as a markdown link, using the system clipboard
" (the "+ register, matches `set clipboard=unnamed`) as the URL. Flow:
" copy a URL elsewhere, then visually select link text here and press
" <leader>l. Clipboard is left untouched so the same URL can be reused.
function! MarkdownWrapSelectionAsLink() range
  let l:url = trim(getreg('+'))
  if empty(l:url)
    echohl WarningMsg | echom 'MarkdownWrapSelectionAsLink: system clipboard is empty' | echohl None
    return
  endif
  let l:save_reg = @z
  let l:save_regtype = getregtype('z')
  normal! gv"zy
  let l:text = @z
  call setreg('z', l:save_reg, l:save_regtype)
  execute "normal! gvc[" . l:text . "](" . l:url . ")"
endfunction

" Wrap the bare URL under the cursor as a self-referencing markdown link.
" Uses <cWORD>, not <cword>, since URLs contain '/', ':', '?', etc. that
" would otherwise split the "word".
function! MarkdownWrapUrlUnderCursor()
  let l:url = expand('<cWORD>')
  if l:url !~# '^\a\+://' && l:url !~# '^www\.'
    echohl WarningMsg | echom 'MarkdownWrapUrlUnderCursor: cursor is not on a URL' | echohl None
    return
  endif
  execute "normal! ciW[" . l:url . "](" . l:url . ")"
endfunction

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
