# vnote2notes

## Description
This is a simple script which provides conversion from `*.vnt` (vNote v.1.1) to plain text. Output consists of _creation timestamp_, _last modification timestamp_ (optionaly) and _body_ of a note.

The output looks like this:

    2012.01.02 06:55
    No traducir - se convertira en un nino!

## How to use
Usage is quite simple:

    vnote2notes.pl <source> [output]

Example:

    vnote2notes.pl sample/path/to/the/vnotes/2012.03.*.vnt notes.txt


## License

Copyright (c) 2012, Vitaliy Krutko

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
