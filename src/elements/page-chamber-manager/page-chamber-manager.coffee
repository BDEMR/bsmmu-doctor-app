
Polymer {
  
  is: 'page-chamber-manager'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:

    hasSearchBeenPressed:
      type: Boolean
      notify: true
      value: true


    matchingChamberList:
      type: Array
      notify: true
      value: []

    chamberSearchString: 
      type: String
      notify: true
      value: ''
      
    user:
      type: Object
      notify: true
      value: null


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
      # console.log @user


  navigatedIn: ->
    @currentOrganization = @getCurrentOrganization()
    unless @currentOrganization
      return @domHost.navigateToPage "#/select-organization"
      
    @_loadUser()
    @_loadChamberList()

  _loadChamberList: (searchString='')->
    data = { 
      apiKey: @user.apiKey
      doctorId: this.user.idOnServer
    }
    @callApi '/bdemr--get-all-doctor-chamber', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else if response.data.length is 0
        @domHost.showModalDialog "No Match Found"
      else
        @matchingChamberList = response.data

  searchChamberTapped: -> @_loadChamberList(@chamberSearchString)

  clearSearchResultsClicked: (e)->
    @matchingChamberList = []



  ## ------------------ import / publish start

  
  viewChamber: (e)->
    chamber = e.model.chamber
    @domHost.navigateToPage '#/chamber/which:' + chamber.shortCode



  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

  newPatientPressed: (e)->
    @domHost.navigateToPage '#/patient-signup'



}
