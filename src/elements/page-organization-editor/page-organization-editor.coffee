
Polymer {

  is: 'page-organization-editor'

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

    parentSearchResultList:
      type: Array
      value: -> []

    parentList:
      type: Array
      value: -> []

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  saveButtonPressed: (e)->
    params = @domHost.getPageParams()
    if params['organization'] is 'new'
      @_createOrganization =>
        @domHost.showToast 'Organization Created'
        @arrowBackButtonPressed()
    else
      @_updateOrganization =>
        @domHost.showToast 'Organization Updated'
        @arrowBackButtonPressed()
    
  _makeNewOrganization: ->
    @organization = 
      idOnServer: null
      serial: null
      name: ''
      address: ''
      effectiveRegion: ''
      parentOrganizationIdList: []
    @isOrganizationValid = true

  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  _createOrganization: (cbfn)->
    data = { 
      apiKey: @user.apiKey
      name: @organization.name
      serial: @organization.serial
      address: @organization.address
      effectiveRegion: @organization.effectiveRegion
      parentOrganizationIdList: @organization.parentOrganizationIdList
      markAsPccOrganization: @organization.markAsPccOrganization
    }
    @callApi '/bdemr-organization-create', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn()

  _updateOrganization: (cbfn)->
    console.log @organization
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      name: @organization.name
      serial: @organization.serial
      address: @organization.address
      effectiveRegion: @organization.effectiveRegion
      parentOrganizationIdList: @organization.parentOrganizationIdList
      markAsPccOrganization: @organization.markAsPccOrganization
    }
    @callApi '/bdemr-organization-update', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn()

  navigatedIn: ->
    @_loadUser()
    
    # currentOrganization = @getCurrentOrganization()
    # unless currentOrganization
    #   @domHost.navigateToPage "#/select-organization"
    
    params = @domHost.getPageParams()
    if params['organization']
      if params['organization'] is 'new'
        @_makeNewOrganization()
      else
        @_loadOrganization params['organization']
    else
      @_notifyInvalidOrganization()
    
  navigatedOut: ->
    @organization = null
    @isOrganizationValid = false
    @parentSearchResultList = []
    @parentList = []

  searchParentOrganizationTapped: (e)->
    data = { 
      apiKey: @user.apiKey
      searchString: @parentOrganizationSearchString
    }
    @callApi '/bdemr-organization-search', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'parentSearchResultList', response.data.matchingOrganizationList

  $in: (value, list)-> 
    value in list

  addParentTapped: (e)->
    { parent } = e.model
    @push 'organization.parentOrganizationIdList', parent.idOnServer
    @push 'parentList', parent
    @splice 'parentSearchResultList', (@parentSearchResultList.indexOf parent), 1

  removeParentTapped: (e)->
    { parent } = e.model
    @splice 'organization.parentOrganizationIdList', (@organization.parentOrganizationIdList.indexOf parent.idOnServer), 1
    @splice 'parentList', (@parentList.indexOf parent), 1

  _loadOrganization: (idOnServer)->
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

        if typeof organization.serial is 'undefined'
          organization.serial = ''

        console.log 'organization', organization
        
        @set 'organization', organization

        @set 'isOrganizationValid', true
        @_loadParentList()

  _loadParentList: ->
    data = { 
      apiKey: @user.apiKey
      idList: @organization.parentOrganizationIdList
    }
    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'parentList', response.data.matchingOrganizationList

}
