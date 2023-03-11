set nocompatible
set cursorline
set number                          " line number
set laststatus=2                    " state bar on the bottom
set termguicolors                   " 24 bit color
set backspace=indent,eol,start      " enable backspace
set incsearch                       " incremental search
set clipboard=unnamed               " enable ctrl-c and ctrl-v
set hlsearch                        " highlight search
set expandtab                       " replace tab with space
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set wildmenu                        " auto complete command
set ignorecase                      " ignore upper/lower case when search
set smartcase                       " sensitive to uppercase
set autochdir
set showmatch
set nobackup
set noswapfile                      " no swap file .***.swp
" disable ominicomplete preview
" set completeopt-=preview
set background=dark

" tablength exceptions
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
autocmd FileType slim setlocal shiftwidth=2 tabstop=2
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType go setlocal shiftwidth=4 tabstop=4
autocmd FileType cc setlocal shiftwidth=2 tabstop=2
autocmd FileType cpp setlocal shiftwidth=2 tabstop=2
autocmd FileType h setlocal shiftwidth=2 tabstop=2
autocmd FileType c setlocal shiftwidth=2 tabstop=2
autocmd FileType py setlocal shiftwidth=4 tabstop=4

filetype on
filetype plugin on
filetype plugin indent on
syntax enable

colorscheme gruvbox

" bind switch shortcut
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

xmap ga <Plug>(EasyAlign)

map <F5>  :call CompileRunGcc()<CR>
map <C-N> :NERDTree<CR>
map <F12> :TagbarToggle<CR>

" header of different file
autocmd BufNewFile *.py exec ":call append(0, '')" 
autocmd BufNewFile *.cc,*.cpp,*.h,*.c exec ":call SetFileHeader('//')"
autocmd BufNewFile *.py,*.sh exec ":call SetFileHeader('##')" 
autocmd BufNewFile *.py exec ":call append(0, ['# -*- coding: utf-8 -*-', ''])" 
autocmd BufNewFile *.sh exec ":call append(0, '#!/bin/bash')" 

autocmd BufWrite *.cc,*.cpp,*.h,*.c exec ":call UpdateModifyTime('//')"
autocmd BufWrite *.py,*.sh exec ":call UpdateModifyTime('##')" 

" set background transparent
" hi Normal guibg=NONE ctermbg=NONE

augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

let g:gruvbox_italic = 1
let g:airline#extensions#tabline#enabled = 1
let g:ale_completion_enabled = 1

" Nerd Commenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDAltDelims_java = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1

" compile run
func CompileRunGcc()
        exec "w"
        if &filetype == 'c'
                exec "!g++ % -o %<"
                exec "!time ./%<"
        elseif &filetype == 'cpp'
                exec "!g++ % -o %<"
                exec "!time ./%<"
        elseif &filetype == 'java'
                exec "!javac %"
                exec "!time java %<"
        elseif &filetype == 'sh'
                :!time bash %
        elseif &filetype == 'python'
                exec "!clear"
                exec "!time python3 %"
        elseif &filetype == 'html'
                exec "!firefox % &"
        elseif &filetype == 'go'
                " exec "!go build %<"
                exec "!time go run %"
        elseif &filetype == 'mkd'
                exec "!~/.vim/markdown.pl % > %.html &"
                exec "!firefox %.html &"
        endif
endfunc

func SetFileHeader(cmt_sym)
    call append(0, a:cmt_sym . " =================================================== ")
    call append(0, a:cmt_sym)
    call append(0, a:cmt_sym . "    Description   : ")
    call append(0, a:cmt_sym . "    File Name     : " . expand('%:t'))
    call append(0, a:cmt_sym . "    Last Modified : " . strftime('%Y-%m-%d %H:%M'))
    call append(0, a:cmt_sym . "    Create On     : " . strftime('%Y-%m-%d %H:%M'))
    call append(0, a:cmt_sym . "    Institute     : " . GetInstitute())
    call append(0, a:cmt_sym . "    Email         : " . GetUserEmail())
    call append(0, a:cmt_sym . "    Author        : " . GetUserName())
    call append(0, a:cmt_sym)
    call append(0, a:cmt_sym . " =================================================== ")
endfunc

func UpdateModifyTime(cmt_sym)
    let line_no = 0
    while line_no < 15
        let cur_line = getline(line_no)
        if cur_line =~ a:cmt_sym . "    Last Modified"
            call setline(line_no, a:cmt_sym . "    Last Modified : " . strftime('%Y-%m-%d %H:%M'))
            break
        endif
        let line_no += 1
    endwhile
endfunc

func GetUserName()
    let author = $USER_NAME
    if author == ""
        let author = "Fan Zhang"
    endif
    return author
endfunc

func GetUserEmail()
    let email = $USER_EMAIL
    if email == ""
        let email = "zhangfan@baai.ac.cn"
    endif
    return email
endfunc

func GetInstitute()
    let email = $INSTITUTE
    if email == ""
        let email = "Beijing Academy of Artificial Intelligence (BAAI)"
    endif
    return email
endfunc

