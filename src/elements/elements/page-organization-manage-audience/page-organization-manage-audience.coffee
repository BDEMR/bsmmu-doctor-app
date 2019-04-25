
Polymer {

  is: 'page-organization-manage-audience'

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

    audienceList:
      type: Array
      value: -> []

    newAudience:
      type: Object
      notify: true
      value: -> null

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
   
    params = @domHost.getPageParams()
    if params['organization']
      @_loadOrganization params['organization']      
    else
      @_notifyInvalidOrganization()

    @_createBlankAudience()

  navigatedOut: ->
    @audienceList = []

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
        @set 'organization', response.data.matchingOrganizationList[0]

        @set 'isOrganizationValid', true
        @_loadAudienceList()

  _loadAudienceList: ->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
    }
    @callApi '/election-audience-list', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'audienceList', response.data.audienceList
        console.log @audienceList

  _createBlankAudience: ->
    this.newAudience = 
      # title: 'Untitled',
      # description: 'Put description here',
      # date: this.$mkDate(new Date),
      # time: '11:30:00'
      phone: ""

  addAudienceTapped: (e)->
    return if (!@newAudienceRawInput)
    count = 0
    done = 0
    audienceList = @newAudienceRawInput.split('\n')
      .filter((audience) => audience.length > 9)
      .forEach (audience, index) =>
        count += 1
        data = { 
          apiKey: @user.apiKey
          organizationId: @organization.idOnServer
          audience: { phone: audience }
        }
        @callApi '/election-audience-set', data, (err, response)=>
          if response.hasError
            @domHost.showModalDialog response.error.message
          else
            done += 1
            @domHost.showToast "Completed #{done} out of #{count}"
            if (done is count)
              # @_createBlankAudience()
              @_loadAudienceList()

  sendSmsTapped: ->
    @responseList = []
    count = 0
    done = 0
    hasShownError = false
    @audienceList.forEach (audience, index) =>
      count += 1
      data = { 
        apiKey: @user.apiKey
        organizationId: @organization.idOnServer
        receiverUserId: null, 
        phoneNumber: audience.phone ,
        smsBody: @newSmsInput
        organizationName: ''
      }
      @callApi '/send-individual-sms', data, (err, response)=>
        if response.hasError
          # if !hasShownError
          #   @domHost.showModalDialog response.error.message
          #   hasShownError = true
          @domHost.showToast "Failed #{audience.phone}"
          @push 'responseList', "FAILED #{audience.phone} - #{response.error.message}"
          done += 1
        else
          done += 1
          @domHost.showToast "Processed #{done} out of #{count}"
          @push 'responseList', "OK #{audience.phone}"
          if (done is count)
            # @_createBlankAudience()
            # @_loadAudienceList()
            @domHost.showModalDialog "All messages processed"


  deleteAudienceTapped: (e)->
    data = {
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      audienceId: e.model.audience.id
    }
    @callApi '/election-audience-delete', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @_createBlankAudience()
        @_loadAudienceList()

        send-individual-sms

  # addAudienceTapped: (e)->
  #   { audience } = e.model
  #   data = { 
  #     apiKey: @user.apiKey
  #     organizationId: @organization.idOnServer
  #     targetUserId: audience.idOnServer
  #   }
  #   @callApi '/election-organization-add-user', data, (err, response)=>
  #     if response.hasError
  #       @domHost.showModalDialog response.error.message
  #     else
  #       @domHost.showToast 'User Added'
  #       @splice 'audienceSearchResultList', (@audienceSearchResultList.indexOf audience), 1
  #       params = @domHost.getPageParams()
  #       @_loadOrganization params['organization']

  # removeAudienceTapped: (e)->
  #   { audience } = e.model
  #   data = { 
  #     apiKey: @user.apiKey
  #     organizationId: @organization.idOnServer
  #     targetUserId: audience.idOnServer
  #   }
  #   @callApi '/election-organization-remove-user', data, (err, response)=>
  #     if response.hasError
  #       @domHost.showModalDialog response.error.message
  #     else
  #       @domHost.showToast 'User Removed'
  #       params = @domHost.getPageParams()
  #       @_loadOrganization params['organization']

}         
