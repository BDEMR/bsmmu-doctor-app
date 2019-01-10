
Polymer {

  is: 'page-organization-manage-patient'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:

    user:
      type: Object
      notify: true
      value: null

    isOrganizationValid: 
      type: Boolean
      notify: true
      value: false

    organization:
      type: Object
      notify: true
      value: null

    matchingPatientList:
      type: Array
      value: -> []

    indoorBalance:
      type: Number
      value: 800

    outdoorBalance:
      type: Number
      value: 200

    ipdOpdActivityLogs:
      type: Array
      value: -> []
    
    loading:
      type: Boolean
      value: -> false

  $add: (a, b)-> parseInt(a) + parseInt(b)

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')

  _sortByDate: (a, b)-> return (b.createdDatetimeStamp - a.createdDatetimeStamp)
  
  getLogAction:(action)-> if action is "add" then true else false

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  navigatedIn: ->
    @_loadUser()
    @_loadWallet()
    
    params = @domHost.getPageParams()
    if params['organization']
      @_loadOrganization params['organization'], (organizationId)=> 
        @_loadIpdOpdLog organizationId
      
    else
      @_notifyInvalidOrganization()
    
    
  navigatedOut: ->
    @organization = null
    @isOrganizationValid = false

  _loadOrganization: (idOnServer, cbfn)->
    
    data = { 
      apiKey: @user.apiKey
      idList: [ idOnServer ]
    }
    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        unless response.data.matchingOrganizationList.length is 1
          @domHost.showModalDialog "Invalid Organization"
          return
        organization = response.data.matchingOrganizationList[0]
        @set 'organization', organization

        @set 'isOrganizationValid', true
        @_loadPatientList()
        cbfn(organization.idOnServer)
        

  searchOnlineButtonPressed: (e)->
    @searchContextDropdownSelectedIndex = 1
    @searchButtonPressed()

  onlineSearchEnterKeyPressed: (e)->
    if e.keyCode is 13
      return unless @searchFieldMainInput
      @_searchOnline @searchFieldMainInput

  _searchOnline: (searchQuery)->
    @callApi '/bdemr-patient-search', { apiKey: @user.apiKey, searchQuery: searchQuery}, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else if response.data.length is 0
        @domHost.showToast 'No Patient Found with that Search'
        @searchFieldMainInput = ""
      else
        matchingPatientList = response.data
        for patient in matchingPatientList
          patient.flags = {
            isImported: false
            isLocalOnly: false
            isOnlineOnly: false
          }
          localPatientList = app.db.find 'patient-list', ({serial})-> serial is patient.serial
          if localPatientList.length is 0
            patient.flags.isOnlineOnly = true
          else
            patient.flags.isImported = true
            patient._tempLocalDbId = localPatientList[0]._id
        
        userSuggestionArray = ({text:"#{@$getFullName(item.name)}--#{item.email}--#{item.phone}", value:item} for item in matchingPatientList)
        # Populating Suggestion Array for Autocomplete
        @$$("#userSearch").suggestions userSuggestionArray

  userSelected: (e)->
    e.stopPropagation()
    patient = e.detail.value
    @searchFieldMainInput = ""
    patient.organizationId = @organization.idOnServer
    @addPatient patient

  addPatient: (patient)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      targetUserId: patient.idOnServer
      outdoorBalance: @outdoorBalance
      indoorBalance: @indoorBalance
    }
    @callApi '/bdemr-organization-add-patient', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Patient Added Successfully'
        @_loadPatientList()
        @_loadWallet()
        @_loadIpdOpdLog(@organization.idOnServer)

  _loadPatientList: ->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      searchString: ""
    }
    @callApi '/bdemr-organization-list-patient', data, (err, response)=>
      if response.hasError
        @domHost.showToast response.error.message
      else
        console.log response.data.matchingPatientList
        @set 'matchingPatientList', response.data.matchingPatientList

  removePatientPressed: (e)->
    {patient, index} = e.model
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      targetUserId: patient.patientId
    }
    @callApi '/bdemr-organization-remove-patient', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @splice 'matchingPatientList', index, 1
        @_loadIpdOpdLog(@organization.idOnServer)

  viewPatientExpenseHistoryPressed: (e)->
    { patient, index } = e.model
    text = ["Outdoor Expenses:"]
    for expense in patient.outdoorTransactionHistory
      text.push (expense.notes + " - " + expense.amountInBdt + " BDT - " + @$mkDate(expense.createDatetimeStamp))
    text.push ''
    text.push "Indoor Expenses:"
    for expense in patient.indoorTransactionHistory
      text.push (expense.notes + " - " + expense.amountInBdt + " BDT - " + @$mkDate(expense.createDatetimeStamp))
    @domHost.showModalDialog text

  
  ## IPD OPD Wallet allocation log function
  _loadIpdOpdLog: (organizationId)->
    @loading = true
    data = {
      organizationId
      apiKey: @user.apiKey
    }

    @callApi '/bdemr-organization-get-ipd-opd-wallet-allocation-log', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        data = response.data
        @set 'ipdOpdActivityLogs', data
        @loading = false


  ## Role Manager - end

}
