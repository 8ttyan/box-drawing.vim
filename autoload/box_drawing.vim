
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
function! box_drawing#moveLine(offset) abort
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
function! box_drawing#moveCol(offset) abort
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

function! box_drawing#debug() abort
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

function! box_drawing#singleLineToLeft() abort
	call s:connectLeft()
	call box_drawing#moveCol(-1)
	call s:connectRight()
endfunction
function! box_drawing#singleLineToRight() abort
	call s:connectRight()
	call box_drawing#moveCol(1)
	call s:connectLeft()
endfunction
function! box_drawing#singleLineToBottom() abort
	call s:connectBottom()
	call box_drawing#moveLine(1)
	call s:connectTop()
endfunction
function! box_drawing#singleLineToTop() abort
	call s:connectTop()
	call box_drawing#moveLine(-1)
	call s:connectBottom()
endfunction

function! box_drawing#map() abort
	nmap <buffer> j :call box_drawing#moveLine(1)<CR>
	nmap <buffer> k :call box_drawing#moveLine(-1)<CR>
	nmap <buffer> h :call box_drawing#moveCol(-1)<CR>
	nmap <buffer> l :call box_drawing#moveCol(1)<CR>

	nmap <buffer> J :call box_drawing#singleLineToBottom()<CR>
	nmap <buffer> K :call box_drawing#singleLineToTop()<CR>
	nmap <buffer> H :call box_drawing#singleLineToLeft()<CR>
	nmap <buffer> L :call box_drawing#singleLineToRight()<CR>

	nmap <buffer> <ESC> :call box_drawing#unmap()<CR>
endfunction

function! box_drawing#unmap() abort
	:mapclear <buffer>
endfunction


