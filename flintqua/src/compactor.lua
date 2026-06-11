local record = require("src.record")
local log = require("src.log")
local keydir = require("src.keydir")

local compactor = {}

function compactor.run(db)
    local temp_path = db.path .. ".compact"
    local old_path = db.path .. ".old"

    local new_log, err = log.open(temp_path)
    if not new_log then
        return nil, err
    end

    local new_keydir = keydir.new()

    for key, place in pairs(db.keydir) do
        local old_bytes, read_err = db.log:read_at(place)
        if not old_bytes then
            new_log:close()
            return nil, read_err
        end

        local old_record, decode_err = record.decode_full(old_bytes)
        if not old_record then
            new_log:close()
            return nil, decode_err
        end

        local bytes, encode_err = record.encode(key, old_record.value, record.FLAG_SET)
        if not bytes then
            new_log:close()
            return nil, encode_err
        end

        local new_place, append_err = new_log:append(bytes)
        if not new_place then
            new_log:close()
            return nil, append_err
        end

        new_place.timestamp = old_record.timestamp
        new_place.flags = record.FLAG_SET
        new_keydir[key] = new_place
    end

    new_log:close()
    db.log:close()

    os.remove(old_path)
    os.rename(db.path, old_path)

    local ok, rename_err = os.rename(temp_path, db.path)
    if not ok then
        return nil, rename_err
    end

    os.remove(old_path)

    local opened, open_err = log.open(db.path)
    if not opened then
        return nil, open_err
    end

    db.log = opened
    db.keydir = new_keydir

    return true
end

return compactor
