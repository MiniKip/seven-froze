local record = {}

local HEADER_FORMAT = ">c2 B B I8 I2 I4"
local HEADER_SIZE = 18

record.HEADER_SIZE = HEADER_SIZE
record.FLAG_SET = 0
record.FLAG_DELETE = 1

local function now_ms()
    return math.floor(os.time() * 1000)
end

function record.encode(key, value, flags)
    if type(key) ~= "string" or key == "" then
        return nil, "key must be a non-empty string"
    end

    value = tostring(value or "")
    flags = flags or record.FLAG_SET

    local key_len = #key
    local value_len = #value

    if key_len > 65535 then
        return nil, "key is too big"
    end

    if value_len > 4294967295 then
        return nil, "value is too big"
    end

    local header = string.pack(
        HEADER_FORMAT,
        "FQ",
        1,
        flags,
        now_ms(),
        key_len,
        value_len
    )

    return header .. key .. value
end

function record.decode_header(bytes)
    if type(bytes) ~= "string" then
        return nil, "header must be a string"
    end

    if #bytes < HEADER_SIZE then
        return nil, "incomplete header"
    end

    local ok, magic, version, flags, timestamp, key_len, value_len = pcall(
        string.unpack,
        HEADER_FORMAT,
        bytes
    )

    if not ok then
        return nil, "could not unpack header"
    end

    if magic ~= "FQ" then
        return nil, "bad magic"
    end

    if version ~= 1 then
        return nil, "bad version"
    end

    return {
        magic = magic,
        version = version,
        flags = flags,
        timestamp = timestamp,
        key_len = key_len,
        value_len = value_len,
        total_size = HEADER_SIZE + key_len + value_len
    }
end

function record.decode_full(bytes)
    local head, err = record.decode_header(bytes)
    if not head then
        return nil, err
    end

    if #bytes < head.total_size then
        return nil, "incomplete record"
    end

    local key_start = HEADER_SIZE + 1
    local key_end = HEADER_SIZE + head.key_len
    local value_start = key_end + 1
    local value_end = key_end + head.value_len

    head.key = string.sub(bytes, key_start, key_end)
    head.value = string.sub(bytes, value_start, value_end)

    return head
end

return record
