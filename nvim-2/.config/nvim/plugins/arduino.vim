Plug 'stevearc/vim-arduino'

let g:arduino_use_cli=1


" Change these as desired
nnoremap <buffer> <leader>ea <cmd>ArduinoAttach<CR>
nnoremap <buffer> <leader>em <cmd>ArduinoVerify<CR>
nnoremap <buffer> <leader>eu <cmd>ArduinoUpload<CR>
nnoremap <buffer> <leader>ed <cmd>ArduinoUploadAndSerial<CR>
nnoremap <buffer> <leader>eb <cmd>ArduinoChooseBoard<CR>
nnoremap <buffer> <leader>ep <cmd>ArduinoChooseProgrammer<CR>
