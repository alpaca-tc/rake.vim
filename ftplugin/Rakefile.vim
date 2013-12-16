augroup Rakefile
  autocmd!
  autocmd BufWritePost <buffer> call rake#initialize_tasks()
  autocmd FileType <buffer> call s:remove_autocmd()
augroup END

function! s:remove_autocmd() "{{{
  if &filetype != 'Rakefile'
    autocmd! Rakefile
  endif
endfunction"}}}
