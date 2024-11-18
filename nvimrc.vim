" init.vim

" File Explorer
cnoreabbrev fe NvimTreeToggle

" open Terminal
" cnoreabbrev t term
" cnoreabbrev Term term
cnoreabbrev W w
cnoreabbrev q wincmd l <BAR> wincmd k <BAR> q <BAR> q <BAR> q
cnoreabbrev Q q
cnoreabbrev wq wincmd l <BAR> wincmd k <BAR> wq <BAR> q <BAR> q
cnoreabbrev qa wincmd l <BAR> wincmd k <BAR> qa <BAR> q <BAR> q
cnoreabbrev qa! wincmd l <BAR> wincmd k <BAR> qa! <BAR> q <BAR> q

" set linebreak
cnoreabbrev save w


highlight Normal guibg=NONE ctermbg=NONE

