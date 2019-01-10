
Polymer {

  is: 'page-select-organization'

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

    organizationsIBelongToList:
      type: Array
      value: -> []
    
    selectedOrganizationIndex:
      type: Number
      notify: true
      value: 0

    selectedUserRoleIndex:
      type: Number
      notify: true
      value: 0
      
    

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  organizationSelected: (e)->
    if @selectedOrganizationIndex?
      @set 'userRoleList', @organizationsIBelongToList[@selectedOrganizationIndex].userRoleList

    console.log 'userRoleList', @userRoleList
  
  $notUndefined: (value)-> if value? then true else false

  navigatedIn: ->
    @_loadUser()
    @_findOrganizationsUserBelongsTo @user.apiKey
    
  navigatedOut: ->
    @isOrganizationValid = false
    @memberSearchResultList = []
    @memberList = []

  _findOrganizationsUserBelongsTo: (apiKey)->
    @callApi '/bdemr-organization-list-those-user-belongs-to', apiKey: apiKey, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @organizationsIBelongToList = response.data.organizationObjectList
  
  
  navigateWithOrganizationSelected: ->
    selectedOrganization = @organizationsIBelongToList[@selectedOrganizationIndex]
    if selectedOrganization
      app.db.remove 'organization', item._id for item in app.db.find 'organization'
      app.db.insert 'organization', selectedOrganization

      selectedUserRole = @userRoleList[@selectedUserRoleIndex]
      if selectedUserRole
        @_getUserRoleDetails selectedUserRole, selectedOrganization.idOnServer, =>
          @domHost.navigateToPage "#/chamber-manager"
          window.location.reload()
      else
        @domHost.navigateToPage "#/chamber-manager"
        window.location.reload()

      # error tracking js meta
      if app.mode is 'production'
        bugsnagClient.metaData.organization = {
          name: @selectedOrganization.name
          id: @selectedOrganization.idOnServer
          isCurrentUserAnAdmin: @selectedOrganization.isCurrentUserAnAdmin
        }

    else
      @domHost.showModalDialog "Chose an Organization to Continue"

  _getUserRoleDetails: (selectedRole, orgIdentifier, cbfn)->
    data =
      apiKey: @user.apiKey
      organizationId: orgIdentifier
      roleId: selectedRole.serial
    console.log 'data', data

    @callApi '/bdemr-get-user-role-details-from-belong-organization', data , (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        selectedOrganization = @organizationsIBelongToList[@selectedOrganizationIndex]
        selectedOrganization.userActiveRole = response.data
        app.db.upsert 'organization', selectedOrganization, ({idOnServer})=> selectedOrganization.idOnServer is idOnServer
        cbfn()

  
  createOrganizationButtonPressed: ->
     @domHost.navigateToPage "#/organization-manager"

  _isEmpty: (data)-> 
    if data is 0
      return true
    else
      return false
}
