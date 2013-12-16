let s:V = vital#of('rake.vim')

let s:rake_tasks = {}

function! rake#complete(arg_lead, cmd_line, cursor_pos) "{{{
  let project_dir = s:get_project_dir()
  if !has_key(s:rake_tasks, project_dir)
    let list = s:execute_rake('-P', 0)
    if empty(list)
      let s:rake_tasks[project_dir] = []
    else
      let s:rake_tasks[project_dir] = s:parse_list(list)
    endif
  endif

  let splited = split(a:cmd_line, '\s\+')
  if splited[-1] == 'Rake'
    return s:rake_tasks[project_dir]
  elseif len(splited) > 1
    return filter(copy(s:rake_tasks[project_dir]), 'v:val =~ "^" . splited[1]')
  elseif
    return []
  endif
endfunction"}}}

function! rake#execute(args) "{{{
  return s:execute_rake(a:args, 1)
endfunction"}}}

function! rake#initialize_tasks() "{{{
  let s:rake_tasks = {}
endfunction"}}}

function! s:execute_rake(options, is_shell) "{{{
  let l:current_dir = getcwd()
  try
    lcd `=s:get_project_dir()`
    if a:is_shell
      execute '!bundle exec rake' a:options
      let l:result = 1
    else
      let l:result = system('bundle exec rake ' . a:options)
    endif
  catch /.*/
    echomsg v:errmsg
    let l:result = ''
  finally
    lcd `=l:current_dir`
  endtry

  return l:result
endfunction"}}}

function! s:get_project_dir() "{{{
  let current_dir = getcwd()
  return s:V.path2project_directory(current_dir)
endfunction"}}}

function! s:parse_list(result) "{{{
  if a:result =~ 'aborted!'
    return []
  endif

  let list = split(a:result, '\n')
  call filter(list, 'empty(v:val) || v:val !~ "\v(No Rakefile found|\(See full trace by running)"')
  call map(list, "substitute(v:val, ' *\\(rake\\)\\? *', '', 'g')")

  return list
endfunction"}}}
