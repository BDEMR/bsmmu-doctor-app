
__isPreloadCalled = false

Polymer {

  is: 'root-element'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.commonComputes
    app.behaviors.apiCalling
    app.behaviors.dbUsing
    app.behaviors.debug
    app.behaviors.local['root-element'].newSync
    app.behaviors.local['root-element'].dataLoader
    # app.behaviors.local['root-element'].patientsDataSyncConfig
    # app.behaviors.local['root-element'].patientsDataSync
    # app.behaviors.local['root-element'].userDataSyncConfig
    # app.behaviors.local['root-element'].userDataSync
  ]
  properties:

    selectedPatientPageIndex:
      type: Number
      value: 0
      notify: true
      observer: 'patientPageSelectedIndexChanged'

    page:
      type: Object
      observer: '_mainViewPageChanged'

    languageSelectedIndex:
      type: Number
      value: app.lang.defaultLanguageIndex
      notify: true
      observer: 'languageSelectedIndexChanged'
    
    languageName:
      type: String
      computed: '_showLanguageName(languageSelectedIndex)'

    downloadActions:
      type: Object
      value: 
        count: 0
        seed: 0
        list: []

    syncActions:
      type: Object
      value:
        count: 0
        seed: 0
        list: []
    
    apiActions:
      type: Object
      value: 
        count: 0
        seed: 0
        list: []

    currentOrganization:
      type: Object
      value: {}

    currentNavigationCandidate:
      type: String
      value: ''

    readyPageNodeNameList:
      type: Array
      value: []

    genericModalDialogContents: 
      type: String
      value: 'Content goes here...'

    genericToastContents: 
      type: String
      value: 'Content goes here...'
    
    longDurationToastContents: 
      type: String
      value: 'Content goes here...'

    genericModalInputFieldValue: 
      type: String
      value: ''
      notify: true

    currentPatientsDetails:
      type: Object
      value: null
      notify: true

    selectedVisitSerial:
      type: String
      value: 'new'
      notify: true
      observer: 'setSelectedVisitSerial'

    currentAd: 
      type: Object

    user:
      type: Object
      value: null

    hideAd:
      type: Boolean
      value: false

    changeWalletUserTypeIcon:
      type: String
      value: null
      notify: true

    shouldChargePatientInsteadOfOrganization:
      type: Boolean
      value: => 
        item = window.localStorage.getItem('shouldChargePatientInsteadOfOrganization')
        if item
          return JSON.parse(item)
        else
          return false          
      observer: 'shouldChargePatientInsteadOfOrganizationChanged'

    # For Getting Responsive Info
    isMobileView:
      type: Boolean
      value: false

    orgSmsBalance:
      type: Number
      value: 0
      notify: true



  observers: [ 
    '_routerHrefChanged(routeData.page)'
  ]

  shouldChargePatientInsteadOfOrganizationChanged: ->
    item = window.localStorage.getItem('shouldChargePatientInsteadOfOrganization')
    if item
      item = JSON.parse(item)
      if item
        @set 'changeWalletUserTypeIcon', 'icons:account-balance-wallet'
      else
        @set 'changeWalletUserTypeIcon', 'icons:account-balance'

    if (item isnt this.shouldChargePatientInsteadOfOrganization)
      window.localStorage.setItem('shouldChargePatientInsteadOfOrganization', JSON.stringify(this.shouldChargePatientInsteadOfOrganization))


  onChargePatientTapped: ()->
    @set 'shouldChargePatientInsteadOfOrganization', true
    @set 'changeWalletUserTypeIcon', 'icons:account-balance-wallet'
    

  onChargeOrganizationTapped: ()->
    @set 'shouldChargePatientInsteadOfOrganization', false
    @set 'changeWalletUserTypeIcon', 'icons:account-balance'

  notifyApiAction: (action, moreData...)->
    if action is 'start'
      @apiActions.count += 1
      @notifyPath 'apiActions.count'
      [ path ] = moreData
      obj = 
        id: @apiActions.seed++
        path: moreData[path]
        time: lib.datetime.now()
        action: 'start'
      @apiActions.list.push obj
      return obj.id
    else if action is 'done'
      @apiActions.count -= 1 unless @apiActions.count is 0
      @notifyPath 'apiActions.count'
      [ path, refId ] = moreData
      obj = 
        id: @apiActions.seed++
        path: path
        refId: refId
        action: 'done'
      @apiActions.list.push obj
      return obj.id
    else if action is 'error'
      @apiActions.count -= 1 unless @apiActions.count is 0
      @notifyPath 'apiActions.count'
      [ path, refId ] = moreData
      obj = 
        id: @apiActions.seed++
        path: path
        refId: refId
        action: 'error'
      @apiActions.list.push obj
      return obj.id

  notifyDownloadAction: (action, moreData...)->
    if action is 'start'
      @downloadActions.count += 1
      @notifyPath 'downloadActions.count'
      [ path ] = moreData
      obj = 
        id: @downloadActions.seed++
        path: moreData[path]
        time: lib.datetime.now()
        action: 'start'
      @downloadActions.list.push obj
      return obj.id
    else if action is 'done'
      @downloadActions.count -= 1 unless @downloadActions.count is 0
      @notifyPath 'downloadActions.count'
      [ path, refId ] = moreData
      obj = 
        id: @downloadActions.seed++
        path: path
        refId: refId
        action: 'done'
      @downloadActions.list.push obj
      return obj.id
    else if action is 'error'
      @downloadActions.count -= 1 unless @downloadActions.count is 0
      @notifyPath 'downloadActions.count'
      [ path, refId ] = moreData
      obj = 
        id: @downloadActions.seed++
        path: path
        refId: refId
        action: 'error'
      @downloadActions.list.push obj
      return obj.id

  notifySyncAction: (action, moreData...)->
    if action is 'start'
      @syncActions.count += 1
      @notifyPath 'syncActions.count'
      [ path ] = moreData
      obj =
        id: @syncActions.seed++
        path: moreData[path]
        time: lib.datetime.now()
        action: 'start'
      @syncActions.list.push obj
      return obj.id
    else if action is 'done'
      @syncActions.count -= 1 unless @syncActions.count is 0
      @notifyPath 'syncActions.count'
      [ path, refId ] = moreData
      obj =
        id: @syncActions.seed++
        path: path
        refId: refId
        action: 'done'
      @syncActions.list.push obj
      return obj.id
    else if action is 'error'
      @apiActions.count -= 1 unless @apiActions.count is 0
      @notifyPath 'apiActions.count'
      [ path, refId ] = moreData
      obj =
        id: @apiActions.seed++
        path: path
        refId: refId
        action: 'error'
      @apiActions.list.push obj
      return obj.id

  _routerHrefChanged: (href) ->
    # @debug '_routerHrefChanged', href
    href = '/' unless href
    wasPageFound = false
    possiblePage = null

    for page in app.pages.pageList
      if href in page.hrefList
        possiblePage = page
        wasPageFound = true
        break

    if wasPageFound
      if possiblePage.requireAuthentication
        if @isUserLoggedIn()
          if @_checkUserAccess possiblePage.accessId
            @page = possiblePage
          else
            @page = app.pages.error404

        else
          if @skipWelcomePage()
            @navigateToPage '#/login'
          else
            @navigateToPage '#/welcome'
      else
        @page = possiblePage
    else
      @page = app.pages.error404

  _preloadOtherPages: ->
    # @debug '_preloadOtherPages'
    fullPageList = [].concat app.pages.pageList, [ app.pages.error404 ]

    for page in fullPageList
      do (page)=>
        unless page.name is @page.name
          pagePath = @resolveUrl ('../' + page.element + '/' + page.element + '.html')
          id = @notifyDownloadAction 'start', pagePath
          successCbfn = lib.network.ensureBaseNetworkDelay => @notifyDownloadAction 'done', pagePath, id
          failureCbfn = lib.network.ensureBaseNetworkDelay => @notifyDownloadAction 'error', pagePath, id
          @importHref pagePath, successCbfn, failureCbfn, true

  _mainViewPageChanged: (page) ->
    ## load page import on demand.
    pagePath = @resolveUrl ('../' + page.element + '/' + page.element + '.html')
    @importHref pagePath, null, null, false

    @_hideAd page.name

  _fillIronPagesFromPageList: ->
    ironPages = Polymer.dom(@root).querySelector 'iron-pages'

    fullPageList = [].concat app.pages.pageList, app.pages.error404

    for page in fullPageList
      pageElement = document.createElement page.element
      pageElement.setAttribute 'name', page.name

      Polymer.dom(ironPages).appendChild pageElement

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

  

  created: ->
    @removeUserUnlessSessionIsPersistent()
    @loadStaticData()


  ready: ->
    # @showModalDialog 'Our service was down for technical issues at Google Server, We are sorry for the earlier inconvience, Thank you for your patience'
    @_fillIronPagesFromPageList()
    if localStorage.getItem("selectedVisitSerial") is null
      localStorage.setItem("selectedVisitSerial", 'new')
    else
      @selectedVisitSerial = localStorage.getItem("selectedVisitSerial")
    patientsDetails = localStorage.getItem("currentPatientsDetails")
    @currentPatientsDetails = JSON.parse(patientsDetails)

    @user = (try (app.db.find 'user')[0] catch ex then null) or null

    if @isUserLoggedIn()
      @_callAfterUserLogsIn()
    
    @_getUserAppSettings()

    # error tracking js meta
    if app.mode is 'production'
      bugsnagClient.app.version = app.config.clientVersion
      if @currentOrganization
        bugsnagClient.metaData = {
          organization: {
            name: @currentOrganization.name
            id: @currentOrganization.idOnServer
            isCurrentUserAnAdmin: @currentOrganization.isCurrentUserAnAdmin
          }
        }
      if @user
        bugsnagClient.user = {
          id: @user.idOnServer
          serial: @user.serial
          name: @user.name
          email: @user.email or @user.phone
        }
    # error tracking js meta end
        

  getYear: ->
    return (new Date).getFullYear()

  _callAfterUserLogsIn: (cbfn)->
    @user = @getCurrentUser()

    @inAppNotificationSystemInitiate()
    @updateNotificationView()
    @initiateAdvertisement()
    currentOrganization = @getCurrentOrganization()
    
    if currentOrganization
      @set 'currentOrganization', currentOrganization
      @loadOrganizationSmsBalance currentOrganization.idOnServer
      @loadOrganizationRemainingFreePatientCount currentOrganization.idOnServer
    else
      @set 'currentOrganization', null

    # error tracking js meta
    if app.mode is 'production'
      bugsnagClient.user = {
        id: @user.idOnServer
        serial: @user.serial
        name: @user.name
        email: @user.email or @user.phone
      }




    


  _showSyncButton: (syncActionsCount, downloadActionsCount)->
    if downloadActionsCount
      return false
    else if syncActionsCount
      return false
    else
      return true

  _hideAd: (pageName)->
    if @isMobileView
      hideOnPage = ['login', 'patient-manager']
    else
      hideOnPage = ['login']

    if pageName in hideOnPage
      @set 'hideAd', true
      @toggleClass 'show-ad', false, @.$.mainHeader
    else
      @set 'hideAd', false
      @toggleClass 'show-ad', true, @.$.mainHeader

  setCurrentPatientsDetails:(data)->
    @currentPatientsDetails = data
    localStorage.setItem("currentPatientsDetails", JSON.stringify @currentPatientsDetails)

  setSelectedVisitSerial: (serial)->
    @set 'selectedVisitSerial', serial
    localStorage.setItem("selectedVisitSerial", serial)

  _compareFn: (left, op, right)->
    if (op=='<')
      return left < right
    if (op=='>')
      return left > right
    if (op=='==')
      return left == right
    if (op=='>=')
      return left >= right
    if (op=='<=')
      return left <= right


  refreshButtonPressed: (e)->
    @reloadPage()

  logoutPressed: (e)->
    user = (app.db.find 'user')[0]
    # if navigator.onLine
    #   @callApi '/bdemr-app-logout', {apiKey: user.apiKey}, (err, response)=> {}
    user.apiKey = ""
    app.db.update 'user', user._id, user
    @$$('app-drawer').toggle()
    @navigateToPage '#/login'
    @reloadPage()
    

  # === NOTE - Common Dialog Boxes ===

  showModalDialog: (content)->
    if typeof(content) is 'string'
      @genericModalDialogContents = content
      @genericModalDialogContentArray = []
    else
      @genericModalDialogContents = ''
      @genericModalDialogContentArray = content
    @$$('#generic-modal-dialog').toggle()
    @$$('#generic-modal-dialog').center()
    # lib.util.delay 100, =>
    #   console.log(Polymer.dom(@$$('#gen-mod-content')).node.innerHtml)
    #   # @$$('#gen-mod-content').innerHtml = "<span>#{content}</span>"

  showModalPrompt: (content, doneCallback)->
    @$$('#generic-modal-prompt').toggle()
    @genericModalPromptContents = content
    @genericModalPromptDoneCallback = doneCallback

  showModalInput: (content, defaultString, doneCallback)->
    @genericModalInputContents = content
    @genericModalInputFieldValue = defaultString
    @$$('#generic-modal-input').toggle()
    @genericModalInputDoneCallback = doneCallback

  toggleModalLoader: (message=null)->
    @set 'loaderMessage', message
    @$$("#generic-loader-dialog").toggle()

  genericModalInputClosed: (e)->
    if e.detail.confirmed
      @genericModalInputDoneCallback @genericModalInputFieldValue
    else
      @genericModalInputDoneCallback false
    @genericModalInputDoneCallback = null

  genericModalPromptClosed: (e)->
    if e.detail.confirmed
      @genericModalPromptDoneCallback true
    else
      @genericModalPromptDoneCallback false
    @genericModalPromptDoneCallback = null

  showToast: (content)->
    @genericToastContents = content
    @$$('#toast1').open()

  showLongDurationToast: (content)->
    @longDurationToastContents = content
    @$$('#longDurationToast').open()


  genericToastTapped: (e)->
    @$$('#toast1').close()

  longDurationToastTapped: (e)->
    @$$('#longDurationToast').close()

  # === NOTE - These events are manually delegated to pages ===

  saveButtonPressed: (e)->
    @$$('iron-pages').selectedItem.saveButtonPressed e

  printButtonPressed: (e)->
    @$$('iron-pages').selectedItem.printButtonPressed e

  arrowBackButtonPressed: (e)->
    @$$('iron-pages').selectedItem.arrowBackButtonPressed e

  # === NOTE - navigation code ===

  getPageParams: ->
    hash = window.location.hash
    hash = hash.replace '#/', ''
    partArray = hash.split '/'
    partArray.shift()
    params = {}
    for part in partArray
      if part.indexOf(':') is -1
        @showModalDialog 'Malformatted Url Given'
        break
      [ left, right ] = part.split ':'
      params[left] = right
    return params

  navigateToPage: (path)->
    @user = (try (app.db.find 'user')[0] catch ex then null) or null
    # window.location = path
    window.history.pushState({}, null, path)
    window.dispatchEvent(new CustomEvent('location-changed'))

  navigateToPreviousPage: ->
    window.history.back()

  modifyCurrentPagePath: (newPath)->
    window.history.replaceState {}, newPath, newPath

  reloadPage: ->
    window.location.reload()


  # === NOTE - The code below generates the pseudo-lifetime-callback 'navigatedIn' ===

  ironPagesSelectedEvent: (e)->
    return unless Polymer.dom(e).rootTarget.id is 'rootPageSwitcher'
    nodeName = e.detail.item.nodeName
    for readyPageNodeName in @readyPageNodeNameList
      if readyPageNodeName is nodeName
        if e.detail.item.navigatedIn
          @pageElement = e.detail.item
          e.detail.item.navigatedIn() 
        return
    @currentNavigationCandidate = nodeName

  pageReady: (pageElement)->
    # console.log 'pageElement', pageElement
    @readyPageNodeNameList.push pageElement.nodeName
    if @currentNavigationCandidate is pageElement.nodeName
      @currentNavigationCandidate = ''

      if pageElement.navigatedIn
        pageElement.navigatedIn()
        @pageElement = pageElement

  ironPagesDeselectedEvent: (e)->
    return unless Polymer.dom(e).rootTarget.id is 'rootPageSwitcher'
    nodeName = e.detail.item.nodeName
    # console.log 'page', e.detail
    for readyPageNodeName in @readyPageNodeNameList
      if readyPageNodeName is nodeName
        e.detail.item.navigatedOut() if e.detail.item.navigatedOut
        return

  changeOrganizationClicked: ->
    @navigateToPage "#/select-organization"


  loadOrganizationRemainingFreePatientCount: (organizationId)->
    # console.log 'organizationId', organizationId
    data = {
      apiKey: @user.apiKey
      organizationId: organizationId
    }
    @callApi '/internal--organization-foc--get-limit', data, (err, response)=>
      # console.log 'ORG SMS BALNCE:', response
      if response.hasError
        @set 'remainingOrganizationFocCount', 0
      else
        @set 'remainingOrganizationFocCount', response.data.remainingOrganizationFocCount

  # Load Organization SMS Balance ======================================

  loadOrganizationSmsBalance: (organizationId)->
    # console.log 'organizationId', organizationId
    data = {
      apiKey: @user.apiKey
      organizationId: organizationId
    }
    @callApi '/bdemr-get-organization-sms-balance', data, (err, response)=>
      # console.log 'ORG SMS BALNCE:', response
      if response.hasError
        if response.error.message is "No data found"
          @set 'orgSmsBalance', 0
      else
        @set 'orgSmsBalance', response.data.smsBalance

  # Notification Area ======================================
  
  _formatDateTime: (dateTime)->
    return unless dateTime
    lib.datetime.format dateTime, 'mmm d, yyyy h:MMTT'

  inAppNotificationSystemInitiate: ->
    webSocketHost = app.config.variableConfigs[app.mode].serverWsHost
    @ws = new WebSocket webSocketHost, [
      'soap'
      'xmpp'
    ]
    @ws.addEventListener 'open', (e)=>
      @inAppNotificationRegister()
      @ws.addEventListener 'message', ((e)=> @inAppNotificationMessageHandler e), false, false

  inAppNotificationMessageHandler: (e)->
    json = JSON.parse e.data
    if json.operation is 'register' and json.status is 'successful'
      @inAppNotificationMyId = json.userId
    else if json.operation is 'incoming-notification'
      # console.log 'incoming'
      json.markedAsRead = false
      # console.log json
      app.db.insert 'in-app-notification', json
      @updateNotificationView()
      @showNotification json


  inAppNotificationRegister: ->
    apiKey = @getCurrentUser().apiKey
    request = {
      operation: 'register'
      apiKey
    }
    @ws.send JSON.stringify request

  showNotification: (json)->
    switch json.category
      when 'patientNote' then title = 'New Patient Note'
      when 'report' then title = 'Report'
      when 'onlineConsultation' then title = 'New Consulation Request'
      when 'general' then title = 'General'
      else title = 'New Notification'

    notificationConfig = {
      body: json.message
      icon: '../../images/web-app-icon/app-icon-72.png'
      timestamp: json.createdDateTimeStamp
      sound: '../../assets/notification.mp3'
    }

    if !('Notification' of window)
      alert message
    else if Notification.permission == 'granted'
      notification = new Notification title, notificationConfig
      try
        audio = new Audio '../../assets/notification.mp3'
        audio.play()
      catch ex
        "Pass"
    else if Notification.permission != 'denied'
      Notification.requestPermission (permission) ->
        if permission == 'granted'
          notification = new Notification title, notificationConfig
          audio = new Audio '../../assets/notification.mp3'
          audio.play()
  
  updateNotificationView: ->
    @reportNotification = app.db.find 'in-app-notification', ({category})=> return true if category is 'report'
    @patientNoteNotification = app.db.find 'in-app-notification', ({category})=> return true if category is 'patientNote'
    @onlineConsultationNotification = app.db.find 'in-app-notification', ({category})=> return true if category is 'onlineConsultation'
    @generalNotification = app.db.find 'in-app-notification', ({category})=> return true if category is 'general'

    # console.log app.db.find 'in-app-notification'
  
  markAllDonePressed: ->
    @reportNotification = []
    @patientNoteNotification = []
    @onlineConsultationNotification = []
    @generalNotification = []
  
  markAsRead: (e)->
    app.db.remove 'in-app-notification', e.model.item._id
    if e.model.item.category is 'report'
      @splice 'reportNotification', e.model.index, 1
    else if e.model.item.category is 'patientNote'
      @splice 'patientNoteNotification', e.model.index, 1
    else if e.model.item.category is 'onlineConsultation'
      @splice 'onlineConsultationNotification', e.model.index, 1
    else if e.model.item.category is 'general'
      @splice 'generalNotification', e.model.index, 1
    else
      # console.log e.model.index


  notificationToggleButtonPressed: (e)->
    @.$.notificationDrawer.toggle()

  toggleReportNotification: ()->
    @.$.reportNotification.toggle()
  togglePatientNoteNotification: ()->
    @.$.patientNoteNotification.toggle()
  toggleOnlineConsultationNotification: ()->
    @.$.onlineConsultationNotification.toggle()
  toggleGeneralNotification: ()->
    @.$.generalNotification.toggle()

  # Notification Area End ======================================
  
  
  # = REGION ====================================== Advertisement - Start

  _callGetAdvertisementApi: (cbfn)->
    { apiKey } = (app.db.find 'user')[0]
    @callApi '/get-advertisement-list', {apiKey}, { automaticallyHandleNetworkErrors: false }, (err, response)=>
      if err
        console.log 'Network error suppressed willingly since showing an advert is not crucial.'
      else if response.hasError
        @showModalDialog response.error.message
      else
        adList = response.data.advertisementLongList
        cbfn adList

  switchAdvertisement: ->
    if @adList.length is 0
      @set 'currentAd', null
    else
      if @currentAd and ('audio' of @currentAd)
        player = @$$('#audioPlayer')
        unless player.paused
          lib.util.delay 10000, (=> @switchAdvertisement())
          return

      if @adListSelectedIndex is null
        @adListSelectedIndex = 0
      else
        @adListSelectedIndex += 1
        if @adListSelectedIndex is @adList.length
          @adListSelectedIndex = 0
      @currentAd = @adList[@adListSelectedIndex]
      lib.util.delay 10000, (=> @switchAdvertisement())

  initiateAdvertisement: ->
    list = (app.db.find 'user')
    return if list.length is 0
    @_callGetAdvertisementApi (adList)=>
      @adList = adList
      @adListSelectedIndex = null
      @switchAdvertisement()



  # = REGION ====================================== Advertisement - End

  addActivityLog: (subject, action, data)->
    object = {
      serial: @generateSerialForActivity()
      doctorSerial: @getCurrentUserSerial()
      patientSerial: data.patientSerial or null
      doctorName: @getCurrentUser().name
      subject
      action
      data
      lastModifiedDatetimeStamp: (new Date).getTime()
    }

    app.db.insert 'activity', object

  languageSelectedIndexChanged: ->
    value = @supportedLanguageList[@languageSelectedIndex]
    @setActiveLanguage value
  
  _showLanguageName: (languageSelectedIndex)->
    if languageSelectedIndex is 0
      return 'EN'
    else
      return 'বাংলা'

  patientPageSelectedIndexChanged: (selectedPageIndex, oldIndex)->
    return unless @currentPatientsDetails

    @debounce 'selectPage', ()=>
      if selectedPageIndex is 0
        @async =>
          @selectedVisitSerial = localStorage.getItem("selectedVisitSerial")
          @navigateToPage '#/visit-editor/visit:' + @selectedVisitSerial + '/patient:' + @currentPatientsDetails.serial
      else
        @async =>
          @navigateToPage '#/patient-viewer/patient:' + @currentPatientsDetails.serial + '/selected:' + selectedPageIndex
          if oldIndex is 0
            # @pageElement.navigatedIn()
          else
            @pageElement.subViewNavigatedIn()

    ,10

  _changeToolbarClass: (showToolbar) ->
    if showToolbar is true
      return 'medium-tall'
    else return ''

  _checkUserAccess: (accessId)->
    currentOrganization = @getCurrentOrganization()

    if accessId is 'none'
      return true
    else
      if currentOrganization

        if currentOrganization.isCurrentUserAnAdmin
          return true
        else if currentOrganization.isCurrentUserAMember
          if currentOrganization.userActiveRole
            privilegeList = currentOrganization.userActiveRole.privilegeList
            unless privilegeList.length is 0
              for privilege in privilegeList
                if privilege.serial is accessId
                  return true
          else
            return true

          return false
        else
          return false

      else
        # @navigateToPage "#/select-organization"
        return true

  # = REGION offline patient 
  _createOnlinePatient: (patient, cbfn) ->
    patient.apiKey = @user.apiKey
    @callApi '/bdemr-app-patient-signup-partial', patient, (err, response)=>
      # console.log response
      if response.hasError
        if response.error.message is "Phone number already exists."
          # @showModalInput "Phone number already exists. Please Enter Another Phone Number instead of #{patient.phone}", patient.phone, (answer)=>
          #   if answer
          #     patient.phone = answer
          #     @_createOnlinePatient patient, cbfn
          patient.userAlreadyExist = true
          # console.log 'patientserial', patient.serial
          @getExisitingPatientInfo patient.name, patient.serial, patient.phone, =>
            return cbfn patient

        else
          @showModalDialog response.error.message
      else
        patientSerial = response.data.patientSerial
        patient.serial = patientSerial
        patient.userAlreadyExist = false
        return cbfn patient

  getExisitingPatientInfo: (patientOldName, oldSerial, phoneNumber, cbfn)->
    data =
      apiKey: @user.apiKey
      phoneNumber: phoneNumber

    @callApi '/bdemr-get-patient-info', data, (err, response)=>
      # console.log response
      if response.hasError
        # console.log response
      else
        patient =
          oldSerial: oldSerial
          patientOldName: patientOldName
          doctorAccessPin: '0000'
          data: null

        patient.data = response.data
        # console.log "PATIENT INFO", patient
        app.db.insert 'conflicted-patient-list', patient
        cbfn()



  _updateLocalPatient: (patient, patientTempSerial)->
    id = (app.db.find 'patient-list', ({serial})-> serial is patientTempSerial)[0]._id
    patient.isTemporaryOfflinePatient = false
    patient.flags = {
      isImported: false
      isLocalOnly: false
      isOnlineOnly: false
    }
    patient.flags.isImported = true
    app.db.remove 'patient-list', id      
    app.db.insert 'patient-list', patient



  _removeLocalPatient: (patientTempSerial)->
    id = (app.db.find 'patient-list', ({serial})-> serial is patientTempSerial)[0]._id
    app.db.remove 'patient-list', id
    # console.log 'deleted already exist patient data'


  _convertOfflinePatientToOnline: (patient, cbfn)->
    oldSerial = patient.serial
    @_createOnlinePatient patient, (patient)=>
      if !patient.userAlreadyExist
        @updatePatientSerialOnExisitingRecords patient.serial, oldSerial, =>
          @_updateLocalPatient patient, oldSerial
          cbfn()
      else
        cbfn()

      return


  checkAndupdateSerialOnCollection: (newSerial, oldSerial, collectionName)->
    list = app.db.find collectionName, ({patientSerial})-> patientSerial is oldSerial

    if list.length > 0
      for item in list
        item.patientSerial = newSerial
        app.db.update collectionName, item._id, item


  updatePatientSerialOnExisitingRecords: (patientActualSerial, patientOldSerial, cbfn)->
    collectionMap = ['unregsitered-patient-details', 'anaesmon-record', 'progress-note-record', 'visited-patient-log', 'history-and-physical-record', 'diagnosis-record', 'doctor-visit', 'doctor-visit', 'visit-note', 'visit-patient-stay', 'visit-next-visit', 'custom-investigation-list', 'visit-advised-test', 'patient-test-results', 'patient-medications', 'patient-vitals-blood-pressure', 'patient-vitals-pulse-rate', 'patient-vitals-respiratory-rate', 'patient-vitals-spo2', 'patient-vitals-temperature', 'patient-vitals-bmi', 'patient-test-blood-sugar', 'patient-test-other', 'comment-patient', 'comment-doctor', 'patient-gallery--local-attachment', 'patient-gallery--online-attachment', 'patient-test-results', 'in-app-notification', 'local-patient-pin-code-list', 'activity', 'visit-invoice', 'visit-diagnosis', 'visit-identified-symptoms', 'visit-examination', 'offline-patient-pin', 'in-patient-medicine-dispense-log', 'pcc-records', 'ndr-records', 'patient-insulin-list']

    for collectionName in collectionMap
      @checkAndupdateSerialOnCollection patientActualSerial, patientOldSerial, collectionName

    cbfn()

  _syncTemporaryOfflinePatients:(cbfn)->
    userList = app.db.find 'patient-list', (patient)=> patient.isTemporaryOfflinePatient is true
    return cbfn() if userList.length is 0
    it1 = new lib.util.Iterator userList
    it1.forEach (next, index, patient)=>
      @_convertOfflinePatientToOnline patient, ()=>
        next()
    it1.finally =>
      return cbfn()
 
  
  # = REGION ======================================

  _syncOnlyPatientTestResults: (cbfn)->
    @_newSync cbfn

  _syncOnlyPatientGallery: (cbfn)->
    @_newSync cbfn

  _syncUserSettings: (cbfn)->
    @_newSync cbfn

  _syncOnlyInvoice: (cbfn)->
    @_newSync cbfn
  

  syncButtonPressed: ()->
    @$$('#sync-dialog').toggle()
    @_syncTemporaryOfflinePatients =>
      @_newSync (errMessage)=>
        if errMessage
          # @$$('#sync-dialog').toggle()
          @async => @showModalDialog(errMessage);
        else
          # @$$('#sync-dialog').toggle()
          @reloadPage()
      

  remoteSyncPressed: (e)->
    if (!window.isOnsite)
      @showModalDialog("Sorry! Onsite to Remote Sync is available for onsite deployments only.")
      return
    if (!window.isOnsiteSyncEnabled)
      @showModalDialog("Sorry! You are not subscribed to our onsite remote sync. Please contact our customer care to learn more.")
      return
      
    @callApi '/bdemr--onsite-sync--init', {}, (err, response)=>
      if response.hasError
        @showModalDialog("Please make sure you are connected to the internet and try again.")
        console.log("Response: ", response)
      else
        @showModalDialog("Thank you. Everything is uploaded to remote server for safekeeping.")
  
  _getUserAppSettings: ()->
    @callApi '/bdemr-get-app-settings', { apiKey: @user.apiKey }, (err, response)=>
      if response.hasError
        @showModalDialog("Please make sure you are connected to the internet and try again.")
      else
        settings = response.data
        app.db.upsert 'settings', settings, ({createdByUserId})=> createdByUserId is @user.idOnServer
}
