" File: cscope_quickfix.vim
" Author: twillard
" Version: 1.0
" Last Modified: Feb 13, 2012
" 
" Overview
" ------------
" Configures vim's builtin cscope support for our clearcase/tagging
" configuration.  Cscope DB is stored in $vob/.svtags/cscope.out
"
" Feature 1
" ------------
" Enables builtin cscope support and hooks up tag stack support as well
" For legacy reasons, maps the ":Cscope" command to ":cscope find"
"
" Feature 2
" ------------
" This script adds keymap macro as follows:
" <C-\> s: Find this C symbol
" <C-\> g: Find this definition
" <C-\> d: Find functions called by this function
" <C-\> c: Find functions calling this function
" <C-\> t: Find this text string
" <C-\> e: Find this egrep pattern
" <C-\> f: Find this file
" <C-\> i: Find files #including this file
" "this" means <cword> or <cfile> on the cursor.
"
" Variables
" --------------
" g:Cscope_OpenQuickfixWindow
" g:Cscope_AutoClose
" g:Cscope_WinHeight
" g:Cscope_Keymap
"
" If you don't want to open quickfix window after :Cscope command, put a line
" in .vimrc like:
" let Cscope_OpenQuickfixWindow = 0
"
" If you want to automatically close the quickfix window after jumping to an
" item, put a line in .vimrc like:
" let Cscope_AutoClose = 1
"
" To configure the height (in lines) of the window that pops up when cscope is
" invoked, put a line in .vimrc like:
" let Cscope_WinHeight = 5
"
" If you don't want to use keymap for :Cscope command, put a line in .vimrc
" like:
" let Cscope_Keymap = 0

" auto-open the quickfix window on a search
if !exists("Cscope_OpenQuickfixWindow")
    let Cscope_OpenQuickfixWindow = 1
endif

" auto-close the quickfix window when leaving it
if !exists("Cscope_AutoClose")
    let Cscope_AutoClose = 0
endif

" enable ctrl+\ keymappings
if !exists("Cscope_Keymap")
    let Cscope_Keymap = 1
endif

" height of the quickfix window when using Cscope_OpenQuickfixWindow
if !exists("Cscope_WinHeight")
    let Cscope_WinHeight = 10
endif

if !exists("Cscope_TagOrder")
    let Cscope_TagOrder = 1
endif

" Automatically close the quickfix window when exiting it if Cscope_AutoClose is 1
autocmd WinLeave * if &buftype == "quickfix" && g:Cscope_AutoClose == 1 | cclose | endif

" Check for the feature first.  vim on wtl-lview-X is built with the cscope
" feature
if has("cscope")

    " RunCscope()
    " Run the cscope command using the supplied option and pattern
    " Has the following perks over just straight-up running :cscope
    " - allows us to support the Cscope_OpenQuickfixWindow (and
    "   Cscope_WinHeight) configuration options
    " - Lets us set the highlight search pattern to the passed-in pattern
    function! s:RunCscope(...)

        " Check function args
        let usage = "Usage: Cscope {type} {pattern}."
        let usage = usage . " {type} is [sgdctefi01234678]."
        if !exists("a:1") || !exists("a:2")
            echohl WarningMsg | echomsg usage | echohl None
            return
        endif

        " Extract args
        let cscope_opt = a:1
        let pattern = a:2

        " Run cscope
        exe "cscope find " . cscope_opt . " " . pattern

        " Open the cscope output window (quickfix) only if these two conditions
        " are true
        " 1) g:Cscope_OpenQuickfixWindow global option is set
        " 2) cscopequickfix is actually configured for this cscope find option
        " (otherwise there'll be no results to show and opening the quickfix
        " window is silly)
        if g:Cscope_OpenQuickfixWindow == 1 && ( stridx(&cscopequickfix, cscope_opt . "+") >= 0 || stridx(&cscopequickfix, cscope_opt . "-") >= 0)
            exe "botright copen " . g:Cscope_WinHeight
        endif

        " highlight pattern
        let @/ = pattern

    endfunction

    " Enable tag stack
    set tagstack

    " Make searches appear in the quickfix window, and each search clears the window
    " first
    " NOTE: putting 'g' in here breaks tag stack functionality
    set cscopequickfix+=s-,c-,d-,i-,t-,e-

    " Make Ctrl-] and :tag use ':cstag' to search
    set cscopetag

    " Make ':cstag' search ctags database first, then cscope database
    " Set to 0 to search cscope first
    let &cscopetagorder = g:Cscope_TagOrder

    " Turn off verbose database adding messages
    set nocscopeverbose

    " add any database in current directory
    if filereadable("cscope.out")
        cscope add cscope.out
    endif

    " Get PWD
    let vob=$PWD

    " translate sw-tc to fwtest, fw-sde to fw because that's where tags are stored
    " for those vobs
    let vob=substitute(vob, "/sw-tc$", "/fwtest", "")
    let vob=substitute(vob, "/fw-sde$", "/fw", "")

    let dirs=split(vob, "/")

    " Build vob path, ie /view/xxx_view_name/vobs/fw
    let linuxvob="/" . join(dirs[:3], "/")

    " Build vob path, ie /m/xxx_view_name/fw
    let cygwinvob="/" . join(dirs[:2], "/")

    " Build vob path, ie /vobs/fw
    let setviewvob="/" . join(dirs[:1], "/")

    let tagsfile = "/.svtags/cscope.out"
    let oldtagsfile = "/.cscope/cscope.out"

    " Look for tags files - starting with the new filename, then trying old
    " filenames.  Stop when we find one.
    for vob in [linuxvob, cygwinvob, setviewvob]
        for tagfile in [tagsfile, oldtagsfile]
            if filereadable(vob . tagfile)
                exe "cscope add " vob . tagfile
                break
            endif
        endfor
    endfor

    " turn verbose database adding messages back on
    set cscopeverbose

    " Map ':Cscope' to ':cscope find'
    command! -nargs=* Cscope call s:RunCscope(<f-args>)
    "command! -nargs=* Cscope cscope find <args>

    """"""""""""" cscope/vim key mappings
    "
    " Stolen shamelessly from http://cscope.sourceforge.net/cscope_maps.vim
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    if g:Cscope_Keymap == 1
        " To do the first type of search, hit 'CTRL-\', followed by one of the
        " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
        " search will be displayed in the current window.  You can use CTRL-T to
        " go back to where you were before the search.
        "

        nmap <C-\>s :Cscope s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>g :Cscope g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>c :Cscope c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>t :Cscope t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>e :Cscope e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>f :Cscope f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-\>i :Cscope i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-\>d :Cscope d <C-R>=expand("<cword>")<CR><CR>


        " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
        " makes the vim window split horizontally, with search result displayed in
        " the new window.

        nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>


        " Hitting CTRL-space *twice* before the search type does a vertical
        " split instead of a horizontal one (vim 6 and up only)
        "
        " (Note: you may wish to put a 'set splitright' in your .vimrc
        " if you prefer the new window on the right instead of the left

        nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

    endif

endif

"Build inside the current directory
function! s:PwdMake(...)
    exe ":make -j8 -C %:p:h " . join(a:000, " ")
    exe ":copen"
endfunction
com! -nargs=* Make call <SID>PwdMake(<args>)

" vim:set ts=4 sw=4 filetype=vim:
