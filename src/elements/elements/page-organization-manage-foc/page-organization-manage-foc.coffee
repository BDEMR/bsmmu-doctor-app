
Polymer {

  is: 'page-organization-manage-foc'

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

    packageList:
      type: Array
      value: -> []

  $add: (a, b)-> parseInt(a) + parseInt(b)

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')

  _sortByDate: (a, b)-> return (b.createdDatetimeStamp - a.createdDatetimeStamp)
  
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
        @_loadAvailablePackages organizationId
        @_loadPackageActivations organizationId
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
        cbfn(organization.idOnServer)
        
  addPatient: (patient)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      targetidOnServer: patient.idOnServer
      outdoorBalance: @outdoorBalance
      indoorBalance: @indoorBalance
    }
    @callApi '/bdemr-organization-add-patient', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Patient Added Successfully'
        @_loadWallet()
        @_loadAvailablePackages(@organization.idOnServer)

  _loadAvailablePackages: (organizationId)->
    data = { 
      apiKey: @user.apiKey
      organizationId: organizationId
    }
    @callApi '/internal--foc--get-packages', data, (err, response)=>
      if response.hasError
        @domHost.showToast response.error.message
      else
        # console.log(response.data.packageList, organizationId)
        @set 'packageList', response.data.packageList

  _loadPackageActivations: (organizationId)->
    data = { 
      apiKey: @user.apiKey
      organizationId: organizationId
    }
    @callApi '/bdemr-patient--foc--get-active-packages', data, (err, response)=>
      if response.hasError
        @domHost.showToast response.error.message
      else
        # console.log(response.data.packageActivationList)
        @set 'packageActivationList', response.data.packageActivationList

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
    @selectPatient patient

  selectPatient: (patient)->
    @selectedPatient = patient

  _setFoc: ({ packageName, patientId, organizationId }, cbfn)->
    @callApi '/bdemr-patient--foc--activate-package', { apiKey: @user.apiKey, packageName, patientId, organizationId }, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showModalDialog "Patient is set as Free Of Charge for the desired duration."
        cbfn()

  chargePatientTapped:(e)->
    selectedPackage = e.model.package
    selectedPatient = @selectedPatient
    @_chargePatient selectedPatient.idOnServer, selectedPackage.needsToPay, 'Payment for FOC', (err)=>
      if (err)
        @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
        return
      packageName = selectedPackage.name
      patientId = selectedPatient.idOnServer
      organizationId = @organization.idOnServer
      @_setFoc { packageName, patientId, organizationId }, => 
        @navigatedIn()
      
  chargeMeTapped:(e)->
    selectedPackage = e.model.package
    selectedPatient = @selectedPatient
    @_chargePatient @user.idOnServer, selectedPackage.needsToPay, 'Payment for FOC', (err)=>
      if (err)
        @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
        return
      packageName = selectedPackage.name
      patientId = selectedPatient.idOnServer
      organizationId = @organization.idOnServer
      @_setFoc { packageName, patientId, organizationId }, => 
        @navigatedIn()

}
