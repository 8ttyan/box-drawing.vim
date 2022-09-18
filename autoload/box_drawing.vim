
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
function! box_drawing#moveRow(offset) abort
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

function! box_drawing#moveCursorUp() abort
	call box_drawing#moveRow(-1)
endfunction
function! box_drawing#moveCursorDown() abort
	call box_drawing#moveRow(1)
endfunction
function! box_drawing#moveCursorLeft() abort
	call box_drawing#moveCol(-1)
endfunction
function! box_drawing#moveCursorRight() abort
	call box_drawing#moveCol(1)
endfunction

function! box_drawing#debug() abort
	echo "virtcol" virtcol('.')
	echo "col"     col('.')
	echo "strlen"  strlen(getline('.'))
	echo "strwidth" strwidth(getline('.'))
	echo "strdisplaywidth" strdisplaywidth(getline('.'))
endfunction

" replace character under cursor by table
function! s:replaceCharUnderCursorTable(table, default) abort
	let curstr = s:getCharUnderCursor()
	let newstr = get(a:table,curstr,a:default)
	call s:replaceCharUnderCursor(newstr)
endfunction

" Base functions (Draw single line)
function! s:singleLeft() abort
	let table = { '─':'─', '│':'┤', '┐':'┐', '┌':'┬', '└':'┴', '┘':'┘', '├':'┼', '┤':'┤', '┬':'┬', '┴':'┴', '┼':'┼', '╴':'╴', '╵':'┘', '╶':'─', '╷':'┐'}
	let default = '╴'
	call s:replaceCharUnderCursorTable(table,default)
endfunction
function! s:singleRight() abort
	let table = { '─':'─', '│':'├', '┐':'┬', '┌':'┬', '└':'└', '┘':'┴', '├':'├', '┤':'┼', '┬':'┬', '┴':'┴', '┼':'┼', '╴':'─', '╵':'└', '╶':'─', '╷':'┌'}
	let default = '╶'
	call s:replaceCharUnderCursorTable(table,default)
endfunction
function! s:singleDown() abort
	let table = { '─':'┬', '│':'│', '┐':'┐', '┌':'┌', '└':'├', '┘':'┤', '├':'├', '┤':'┤', '┬':'┬', '┴':'┼', '┼':'┼', '╴':'┐', '╵':'│', '╶':'┌', '╷':'╷'}
	let default = '╷'
	call s:replaceCharUnderCursorTable(table,default)
endfunction
function! s:singleUp() abort
	let table = { '─':'┴','│':'│',  '┐':'┤', '┌':'├', '└':'└', '┘':'┘', '├':'├', '┤':'┤', '┬':'┼', '┴':'┴', '┼':'┼', '╴':'┘', '╵':'╵', '╶':'└', '╷':'│'}
	let default = '╵'
	call s:replaceCharUnderCursorTable(table,default)
endfunction

" Base functions (Erase line)
function! s:eraseLeft() abort
	let table = {'─':'╶', '│':'│', '┐':'╷', '┌':'┌', '└':'└', '┘':'╵', '├':'├', '┤':'│', '┬':'┌', '┴':'└', '┼':'├', '╴':' ', '╵':' ', '╶':'╶', '╷':'╷'}
	let default = ' '
	call s:replaceCharUnderCursorTable(table,default)
endfunction
function! s:eraseRight() abort
	let table = {'─':'╴', '│':'│', '┐':'┐', '┌':'╷', '└':'╵', '┘':'┘', '├':'│', '┤':'┤', '┬':'┐', '┴':'┘', '┼':'┤', '╴':'╴', '╵':'╵', '╶':' ', '╷':'╷'}
	let default = ' '
	call s:replaceCharUnderCursorTable(table,default)
endfunction
function! s:eraseDown() abort
	let table = {'─':'─', '│':'╵', '┐':'╴', '┌':'╶', '└':'└', '┘':'┘', '├':'└', '┤':'┘', '┬':'─', '┴':'┴', '┼':'┴', '╴':'╴', '╵':'╵', '╶':'╶', '╷':' '}
	let default = ' '
	call s:replaceCharUnderCursorTable(table,default)
endfunction
function! s:eraseUp() abort
	let table = {'─':'─', '│':'╷', '┐':'┐', '┌':'┌', '└':'╶', '┘':'╴', '├':'┌', '┤':'┐', '┬':'┬', '┴':'─', '┼':'┬', '╴':'╴', '╵':' ', '╶':'╶', '╷':'╷'}
	let default = ' '
	call s:replaceCharUnderCursorTable(table,default)
endfunction

" Move single line pen
function! box_drawing#moveSinglePenLeft() abort
	call s:singleLeft()
	call box_drawing#moveCursorLeft()
	call s:singleRight()
endfunction
function! box_drawing#moveSinglePenRight() abort
	call s:singleRight()
	call box_drawing#moveCursorRight()
	call s:singleLeft()
endfunction
function! box_drawing#moveSinglePenDown() abort
	call s:singleDown()
	call box_drawing#moveCursorDown()
	call s:singleUp()
endfunction
function! box_drawing#moveSinglePenUp() abort
	call s:singleUp()
	call box_drawing#moveCursorUp()
	call s:singleDown()
endfunction

" Move eraser
function! box_drawing#moveEraserLeft() abort
	call s:eraseLeft()
	call box_drawing#moveCursorLeft()
	call s:eraseRight()
endfunction
function! box_drawing#moveEraserRight() abort
	call s:eraseRight()
	call box_drawing#moveCursorRight()
	call s:eraseLeft()
endfunction
function! box_drawing#moveEraserDown() abort
	call s:eraseDown()
	call box_drawing#moveCursorDown()
	call s:eraseUp()
endfunction
function! box_drawing#moveEraserUp() abort
	call s:eraseUp()
	call box_drawing#moveCursorUp()
	call s:eraseDown()
endfunction

function! box_drawing#map() abort
	"move
	nnoremap <silent><buffer> j :call box_drawing#moveCursorDown()<CR>
	nnoremap <silent><buffer> k :call box_drawing#moveCursorUp()<CR>
	nnoremap <silent><buffer> h :call box_drawing#moveCursorLeft()<CR>
	nnoremap <silent><buffer> l :call box_drawing#moveCursorRight()<CR>

	"single line
	nnoremap <silent><buffer> J :call box_drawing#moveSinglePenDown()<CR>
	nnoremap <silent><buffer> K :call box_drawing#moveSinglePenUp()<CR>
	nnoremap <silent><buffer> H :call box_drawing#moveSinglePenLeft()<CR>
	nnoremap <silent><buffer> L :call box_drawing#moveSinglePenRight()<CR>

	"erase line
	nnoremap <silent><buffer> <c-j> :call box_drawing#moveEraserDown()<CR>
	nnoremap <silent><buffer> <c-k> :call box_drawing#moveEraserUp()<CR>
	nnoremap <silent><buffer> <c-h> :call box_drawing#moveEraserLeft()<CR>
	nnoremap <silent><buffer> <c-l> :call box_drawing#moveEraserRight()<CR>

	"escape keybind
	nnoremap <silent><buffer> <ESC> :call box_drawing#unmap()<CR>
	nnoremap <silent><buffer> : :call box_drawing#unmap()<CR>

	"print usage
	echohl Comment
	echo "single:JKHL, erase:Ctrl-jkhl, exit:ESC"
	echohl None
endfunction
       
function! box_drawing#unmap() abort
	:mapclear <buffer>
endfunction

