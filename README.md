betalib
=======

The beta library is an incubator for ActionScript 3.0 source code to be
embedded in future releases of the redtamarin binaries.

The following packages are concerned
```tree
avm2
  |_ ...

avmplus
  |_ ...

flash
  |_ ...

C
  |_ ...

shell
  |_ ...

```

Not all source code in Redtamarin are native libraries (eg. implemented in **C**/**C++**),
some functionalities are simply implemented using ActionScript 3.0 , but they end up
all the same being embedded in the final binaries.

Once AS3 code is embedded in the binaries it obtain some intrinsic properties
  - it is instantly available anywhere  
  (without the need to load the corresponding ABC library)
  - it can not be overriden or replaced by your own AS3 source code  
  (the code can be considered **final**)
  - it can only be updated or modified in a future release

Redtamarin binaries are mainly all the Redtamarin shell: **redshell**, **redshell_d**, **redshell_dd**
but they are also reused in all the tools (for ex: **redbean**, **as3shebang**) and are the main dependency
for all the libraries (for ex: **httplib**).


In come cases, you will find here correction of some already embedded code,
in other cases you will find some tests or prototypes of future code,
and finally it gives you an opportunity to contribute source code.

#### An example of correction

In the pakcage `C.sys.socket` I added an utility function `recvall()`
which basically allow to receive the whole buffer of a message on a socket.

The way sockets work, you receive a buffer (our default is 8192 bytes, or 8 KiloBytes),
but if the packet or message is bigger, you have to keep resusing the `recv()` function
in a loop to receive the entire message.

When I embedded this code I made a little mistake and "as is" the function is unusable,
so here I can post a fix, and the next time I publish a redtamarin binary it will apply the fix
and correct all code dependant on this fucntion.

And it could also break code.


#### An example of extension

The **CLIB** has the goal to implement the C standard library and other POSIX API.

It is more or less standard as sometimes to adapt the C source code logic to ActionScript 3.0
we can take some liberties (for ex: use a ByteArray instead of a C char array).

But still this library does not reinvent the C libraries, if the name is `mkdir()` in **C**
and it takes 2 arguments and return an integer, we try to replicate as much as possible
the C function signature and behaviour.

[The C function signature](http://pubs.opengroup.org/onlinepubs/9699919799/functions/mkdir.html)
```C
int mkdir(const char *path, mode_t mode);
```

our AS3 function signature
```AS3
public function mkdir(path:String, mode:int = -1):int;
```