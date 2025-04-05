function NullOrEmpty(extstr)
  return extstr == nil or extstr == ''
end

local ftype = "png"
local mimetype = "image/png"
local tostr = os.getenv("PANDOC_MAGICK_TO_EXT")
local tomime = os.getenv("PANDOC_MAGICK_TO_MIME")
print(tostr)
print(tomime)
if (not NullOrEmpty(tostr) and not NullOrEmpty(tomime)) then
  ftype = tostr
  mimetype = tomime
  print("Converting to " .. ftype .. " (" .. mimetype .. ")")
end

function GetFileName(url)
  return url:match("^(.+)%..+$")
end

function GetFileExtension(url)
  return url:match("^.+(%..+)$")
end

function is_img(item)
  local lower = string.lower(item)
  local exts = {}
  local extstr = os.getenv("PANDOC_MAGICK_EXTENSIONS")
  if NullOrEmpty(extstr) then
    exts = {
      "png",
      "jpg",
      "jpeg",
      "tif",
      "tiff",
      "webp",
    }
  else
    for str in string.gmatch(extstr, "([^,]+)") do
      str, _ = str:gsub("%s+", "")
      table.insert(exts, str)
    end
  end
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
