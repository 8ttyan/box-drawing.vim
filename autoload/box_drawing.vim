
" Direction definition
let s:down  = 0
let s:up    = 1
let s:left  = 2
let s:right = 3

function! s:oppositeDirection(direction)
	if a:direction==s:down
		return s:up
	elseif a:direction==s:up
		return s:down
	elseif a:direction==s:left
		return s:right
	else
		return s:left
	endif
endfunction

" character name definition
" format:(down)(up)(left)(right)
" value:
"	n:none
"	s:single line
"	d:double line
"	b:bold line
"	t:triple dash line
"	T:triple bold dash line
"	q:quadruple dash line
"	Q:quadruple bold dash line
let s:nameToCharTable = {
	\ 'nnnn':' ',
	\ 'nnss':'─',
	\ 'nnbb':'━',
	\ 'ssnn':'│',
	\ 'bbnn':'┃',
	\ 'nntt':'┄',
	\ 'nnTT':'┅',
	\ 'ttnn':'┆',
	\ 'TTnn':'┇',
	\ 'nnqq':'┈',
	\ 'nnQQ':'┉',
	\ 'qqnn':'┊',
	\ 'QQnn':'┋',
	\ 'snns':'┌',
	\ 'snnb':'┍',
	\ 'bnns':'┎',
	\ 'bnnb':'┏',
	\ 'snsn':'┐',
	\ 'snbn':'┑',
	\ 'bnsn':'┒',
	\ 'bnbn':'┓',
	\ 'nsns':'└',
	\ 'nsnb':'┕',
	\ 'nbns':'┖',
	\ 'nbnb':'┗',
	\ 'nssn':'┘',
	\ 'nsbn':'┙',
	\ 'nbsn':'┚',
	\ 'nbbn':'┛',
	\ 'ssns':'├',
	\ 'ssnb':'┝',
	\ 'sbns':'┞',
	\ 'bsns':'┟',
	\ 'bbns':'┠',
	\ 'sbnb':'┡',
	\ 'bsnb':'┢',
	\ 'bbnb':'┣',
	\ 'sssn':'┤',
	\ 'ssbn':'┥',
	\ 'sbsn':'┦',
	\ 'bssn':'┧',
	\ 'bbsn':'┨',
	\ 'sbbn':'┩',
	\ 'bsbn':'┪',
	\ 'bbbn':'┫',
	\ 'snss':'┬',
	\ 'snbs':'┭',
	\ 'snsb':'┮',
	\ 'snbb':'┯',
	\ 'bnss':'┰',
	\ 'bnbs':'┱',
	\ 'bnsb':'┲',
	\ 'bnbb':'┳',
	\ 'nsss':'┴',
	\ 'nsbs':'┵',
	\ 'nssb':'┶',
	\ 'nsbb':'┷',
	\ 'nbss':'┸',
	\ 'nbbs':'┹',
	\ 'nbsb':'┺',
	\ 'nbbb':'┻',
	\ 'ssss':'┼',
	\ 'ssbs':'┽',
	\ 'sssb':'┾',
	\ 'ssbb':'┿',
	\ 'sbss':'╀',
	\ 'bsss':'╁',
	\ 'bbss':'╂',
	\ 'sbbs':'╃',
	\ 'sbsb':'╄',
	\ 'bsbs':'╅',
	\ 'bssb':'╆',
	\ 'sbbb':'╇',
	\ 'bsbb':'╈',
	\ 'bbbs':'╉',
	\ 'bbsb':'╊',
	\ 'bbbb':'╋',
	\ 'nndd':'═',
	\ 'ddnn':'║',
	\ 'snnd':'╒',
	\ 'dnns':'╓',
	\ 'dnnd':'╔',
	\ 'sndn':'╕',
	\ 'dnsn':'╖',
	\ 'dndn':'╗',
	\ 'nsnd':'╘',
	\ 'ndns':'╙',
	\ 'ndnd':'╚',
	\ 'nsdn':'╛',
	\ 'ndsn':'╜',
	\ 'nddn':'╝',
	\ 'ssnd':'╞',
	\ 'ddns':'╟',
	\ 'ddnd':'╠',
	\ 'ssdn':'╡',
	\ 'ddsn':'╢',
	\ 'dddn':'╣',
	\ 'sndd':'╤',
	\ 'dnss':'╥',
	\ 'dndd':'╦',
	\ 'nsdd':'╧',
	\ 'ndss':'╨',
	\ 'nddd':'╩',
	\ 'ssdd':'╪',
	\ 'ddss':'╫',
	\ 'dddd':'╬',
	\ 'nnsn':'╴',
	\ 'nsnn':'╵',
	\ 'nnns':'╶',
	\ 'snnn':'╷',
	\ 'nnbn':'╸',
	\ 'nbnn':'╹',
	\ 'nnnb':'╺',
	\ 'bnnn':'╻',
	\ 'nnsb':'╼',
	\ 'bsnn':'╽',
	\ 'nnbs':'╾',
	\ 'sbnn':'╿'
\}

