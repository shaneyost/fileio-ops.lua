local Utils = {}
function Utils.PT(tbl, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(prefix .. tostring(k) .. " = {")
            Utils.PT(v, indent + 1)
            print(prefix .. "}")
        else
            print(prefix .. tostring(k) .. " = " .. tostring(v))
        end
    end
end
return Utils
