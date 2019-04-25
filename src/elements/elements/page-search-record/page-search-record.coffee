
Polymer {
  
  is: 'page-search-record'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:
    matchingRecordList: 
      type: Array
      value: -> []
    searchParameters:
      type: Object
      value: -> {
        symptoms: { shouldSearch: false }
        diagnosis: { shouldSearch: false }
      }  

    currentOrganization:
      type: Object
      value: {}

  # region: common utilities ============================
  
  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  # region: lifetime and observers ============================

  navigatedIn: ->
    @currentOrganization = @getCurrentOrganization()
    unless @currentOrganization
      @domHost.navigateToPage "#/select-organization"
      
    this._loadUser()

  # region: ui ============================

  searchButtonPressed: (e)->
    @_search()

  _goBack: ->
    @domHost.navigateToPreviousPage()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  recordPressed: (e)->
    { record } = e.model
    this._importAndShowRecord record

  # region: online search ============================

  _searchOnline: (searchParameters, cbfn)->
    data = { 
      apiKey: @user.apiKey
      searchParameters
      doctorSerial: @user.serial
    }
    @callApi '/bdemr-doctor-app--search-records', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn response.data.visitList

  _search: ->
    console.log this.searchParameters
    this._searchOnline this.searchParameters, (matchingRecordList)=>
      console.log matchingRecordList
      @matchingRecordList = matchingRecordList
  
  # region: record import ============================

  _importAndShowRecord: (record)->
    clientPatientDb = 'patient-list'
    patientSerial = record.patientSerial

    data = { 
      apiKey: @user.apiKey
      serial: patientSerial
      pin: 'DISREGARD-ME'
      doctorName: @user.name
      organizationId: @currentOrganization.idOnServer
    }
    @callApi '/bdemr-patient-import-new', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
        return
      else
        patientObject = response.data[0]

        # patientObject.isForOrganizationOnly = true
        app.db.upsert clientPatientDb, patientObject, ({serial})=> patientObject.serial is serial
        # console.log patientObject
        
        url = "#/visit-editor/visit:#{record.serial}/patient:#{patientSerial}"
        @domHost._sync url

}
