-- Resource Metadata
fx_version 'cerulean'
games {'gta5'}

author 'Will B.'
description 'MidwestRP Trucking Job'
version '1.0.0'

-- What to run
client_scripts {
    "@NativeUI/NativeUI.lua",
    'client/cl_main.lua',
    'config/config.lua',
    'menu/menu.lua',
    'functions/functions.lua',
}

server_scripts {
    'server/sv_main.lua',
}

ui_page 'nui/nui.html'

files {
    'nui/nui.html',
    'nui/style.css',
    'nui/script.js',
    'nui/images/*',
}
