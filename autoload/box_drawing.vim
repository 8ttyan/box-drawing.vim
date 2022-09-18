
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

" replace char by table
function! s:connect(table, default) abort
	let curstr = s:getCharUnderCursor()
	let newstr = get(a:table,curstr,a:default)
	call s:replaceCharUnderCursor(newstr)
endfunction

" connect functions
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

" discnnect functions
function! s:disconnectLeft() abort
	let table = {'│':'│', '─':'╶', '┐':'╷', '┌':'┌', '└':'└', '┘':'╵', '├':'├', '┤':'│', '┬':'┌', '┴':'└', '┼':'├', '╴':' ', '╵':' ', '╶':'╶', '╷':'╷'}
	let default = ' '
	call s:connect(table,default)
endfunction
function! s:disconnectRight() abort
	let table = {'│':'│', '─':'╴', '┐':'┐', '┌':'╷', '└':'╵', '┘':'┘', '├':'│', '┤':'┤', '┬':'┐', '┴':'┘', '┼':'┤', '╴':'╴', '╵':'╵', '╶':' ', '╷':'╷'}
	let default = ' '
	call s:connect(table,default)
endfunction
function! s:disconnectBottom() abort
	let table = {'│':'╵', '─':'╶', '┐':'╴', '┌':'╶', '└':'└', '┘':'┘', '├':'└', '┤':'┘', '┬':'─', '┴':'┴', '┼':'┴', '╴':'╴', '╵':'╵', '╶':'╶', '╷':' '}
	let default = ' '
	call s:connect(table,default)
endfunction
function! s:disconnectTop() abort
	let table = {'│':'╷', '─':'─', '┐':'┐', '┌':'┌', '└':'╶', '┘':'╴', '├':'┌', '┤':'┐', '┬':'┬', '┴':'─', '┼':'┬', '╴':'╴', '╵':' ', '╶':'╶', '╷':'╷'}
	let default = ' '
	call s:connect(table,default)
endfunction

" Draw single line
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

" Erase single line
function! box_drawing#eraserToLeft() abort
	call s:disconnectLeft()
	call box_drawing#moveCol(-1)
	call s:disconnectRight()
endfunction
function! box_drawing#eraserToRight() abort
	call s:disconnectRight()
	call box_drawing#moveCol(1)
	call s:disconnectLeft()
endfunction
function! box_drawing#eraserToBottom() abort
	call s:disconnectBottom()
	call box_drawing#moveLine(1)
	call s:disconnectTop()
endfunction
function! box_drawing#eraserToTop() abort
	call s:disconnectTop()
	call box_drawing#moveLine(-1)
	call s:disconnectBottom()
endfunction

function! box_drawing#map() abort
	"move
	nnoremap <silent><buffer> j :call box_drawing#moveLine(1)<CR>
	nnoremap <silent><buffer> k :call box_drawing#moveLine(-1)<CR>
	nnoremap <silent><buffer> h :call box_drawing#moveCol(-1)<CR>
	nnoremap <silent><buffer> l :call box_drawing#moveCol(1)<CR>

	"single line
	nnoremap <silent><buffer> J :call box_drawing#singleLineToBottom()<CR>
	nnoremap <silent><buffer> K :call box_drawing#singleLineToTop()<CR>
	nnoremap <silent><buffer> H :call box_drawing#singleLineToLeft()<CR>
	nnoremap <silent><buffer> L :call box_drawing#singleLineToRight()<CR>

	"erase line
	nnoremap <silent><buffer> <c-j> :call box_drawing#eraserToBottom()<CR>
	nnoremap <silent><buffer> <c-k> :call box_drawing#eraserToTop()<CR>
	nnoremap <silent><buffer> <c-h> :call box_drawing#eraserToLeft()<CR>
	nnoremap <silent><buffer> <c-l> :call box_drawing#eraserToRight()<CR>

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

