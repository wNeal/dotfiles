-- Imports {{{
import XMonad
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)
-- Hooks
import XMonad.Operations

import System.IO
import System.Exit

import XMonad.Util.Run

import XMonad.Actions.CycleWS

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

-- Layouts
import XMonad.Layout.ComboP
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.LayoutHints
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane
import XMonad.Layout.IM
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.Named
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleFloat

-- Additional Layout Imports
--import XMonad.Layout.Simplest
--import XMonad.Layout.SubLayouts
--import XMonad.Layout.Tabbed
--import XMonad.Layout.Spacing
--import XMonad.Layout.Spiral
--import XMonad.Layout.Roledex
--import XMonad.Layout.ThreeColumns
--import XMonad.Layout.Accordion
--import XMonad.Layout.Mosaic

import Data.Ratio ((%))
import Data.List
import qualified XMonad.StackSet as W
import qualified Data.Map as M

--}}}

-- Config {{{
-- Define Terminal
myTerminal = "urxvtc"
-- Define modMask
modMask' :: KeyMask
modMask' = mod4Mask
-- Define workspaces
myWorkspaces :: [String]
myWorkspaces =  ["home","web","music","docs","dev","gimp","graphics","im","irc"]

-- Dzen config
myStatusBar = "$HOME/.scripts/autostart.sh && $HOME/.scripts/top_panel.sh"
myBitmapsDir = "/home/weston/.xmonad/icons"

-------------------
-- COLORS
-------------------

black   =     "#101810"
briteblack   =     "#232323"
white   =     "#96c171"
britewhite    =     "#b8c4ab"
yellow   =     "#d6f418"
orange   =     "#fa850e"
red      =     "#df112a"
magenta  =     "#9d0647"
blue     =     "#057a8f"
cyan     =     "#10ad72"
green    =     "#8fca0c"

colorNormalBorder  = black
colorFocusedBorder = white

barFont  = "lime"
barXFont = "-*-lime-bold-r-normal-*-12-*-*-*-*-*-iso8859-1"
xftFont  = "-*-lime-bold-r-normal-*-12-*-*-*-*-*-iso8859-1"

--}}}

-- "^i(" ++ myBitmapsDir ++ "/arch_10x10.xbm) " $ 

-- Main {{{
main = do
    dzenTopBar <- spawnPipe myStatusBar
    xmonad $ defaultConfig
      { terminal            = myTerminal
      , workspaces          = myWorkspaces
      , keys                = keys'
      , modMask             = modMask'
      , startupHook         = startupHook'
      , layoutHook          = layoutHook'
      , manageHook          = manageHook'
      , logHook             = myLogHook dzenTopBar >> fadeInactiveLogHook 0xdddddddd  >> setWMName "LG3D"
      , normalBorderColor   = colorNormalBorder
      , focusedBorderColor  = colorFocusedBorder
}
--}}}


