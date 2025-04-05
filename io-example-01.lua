#!/usr/bin/env luajit
--- This is considered a typical idiom to check for errors. How can we get away
--- without explicitly passing two arguments to assert?
--- 
--- First, lets understand that `io.open` may return one or two values. On 
--- failure, it would return nil and the error message. 
---
--- Second, we need to know what assert takes. It requires one argument with an
--- optional second argument being a message.
---
--- On failure, you're providing nil and the error message. On failure, assert
--- sees `nil` and the error message return by `io.open` will be raised.
---
--- On success, `io.open` succeeds where `assert` sees a valid file handle (
--- i.e stream) and returns it.
local f = assert(io.open("foo.txt", "r"))
local t = f:read("a")
--- Why does type(f) return userdata? I guess I'm expecting something more
--- reflective of file stream or file handle. 
---
--- In Lua, userdata is a special data type used to represent C data from 
--- outside Lua itself. Lua's built-in file handles (`io.open`) are actually
--- implemented in C under the hood, making them appear as userdata. Userdata
--- itself doesn't tell me much about what's inside. If I really wanted to get 
--- more information what could I do?
---
--- Lua provides functions designed specifically for file objects. The most 
--- common is `io.type().
print("type(f): ", type(f))
print("io.type(f): ", io.type(f))
print("type(t): ", type(t))
--- If we call `f:close` and then call `io.type(f)` it will say something like
--- "closed file".
---
--- So when would I want to use io.type(f)? Is there a real world situation 
--- where it might be useful?
---
--- 1. Ensuring a file is still open
--- When passing file handles around, it might be unclear if they've already
--- been closed elsewhere. So this might warrant something like the following.
if io.type(f) == "file" then
    -- do something
else
    error("File is already closed.")
end
f:close()
print(t)
--- If i'm uncertain of a file's state (open or closed), `io.type` makes it 
--- safe to close files multiple times without causing errors.
--- local function safe_close(f)
---     if io.type(f) == "file" then
---         f:close()
---     end
--- end
---
--- I might also want to use it if i'm writing reusable Lua library that
--- expects a file handle. 
--- function process_file(f)
---     assert(io.type(f) == "file", "Expect a file handle")
--- end
---
--- I could also use it for reopening a file if it has closed. Useful in longer
--- running programs or services that reuse file handles over extended periods.
---
--- `io.type(f) is practical whenever you need robustness, clarity, or safety
--- in handling lua file handles - especially as your applications grow in 
--- complexity. 
