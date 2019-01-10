
Polymer {

  is: 'page-dashboard'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.dbUsing
    app.behaviors.apiCalling
  ]

  properties:
    languageSelectedIndex: 
      type: Number
      value: app.lang.defaultLanguageIndex
      notify: true
      observer: 'languageSelectedIndexChanged'

    daysLeft:
      type: Number
      value: 0

    authorizeToSelectedIndex:
      type: Number
      value: 0

    organizationsIBelongToList:
      type: Array
      value: -> []

    settings:
      type: Array
      value: null
      notify: true

    managePatientLinkList:
      type: Array
      value: -> [
        {
          title: 'New Patient'
          subTitle: 'Create'
          info: ''
          imagePath: 'images/icons/add_user.png'
          urlPath: '#/patient-signup'
          accessId: ''
        }
        {
          title: 'FOLLOW UP'
          subTitle: 'Patient'
          info: ''
          imagePath: 'images/icons/ico_history_and_physical.png'
          urlPath: '#/patient-manager/selected:0'
          accessId: ''
        }

        # {
        #   title: 'Create '
        #   subTitle: 'New Patient'
        #   info: ''
        #   imagePath: 'assets/img/partners/badas.jpg'
        #   urlPath: '#/patient-signup'
        #   accessId: ''
        # }
        
        # {
        #   title: 'Patients Log'
        #   subTitle: 'patient history from'
        #   info: ''
        #   imagePath: 'images/icons/ico_history_and_physical.png'
        #   urlPath: '#/patient-manager/selected:1'
        #   accessId: ''
        # }
      ]

    sortcutList:
      type: Array
      value: -> [
        {
          title: 'Create New Patient'
          info: ''
          icon: 'icons:open-in-new'
          urlPath: '#/patient-signup'
          accessId: ''
        }
        {
          title: 'Patient Manager'
          info: ''
          icon: 'icons:open-in-new'
          urlPath: '#/patient-manager'
          accessId: ''
        }
        {
          title: 'Report Manager'
          info: ''
          icon: 'icons:open-in-new'
          urlPath: '#/reports-manager'
          accessId: ''
        }
        {
          title: 'Chamber Manager'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/chamber-manager'
          accessId: ''
        }
        {
          title: 'Medicine Dispension'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/medicine-dispension'
          accessId: ''
        }
        {
          title: 'Assistant Manager'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/assistant-manager'
          accessId: ''
        }
        {
          title: 'Search Records'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/search-record'
          accessId: ''
        }
        {
          title: 'Invoice Manager'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/invoice-manager'
          accessId: ''
        }
        {
          title: 'Booking and Searvices'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/booking'
          accessId: ''
        }
        {
          title: 'Organization Manager'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/organization-manager'
          accessId: ''
        }
        {
          title: 'Send Notification'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/notification-panel'
          accessId: ''
        }
        {
          title: 'My Wallet'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/wallet'
          accessId: ''
        }
        {
          title: 'Send Feedback'
          icon: 'icons:open-in-new'
          info: ''
          urlPath: '#/send-feedback'
          accessId: ''
        }
        {
          title: 'Settings'
          icon: 'settings'
          info: ''
          urlPath: '#/settings'
          accessId: ''
        }
      ]


  goToUrlForManagePatientList: (e)->
    index = e.model.index
    item = @managePatientLinkList[index]
    window.location = item.urlPath

  goToUrlForShortcutNav: (e)->
    index = e.model.index
    item = @sortcutList[index]
    window.location = item.urlPath


  ready: -> @version = app.config.clientVersion


  authorizeToSelected: (e)->
    return if @authorizeToSelectedIndex is null
    org = @organizationsIBelongToList[@authorizeToSelectedIndex]
    @authorizedOrganiztionId = org.idOnServer
    localStorage.setItem("authorizedOrganiztionId", @authorizedOrganiztionId)

   
  _organizationNavigatedIn: () ->
    if localStorage.getItem("authorizedOrganiztionId")
      @authorizedOrganiztionId = localStorage.getItem("authorizedOrganiztionId")
    else
      @authorizedOrganiztionId = @currentOrganization.idOnServer
      localStorage.setItem("authorizedOrganiztionId", @authorizedOrganiztionId)

    data = { 
      apiKey: @user.apiKey
    }

    @callApi '/bdemr-organization-list-those-user-belongs-to', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @organizationsIBelongToList = response.data.organizationObjectList

        # for item, index in @organizationsIBelongToList
        #   if item.idOnServer is @authorizedOrganiztionId
        #     @set 'authorizeToSelectedIndex', index

        @crossMatchWithSelectedAndAvailableOrganization =>
          


  isOrganizationFoundOnAuthorizedOrganiztionList: (org)->
    list = @settings.authorizedOrganiztionList
    for item in list
      if item.idOnServer is org.idOnServer
        return true
    return false
  
  _saveSettings: (cbfn) ->
    if @settings
      @settings.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'settings', @settings, ({serial})=> serial is @settings.serial
      cbfn()
    
  crossMatchWithSelectedAndAvailableOrganization: (cbfn)->
    authorizedOrganiztionList = []

    if @settings
      if @settings.authorizedOrganiztionList is 'undefined'
        @settings.authorizedOrganiztionList = []
      
      authorizedOrgIdList = @settings.authorizedOrganiztionList.map (item) => item.idOnServer

      @organizationsIBelongToList.forEach (item) =>
        if !(item.idOnServer in authorizedOrgIdList)
          @settings.authorizedOrganiztionList.push {
            idOnServer: item.idOnServer
            isChecked: false
            name: item.name
          }
      
      console.log @settings
    @_saveSettings =>
      cbfn()

  onCheckAuthorizedOrganization: (e)->
    isChecked = e.target.checked
    index = e.model.index
    if isChecked
      @settings.authorizedOrganiztionList[index].isChecked = isChecked
    else
      @settings.authorizedOrganiztionList[index].isChecked = false

    @_saveSettings =>
      @loadSettings =>
        null


  loadSettings: (cbfn)->
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()

    if list.length > 0
      @settings = list[0]
    else
      @settings = null

    cbfn()

  navigatedIn: ->
    
    @currentOrganization = @getCurrentOrganization()
    unless @currentOrganization
      @domHost.navigateToPage "#/select-organization"

    metrics = @getDashboardMetrics()

    @user = (app.db.find 'user')[0]

    @newPatientCount = metrics.newPatientCount
    @totalPatientCount = metrics.totalPatientCount
    @newRecordCount = metrics.newRecordCount
    @totalRecordCount = metrics.totalRecordCount
    @totalUnpaidInvoiceCount = metrics.totalUnpaidInvoiceCount
    @daysLeft = metrics.daysLeft

    if @daysLeft < 0
      @domHost.navigateToPage '#/activate'

    @loadSettings =>
      @_organizationNavigatedIn()


  # callSearchMedicineApi: (searchString)->
  #   data = {
  #     apiKey: @user.apiKey
  #     searchString
  #   }
  #   @callApi '/bdemr-search-medicine', data, (err, response)=>
  #     if response.hasError
  #       console.log response
  #     else
  #       console.log response

  # saveAllMedicineDataToServer: (list, cbfn)->
  #   data = {
  #     medicineList: list
  #     apiKey: @user.apiKey
  #   }

  #   @callApi '/bdemr-temp-save-all-medicine', data, (err, response)=>
  #     # console.log response
  #     if response.hasError
  #       console.log response

  #   cbfn()
    

  # getAllMedicineList: ()->
  #   @domHost.getStaticData 'pccMedicineList', (medicineList)=>
      
  #     console.log medicineList.length

  #     modifiedMedicineList = []

  #     for item, index in medicineList
  #       item.serial = @generateSerialForMed(index)
  #       item.createdDatetimeStamp = lib.datetime.now()
  #       item.createdByUserSerial = null
  #       item.lastModifiedDatetimeStamp = lib.datetime.now()
  #       item.lastSyncedDatetimeStamp = lib.datetime.now()
  #       item.organizationSerial = null
        
  #       modifiedMedicineList.push item

  #     modifiedMedicineList
  #     console.log JSON.stringify modifiedMedicineList


  # generateSerialForMed: (index)->
  #   string = 'm-'
  #   number = index + 1
  #   length = number.length

  #   serial = number.toString()

  #   zeros = (8 - number.length)

  #   zerosString = ''

  #   if zeros.length > 0
  #     for zero in zeros
  #       zerosString += '0'

  #   return string + zerosString + serial + '-s'




  languageSelectedIndexChanged: ->
    value = @supportedLanguageList[@languageSelectedIndex]
    @setActiveLanguage value

  $getString1: (daysLeft, LANG)->
    if LANG is 'en-us'
      return "Your license for Doctor App will <br>expire in #{daysLeft} days."
    else if LANG is 'bn-bd'
      daysLeft = @$TRANSLATE_NUMBER daysLeft, LANG
      return "আপনার Doctor App এর লাইসেন্স বাতিল <br>হতে #{daysLeft} দিন বাকি আছে।"
    else
      return "TRANSLATION_FAILED"

  viewNewPatientsTapped: (e)->
    @domHost.navigateToPage '#/patient-manager/filter:today-only'

  viewNewRecordsTapped: (e)->
    @domHost.navigateToPage '#/record-manager/filter:today-only'

  viewAllRecordsTapped: (e)->
    @domHost.navigateToPage '#/record-manager/filter:clear'

  viewAllPatientsTapped: (e)->
    @domHost.navigateToPage '#/patient-manager/filter:clear'

  viewUnpaidInvoicesTapped: (e)->
    @domHost.navigateToPage '#/invoices/unpaid-only'

  purchaseAnaesMonTapped: (e)->
    window.open 'https://my.bdemr.com/#/apps/anaesmon/purchase'

  renewAnaesMonTapped: (e)->
    @domHost.navigateToPage '#/activate'

}
