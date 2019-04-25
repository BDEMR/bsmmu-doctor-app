Polymer {
  is: 'page-welcome-internal'

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
  
  nextSectionButtonClicked: ->
    if @welcomeSection isnt 3
      ++@welcomeSection
    
  _nextButtonDisabled: (welcomeSection)->
    return true if welcomeSection is 3
    return false

  previousSectionButtonClicked: (e)->
    if @welcomeSection isnt 0
      --@welcomeSection
    else
      console.log 'limit reached'

  _previousButtonDisabled: (welcomeSection)->
    return true if welcomeSection is 0
    return false

  arrowBackButtonPressed: (e)->
     window.location = '#/dashboard'

  
}