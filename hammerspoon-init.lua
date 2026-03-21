hs.hotkey.bind({"cmd", "option"}, "r", function() hs.reload() end)

hs.hotkey.bind({}, "f14", function ()
	toggle_application('cmux')
end)

hs.hotkey.bind({"cmd"}, "f1", function ()
	toggle_application('Google Chrome')
end)

hs.hotkey.bind({"cmd"}, "f2", function ()
	hs.application.launchOrFocus('Flow')
end)

hs.hotkey.bind({}, "f1", function ()
	toggle_application('Obsidian')
end)

hs.hotkey.bind({}, "f2", function ()
	toggle_application('Google Chrome')
end)

-- Toggle an application between being the frontmost app, and being hidden
function toggle_application(_app)
    local app = hs.appfinder.appFromName(_app)
    if not app then
        -- FIXME: This should really launch _app
        return
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end