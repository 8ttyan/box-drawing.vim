
" get character under cursor for multibyte
function! s:getCharUnderCursor() abort
	return matchstr(getline('.'), '.', col('.')-1)
endfunction

" replace character in multibyte string
function! s:replaceCharInString(target, pos, char) abort
	let splitted = split(a:target, '\zs')
	call remove(splitted,a:pos)
	call insert(splitted,a:char,a:pos)
	return join(splitted,"")
endfunction

" replace character under cursor
function! s:replaceCharUnderCursor(str) abort
	let newline = s:replaceCharInString(getline('.'), charcol('.')-1 ,a:str)
	call setline(line('.'), newline)
endfunction

" move cursor to next/prev line and keep column
function! boxdrawing#moveLine(offset) abort
	let mycol = virtcol('.')
	let linestr = getline(line('.')+a:offset)
	let linelen = strwidth(linestr)
	"add space
	if linelen<mycol
		let index = linelen
		while index<mycol
			let linestr = linestr . ' '
			let index = index + 1
		endwhile
		call setline(line('.')+a:offset,linestr)
	endif
	"move cursor
	call setcharpos('.',[0,line('.')+a:offset,mycol,0])
endfunction

" move corsor to left/right (multibyte character)
function! boxdrawing#moveCol(offset) abort
	let mycol = virtcol('.')
	let linestr = getline('.')
	let linelen = strwidth(linestr)
	"add space
	let needlen = mycol+a:offset
	if linelen<needlen
		let index = mycol
		while index<needlen
			let linestr = linestr . ' '
			let index = index + 1
		endwhile
		call setline('.',linestr)
	endif
	call setcharpos('.',[0,line('.'),mycol+a:offset,0])
endfunction

function! boxdrawing#debug() abort
	echo "virtcol" virtcol('.')
	echo "col"     col('.')
	echo "strlen"  strlen(getline('.'))
	echo "strwidth" strwidth(getline('.'))
	echo "strdisplaywidth" strdisplaywidth(getline('.'))
endfunction

" connect cursor character to left character
function! s:connectLeft() abort
	let table = {'│':'┤', '─':'─', '┐':'┐', '┌':'┬', '└':'┴', '┘':'┘', '├':'┼', '┤':'┤', '┬':'┬', '┴':'┴', '┼':'┼', '╴':'╴', '╵':'┘', '╶':'─', '╷':'┐'}
	let default = '╴'
	call s:connect(table,default)
endfunction
function! s:connectRight() abort
	let table = { '│':'├', '─':'─', '┐':'┬', '┌':'┬', '└':'└', '┘':'┴', '├':'├', '┤':'┼', '┬':'┬', '┴':'┴', '┼':'┼', '╴':'─', '╵':'└', '╶':'─', '╷':'┌'}
	let default = '╶'
	call s:connect(table,default)
endfunction
function! s:connectBottom() abort
	let table = { '│':'│', '─':'┬', '┐':'┐', '┌':'┌', '└':'├', '┘':'┤', '├':'├', '┤':'┤', '┬':'┬', '┴':'┼', '┼':'┼', '╴':'┐', '╵':'│', '╶':'┌', '╷':'╷'}
	let default = '╷'
	call s:connect(table,default)
endfunction
function! s:connectTop() abort
	let table = { '│':'│', '─':'┴', '┐':'┤', '┌':'├', '└':'└', '┘':'┘', '├':'├', '┤':'┤', '┬':'┼', '┴':'┴', '┼':'┼', '╴':'┘', '╵':'╵', '╶':'└', '╷':'│'}
	let default = '╵'
	call s:connect(table,default)
endfunction

function! s:connect(table, default) abort
	let curstr = s:getCharUnderCursor()
	let newstr = get(a:table,curstr,a:default)
	call s:replaceCharUnderCursor(newstr)
endfunction

function! boxdrawing#singleLineToLeft() abort
	call s:connectLeft()
	call boxdrawing#moveCol(-1)
	call s:connectRight()
endfunction
function! boxdrawing#singleLineToRight() abort
	call s:connectRight()
	call boxdrawing#moveCol(1)
	call s:connectLeft()
endfunction
function! boxdrawing#singleLineToBottom() abort
	call s:connectBottom()
	call boxdrawing#moveLine(1)
	call s:connectTop()
endfunction
function! boxdrawing#singleLineToTop() abort
	call s:connectTop()
	call boxdrawing#moveLine(-1)
	call s:connectBottom()
endfunction

function! boxdrawing#map() abort
	nmap <buffer> j :call boxdrawing#moveLine(1)<CR>
	nmap <buffer> k :call boxdrawing#moveLine(-1)<CR>
	nmap <buffer> h :call boxdrawing#moveCol(-1)<CR>
	nmap <buffer> l :call boxdrawing#moveCol(1)<CR>

	nmap <buffer> J :call boxdrawing#singleLineToBottom()<CR>
	nmap <buffer> K :call boxdrawing#singleLineToTop()<CR>
	nmap <buffer> H :call boxdrawing#singleLineToLeft()<CR>
	nmap <buffer> L :call boxdrawing#singleLineToRight()<CR>

	nmap <buffer> <ESC> :call boxdrawing#unmap()<CR>
endfunction

function! boxdrawing#unmap() abort
	:mapclear <buffer>
endfunction