let s:charToNameTable = {
	\ ' ':'nnnn',
	\ '─':'nnss',
	\ '━':'nnbb',
	\ '│':'ssnn',
	\ '┃':'bbnn',
	\ '┄':'nntt',
	\ '┅':'nnTT',
	\ '┆':'ttnn',
	\ '┇':'TTnn',
	\ '┈':'nnqq',
	\ '┉':'nnQQ',
	\ '┊':'qqnn',
	\ '┋':'QQnn',
	\ '┌':'snns',
	\ '┍':'snnb',
	\ '┎':'bnns',
	\ '┏':'bnnb',
	\ '┐':'snsn',
	\ '┑':'snbn',
	\ '┒':'bnsn',
	\ '┓':'bnbn',
	\ '└':'nsns',
	\ '┕':'nsnb',
	\ '┖':'nbns',
	\ '┗':'nbnb',
	\ '┘':'nssn',
	\ '┙':'nsbn',
	\ '┚':'nbsn',
	\ '┛':'nbbn',
	\ '├':'ssns',
	\ '┝':'ssnb',
	\ '┞':'sbns',
	\ '┟':'bsns',
	\ '┠':'bbns',
	\ '┡':'sbnb',
	\ '┢':'bsnb',
	\ '┣':'bbnb',
	\ '┤':'sssn',
	\ '┥':'ssbn',
	\ '┦':'sbsn',
	\ '┧':'bssn',
	\ '┨':'bbsn',
	\ '┩':'sbbn',
	\ '┪':'bsbn',
	\ '┫':'bbbn',
	\ '┬':'snss',
	\ '┭':'snbs',
	\ '┮':'snsb',
	\ '┯':'snbb',
	\ '┰':'bnss',
	\ '┱':'bnbs',
	\ '┲':'bnsb',
	\ '┳':'bnbb',
	\ '┴':'nsss',
	\ '┵':'nsbs',
	\ '┶':'nssb',
	\ '┷':'nsbb',
	\ '┸':'nbss',
	\ '┹':'nbbs',
	\ '┺':'nbsb',
	\ '┻':'nbbb',
	\ '┼':'ssss',
	\ '┽':'ssbs',
	\ '┾':'sssb',
	\ '┿':'ssbb',
	\ '╀':'sbss',
	\ '╁':'bsss',
	\ '╂':'bbss',
	\ '╃':'sbbs',
	\ '╄':'sbsb',
	\ '╅':'bsbs',
	\ '╆':'bssb',
	\ '╇':'sbbb',
	\ '╈':'bsbb',
	\ '╉':'bbbs',
	\ '╊':'bbsb',
	\ '╋':'bbbb',
	\ '═':'nndd',
	\ '║':'ddnn',
	\ '╒':'snnd',
	\ '╓':'dnns',
	\ '╔':'dnnd',
	\ '╕':'sndn',
	\ '╖':'dnsn',
	\ '╗':'dndn',
	\ '╘':'nsnd',
	\ '╙':'ndns',
	\ '╚':'ndnd',
	\ '╛':'nsdn',
	\ '╜':'ndsn',
	\ '╝':'nddn',
	\ '╞':'ssnd',
	\ '╟':'ddns',
	\ '╠':'ddnd',
	\ '╡':'ssdn',
	\ '╢':'ddsn',
	\ '╣':'dddn',
	\ '╤':'sndd',
	\ '╥':'dnss',
	\ '╦':'dndd',
	\ '╧':'nsdd',
	\ '╨':'ndss',
	\ '╩':'nddd',
	\ '╪':'ssdd',
	\ '╫':'ddss',
	\ '╬':'dddd',
	\ '╴':'nnsn',
	\ '╵':'nsnn',
	\ '╶':'nnns',
	\ '╷':'snnn',
	\ '╸':'nnbn',
	\ '╹':'nbnn',
	\ '╺':'nnnb',
	\ '╻':'bnnn',
	\ '╼':'nnsb',
	\ '╽':'bsnn',
	\ '╾':'nnbs',
	\ '╿':'sbnn'
	\}

