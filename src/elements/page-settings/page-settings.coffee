
Polymer {

  is: 'page-settings'

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
    settings:
      type: Object
      notify: true
    languageSelectedIndex: 
      type: Number
      value: app.lang.defaultLanguageIndex
      notify: true
      observer: 'languageSelectedIndexChanged'
    maximumLogoImageSizeAllowedInBytes:
      type: Number
      value: 1000 * 1000

    changePassword:
      type: Object
      notify: true

    validationError:
      type: Object
      notify: true
      value: null

  navigatedIn: ->
    @_loadUser()
    @loadSettings()
    @resetChangePasswordObject()

  languageSelectedIndexChanged: ->
    value = @supportedLanguageList[@languageSelectedIndex]
    # console.log value
    @setActiveLanguage value

  _saveSettings: ->
    @settings.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'settings', @settings, ({serial})=> serial is @settings.serial

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  saveButtonPressed: (e)->
    @_saveSettings()
    @domHost.showToast 'Settings Saved!'

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  _makeSettings: () ->
    @settings =
      createdByUserSerial: @user.serial
      lastModifiedDatetimeStamp: null
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: null
      serial: @generateSerialForSettings()
      printDecoration:
        headerLine: ''
        leftSideLine1: ''
        leftSideLine2: ''
        leftSideLine3: ''
        rightSideLine1: ''
        rightSideLine2: ''
        rightSideLine3: ''
        footerLine: ''
        logoDataUri: null
      billingTargetEmailAddress: ''
      nsqipTargetEmailAddress: ''
      monetaryUnit: 'BDT'
      otherSettings:
        patientSignUpDefaultPassword: '123456'
      flags:
        showFooterLine: true
        showUserNameOnPrintPreview: true
      authorizedOrganiztionList: []

  showFooterLine:(e)->
    value = e.target.checked

    if typeof @settings.flags is 'undefined'
      object =
        showFooterLine: value
      @settings.flags = object
    else
      @settings.flags.showFooterLine = value

    console.log @settings


  loadSettings: ()->
    settingsSerial = @generateSerialForSettings()
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()
    if list.length
      @settings = list[0]
    else
      @_makeSettings()
    

  ## change password - start
  changePasswordBtnPressed: ()->
    if @changePassword.oldPassword and @changePassword.newPassword and @changePassword.newRetypePassword
      @_callChangeUserPasswordApi()


  _callChangeUserPasswordApi: ()->
    data = @changePassword
    data.apiKey = @user.apiKey

    @callApi '/change-user-password', data, (err, response)=>
      console.log response
      if response.hasError
        
        # if response.error.message
        #   @domHost.showModalDialog response.error.message
        # else
        @validationError = response.error.details

        @domHost.showModalDialog @_formatErrorMessageAndShow @validationError

      else
        @validationError = null
        @resetChangePasswordObject()
        @domHost.showModalDialog "Password has been changes successfully!"


      console.log 'validationError', @validationError

  _formatErrorMessageAndShow: (err)->
    errList = []

    if err.oldPassword
      errList.push err.oldPassword[0]

    if err.newPassword
      errList.push err.newPassword[0]

    if err.newRetypePassword
      errList.push err.newRetypePassword[0]

    return errList




  resetChangePasswordObject: ()->
    @changePassword =
      oldPassword: null
      newPassword: null
      newRetypePassword: null
      


  _getError: (errObj, prop)->
    console.log 'errObj', errObj

  ## change password - end

  
  fileInputChanged: (e)->
    reader = new FileReader
    file = e.target.files[0]

    if file.size > @maximumLogoImageSizeAllowedInBytes
      @domHost.showModalDialog 'Please provide a file less than 1mb in size.'
      return

    reader.readAsDataURL file
    reader.onload = =>
      dataUri = reader.result
      @set 'settings.printDecoration.logoDataUri', dataUri

  fileInputChanged2: (e)->
    reader = new FileReader
    file = e.target.files[0]

    if file.size > @maximumLogoImageSizeAllowedInBytes
      @domHost.showModalDialog 'Please provide a file less than 1mb in size.'
      return

    reader.readAsDataURL file
    reader.onload = =>
      dataUri = reader.result
      @set 'settings.printDecoration.signatureDataUri', dataUri

}