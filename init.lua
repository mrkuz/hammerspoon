-- -------------------------------------------------------------------------------
-- Map caps lock to F20 ==
-- see: https://developer.apple.com/library/archive/technotes/tn2450/_index.html#//apple_ref/doc/uid/DTS40017618-CH1-KEY_TABLE_USAGES)
-- -------------------------------------------------------------------------------

local codeCapsLock = '0x700000039'
local codeF20 = '0x70000006F'
hs.execute("hidutil property --set '{\"UserKeyMapping\":[{"
           .. "\"HIDKeyboardModifierMappingSrc\": " .. codeCapsLock .. ", "
           .. "\"HIDKeyboardModifierMappingDst\": " .. codeF20
           ..  "}]}'")

local hyper = hs.hotkey.modal.new()
hs.hotkey.bind({}, 'F20', function() hyper:enter() end, function() hyper:exit() end)

-- -------------------------------------------------------------------------------
-- Load Spoons
-- -------------------------------------------------------------------------------

hs.loadSpoon('SafetyNet'):start()

local commander = hs.loadSpoon('Commander')
local hammerspoon = hs.loadSpoon('Hammerspoon')
local locator = hs.loadSpoon('MouseLocator')
local windows = hs.loadSpoon('Windows')
local spaces = hs.loadSpoon('Spaces'):start()
local inputSources = hs.loadSpoon('InputSources'):start()
local secondaryPasteboard = hs.loadSpoon('SecondaryPasteboard'):start()
local menuActions = hs.loadSpoon('MenuActions')
local cheatSheet = hs.loadSpoon("CheatSheet")

-- -------------------------------------------------------------------------------
-- Configure Commander
-- -------------------------------------------------------------------------------

commander:registerAction({ name = 'windows', text = 'Windows' })
commander:registerAction({ name = 'spaces', text = 'Spaces' })
commander:registerAction({ name = 'pasteboard', text = 'Pasteboard' })
commander:registerAction({ name = 'menu', text = 'Menu' })

commander:registerSpoon(cheatSheet)
commander:registerSpoon(inputSources)
commander:registerSpoon(locator)
commander:registerSpoon(windows, 'windows')
commander:registerSpoon(spaces, 'spaces')
commander:registerSpoon(secondaryPasteboard, 'pasteboard')
commander:registerSpoon(menuActions, 'menu')
commander:registerSpoon(hammerspoon)

-- -------------------------------------------------------------------------------
-- Set up hotkeys
-- -------------------------------------------------------------------------------

commander:bindHotkeys({
      show = { {}, 'space', modal = hyper }
})
cheatSheet:bindHotkeys({
      toggle = { { 'hyper' }, '/', modal = hyper }
})
locator:bindHotkeys({
      toggle = { { 'hyper' }, 'w', modal = hyper }
})
windows:bindHotkeys({
      forceClose = { { 'ctrl', 'cmd' }, 'w' },
      minimizeAll = { { 'hyper', 'cmd' }, 'm', modal = hyper },
      hideAll = { { 'hyper', 'cmd' }, 'h', modal = hyper }
})
hammerspoon:bindHotkeys({
      reloadConfig = { { 'hyper' }, 'r', modal = hyper }
})

-- -------------------------------------------------------------------------------
-- Configure some custom hotkeys
-- -------------------------------------------------------------------------------

local emacsSocket = '/var/folders/tm/s0rmv44130v_l7p3jynpdkm00000gn/T/emacs501/default'

hyper:bind({}, 'e', nil, function()
      hs.execute('emacsclient --socket-name ' .. emacsSocket .. ' -n -c', true)
end)

hyper:bind({}, 'h', nil, function()
      hs.execute('open $HOME', true)
end)

hyper:bind({}, 'j', nil, function()
      hs.execute("emacsclient --socket-name " .. emacsSocket .. " -n -c -F '((name . \\\"org-protocol-capture\\\"))' 'org-protocol://capture?template=j'", true)
end)

hyper:bind({}, 't', nil, function()
      hs.execute('open -n /Users/markus/Applications/Home\\ Manager\\ Apps/kitty.app', true)
end)
