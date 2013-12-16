if exists('g:loaded_rakevim')
  finish
endif
let g:loaded_rakevim = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? -complete=customlist,rake#complete Rake call rake#execute(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
