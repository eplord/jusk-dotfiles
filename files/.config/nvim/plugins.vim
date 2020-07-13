" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "
call plug#begin('~/.config/nvim/plugged')


" Sensible (?) defaults
Plug 'tpope/vim-sensible'


" colorscheme
Plug 'flazz/vim-colorschemes'


" Icons
Plug 'ryanoasis/vim-devicons'


" File explorer
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Show hidden files/directories
let g:NERDTreeShowHidden = 1

" Remove bookmarks and help text from NERDTree
let g:NERDTreeMinimalUI = 1

" Custom icons for expandable/expanded directories
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

" Hide certain files and directories from NERDTree
let g:NERDTreeIgnore = ['\.git$[[dir]]']


" Customized vim status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='badwolf'


" === Languages === "
" lint
Plug 'dense-analysis/ale'
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 1000
let g:ale_sign_error = '\ '
let g:ale_sign_warning = '\ '
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}


" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }


" elm
Plug 'elmcast/elm-vim'
let g:elm_setup_keybindings = 0


" DOcumentation GEneraton
Plug 'kkoomen/vim-doge'


" Trailing whitespace highlighting & automatic fixing
Plug 'ntpeters/vim-better-whitespace'


" auto-close plugins
Plug 'rstacruz/vim-closer'
Plug 'tpope/vim-endwise'


" Improved motion in Vim
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'


" Snippet support
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'


" Print function signatures in echo area
Plug 'Shougo/echodoc.vim'


" Enable git changes to be shown in sign column
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'


" Initialize plugin system
call plug#end()



" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

colorscheme badwolf


" Wrap in try/catch to avoid errors on initial install before plugin is available
try
" === Coc.nvim === "
" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Allow use of :Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" === NeoSnippet === "
" Map <C-k> as shortcut to activate snippet if available
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" Load custom snippets from snippets folder
let g:neosnippet#snippets_directory='~/.config/nvim/snippets'

" Hide conceal markers
let g:neosnippet#enable_conceal_markers = 0


" === Vim airline ==== "
" Enable extensions
let g:airline_extensions = ['branch', 'hunks', 'coc']

" Update section z to just have line number
let g:airline_section_z = airline#section#create(['linenr'])

" Do not draw separators for empty sections (only for the active window) >
let g:airline_skip_empty_sections = 1

" Smartly uniquify buffers names with similar filename, suppressing common parts of paths.
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Custom setup that removes filetype/whitespace from default vim airline bar
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]

" Customize vim airline per filetype
" 'nerdtree'  - Hide nerdtree status line
" 'list'      - Only show file type plus current line number out of total
let g:airline_filetype_overrides = {
  \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', ''), '' ],
  \ 'list': [ '%y', '%l/%L'],
  \ }

" Enable powerline fonts
let g:airline_powerline_fonts = 1

" Enable caching of syntax highlighting groups
let g:airline_highlighting_cache = 1

" Define custom airline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Don't show git changes to current file in airline
let g:airline#extensions#hunks#enabled=0

catch
  echo 'Airline not installed. It should work after running :PlugInstall'
endtry

" === echodoc === "
" Enable echodoc on startup
let g:echodoc#enable_at_startup = 1

" === vim-javascript === "
" Enable syntax highlighting for JSDoc
let g:javascript_plugin_jsdoc = 1

" === vim-jsx === "
" Highlight jsx syntax even in non .jsx files
let g:jsx_ext_required = 0

" === javascript-libraries-syntax === "
let g:used_javascript_libs = 'underscore,requirejs,chai,jquery'

" === Signify === "
let g:signify_sign_delete = '-'


" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Change highlight group of preview window when open
function! Handle_Win_Enter()
  if &previewwindow
    setlocal winhighlight=Normal:MarkdownError
  endif
endfunction


" Reload icons after init source
if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif

" Disable deprecated python2 provider
let g:loaded_python_provider = 0
