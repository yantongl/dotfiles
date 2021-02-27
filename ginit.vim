" this is config for nvim-qt
let isNvimQt=has('nvim') && exists('g:GuiLoaded')

if isNvimQt == 1
    GuiFont Consolas:h11
    GuiTabline 0  " disable nvim-qt tabline
endif

