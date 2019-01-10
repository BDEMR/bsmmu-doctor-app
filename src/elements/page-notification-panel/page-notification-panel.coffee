Polymer {
  is: 'page-notification-panel'

  behaviors: [
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
    app.behaviors.dbUsing
  ]
  
  properties:
    searchFieldMainInput: 
      type: String
      notify: true
      value: ''
    selectedUserId:
      type: String
      value: ''
    roleSelected:
      type: Number
      value: 0
  
  # _patientSearch: (cbfn)->
  #   @callApi '/bdemr-patient-search', { apiKey: @user.apiKey, searchQuery: @searchFieldMainInput}, (err, response)=>
  #     if response.hasError
  #       @domHost.showModalDialog response.error.message
  #     else
  #       cbfn response.data

  # _doctorSearch: (cbfn)->
  #   @callApi '/bdemr-doctor-search', {searchQuery: @searchFieldMainInput}, (err, response)=>
  #     if response.hasError
  #       @domHost.showModalDialog response.error.message
  #     else
  #       cbfn response.data

  # _clinicSearch: (cbfn)->
  #   @callApi '/bdemr-clinic-search', {searchQuery: @searchFieldMainInput}, (err, response)=>
  #     if response.hasError
  #       @domHost.showModalDialog response.error.message
  #     else
  #       cbfn response.data
  
  _searchUser: ->
    @callApi '/bdemr-user-search-for-notification', {searchString: @searchFieldMainInput}, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        data = response.data
        if data.length > 0
          userSuggestionArray = (item for item in data)
          @.$.userSearch.suggestions userSuggestionArray
        else
          @domHost.showToast 'No Match Found'
    
  
  userSearchStartKeyPressed: (e)->
    return unless e.which is 13
    @_searchUser()

  userSearchButtonPressed: ->
    @_searchUser()

  
  userSelected: (e)->
    e.preventDefault()
    userId = e.detail.value
    @set 'selectedUserId', userId

  userSearchCleared: ->
     @set 'searchFieldMainInput', ''

  notificationSendButtonPressed: ->
    this._chargePatient @selectedUserId, 1, 'Payment BDEMR Doctor Generic', (err)=>
      if (err)
        @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
        return
        
      user = @getCurrentUser()
      request = {
        operation: 'notify-single'
        apiKey: user.apiKey
        notificationCategory: 'general'
        notificationMessage: @notificationMessage
        notificationTargetId: @selectedUserId
        sender: user.name
      }
      @domHost.ws.send JSON.stringify request

  smsSendButtonPressed: (e)->
    unless @selectedUserId
      @domHost.showToast 'Select an User from Search'
      return
    unless @notificationMessage
      @domHost.showToast 'Write a message to be sent.'
      return

    @domHost.showModalPrompt 'SMS Sending will cost you 1.23 BDT/sms. Are you sure?', (done)=>
      if done
        data =
          apiKey: @getCurrentUser().apiKey
          receiverUserId: @selectedUserId
          phoneNumber: null
          smsBody: @notificationMessage
        
        @callApi '/send-individual-sms', data, (err, response)=>
          if response.hasError
            @domHost.showModalDialog response.error.message
          else
            @domHost.showModalDialog 'Successfuly Sent'

  arrowBackButtonPressed: (e)->
    window.location = '#/dashboard'

    
  
}