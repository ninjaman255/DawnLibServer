local CustPlugin = {}

local nebulibs = require('scripts/ezlibs-custom/nebulous-liberations/main')
local helpers = require('scripts/ezlibs-scripts/helpers')
local ezcheckpoints = helpers.safe_require('scripts/ezlibs-custom/ezcheckpoints')
local compression = helpers.safe_require('scripts/ezlibs-custom/compression')
local naviNames = helpers.safe_require('scripts/ezlibs-custom/navi_names')
local ezadmin = helpers.safe_require('scripts/ezlibs-custom/ezadmin')
local ezshortcuts = helpers.safe_require('scripts/ezlibs-custom/ezshortcuts')

return CustPlugin