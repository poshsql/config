"these lines are suggested to be at the top of every colorscheme
hi clear
if exists("syntax_on")
  syntax reset
endif

"Load the 'base' colorscheme - the one you want to alter
runtime colors/xoria256.vim

"Override the name of the base colorscheme with the name of this custom one
let g:colors_name = "myxoria256"

"Clear the colors for any items that you don't like
hi clear Folded       

"Set up your new & improved colors
hi Folded       ctermfg=255 guifg=grey ctermbg=60  guibg=black
