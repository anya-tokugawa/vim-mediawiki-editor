if exists('g:loaded_mediawiki_editor')
    finish
endif
let g:loaded_mediawiki_editor = 1

let s:initialized_python = 0
let s:script_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! s:InitializeClient()
    if has('python')
        let s:pcommand = 'python'
        let s:pfile = 'pyfile'
    elseif has('python3')
        let s:pcommand = 'python3'
        let s:pfile = 'py3file'
    else
        echo 'Error: this plugin requires vim compiled with python support.'
        finish
    endif

    if !s:initialized_python
        let s:initialized_python = 1
        execute s:pfile . ' ' . s:script_path . '/mediawiki_editor.py'
    endif
endfunction

function! s:MWRead(article_name) abort
    call <SID>InitializeClient()
    execute s:pcommand . " mw_read(vim.eval('a:article_name'))"
endfunction

function! s:MWCurrentBacklinks() abort
    call <SID>InitializeClient()
    execute s:pcommand . " mw_currentbacklinks()"
endfunction

function! s:MWBacklinks(article_name) abort
    call <SID>InitializeClient()
    execute s:pcommand . " mw_backlinks(vim.eval('a:article_name'))"
endfunction

function! s:MWMove(no_redirect, new_name) abort
    call <SID>InitializeClient()
    execute s:pcommand . " mw_move(vim.eval('a:no_redirect'), vim.eval('a:new_name'))"
endfunction

function! s:MWWrite(...) abort
    call <SID>InitializeClient()
    execute s:pcommand . " mw_write(vim.eval('a:000'))"
endfunction

function! s:MWDiff(...) abort
    call <SID>InitializeClient()
    execute s:pcommand . " mw_diff(vim.eval('a:000'))"
endfunction

function! s:MWBrowse(...) abort
    call <SID>InitializeClient()
    execute s:pcommand . " mw_browse(vim.eval('a:000'))"
endfunction

command! -nargs=1 MWRead call <SID>MWRead(<f-args>)
command! -nargs=1 MWBacklinks call <SID>MWBacklinks(<f-args>)
command! -nargs=? MWCurrentBacklinks call <SID>MWCurrentBacklinks()
command! -nargs=1 MWMove call <SID>MWMove(0, <f-args>)
command! -nargs=1 MWRename call <SID>MWMove(1, <f-args>)
command! -nargs=? MWWrite call <SID>MWWrite(<f-args>)
command! -nargs=? MWDiff call <SID>MWDiff(<f-args>)
command! -nargs=? MWBrowse call <SID>MWBrowse(<f-args>)

" Useful mappings
nnoremap gf "wyi[:MWRead <C-R>w<CR>
nnoremap <C-w>f "wyi[<C-w>n:MWRead <C-R>w<CR>
nnoremap gl "wyi[:MWBacklinks <C-R>w<CR>
nnoremap g. :MWCurrentBacklinks<CR>


"augroup mediawiki
"    autocmd!
"    "
"    " Try to make mediawiki stuff automatically :w to the right place since we set 
"    " the buftype=acwrite
"    autocmd BufWriteCmd *.wiki call <SID>MWWrite()

"    " This is making it break with current syntax highlighting
"    "autocmd BufReadPost *.wiki setfiletype mediawiki
"    " ...
"augroup END
