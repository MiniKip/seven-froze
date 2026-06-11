package.path = "./flintqua/?.lua;./flintqua/?/init.lua;" .. package.path
local flintqua = require("flintqua.src.flintqua")
local db = flintqua.open("data/chats.db")



db:close()