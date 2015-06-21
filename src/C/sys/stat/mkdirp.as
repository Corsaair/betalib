package C.sys.stat
{

    /* Note:
       mkdir() creates directoy
       but can not creates directory tree

       the command line "$ mkdir -p" allows that
       so here a small util function to emulate that
       behaviour

       usage:
        var result:int = mkdirp( "hello/the/big/world/", -1 );
        trace( "result = " + result );
        if( result != 0 )
        {
            var e:* = new CError( "", errno );
            trace( e );
        }
    */

    import C.errno.*;
    import C.sys.stat.*; // mkdir
    import C.unistd.*;   // access, F_OK

    /**
     * mkdirp - create a new directory and intermediate directories as required
     *
     * @param path The pathname of the directory tree to be created.
     * @param mode The file permission bits (optional).
     * @return Upon successful completion, this function shall return <code>0</code>.
     * Otherwise, this function shall return <code>-1</code> and set <code>errno</code>
     * to indicate the error.
     * If <code>-1</code> is returned, last directory in the path shall not be created.
     */
    public function mkdirp( path:String, mode:int = -1 ):int
    {
        // special case
        if( (path == ".") || (path == "/") )
        {
            return 0;
        }

        if( mode == -1 )
        {
            mode = S_IRWXU | S_IRWXG | S_IRWXO;
        }

        // remove trailing slash
        if( path.charAt( path.length - 1 ) == "/" )
        {
            path = path.substr( 0, path.length - 1 );
        }

        var start:String = "";
        // remove head slash if exists
        if( path.charAt( 0 ) == "/" )
        {
            path  = path.substr( 1 );
            start = "/";
        }

        // split path into components
        var paths:Array;
        if( path.indexOf( "/" ) > -1 )
        {
            paths = path.split( "/" );
        }
        else
        {
            paths = [ path ];
        }

        // remember the head slash
        paths[0] = start + paths[0];

        // iterates trough the path components
        // check if the directory exists, if not create it
        var last:String = "";
        var result:int;
        while( paths.length > 0 )
        {
            // accumulate path components
            last += paths.shift();

            // does the dir exists ?
            if( access( last, F_OK ) != 0 )
            {
                // create the directory
                result = mkdir( last, mode );
                if( result != 0 )
                {
                    return result;
                }
            }
            last += "/"; // append dir separator for next component
        }

        return 0;
    }
    
}
