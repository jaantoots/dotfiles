#!/usr/bin/env th
-- Print a list all unique colors in a PNG image as hex color codes
local argparse = require "argparse"
local gm = require "graphicsmagick"

-- Parse command line arguments
local parser = argparse("pnguniq.lua", "Return unique colors in a PNG image.")
parser:argument("file", "PNG file to check.")
local args = parser:parse()

local function bytesToHex (bytes)
  -- Convert torch.ByteTensor of size 3 to hex string
  return string.format('#%02x%02x%02x', bytes[1], bytes[2], bytes[3])
end

-- Load the image
local img = gm.Image(args.file):toTensor('byte')
local size = img:size()
-- Table of colors with unique keys
local colors = {}
for i=1,size[1] do
  for j=1,size[2] do
    colors[bytesToHex(img[i][j])] = true
  end
end

-- Print the output
for color,_ in pairs(colors) do
  -- body...
  print(color)
end
