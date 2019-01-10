
Polymer {

  is: 'page-foc-admin-panel'

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

    newPackage:
      type: Object
      value: -> {}

    currentlySelectedPackage:
      type: Object
      value: -> {}

  $add: (a, b)-> parseInt(a) + parseInt(b)

  _returnSerial: (index)->
    index+1

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
    @_makeNewPackage()
    
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
        

  _loadAvailablePackages: (organizationId)->
    data = { 
      apiKey: @user.apiKey
      organizationId: organizationId
    }
    @callApi '/internal--foc--get-packages', data, (err, response)=>
      if response.hasError
        @domHost.showToast response.error.message
      else
        console.log("Get Packages", response.data.packageList, organizationId)
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

  _makeNewPackage: ()->
     @set "newPackage", {
       "name": "",
       "displayName": "",
       "needsToPay": null,
       "freeForDays": null,
       "isActive": true,
       "offerableBy": [],
       "applicableToAnyOrganization": true
     }

  _addPackageButtonPressed: (e)->
    console.log "PACKAGE", @newPackage
    @callApi '/internal--foc--set-package', @newPackage, (err,response)=>
      @domHost.showModalDialog "Package Submission Completed"
      window.location.reload(true)
      

  
  _editPackageButtonClicked: (e)->
    @newPackage = e.model.item


}
