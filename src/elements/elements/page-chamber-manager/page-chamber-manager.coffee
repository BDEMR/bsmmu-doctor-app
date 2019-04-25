
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
      console.log @user


  # navigatedIn: ->
  #   @currentOrganization = @getCurrentOrganization()
  #   unless @currentOrganization
  #     return @domHost.navigateToPage "#/select-organization"
      
  #   @_loadUser()
  #   @_loadChamberList()

  # _loadChamberList: (searchString='')->
  #   data = { 
  #     apiKey: @user.apiKey
  #     doctorId: this.user.idOnServer
  #   }
  #   @callApi '/bdemr--get-all-doctor-chamber', data, (err, response)=>
  #     if response.hasError
  #       @domHost.showModalDialog response.error.message
  #     else if response.data.length is 0
  #       @domHost.showModalDialog "No Match Found"
  #     else
  #       @matchingChamberList = response.data

  # searchChamberTapped: -> @_loadChamberList(@chamberSearchString)

  # clearSearchResultsClicked: (e)->
  #   @matchingChamberList = []



  # ## ------------------ import / publish start

  
  # viewChamber: (e)->
  #   chamber = e.model.chamber
  #   @domHost.navigateToPage '#/chamber/which:' + chamber.shortCode



  # _isEmptyArray: (data)->
  #   if data.length is 0
  #     return true
  #   else
  #     return false

  newPatientPressed: (e)->
    @domHost.navigateToPage '#/patient-signup'


  navigatedIn: ->
    @organization = @getCurrentOrganization()
    unless @organization
      return @domHost.navigateToPage "#/select-organization"
    @_loadUser()
    @_getChamberList ()=> null

  _getChamberList: (cbfn)->
    data = { 
      apiKey: this.user.apiKey
      dateString: (new Date()).toISOString().split('T')[0]
    }
    this.loading = true;
    this.callApi '/bdemr-booking--doctor--get-chamber-schedule-report', data, (err, response)=>
      this.loading = false;
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        matchingChamberList = response.data
        matchingChamberList.sort (a, b)->
          return -1 if a.name < b.name
          return 1 if a.name > b.name
          return 0
        @set 'matchingChamberList', matchingChamberList
        cbfn()
      else
        this.matchingChamberList = []
        cbfn()

  getFreeSlots: (freeSlots)->
    return 0 unless freeSlots?.length 
    return freeSlots.reduce (total, freeSlot)->
      return total += freeSlot.availableCount
    , 0

  getTotalFreeSlots: (chamberList)->
    return 0 unless chamberList?.length 
    return chamberList.reduce (total, chamber)=>
      return total += @getFreeSlots chamber.freeSlots
    ,0

  getTotalBooked: (chamberList)->
    return 0 unless chamberList?.length 
    return chamberList.reduce (total, chamber)->
      return total += chamber.bookedPatient?=0
    ,0

  getTotalAwaiting: (chamberList)->
    return 0 unless chamberList?.length 
    return chamberList.reduce (total, chamber)->
      return total += chamber.awaitingPatient?=0
    ,0

  getTotalCompleted: (chamberList)->
    return 0 unless chamberList?.length 
    return chamberList.reduce (total, chamber)->
      return total += chamber.completedPatient?=0
    ,0
  
  formatDate: ()->
    d = new Date()
    month = '' + (d.getMonth() + 1)
    day = '' + d.getDate()
    year = d.getFullYear()

    if month.length < 2
      month = '0' + month
    if day.length < 2
      day = '0' + day
    return [year, month, day].join('-')  

  viewChamberSchedule: (e)->
    { item } = e.model
    today = this.formatDate()
    this.domHost.navigateToPage "#/chamber-patients/chamber:#{item.shortCode}/date:#{today}"


  viewTodaysPatient: (e)->
    {item} = e.model
    dateString = (new Date()).toISOString().split('T')[0]
    this.domHost.navigateToPage "#/chamber-patients/chamber:#{item.shortCode}/date:#{dateString}"



}
