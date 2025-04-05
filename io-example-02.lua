#!/usr/bin/env luajit

--- A question that has popped up now is how can I get away with writing to the
--- standard output yet not specify any kind of stream? How does the following
--- just know or allow an implicit behavior?
---
---@usage >lua
---     io.write("Hello World\n")
--- <
---
--- The I/O library offsers handles for the three predefined C streams being
--- standard input `io.stdin`, standard output `io.stdout` and standard error
--- `io.stderr`.
---
--- Reading through sources I hear the phrase "convenience functions" which is
--- calling `io.write`, `io.read` as is. Lua is using the default file handles
--- here where satndard input is mapped to `io.read` and standard output is
--- mapped to `io.write`.
---
--- It's not unreasonable, according to the book and other sources, to imply
--- precision and or clarity by explicitly calling the default handles as such.
---
---@usage >lua
---     io.stdout:write("Hello World\n")
--- <
---
--- But why is it not unreasonable if this behavior is implicitly handles for
--- me? Why would I ever want to manually write it out. Afterall, isn't this
--- the entire point to providing such convenient functions?
---
--- - You may need to write to both a log file and to stdout. Conveying clarity
---   and precision in this case ensures safe intention.
---
---@usage >lua
---     local log = io.open("log.txt", "w")
---     log:write("Preparing to execute task\n")
---     io.stdout:write("10% complete\n")
---     io.stdout:write("20% complete\n")
---     log:write("Task completed\n")
---     log:close()
--- <
---
--- - What if the standard output is redirected to a file? What if an embedded
---   system (that is running a OS) overrides standard output in some way?
---   Conveying clarity and precision in this case also ensures safe intention.
---
---@usage >lua
---     local log = io.open("log.txt", "w")
---     io.output(log)
---     io.write("This goes to the log file\n")
---     io.stdout:write("But this goes to stdout")
--- <
---
--- - It may be required that you need to write to several streams at once and
---   by choosing to do so conveying clarity in both situations contributes to
---   readability/consistency.
---
---@usage >lua
---     io.stderr:write("this is an error\n")
---     io.stdout:write("this is a mesasge\n")
--- <

local log = assert(io.open("log.txt", "w"))
log:write("Hello to the log file!\n")
io.write("Hello to stdout!\n")
io.output(log)
io.write("Hello to the log file again!\n")
log:close()
io.output(io.stdout)
io.write("Does this appear in stdout now?\n")
