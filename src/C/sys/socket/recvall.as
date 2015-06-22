package C.sys.socket
{

    import flash.utils.*;
    
    /**
     * Receive the full message on a socket.
     *
     * <p>
     * This function handle reassembly buffer for you.
     * </p>
     * 
     * <p>
     * Because we receive data into a <code>ByteArray</code>
     * we are limited to <code>4 GB</code>.
     * To receive bigger files we could modifiy this function
     * to save the bytes into a file for example.
     * </p>
     * 
     * @example Usage
     * <listing>
     * // ...
     * var recvbytes:ByteArray = new ByteArray();
     * var recvr:int = recvall( sockfd, recvbytes );
     * if( sendr < 0 )
     * {
     *      var e:CError = new CError( "", errno );
     *      trace( e );
     *      close( sockfd );
     *      exit( EXIT_FAILURE );
     * }
     * 
     * recvbytes.position = 0;
     * trace( "received " + recvbytes.length + " bytes" );
     * close( sockfd );
     * 
     * var data:String = recvbytes.readUTFBytes( recvbytes.length );
     * // ...
     * </listing>
     * 
     * @param socket socket descriptor.
     * @param bytes ByteArray to store the received data.
     * @param buffer how mnay bytes to copy per cycle (default is 8192)
     * @param flags socket flags (default is 0 or none)
     * @return Upon successful completion, <code>recvall()</code> should return the number of bytes received.
     * Otherwise, if an error occurs, the return value should be less than zero, and errno shall be set to indicate the error.
     * 
     * @langversion 3.0
     * @playerversion AVM 0.4
     *
     * @see C.sys.socket#recv
     * @see http://beej.us/guide/bgnet/output/html/singlepage/bgnet.html#sendall
     * @see NON STANDARD EXTENSION
     */
    public function recvall2( socket:int, bytes:ByteArray, buffer:uint = 8192, flags:int = 0 ):Number
    {
        var total:Number = 0; // how many bytes we received
        var n:int;
        var b:ByteArray = new ByteArray();

        var run:Boolean = true;
        while( run )
        {
            b.clear();
            n = recv( socket, b, buffer, flags );
            if( n < 0 )
            {
                b.clear();
                return n; //failure
            }

            bytes.writeBytes( b );
            total += n;
            /* Note:
               defining a buffer does not guarantee this one will be full all the time
               here an output
               --------
               n = 1448
               n = 1448
               n = 2896
               n = 1448
               n = 1448
               n = 1448
               n = 2896
               n = 1448
               n = 1448
               n = 1448
               n = 1448
               n = 1448
               n = 1448
               n = 2896
               n = 1534
               n = 0
               --------
               even with a defualt buffer of 8192, this parciular connection
               use a max buffer of 2896, sometimes less 1448, etc.
               this can depends on network settings and other MTU window

               the only way to be sure that data has ended is to check for zero
            */
            if( n == 0 ) { run = false; break; }
        }
        
        b.clear();

        return total; // number of bytes actually received
    }

}