if not package.loaded["mini.doc"] then
    require("mini.doc").setup()
end
require("mini.doc").generate({
    "io-example-01.lua",
})
