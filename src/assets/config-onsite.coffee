
window.app = 

  mode: 'development' # can be - 'production' or 'development'

  config:

    clientIdentifier: 'bdemr-doctor-app'

    clientName: 'bdemr'

    clientVersion: '1.2.56'

    clientPlatform: 'onsite' # can be - 'web', 'android', 'ios', 'windows', 'osx', 'ubuntu'

    masterApiVersion: '1'

    variableConfigs:

      'development':

        serverHost: 'http://localhost:8671'
        serverWsHost: 'ws://localhost:8671'

  options:

    baseNetworkDelay: 10

app.config.serverHost = app.config.variableConfigs[app.mode].serverHost


