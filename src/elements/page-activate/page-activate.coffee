
Polymer {

  is: 'page-activate'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.dbUsing
  ]

  properties:

    activationCode: 
      type: String
      notify: true
      value: ''
      observer: 'activationCodeChanged'

    isValid: 
      type: Boolean
      notify: true
      value: false

    daysWorth:
      type: Number
      notify: true
      value: 0

    daysLeft:
      type: Number
      notify: true
      value: 0

  activationCodeChanged: ->
    @isValid = false
    @daysWorth = 0

  checkButtonPressed: (e)->
    { apiKey } = (app.db.find 'user')[0]
    @callApi '/check-activation-key', { key: @activationCode, apiKey: apiKey }, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @isValid = true
        @daysWorth = response.data.daysWorth

  activateButtonPressed: (e)->
    { apiKey } = (app.db.find 'user')[0]
    @callApi '/activate-activation-key', { key: @activationCode, apiKey: apiKey }, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        user = (app.db.find 'user')[0]
        user.accountExpiresOnDate = response.data.accountExpiresOnDate
        app.db.update 'user', user._id, user
        @domHost.navigateToPage '#/dashboard'
        @domHost.showModalDialog 'Activation Successful.'

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  navigatedIn: ->
    if (app.db.find 'user').length is 0
      @domHost.logoutPressed()
      return
    user = (app.db.find 'user')[0]
    dt = new Date user.accountExpiresOnDate
    now = new Date lib.datetime.mkDate lib.datetime.now()
    diff = (lib.datetime.diff dt, now)
    if diff > 0
      @daysLeft = Math.floor (diff / 1000 / 60 / 60 / 24)
    @activationCode = ''

  logoutPressed: (e)->
    @removeAllUserInfo()
    @domHost.navigateToPage '#/login'


}
