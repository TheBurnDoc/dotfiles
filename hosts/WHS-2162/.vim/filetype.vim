if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.html.j2 setfiletype htmljinja
augroup END
