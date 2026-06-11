local keydir = {}

function keydir.new()
    return {}
end

function keydir.set(dir, key, place)
    dir[key] = place
end

function keydir.get(dir, key)
    return dir[key]
end

function keydir.delete(dir, key)
    dir[key] = nil
end

return keydir
