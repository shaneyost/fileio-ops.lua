#!/usr/bin/env luajit

--- A typical convention when opening a file is to use assert according to
--- sources. On failure, nil and the error message is supplied to `assert`. On
--- success `io.open` returns a file handle (stream) and assert returns it. I
--- haven't read enough to know if this is a good convention outside of what
--- the book is telling me as of now.
local file_handle = assert(io.open("foo.txt", "r"))

--- After we receive a handle we can read from or write to the stream through
--- using methods like `read` and `write`. We call them as methods using the
--- colon notation. Note in colon notation self is automatically passed.
local file_contents = file_handle:read("a")
print(file_contents)

--- First question, why does type(file) return `userdata`? That doesn't mean
--- much to me nor allows much usage. Is there a way to gather more
--- information on the type? Am I doing something wrong?
---
---@usage >lua
---     print("type(file_handle): ", type(file_handle))
---     file_handle:close()
--- <
---
--- Lua provides functions designed specifically for file objects. The most
--- common is `io.type()`. Another question now is what happens when I call
--- `io.type()` after it's been closed? What will it print?
---
---@usage >lua
---     print("io.type(file_handle): ", io.type(file_handle))
---     file_handle:close()
---     print("io.type(file_handle): ", io.type(file_handle))
--- <
--- io.type(file_handle): 	file
--- io.type(file_handle): 	closed file
print("io.type(file_handle): ", io.type(file_handle))

--- So when would I want to use io.type(f)? Is there a real world situation
--- where it might be useful?
---
--- - Ensuring a file handle is still opened prior to doing something
---
---@usage >lua
---     if io.type(file_handle) == "file" then
---         -- do something
---     else
---         error("File is already closed.")
---     end
--- <
---
--- - Ensuring closed is not called on a already closed file handle
---
---@usage >lua
---     local function safe_close(file_handle)
---         if io.type(file_handle) == "file" then
---             file_handle:close
---         end
---     end
--- <
---
--- - Ensuring a file handle argument to function is a file handle
---
---@usage >lua
---     local function foo(file_handle)
---         assert(io.type(file_handle) == "file", "Expected a file handle")
---         -- do something
---     end
--- <
---
--- - Ensuring that I can reopen a file safely unsure if it was closed
---
---@usage >lua
---     local function reopen(file_handle, filename)
---         if io.type(file_handle) ~= "file" then
---             return io.open(filename, "r")
---         else
---             return file_handle
---         end
---     end
--- <
