fx_version 'cerulean'
game 'gta5'

description 'https://github.com/QBCore-Remastered'
version '1.0.1 dev'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'