-- Hooks {{{

-- StartupHook {{{
startupHook' :: X()
startupHook' = do
    ewmhDesktopsStartup >> setWMName "LG3D" 
--}}}

-- ManageHook {{{
manageHook' = composeAll . concat $
    [ [resource     =? r            --> doIgnore              |   r   <- myIgnores  ] -- ignore desktop
    , [className    =? c            --> doShift  "web"        |   c   <- myWebs     ] -- move webs to webs
    , [className    =? c            --> doShift  "music"      |   c   <- myMusic    ] -- move music player to music
    , [className    =? c            --> doShift  "docs"       |   c   <- myDocs     ] -- move myDocs to docs
    , [className    =? c            --> doShift  "dev"        |   c   <- myDevs     ] -- move devs to devs
    , [className    =? c            --> doShift  "gimp"       |   c   <- myGimps    ]
    , [className    =? c            --> doShift  "graphics"   |   c   <- myGraphics ]
    , [className    =? c            --> doShift  "im"         |   c   <- myIMs      ] -- move pidgin to im
    , [className    =? c            --> doShift  "irc"        |   c   <- myIRC      ] -- move myIRC to irc
    , [className    =? c            --> doCenterFloat         |   c   <- myFloats   ] -- float my floats
    , [name         =? n            --> doCenterFloat         |   n   <- myNames    ] -- float my names
    , [isFullscreen                 --> myDoFullFloat                               ]
    ]
    where

        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames
        myFloats  = ["Zenity","VirtualBox","Xmessage","Save As...","XFontSel","Downloads","Nm-connection-editor"]
        myDocs    = ["Openoffice","Zathura","Xpdf"]
        myWebs    = ["Navigator","Shiretoko","Firefox","Uzbl","uzbl","Uzbl-core","uzbl-core","uzbl-tabbed","Uzbl-tabbed","Google-chrome","Chromium","Shredder","Mail"] 
        myDevs    = ["Eclipse","eclipse","Gvim", "vim"] 
        myWines   = ["Wine"] 
        myGimps   = ["Gimp"]
        myGraphics= ["Blender","Inkscape"]
        myIMs     = ["Pidgin","Empathy"]
        myMusic   = ["Sonata","Rhythmbox"]
        myIRC     = ["irssi"]

        -- resources
        myIgnores = ["desktop","desktop_window","notify-osd","stalonetray","trayer"]

        -- names
        myNames   = ["bashrun","Chromium Options", "Wicd Network Manager", "Eclipse", "Accounts", "Deleting files"]

-- a trick for fullscreen but still allow focusing of other WSs
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat
-- }}}

-- Layouts {{{
layoutHook' = avoidStruts $ onWorkspace "1:home" mainLayout $ onWorkspace "8:irc" (resizableTile ||| Mirror resizableTile) $ onWorkspace "6:gimp" gimpLayout $ onWorkspace "7:im" imLayout $ smartBorders (Full ||| resizableTile ||| Mirror resizableTile ||| Grid ) -- ||| tall ||| mtall ||| spaced ||| spiral (6/7) ||| ThreeCol 1 (3/100) (1/2) ||| Accordion ||| mosaic 2 [3,2])
    where
        mainLayout = Grid ||| Full ||| resizableTile ||| Mirror resizableTile
        resizableTile = ResizableTall nmaster delta ratio []
        imLayout = reflectHoriz $ avoidStruts $ withIM (0.17) (Title "Buddy List") Grid
        gimpLayout = withIM (0.11) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.15) (Role "gimp-dock") Full
        nmaster = 1
        ratio = toRational (2/(1+sqrt(5)::Double))
        delta = 3/100
-- }}}

-- Bar {{{
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor green black . pad
      , ppVisible           =   dzenColor cyan black . pad
      , ppHidden            =   dzenColor cyan black . pad
      , ppUrgent            =   dzenColor red black . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor red black .
                                -- displays the icon or the name of the layout
                                (\x -> case x of
                                    "ResizableTall"               ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Hinted ResizableTall"        ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"

                                    "Mirror ResizableTall"        ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Hinted Mirror ResizableTall" ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"

                                    "Full"                        ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "Hinted Full"                 ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"

                                    "Simple Float"                ->      "~"
                                    _                             ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor white black . dzenEscape
      , ppOutput            =   System.IO.hPutStrLn h
    }

--}}}

-- Prompt Config {{{
mXPConfig :: XPConfig
mXPConfig =
    defaultXPConfig { font                  = barFont
                    , bgColor               = black
                    , fgColor               = green
                    , bgHLight              = green
                    , fgHLight              = black
                    , promptBorderWidth     = 0
                    , height                = 14
                    , historyFilter         = deleteConsecutive
                    }
 
-- Run or Raise Menu
largeXPConfig :: XPConfig
largeXPConfig = mXPConfig { font = xftFont , height = 12 }

-- }}}

-- Key mapping {{{
keys' :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask,                    xK_z        ), spawn "gmrun")
    , ((modMask,                    xK_p        ), runOrRaisePrompt largeXPConfig)
    , ((0,                          xK_Print    ), spawn "scrot '%Y-%m-%d_wx$h_scrot.png' -e 'mv $f ~/Pictures/screenshots/'")

    -- Programs
    , ((modMask .|. shiftMask,      xK_Return   ), spawn $ XMonad.terminal conf) -- spawn terminal
    , ((modMask,                    xK_w        ), spawn "chromium")
    , ((modMask,                    xK_e        ), spawn "thunar")
    , ((modMask,                    xK_i        ), spawn "pidgin")

    -- Media Keys
    , ((modMask,                    xK_Insert   ), spawn "amixer -c 0 set Master 1dB-")
    , ((modMask,                    xK_Delete   ), spawn "amixer -c 0 set Master 2dB+")

    -- layouts
    , ((modMask,                    xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf) -- reset layout on current desktop to default
    , ((modMask,                    xK_t        ), sendMessage ToggleStruts)

    -- Sub Layout ------------------------------------------------------------
    --, ((modMask .|. controlMask, xK_Left), sendMessage $ pullGroup L)
    --, ((modMask .|. controlMask, xK_Right), sendMessage $ pullGroup R)
    --, ((modMask .|. controlMask, xK_Up), sendMessage $ pullGroup U)
    --, ((modMask .|. controlMask, xK_Down), sendMessage $ pullGroup D)

    --, ((modMask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    --, ((modMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))

    --, ((modMask .|. controlMask, xK_period), onGroup W.focusUp')
    --, ((modMask .|. controlMask, xK_comma), onGroup W.focusDown')
    --------------------------------------------------------------------------  
    
    , ((modMask .|. shiftMask,      xK_c        ), kill) -- kill selected window
    , ((modMask,                    xK_Return   ), windows W.swapMaster) -- swap the focused window with the master window
    , ((modMask .|. shiftMask,      xK_j        ), windows W.swapDown) -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_k        ), windows W.swapUp)  -- swap the focused window with the previous window

    , ((modMask,                    xK_j        ), windows W.focusDown) -- move focus to next window
    , ((modMask,                    xK_k        ), windows W.focusUp) -- move focus to previous window
    , ((modMask,                    xK_h        ), sendMessage Shrink)
    , ((modMask,                    xK_l        ), sendMessage Expand)

    , ((modMask,                    xK_Down     ), windows W.focusDown) -- move focus to next window
    , ((modMask,                    xK_Up       ), windows W.focusUp) -- move focus to previous window
    , ((modMask,                    xK_Left     ), sendMessage Shrink)
    , ((modMask,                    xK_Right    ), sendMessage Expand)

    , ((modMask  .|. shiftMask,     xK_t        ), withFocused $ windows . W.sink) -- Push window back into tiling

    -- workspaces
    , ((mod1Mask .|. controlMask,   xK_Right    ), nextWS)
    , ((mod1Mask .|. shiftMask,     xK_Right    ), shiftToNext)
    , ((mod1Mask .|. controlMask,   xK_Left     ), prevWS)
    , ((mod1Mask .|. shiftMask,     xK_Left     ), shiftToPrev)
    
    -- quit, or restart
    , ((modMask .|. shiftMask,      xK_q        ), io (exitWith ExitSuccess))
    , ((modMask .|. controlMask,    xK_q        ), restart "xmonad" True)
    ]
    ++
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

--}}}
