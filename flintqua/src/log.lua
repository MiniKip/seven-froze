local record = require("src.record")

local log = {}

function log.open(path)
    local file = io.open(path, "a+b")
    if not file then
        return nil, "could not open data file"
    end

    local self = {
        path = path,
        file = file
    }

    setmetatable(self, { __index = log })

    return self
end

function log.close(self)
    if self.file then
        self.file:close()
        self.file = nil
    end

    return true
end

function log.append(self, bytes)
    self.file:seek("end")
    local offset = self.file:seek()
    local ok, err = self.file:write(bytes)
    if not ok then
        return nil, err
    end

    self.file:flush()

    return {
        offset = offset,
        size = #bytes
    }
end

function log.read_at(self, place)
    self.file:seek("set", place.offset)
    local bytes = self.file:read(place.size)

    if not bytes or #bytes < place.size then
        return nil, "could not read record"
    end

    return bytes
end

function log.scan(self, each_record)
    self.file:seek("set", 0)

    while true do
        local offset = self.file:seek()
        local header_bytes = self.file:read(record.HEADER_SIZE)

        if not header_bytes or #header_bytes == 0 then
            break
        end

        if #header_bytes < record.HEADER_SIZE then
            break
        end

        local head, err = record.decode_header(header_bytes)
        if not head then
            break
        end

        local rest_size = head.key_len + head.value_len
        local rest = self.file:read(rest_size)
        if rest_size > 0 and (not rest or #rest < rest_size) then
            break
        end

        rest = rest or ""

        local full = header_bytes .. rest
        local decoded = record.decode_full(full)
        if not decoded then
            break
        end

        local keep_going = each_record(decoded, {
            offset = offset,
            size = #full
        })

        if keep_going == false then
            break
        end
    end

    return true
end

return log
