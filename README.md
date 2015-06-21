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

From time to time I will encounter a C utility function that did not end up being
officially part of either the ANSI C library and/or the POSIX library, for example
`mkdirp()`.

Here `mkdirp()` has the same behaviour of `mkdir()` with the welcomed difference
that provided a path it will create the non-existing elements, it is a basic feature
but quite useful, the code involved rely only on the standard C libraries so it is
something worth considering to add directly into the runtime.

Simply put, the few lines of AS3 source code, add fucntionality and no dependency,
and can help AS3 dev to write faster code.

That would be a good candidate to add.

Note well, it would be a completely different talk if someone were to ask to add something
like `mysql_connect()` which add a heavy dependency at the C source code level.


#### An example with AVMGLUE

AVMGLUE is the library that take the responsibility to add implementatiosn fo the Flash API into Redtamarin.

This Flash API is huge to implement and off course not everythign is ready yet.

The betalib could then be used to incubate proposed implementations, for ex someone could
propose a `flash.net.Socket` or other class part of the Flash API and not avaialble yet.


Some Advices
------------

I understand that working on Redtamarin can be frustrating if the one class you need is missing,
and this **betalib** is here to fix that, even if you do not want to compile the original
Redtamarin source code (because it can be complicated, because it's C++, etc...) it allows you
to contribute good old ActionScript 3.0 source code.

By extension, it alow you also to contribute to any other parts like the `shell` package or the `C` package.

But I will insist that I will review this source code like a hawk so please follow those advices
  - communicate, don't go writing thousands of line of code in your corner and then send a big patch
  - don't change the nature of Redtamarin  
  for example the  
      > because I felt redtamarin should be like node.js
      > I made everything async
      > but now everyone else code need to be run async ...
  will not be well received
  - do clean code and clean documentation  
    see: [specific asdoc for Redtamarin](https://github.com/Corsaair/redtamarin/wiki/specific-asdoc-for-Redtamarin)
  - remember that Redtamarin is crossplatform (Windows, Macintosh, Linux)  
  unless it is really impossible try to contribute code that can work everywhere
  - this is not an excuse to add anything and everything


How to Contribute
-----------------

  1. Fork this repository
  2. add your code in the src/ , ideally only 1 function or 1 class
  3. Raise a pull request
  4. Discuss in the pull request
  5. If/Once merged enjoy to have contributed to Redtamarin :)
