set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set autoindent
set smartindent
set noswapfile
set number
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
nmap <silent> <c-m> :NERDTreeToggle<CR>
syntax enable
set background=dark
colorscheme solarized

function! UPDATE_TAGS()
  cd /home/jacek/work/PCI/payment_gateway
  let _f_ = expand("%:p")
  let _cmd_ = '"ctags -R *"'
  let _resp = system(_cmd_)
  unlet _cmd_
  unlet _f_
  unlet _resp
endfunction
autocmd BufWrite *.rb call UPDATE_TAGS()


function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
