" Vim color file
" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
    syntax reset
    endif
endif
let g:colors_name="adam"

hi Normal   guifg=grey80 guibg=grey8

" highlight groups
hi Cursor   guibg=goldenrod guifg=black
hi CursorLine   gui=NONE guibg=grey15
"hi CursorIM    
"hi Directory   
"hi DiffAdd             
"hi DiffChange  
"hi DiffDelete  
"hi DiffText    
"hi ErrorMsg    
hi VertSplit    guibg=#c2bfa5 guifg=grey50 gui=none
hi Folded   guibg=grey30 guifg=gold 
hi FoldColumn   guibg=grey30 guifg=tan
hi LineNr   guifg=#404040
hi ModeMsg  guifg=goldenrod
hi MoreMsg  guifg=SeaGreen
hi NonText  guifg=#202020 guibg=grey8
hi Question guifg=springgreen
hi Search       guifg=white guibg=dodgerblue
hi IncSearch    guifg=mediumpurple guibg=darkblue
hi SpecialKey   guifg=yellowgreen
hi StatusLine   guibg=#c2bfa5 guifg=black gui=none
hi StatusLineNC guibg=#c2bfa5 guifg=grey50 gui=none
hi Title    guifg=indianred
"hi Visual  gui=none guifg=grey16 guibg=darkgoldenrod
hi Visual gui=none guibg=grey20
"hi VisualNOS   
hi WarningMsg   guifg=salmon
"hi WildMenu    
"hi Menu                
"hi Scrollbar   
"hi Tooltip
hi String guifg=darksalmon

" syntax highlighting groups
hi Comment   guifg=SkyBlue
hi Constant  guifg=#ffa0a0
hi Identifier    guifg=palegreen
hi Statement     guifg=khaki
hi PreProc   guifg=indianred
hi Type      guifg=darkkhaki
hi Special   guifg=navajowhite
"hi Underlined  
hi Ignore    guifg=grey40
"hi Error           
hi Todo      guifg=orangered guibg=yellow2


"hi CursorLine   cterm=NONE ctermbg=darkgrey guibg=darkgrey
"hi CursorColumn cterm=NONE ctermbg=darkgrey guibg=darkgrey


"NR-16   NR-8    COLOR NAME 
"0       0       Black
"1       4       DarkBlue
"2       2       DarkGreen
"3       6       DarkCyan
"4       1       DarkRed
"5       5       DarkMagenta
"6       3       Brown, DarkYellow
"7       7       LightGray, LightGrey, Gray, Grey
"8       0*      DarkGray, DarkGrey
"9       4*      Blue, LightBlue
"10      2*      Green, LightGreen
"11      6*      Cyan, LightCyan
"12      1*      Red, LightRed
"13      5*      Magenta, LightMagenta
"14      3*      Yellow, LightYellow
"15      7*      White
" color terminal definitions
hi Normal   ctermfg=grey
hi SpecialKey    ctermfg=darkgreen
hi NonText       cterm=bold ctermfg=darkgrey
hi Directory     ctermfg=darkcyan
hi ErrorMsg      cterm=bold ctermfg=7 ctermbg=1
hi IncSearch     cterm=NONE ctermfg=DarkBlue ctermbg=LightBlue
hi Search        cterm=NONE ctermfg=white ctermbg=blue
hi MoreMsg       ctermfg=darkgreen
hi ModeMsg       cterm=NONE ctermfg=brown
hi LineNr        ctermfg=darkgray
hi Question      ctermfg=green
hi StatusLine    cterm=bold
hi StatusLineNC  cterm=NONE
hi VertSplit     cterm=reverse
hi Title         ctermfg=5
hi Visual        cterm=NONE ctermfg=black ctermbg=darkyellow
hi VisualNOS     cterm=bold,underline
hi WarningMsg    ctermfg=1
hi WildMenu      ctermfg=0 ctermbg=3
hi Folded        ctermfg=darkgrey ctermbg=NONE
hi FoldColumn    ctermfg=darkgrey ctermbg=NONE
hi DiffAdd       ctermbg=4
hi DiffChange    ctermbg=5
hi DiffDelete    cterm=bold ctermfg=4 ctermbg=6
hi DiffText      cterm=bold ctermbg=1
hi Comment       ctermfg=LightBlue
hi Constant      ctermfg=red
hi Special       ctermfg=lightyellow
hi Identifier    ctermfg=darkgreen
hi Statement     ctermfg=yellow
hi PreProc       ctermfg=5
hi Type          ctermfg=lightyellow
hi Underlined    cterm=underline ctermfg=5
hi Ignore        ctermfg=darkgrey
hi Error         cterm=bold ctermfg=7 ctermbg=1
hi String        ctermfg=darkyellow
