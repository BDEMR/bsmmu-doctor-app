
window.app = 

  mode: 'production' # can be - 'production' or 'development'

  config:

    clientIdentifier: 'bsmmu-doctor-app'

    clientName: 'bsmmu'

    clientVersion: '0.0.9'

    clientPlatform: 'web' # can be - 'web', 'android', 'ios', 'windows', 'osx', 'ubuntu'

    masterApiVersion: '1'

    variableConfigs:

      'development':

        serverHost: 'http://localhost:8671'
        serverWsHost: 'ws://localhost:8671'

      'production':

        serverHost: 'https://bdemr.services'
        serverWsHost: 'wss://bdemr.services:443'
        

  options:

    baseNetworkDelay: 10

app.config.serverHost = app.config.variableConfigs[app.mode].serverHost


