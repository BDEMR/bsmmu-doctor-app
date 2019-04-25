Polymer {
  is: 'page-welcome'

  properties:
    welcomeSection:
      type: Number
      value: 0
    previousButtonDisabled:
      type: Boolean
      computed: '_previousButtonDisabled(welcomeSection)'
    nextButtonDisabled:
      type: Boolean
      computed: '_nextButtonDisabled(welcomeSection)'
  
  ready: ->
    lib.localStorage.setItem 'welcomePageViewed', 'true'
  
  nextSectionButtonClicked: ->
    if @welcomeSection isnt 3
      ++@welcomeSection
    

  _nextButtonDisabled: (welcomeSection)->
    return true if welcomeSection is 3
    return false

  previousSectionButtonClicked: (e)->
    if @welcomeSection isnt 0
      --@welcomeSection

  _previousButtonDisabled: (welcomeSection)->
    return true if welcomeSection is 0
    return false

  showLoginButtons: (welcomeSection)->
    return true if welcomeSection is 3
    return false

  loginButtonClicked: ->
    window.location = '#/login'
  
  signupButtonClicked: ->
   window.location = '#/signup'
  
}