local record = require("src.record")
local log = require("src.log")
local keydir = require("src.keydir")
local compactor = require("src.compactor")

local flintqua = {}
local db_methods = {}

local function check_open(db)
    if db.closed then
        return nil, "database is closed"
    end

    return true
end

local function check_key(key)
    if type(key) ~= "string" or key == "" then
        return nil, "key must be a non-empty string"
    end

    return true
end

local function update_keydir(dir, item, place)
    if item.flags == record.FLAG_DELETE then
        keydir.delete(dir, item.key)
        return
    end

    place.timestamp = item.timestamp
    place.flags = item.flags
    keydir.set(dir, item.key, place)
end

function flintqua.open(path)
    if type(path) ~= "string" or path == "" then
        return nil, "path must be a non-empty string"
    end

    local data_log, err = log.open(path)
    if not data_log then
        return nil, err
    end

    local db = {
        path = path,
        log = data_log,
        keydir = keydir.new(),
        closed = false
    }

    setmetatable(db, { __index = db_methods })

    data_log:scan(function(item, place)
        update_keydir(db.keydir, item, place)
    end)

    return db
end

function db_methods:set(key, value)
    local ok, err = check_open(self)
    if not ok then
        return nil, err
    end

    ok, err = check_key(key)
    if not ok then
        return nil, err
    end

    local text = tostring(value)
    local bytes, encode_err = record.encode(key, text, record.FLAG_SET)
    if not bytes then
        return nil, encode_err
    end

    local place, append_err = self.log:append(bytes)
    if not place then
        return nil, append_err
    end

    local item = record.decode_full(bytes)
    update_keydir(self.keydir, item, place)

    return true
end

function db_methods:get(key)
    local ok, err = check_open(self)
    if not ok then
        return nil, err
    end

    ok, err = check_key(key)
    if not ok then
        return nil, err
    end

    local place = keydir.get(self.keydir, key)
    if not place then
        return nil
    end

    local bytes, read_err = self.log:read_at(place)
    if not bytes then
        return nil, read_err
    end

    local item, decode_err = record.decode_full(bytes)
    if not item then
        return nil, decode_err
    end

    return item.value
end

function db_methods:delete(key)
    local ok, err = check_open(self)
    if not ok then
        return nil, err
    end

    ok, err = check_key(key)
    if not ok then
        return nil, err
    end

    local bytes, encode_err = record.encode(key, "", record.FLAG_DELETE)
    if not bytes then
        return nil, encode_err
    end

    local place, append_err = self.log:append(bytes)
    if not place then
        return nil, append_err
    end

    local item = record.decode_full(bytes)
    update_keydir(self.keydir, item, place)

    return true
end

function db_methods:compact()
    local ok, err = check_open(self)
    if not ok then
        return nil, err
    end

    return compactor.run(self)
end

function db_methods:close()
    local ok, err = check_open(self)
    if not ok then
        return nil, err
    end

    self.log:close()
    self.closed = true

    return true
end

return flintqua
