fx_version 'cerulean'
game 'gta5'

author 'ValdarixGames'
description 'Script for farming and processing weed built for Ox'
version '0.0.1a'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config/*.lua',
}

escrow_ignore {  
    'config.lua',
    'Readme.md'
}

lua54 'yes'
dependency '/assetpacks'