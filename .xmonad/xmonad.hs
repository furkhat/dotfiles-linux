import XMonad
import XMonad.Hooks.DynamicLog

main = xmonad =<< xmobar defaultConfig
        { -- modMask = mod4Mask -- Use Super instead of Alt
        terminal = "st"
         -- more changes
        }

