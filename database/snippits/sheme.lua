package.path = "./flintqua/?.lua;./flintqua/?/init.lua;" .. package.path
local flintqua = require("src.flintqua")
local db = flintqua.open("database/playerdata.db")

db:set("Player Health", 100)
db:set("Player Gold", 0)

print("success")

db:close()