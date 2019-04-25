
Polymer {
  
  is: 'page-send-feedback'
  

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:
    feedbackText:
      type:String
      value: -> ""

    email:
      type: String
      value: -> ""
    
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
    @_loadUser()


  sendFeedback: ()->
    console.log @feedbackText
    @callApi 'bdemr-send-feedback-via-email', {feedbackText:@feedbackText, email:@email, apiKey: @user.apiKey}, ()=> 

      console.log "success"
      @domHost.showToast "Email Sent! Thank you for your Feedbacks"
      @feedbackText = ""
      @email = ""
}
