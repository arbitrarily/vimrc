" http://nvie.com/posts/how-i-boosted-my-vim/
" http://natelandau.com/bash-scripting-utilities/

" Colors
    syntax enable           " enable syntax processing
    colorscheme badwolf     " https://github.com/sjl/badwolf

" Misc
    set ttyfast             " faster redraw
    set backspace=indent,eol,start

" Spaces & Tabs
    set tabstop=4           " 4 space tab
    set expandtab           " use spaces for tabs
    set softtabstop=4       " 4 space tab
    set shiftwidth=4
    set modelines=1
    filetype indent on
    filetype plugin on
    set autoindent

" UI Layout
    set number              " show line numbers
    set showcmd             " show command in bottom bar
    set cursorline          " highlight current line
    hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
    set wildmenu
    "set lazyredraw
    set showmatch           " higlight matching parenthesis

" Searching
    set ignorecase          " ignore case when searching
    set incsearch           " search as characters are entered
    set hlsearch            " highlight all matches

" Folding
    set foldmethod=indent   " fold based on indent level
    set foldnestmax=10      " max 10 depth
    set foldenable          " don't fold files by default on open
    nnoremap <space> za
    set foldlevelstart=10    " start with fold level of 1

" Line Shortcuts
    nnoremap j gj
    nnoremap k gk
    nnoremap B ^
    nnoremap E $
    nnoremap $ <nop>
    nnoremap ^ <nop>
    nnoremap gV `[v`]
    onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
    xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
    onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
    xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

    " disable them arrow keys
    noremap <Up> <NOP>
    noremap <Down> <NOP>
    noremap <Left> <NOP>
    noremap <Right> <NOP>

    onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
    xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
    onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
    xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>

" Leader Shortcuts
    let mapleader=","
    nnoremap <leader>m :silent make\|redraw!\|cw<CR>
    nnoremap <leader>w :NERDTree<CR>
    nnoremap <leader>u :GundoToggle<CR>
    nnoremap <leader>h :A<CR>
    nnoremap <leader>ev :vsp $MYVIMRC<CR>
    nnoremap <leader>ez :vsp ~/.zshrc<CR>
    nnoremap <leader>sv :source $MYVIMRC<CR>
    nnoremap <leader>l :call ToggleNumber()<CR>
    nnoremap <leader><space> :noh<CR>
    nnoremap <leader>s :mksession<CR>
    nnoremap <leader>a :Ag
    nnoremap <leader>c :SyntasticCheck<CR>:Errors<CR>
    nnoremap <leader>1 :set number!<CR>
    nnoremap <leader>d :Make!
    nnoremap <leader>r :call RunTestFile()<CR>
    nnoremap <leader>g :call RunGoFile()<CR>
    vnoremap <leader>y "+y
    vmap v <Plug>(expand_region_expand)
    vmap <C-v> <Plug>(expand_region_shrink)
    inoremap jk <esc>

" CtrlP
    let g:ctrlp_match_window = 'bottom,order:ttb'
    let g:ctrlp_switch_buffer = 0
    let g:ctrlp_working_path_mode = 0
    let g:ctrlp_custom_ignore = '\vbuild/|dist/|venv/|target/|\.(o|swp|pyc|egg)$'

"" Tmux
    "if exists('$TMUX') " allows cursor change in tmux mode
    "    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    "    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    "else
    "    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    "    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    "endif

" MacVim
    set guioptions-=r
    set guioptions-=L

" AutoGroups
    augroup configgroup
        autocmd!
        autocmd VimEnter * highlight clear SignColumn
        autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md,*.rb :call <SID>StripTrailingWhitespaces()
        autocmd BufEnter *.cls setlocal filetype=java
        autocmd BufEnter *.zsh-theme setlocal filetype=zsh
        autocmd BufEnter Makefile setlocal noexpandtab
        autocmd BufEnter *.sh setlocal tabstop=2
        autocmd BufEnter *.sh setlocal shiftwidth=2
        autocmd BufEnter *.sh setlocal softtabstop=2
    augroup END

" Backups
    set backup
    set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    set backupskip=/tmp/*,/private/tmp/*
    set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    set writebackup

" Custom Functions
    function! ToggleNumber()
        if(&relativenumber == 1)
            set norelativenumber
            set number
        else
            set relativenumber
        endif
    endfunc

    " strips trailing whitespace at the end of files. this
    " is called on buffer write in the autogroup above.
    function! <SID>StripTrailingWhitespaces()
        " save last search & cursor position
        let _s=@/
        let l = line(".")
        let c = col(".")
        %s/\s\+$//e
        let @/=_s
        call cursor(l, c)
    endfunction

    function! <SID>CleanFile()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " Do the business:
        %!git stripspace
        " Clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction

    function! s:NextTextObject(motion, dir)
      let c = nr2char(getchar())

      if c ==# "b"
          let c = "("
      elseif c ==# "B"
          let c = "{"
      elseif c ==# "r"
          let c = "["
      endif

      exe "normal! ".a:dir.c."v".a:motion.c
    endfunction

" vim:foldmethod=marker:foldlevel=0
