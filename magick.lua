local ftype = "png"
local mimetype = "image/png"

function GetFileName(url)
  return url:match("^(.+)%..+$")
end

function GetFileExtension(url)
  return url:match("^.+(%..+)$")
end

function is_img(item)
  local lower = string.lower(item)
  local exts = {
    "png",
    -- "jpg",
    -- "jpeg",
    "tif",
    "tiff",
    "webp",
  }
  for i = 1, #exts do
    if lower == exts[i] then
      return true
    end
  end

  return false
end

function Image(elem)
  local ext = string.lower(GetFileExtension(elem.src))

  if is_img(ext) then
    return elem
  else
    local fname = GetFileName(elem.src) .. "." .. ftype
    local img = pandoc.pipe("magick", { elem.src, ftype .. ":-" }, "")
    pandoc.mediabag.insert(fname, mimetype, img)
    return pandoc.Image({}, fname)
  end
end
