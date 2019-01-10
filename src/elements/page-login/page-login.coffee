
Polymer {
  is: 'page-login'

  behaviors: [
    app.behaviors.dbUsing
    app.behaviors.apiCalling
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.commonComputes
  ]

  properties:

    loginFormData: 
      type: Object
      notify: true
      value: do ->
        if app.mode is 'production'
          emailOrPhone: ''
          password: ''
        else
          emailOrPhone: 'doctor1@doctor1.com'
          password: 'asdfasdf'
    mode:
      type: String
      value: 'login'
    tempUser:
      type: String
      value: null
    shouldRememberUser: 
      type: Boolean
      notify: true
      value: true


  navigatedIn: ->
    @mode = 'login'

  loginAsMyselfPressed: (e)->
    @tempUser.isUsingAsAssistant = false
    @loginDbAction @tempUser, @shouldRememberUser
    @domHost.navigateToPage '#/'

  loginAsSomeoneElsePressed: (e)->
    {ofDoctor} = e.model
    ofDoctor.isUsingAsAssistant = true
    delete @tempUser['listOfDoctorsAssistantTo']
    ofDoctor.usingAsAssistantUserObject = @tempUser
    @loginDbAction ofDoctor, @shouldRememberUser
    @domHost.navigateToPage '#/'

  enterKeyPressed: (e)->
    if e.keyCode is 13 
      @loginApiCalled()
    

  loginButtonPressed: ()->
    @loginApiCalled()
    
  _checkUserActivation: (user, cbfn)->
    dt = new Date user.accountExpiresOnDate
    now = new Date lib.datetime.mkDate lib.datetime.now()
    daysLeft = Math.floor ((lib.datetime.diff dt, now) / 1000 / 60 / 60 / 24)
    if daysLeft < 0
      @domHost.navigateToPage '#/activate'
      return
    else
      cbfn()
  
  loginApiCalled: ()->
    @callApi '/bdemr-app-login', @loginFormData, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        user = response.data
        if 'isUserThemselvesADoctor' of user or 'listOfDoctorsAssistantTo' of user
          @set 'tempUser', user
          @set 'mode', 'doctor-selection'
        if 'isUserThemselvesAStudent' of user
          @loginDbAction user, @shouldRememberUser
          @_checkUserActivation user, ()=>
            @domHost._callAfterUserLogsIn()
            @domHost.navigateToPage '#/'
        else
          user.isUsingAsAssistant = false
          @loginDbAction user, @shouldRememberUser
          @_checkUserActivation user, ()=>
            @domHost._callAfterUserLogsIn()
            @domHost.navigateToPage '#/'

          

}
