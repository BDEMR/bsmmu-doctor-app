Polymer {

  is: 'page-organization-manage-waitlist'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:

    selectedView:
      type: Number
      value: -> 1
    
    shouldShowAdd:
      type: Boolean
      value: -> true

    isBookedForProcedure:
      type: Boolean
      value: -> false

    user:
      type: Object
      notify: true
      value: null

    patient:
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

    waitlistObject:
      type: Object
      value: null

    newItemDetails:
      type: String
      value: ''

    newItemPatientSerial:
      type: String
      value: ''

    newItemPatientNameManuallyEntered:
      type: String
      value: ''

    seatList:
      type: Array
      value: -> []

    genericItemList:
      type: Array
      value: -> []

    level:
      type: Number
      value: -> 0

    currentItemStack:
      type: Array
      value: -> []

    currentItemListStack:
      type: Array
      value: -> []

    currentSeatListStack:
      type: Array
      value: -> []
      

    shouldShowPatients:
      type: Boolean
      value: -> false

    flatWaitListObjectMap:
      type: Array
      value: -> []

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  $getFullName:(data)->
    if typeof data is "object"
      honorifics = ''
      first = ''
      last = ''
      middle = ''

      if data.honorifics  
        honorifics = data.honorifics + ". "
      if data.first
        first = data.first
      if data.middle
        middle = " " + data.middle
      if data.last
        last = " " + data.last
        
      return honorifics + first + middle + last

    else return data   
  
  navigatedIn: ->
    # currentOrganization = @getCurrentOrganization()
    # unless currentOrganization
    #   @domHost.navigateToPage "#/select-organization"
      
    @isLoading = true
    @_loadUser()
    
    params = @domHost.getPageParams()
    if params['organization']
      @_loadOrganization params['organization']
    else
      @_notifyInvalidOrganization()

    if params['patient']
      @_loadPatient params['patient']
      @set 'selectedView', 0
    
  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @set 'patient', list[0]

  navigatedOut: ->
    @organization = null
    @isOrganizationValid = false
    @patient = null
    @isBookedForProcedure = false

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
        
        @_loadWaitlistObject()

  _loadWaitlistObject: ->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
    }
    @callApi '/bdemr-organization-waitlist-get-object', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'waitlistObject', response.data.waitlistObject
        @set 'seatList', @waitlistObject.seatList
        @set 'genericItemList', @waitlistObject.itemList
        @set 'level', 0
        @set 'isOrganizationValid', true
        @_aggregateWaitList @waitlistObject.itemList
        @_populateFlatList @waitlistObject.itemList

        @isLoading = false

  
  # Flattened Waitlist Object to get a flat list of Waitlist and the related UID for easy searching and showing
  _getFlatList: (list)->
    flatList = []
    for item in list
      flatList.push [ item.name, item.uid, item.seatList, item.aggregatedSeatCount, item.aggregatedSeatList ] 
      childFlatList = @_getFlatList(item.subitemList)
      for child in childFlatList
        child.unshift item.name
        flatList.push child
    
    return flatList

  _populateFlatList: (list)->
    flattenedList = @_getFlatList(list)
    flatListMap = []
    for item in flattenedList
      seatList = item[item.length-3]
      uid = item[item.length-4]
      path = (item.slice 0, item.length-4).join(' > ')
      aggregatedSeatList = item[item.length-1]
      aggregatedSeatCount = item[item.length-2]
      flatListMap.push { path: path, uid: uid, seatList: seatList or [], aggregatedSeatList, aggregatedSeatCount}

    @set 'flatWaitListObjectMap', flatListMap
    @waitlistSourceMap = ({text: item.path.split(' > ').reverse().join(' < '), value: item.uid} for item in flatListMap)

  # ========================================================================================

  _aggregateSeatList: (item)->
    item.seatList = [] unless item.seatList
    item.subitemList = [] unless item.subitemList
    aggregatedSeatList = [].concat item.seatList
    for subItem in item.subitemList
      aggregatedSeatList = aggregatedSeatList.concat @_aggregateSeatList subItem
    item.aggregatedSeatList = aggregatedSeatList
    return aggregatedSeatList
  
  _aggregateSeatCount: (item)->
    item.seatList = [] unless item.seatList
    item.subitemList = [] unless item.subitemList
    aggregatedSeatCount = item.seatList.length
    for subItem in item.subitemList
      aggregatedSeatCount += @_aggregateSeatCount subItem
    item.aggregatedSeatCount = aggregatedSeatCount
    return aggregatedSeatCount
      
  _aggregateWaitList: (list)->
    for item in list
      @_aggregateSeatCount item
      @_aggregateSeatList item


  _getWaitlistRef: (e)->
    uid = e.detail.value
    item = (item for item in @flatWaitListObjectMap when item.uid is uid)[0]
    @shouldShowPatients = true
    unless 'seatList' of item
      item.seatList = []
    @set 'seatList', item.seatList

  viewPatientsForThisWaitList: (e)->
    item = e.model.item
    @shouldShowPatients = true
    unless 'aggregatedSeatList' of item
      item.aggregatedSeatList = []
    @set 'seatList', item.aggregatedSeatList
  
  saveTapped: (e)->
    @_saveWaitlist()

  _saveWaitlist: (cbfn)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      waitlistObject: @waitlistObject
    }
    @callApi '/bdemr-organization-waitlist-set-object', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Saved'
        cbfn() if cbfn

  addNewGenericItemEnterKeyPressed: (e)->
    if e.keyCode is 13
      @$$('#genericEntry').validate()
      @addNewGenericItem()
  
  addNewGenericItemTapped: (e)->
    @$$('#genericEntry').validate()
    @addNewGenericItem()

  addNewGenericItem: ->
    return unless @newGenericItemName
    unless 'uidSeed' of @waitlistObject
      @waitlistObject.uidSeed = 0
    genericItem = {
      name: @newGenericItemName
      uid: ( @waitlistObject.uidSeed++ )
      level: (@level + 1)
      subitemList: []
    }
    @push 'genericItemList', genericItem
    @set 'newGenericItemName', ''
    @_populateFlatList @waitlistObject.itemList
    @_saveWaitlist()

  upCurrentItemTapped: (e)->
    @shouldShowPatients = true
    genericItem = @pop 'currentItemStack'
    @set 'level', (@level - 1)
    if @level is 0
      @set 'genericItemList', @waitlistObject.itemList
    else
      genericItemList = @pop 'currentItemListStack'
      @set 'genericItemList', genericItemList
    seatList = @pop 'currentSeatListStack'
    @set 'seatList', seatList

  genericItemViewSubitemsTapped: (e)->
    @shouldShowPatients = true
    { genericItem } = e.model
    @push 'currentItemListStack', @genericItemList
    @push 'currentSeatListStack', @seatList
    @set 'genericItemList', genericItem.subitemList
    @set 'level', (@level + 1)
    @push 'currentItemStack', genericItem
    unless 'seatList' of genericItem
      genericItem.seatList = []
    @set 'seatList', genericItem.seatList
    
  showPatientsTapped: (e)->
    @shouldShowPatients = true

  moveToThisWaitlistAutocompleteSelected: (e)->
    uid = e.detail.value
    item = (waitListObj for waitListObj in @flatWaitListObjectMap when waitListObj.uid is uid)[0]
    e.target.text = ""
    @_movePatientToWaitList item
  
  movePatientToThisWaitListButtonClicked: (e)->
    item = e.model.item
    @_movePatientToWaitList item
  
  _movePatientToWaitList: (item)->  
    unless 'seatList' of item
      item.seatList = []
    @set 'seatList', item.seatList
    
    for item in @seatList
      if item.patientSerial is @patient.serial
        @domHost.showToast 'Patient Already added to this Waitlist'
        return
    
    unless 'seedUidSeed' of @waitlistObject
      @waitlistObject.seedUidSeed = 0

    seat = {
      uid: (@waitlistObject.seedUidSeed++)
      seatDetail: item.path
      patientSerial: @patient.serial
      patientNameCopy: @$getFullName(@patient.name)
      patientEmailCopy: @patient.email
      patientPhoneCopy: @patient.phone
      isBookedForProcedure: false
      procedureDate: 0
      procedureTime: ''
    }

    @push 'seatList', seat
    @shouldShowPatients = true
    @patient = null
    
    @set 'selectedView', 1

    notification = {
      "phone": seat.patientPhoneCopy,
      "email": seat.patientEmailCopy,
      "category": "waitlist",
      "message": "Added to #{@organization.name} > #{seat.seatDetail}. Serial Token: #{seat.uid}"
    }
    data = notification
    data.apiKey = @user.apiKey

    @_saveWaitlist ()=>
      @domHost.showToast "Patient Moved"
      @_sendNotification data

  _sendNotification: (data)->  
    @callApi '/extern-scheduler-add-notification', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog "Notification Error: " +response.error.message
      else
        @domHost.showToast 'Notification Sent'

  genericItemDeleteTapped: (e)->
    { index } = e.model
    @splice 'genericItemList', index, 1
    @domHost.showToast 'Save Waitlist for changes to take affect'

  seatDeleteTapped: (e)->
    { index } = e.model
    @splice 'seatList', index, 1
    @_saveWaitlist()

  seatMoveTapped: (e)->
    { seat, index } = e.model
    @splice 'seatList', index, 1
    @_loadPatient seat.patientSerial
    @selectedView = 0

  seatBookForProcedureTapped: (e)->
    { seat, index } = e.model
    @isBookedForProcedure = true
    @_makeNewVisit seat.patientSerial
    @_makeNewNextVisit seat.patientSerial

  bookProecedureConfirmedClick: (e)->
    {seat} = e.model
    return unless seat.procedureDate and seat.procedureTime
    @nextVisit.doctorName = (@organization.name+' > '+seat.seatDetail.split(" <").reverse().join(" >"))
    dateTime = new Date(seat.procedureDate+' '+seat.procedureTime)
    # issue dateTime returns local, we need UTC, couldn't solve the problem
    @nextVisit.data.nextVisitDateTimestamp = dateTime.getTime()
    @_addNextVisitPressed()
    e.model.set "seat.isConfirmedForProcedure", true
    e.model.set "seat.confirmedForProcedureDatetimeStamp", (dateTime.getTime())
    @isBookedForProcedure = false
    @_saveWaitlist()

    procedure = seat.seatDetail.split('<')[0].trim()
    notification = {
      "phone": seat.patientPhoneCopy,
      "email": seat.patientEmailCopy,
      "category": "waitlist",
      "message": "#{procedure} is booked  at #{@organization.name} on #{lib.datetime.mkDatetime dateTime, 'mmm d, yyyy h:MMTT'}"
      apiKey: @user.apiKey
    }
    @_sendNotification notification

  _makeNewVisit: (patientSerial)->
    @visit =
      serial: @generateSerialForVisit()
      idOnServer: null
      source: 'local'
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      doctorsPrivateNote: ''
      patientSerial: patientSerial
      recordType: 'doctor-visit'
      doctorName: @user.name
      hospitalName: null
      doctorSpeciality: null
      prescriptionSerial: null
      doctorNotesSerial: null
      nextVisitSerial: null
      advisedTestSerial: null
      patientStaySerial: null
      invoiceSerial: null
      historyAndPhysicalRecordSerial: null
      diagnosisSerial: null
      identifiedSymptomsSerial: null
      recordTitle: null
      vitalSerial: {
        bp: null
        hr: null
        bmi: null
        rr: null
        spo2: null
        temp: null
      }
      testResults: {
        serial: null
        name: null
        attachmentSerialList: []
      }
  
  _makeNewNextVisit: (patientSerial)->
    @nextVisit =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: @visit.serial
      patientSerial: patientSerial
      doctorName: ""
      doctorSpeciality: ""
      data:
        nextVisitDateTimestamp: 0
        priorityType: ''

  _addNextVisitPressed: ()->
    @nextVisit.serial = @generateSerialForNextVisit()
    @nextVisit.createdDatetimeStamp = lib.datetime.now()
    @_updateVisitForNextVisit @nextVisit.serial
    @_saveNextVisit @nextVisit
    @domHost.showToast 'Next Visit Added.'
    console.log @nextVisit
  
  _saveNextVisit: (data)->
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'visit-next-visit', data, ({serial})=> data.serial is serial
    

  _updateVisitForNextVisit: (nextVisitSerial)->
    if @visit.nextVisitSerial is null
      @visit.nextVisitSerial = nextVisitSerial
    @visit.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial

  

  

}
