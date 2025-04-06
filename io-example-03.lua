#!/usr/bin/env luajit
local IO3 = {}

--- I want to take some time to understand the IO methods read/write a bit 
--- more in preparation for the next step which is reading/writing binary
--- files. I've learned how to call these methods but haven't really inspected
--- their signature. Lets hop over to the manual.
---
--- > file:read(...)
--- > Reads the file `file`, according to the given formats, which specify
--- > what to read. For each format, the function returns a string (or number)
--- > with the characters read, or nil if it cannot read data with specified
--- > format. When called without formats, it uses a default format that reads
--- > the entire next line.
---
--- Lets get our initial set of questions out of the way on what we just read.
--- It's important to question everything I read. If i'm not questioning what
--- I'm reading then i'm not actively learning.
---
--- - There are formats we pass to read. What exactly is being defined as a 
---   format? Why does lua choose to use formats?
---
---     From my reading a format refers to this predefined way of interpreting
---     and extracting data from a file. So it tells Lua how to read and how
---     much to read. So I can kind of think of them as little shortcuts or
---     instructions for interpreting the stream of bytes coming from a file.
---
---     I can summarize three main reason off the top of my head why Lua uses
---     formats gathered from sources.
---
---         - Simplicity: Lua favors minimalism. Instead of having a bunch of
---           different functions like `readLine(), readBytes(n), and so on it
---           provides a single function `read()` that can take a flexible set
---           of instructions via formats.
---
---         - Efficiency: Formats are interpreted natively and allow Lua to
---           manage buffering and memory use efficiently. Interpreted
---           natively means it's built directly into Lua interpreter's C
---           source code, not written in Lua or handled by a external
---           library.
---
---         - Portability: Formats work across all Lua-supported platforms,
---           abstracting away low-level file system differences. This means
---           that `file:read(...)` behaves consistently whether i'm on
---           Windows, Linux/Unix, or an embedded platform. I don't have to 
---           write different code for different platforms. For example, on 
---           Windows it uses `\r\n` line endings but on nix platforms it's
---           just `\n`. Lua doesn't make you care.
---
--- - Can I provide combinations of formats or just one format? How does one 
---   choose which format is suitable? What if I don't know what the contents
---   of a file are?
---
---     Looks like I can provide an number of arguments to `file:read()`. So I
---     I could do `file:read("n", "n", "l")`. I guess if I don't know what
---     exactly the file contains I would read raw bytes or scan lines and
---     then analyze them dynamically. Typically you would know so maybe a
---     irrelavent question to ask.
---
--- - To confirm read can return different types? It can return a string or a 
---   number? What if there's multiple numbers separated by a space or comma 
---   will it return it as a string then?
---
---     I'll explore this below later this kind of hits on the fact that I can
---     pass multiple formats to read which could return different types.
---
--- - Is there a Lua idiom in calling read that would allow us to catch cases
---   where nil is returned? Should I really treat nil as a error though? An 
---   empty file could return nil, correct? That's not really an error, is it?
---
---     The values `nil` on return would simply mean "couldn't read as 
---     requested" but this isn't an error always. An end of file might give
---     me `nil`. If I gave the wrong format I could also get `nil`. If the 
---     file is empty I could get `nil`. The idiomatic way is to check the
---     value if it's equal to `nil` before using it.
---
--- - It says it uses a default format when not provided one. What format is
---   it? The manual says it reads the entire next line. That doesn't make any
---   sense. Shouldn't it read the current line. Why skip ahead or am I not
---   understanding something?
---
---     So the default is "l". It reads a line (without the newline char). I
---     was misunderstanding the manaul. When it says it reads the next line,
---     it just means "from the current possition up to the next newline". I
---     can think of a file as a stream. I'm at a position and calling the
---     method `file:read()` moves me forward. So it's not skipping anything.
---     The next line is the first line from where I'm currently at (i.e.
---     where the file pointer currently is pointing).
---
--- - Why do I see snippets with the asterisk in front of the format specifier
---   but in other places I don't? What is the use of the asterisk?
---
---     This asterisk is a way of telling lua "Yo, i'm giving you a format,
---     not a number of bytes". This is perfectly valid `file:read(4)`. Says
---     read 4 bytes. I can't speak to all versions of Lua but it we look in
---     the source code liolib.c (for Lua 5.4) we see the asterisk is
---     optionally. In fact, the comment says "skip optional '*' (for
---     compatibility)".
---
--- Well I think that's a good review over `file:read()`. Learned what the
--- method takes and returns. Dived into the various formats that are allowed
--- and what it means to pass a format to Lua.

local file = assert(io.open("somenumbers.txt", "r"))
-- Only works if numbers separated by spaces (commas will break it)
-- local a, b, c = file:read("*n", "*n", "*n")
-- print(a,b,c)
local a = file:read("*n")
print(a)
file:close()

file = assert(io.open("foo.txt"))
-- default format should be "l", see if that's true
local stuff = file:read()
-- we are moving forward in the stream (file pointer moving)
local more_stuff = file:read()
print(stuff)
print(more_stuff)
file:close()

file = assert(io.open("hexdata.bin", "rb"))
local b = file:read("a")
for i=1, #b do
    local val = b:byte(i)
    io.write(string.format("%02X ", val))
end
print()
