version = "0.21.0"
local xplr = xplr
local home = os.getenv("HOME")
package.path = home
    .. "/.config/xplr/plugins/?/init.lua;"
    .. home
    .. "/.config/xplr/plugins/?.lua;"
    .. package.path

require "icons".setup()
require "zentable".setup()
