# box-drawing.vim
Unicode box-drawing Vim plugin

## Usage

Type the command.
```
:Boxdrawing
```
Then, your keybinds are overridden temporary like this:

```
j,k,h,l     : Move cursor (able to move empty line or column)
J,K,H,L     : Draw single line
Ctrl-j,k,h,l: Erase line
u,i,y,o     : Draw bold line
```

The temporary keybinds are deleted if ESC key pressed.
