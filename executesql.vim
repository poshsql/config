function! ExecuteSQL()
    let g:sqlquery = @q
    if g:sqlquery == ""
        echo "The register q doesnot have query"
        return 0
    endif
    call writefile(split(g:sqlquery, "\n"), 'c:\temp\vim.sql')

    if exists("g:my_run_buffer")
        " Go to buffer
        set swb=usetab
        exec ":rightbelow sbuf " . g:my_run_buffer
    else
        bo new
        set buftype=nofile
        let g:my_run_buffer = bufnr("%")
        let g:mydb = "tempdb"
        let g:mydbserver = "localhost"
    endif
    let mycommand = '%!sqlcmd -S' . g:mydbserver .' -d' .g:mydb. ' -i "c:\temp\vim.sql"'

    exec mycommand
endfunction
"select * from sys.databases
"