" Convert box-drawing character to name
function! s:charToName(char) abort
	let retval = get(s:charToNameTable,a:char,'nnnn')
	return retval
endfunction

" Convert name to box-drawing character
function! s:nameToChar(name) abort
	let retval = get(s:nameToCharTable,a:name,'x')
	" some character is not exist. Change line type to single
	if retval==#'x'
		let newname = a:name
		if newname[0]!=#'n'
			let newname=s:replaceCharInString(newname,0,'s')
		endif
		if newname[1]!=#'n'
			let newname=s:replaceCharInString(newname,1,'s')
		endif
		if newname[2]!=#'n'
			let newname=s:replaceCharInString(newname,2,'s')
		endif
		if newname[3]!=#'n'
			let newname=s:replaceCharInString(newname,3,'s')
		endif
		let retval = get(s:nameToCharTable,newname,' ')
	endif
	return retval
endfunction

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

" Move function
function! box_drawing#moveCursor(direction) abort
	if a:direction==s:down
		call box_drawing#moveRow(1)
	elseif a:direction==s:up
		call box_drawing#moveRow(-1)
	elseif a:direction==s:left
		call box_drawing#moveCol(-1)
	else
		call box_drawing#moveCol(1)
	endif
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

" Base functions
function! s:drawTicsUnderCursor(direction, lineType) abort
	let char1 = s:getCharUnderCursor()
	let name1 = s:charToName(char1)
	let name2 = s:replaceCharInString(name1,a:direction,a:lineType)
	let char2 = s:nameToChar(name2)
	call s:replaceCharUnderCursor(char2)
	"echo name1 name2
	"echo char1 char2
endfunction

function! box_drawing#movePen(direction, lineType) abort
	call s:drawTicsUnderCursor(a:direction, a:lineType)
	call box_drawing#moveCursor(a:direction)
	let oppositeDir = s:oppositeDirection(a:direction)
	call s:drawTicsUnderCursor(oppositeDir, a:lineType)
endfunction

function! box_drawing#map() abort
	"move
	nnoremap <silent><buffer> j :call box_drawing#moveCursor(0)<CR>
	nnoremap <silent><buffer> k :call box_drawing#moveCursor(1)<CR>
	nnoremap <silent><buffer> h :call box_drawing#moveCursor(2)<CR>
	nnoremap <silent><buffer> l :call box_drawing#moveCursor(3)<CR>

	"single line
	nnoremap <silent><buffer> J :call box_drawing#movePen(0,'s')<CR>
	nnoremap <silent><buffer> K :call box_drawing#movePen(1,'s')<CR>
	nnoremap <silent><buffer> H :call box_drawing#movePen(2,'s')<CR>
	nnoremap <silent><buffer> L :call box_drawing#movePen(3,'s')<CR>

	"erase line
	nnoremap <silent><buffer> <c-j> :call box_drawing#movePen(0,'n')<CR>
	nnoremap <silent><buffer> <c-k> :call box_drawing#movePen(1,'n')<CR>
	nnoremap <silent><buffer> <c-h> :call box_drawing#movePen(2,'n')<CR>
	nnoremap <silent><buffer> <c-l> :call box_drawing#movePen(3,'n')<CR>

	"double line
	"does not work
"	nnoremap <silent><buffer> u :call box_drawing#movePen(0,'d')<CR>
"	nnoremap <silent><buffer> i :call box_drawing#movePen(1,'d')<CR>
"	nnoremap <silent><buffer> y :call box_drawing#movePen(2,'d')<CR>
"	nnoremap <silent><buffer> o :call box_drawing#movePen(3,'d')<CR>

	"bold line
	nnoremap <silent><buffer> u :call box_drawing#movePen(0,'b')<CR>
	nnoremap <silent><buffer> i :call box_drawing#movePen(1,'b')<CR>
	nnoremap <silent><buffer> y :call box_drawing#movePen(2,'b')<CR>
	nnoremap <silent><buffer> o :call box_drawing#movePen(3,'b')<CR>

	"escape keybind
	nnoremap <silent><buffer> <ESC> :call box_drawing#unmap()<CR>
	nnoremap <silent><buffer> : :call box_drawing#unmap()<CR>

	"print usage
	echohl Comment
	echo "single:JKHL, bold:uiyo, erase:Ctrl-jkhl, exit:ESC"
	echohl None
endfunction
       
function! box_drawing#unmap() abort
	:mapclear <buffer>
endfunction

