
Polymer {
  
  is: 'page-chamber-patients'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:
    user:
      type: Object
      value: -> (app.db.find 'user')[0]

    organization:
      type: Object
      value: null
    
    chamberShortCode:
      type: Object
      value: null
      
    timeSlotAvailability:
      type: Object
      value: null

  _notify: (patientId, message)->
    user = @getCurrentUser()
    request = {
      operation: 'notify-single'
      apiKey: user.apiKey
      notificationCategory: 'Booking'
      notificationMessage: message
      notificationTargetId: patientId
      sender: user.name
    }
    return console.log request
    @domHost.ws.send JSON.stringify request
    
  _getChamber: (cbfn)->
    data = { 
      apiKey: this.user.apiKey
      doctorId: this.user.idOnServer
    }
    this.callApi '/bdemr--get-all-doctor-chamber', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        this.chamber =  null
        chamberList = response.data
        for chamber in chamberList
          if chamber.shortCode is this.chamberShortCode
            this.chamber = chamber
        cbfn()
      else
        this.chamber = null
        cbfn()

  _getScheduleForMonth: (monthString, chamberSerial, cbfn)->
    data = { 
      apiKey: this.user.apiKey
      monthString
      chamberSerial
    }
    this.callApi '/bdemr-booking--doctor--get-schedule-for-month', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        this.scheduleForMonth = []
        scheduleForMonth = response.data
        console.log "schedule for month", scheduleForMonth
        this.scheduleForMonth = scheduleForMonth
        cbfn()
      else
        this.scheduleForMonth = []
        cbfn()

  _getMonthString: ->
    array = this.dateString.split '-'
    array.pop()
    return array.join '-'

  _getScheduleForDate: (dateString, cbfn)->
    monthString = this._getMonthString()
    this._getScheduleForMonth monthString, this.chamber.serial, =>
      selectedSchedule = null
      for schedule in this.scheduleForMonth
        if dateString is schedule.dateString
          selectedSchedule = schedule
      this.schedule = selectedSchedule
      this._computeTimeSlotAvailability()
      cbfn()

  _setScheduleForDate: (schedule, cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    Object.assign(data, schedule)
    this.callApi '/bdemr-booking--doctor--set-schedule-for-date', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        cbfn()

  sendSMSButtonClicked: (e)->
    {entry} = e.model
    message = "#{this.user.name} of #{this.chamber.name} created an appointment for you on #{this.dateString} at #{entry.timeSlot.replace(/\-/g,':')}"

    @domHost.showModalPrompt 'SMS Sending will cost 2.21 BDT/sms from this Organization. Are you sure?', (done)=>
      if done
        data =
          apiKey: @getCurrentUser().apiKey
          receiverUserId: entry.patientId
          phoneNumber: entry.patientPhone
          smsBody: message
          organizationId: @organization.idOnServer
        @callApi '/bdemr--send-sms-using-organization', data, (err, response)=>
          if response.hasError
            @domHost.showModalDialog response.error.message
          else
            @domHost.showModalDialog 'Successfuly Sent'

  _searchOnline: ->
    @matchingPatientList = []
    @callApi '/bdemr-patient-search-new', { apiKey: @user.apiKey, searchQuery: @searchPatientInput}, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else  
        if response.data.length is 0
          @domHost.showToast 'No Patient Found'
          return
        @matchingPatientList = response.data
        
  searchPatientTapped: (e)->
    this._searchOnline()

  searchPatintKeyPressed: (e)->
    if e.which is 13
      this._searchOnline()

  
  _calculateAppoinmentCallForPatient: (bookedPatientList)->
    awaitingPatientList = (item for item in bookedPatientList when item.status isnt 'completed')
    return unless awaitingPatientList.length
    awaitingPatientList.sort (a, b)-> a.bookedDatetimeStamp - b.bookedDatetimeStamp
    for item, index in awaitingPatientList
      if index is 0
        @_notify item.patientId, 'You are Next'
      else
        @_notify item.patientId, "You are number #{index+1}"


  addPatientTapped: (e)->
    { patient } = e.model   
    newEntry = {
      patientId: patient.idOnServer
      patientFullName: @$getFullName patient.name
      patientEmail: patient.email
      patientPhone: patient.phone
      patientSerial: patient.serial # extra
      timeSlot: this.schedule.timeSlotList[0]
      paymentStatus: 'manual' # 'manual', 'online-pending', 'online-successful', 'online-failure'
      status: 'booked' # 'booked','awaiting', 'completed', 'require-second-visit', 'canceled'
      bookedByUserType: 'doctor'
      bookedByUserId: this.user.idOnServer
      bookedDatetimeStamp: (new Date).getTime()
      activityLog: [{
        status: 'booked'
        createdDateTimeStamp: lib.datetime.now()
        createdByUserId: @user.idOnServer
      }]
    }
    this.push('schedule.bookingList', newEntry)
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamber.name} created an appointment for you on #{this.dateString} at #{newEntry.timeSlot.replace(/\-/g,':')}"
        this._notify(newEntry.patientId, message)
        this._calculatePatientsBookingStatusCount this.schedule.bookingList
        null
    @matchingPatientList = "" 
  
  patientArrivedTapped: (e)->
    { entry } = e.model   
    e.model.set('entry.status', 'awaiting')
    if e.model.entry.activityLog
      e.model.push('entry.activityLog', {
        status: 'awaiting'
        createdDateTimeStamp: lib.datetime.now()
        createdByUserId: @user.idOnServer
      })
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        this._calculatePatientsBookingStatusCount this.schedule.bookingList
        null
  
  markAsDoneTapped: (e)->
    { entry } = e.model   
    e.model.set('entry.status', 'completed')
    if e.model.entry.activityLog
      e.model.push('entry.activityLog', {
        status: 'completed'
        createdDateTimeStamp: lib.datetime.now()
        createdByUserId: @user.idOnServer
      })
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamber.name} completed your appointment on #{this.dateString}"
        this._notify(entry.patientId, message)
        this._calculateAppoinmentCallForPatient this.schedule.bookingList
        this._calculatePatientsBookingStatusCount this.schedule.bookingList
        null
        
  requiresSecondVisitTapped: (e)->
    { entry } = e.model   
    e.model.set('entry.status', 'require-second-visit')
    if e.model.entry.activityLog
      e.model.push('entry.activityLog', {
        status: 'require-second-visit'
        createdDateTimeStamp: lib.datetime.now()
        createdByUserId: @user.idOnServer
      })
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamber.name} completed your appointment on #{this.dateString} and required a second visit"
        this._notify(entry.patientId, message)
        this._calculatePatientsBookingStatusCount this.schedule.bookingList
        null

  doctorCancelTapped: (e)->
    { entry } = e.model   
    e.model.set('entry.status', 'canceled')
    if e.model.entry.activityLog
      e.model.push('entry.activityLog', {
        status: 'canceled'
        createdDateTimeStamp: lib.datetime.now()
        createdByUserId: @user.idOnServer
      })
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamber.name} canceled your appointment on #{this.dateString}"
        this._notify(entry.patientId, message)
        this._calculatePatientsBookingStatusCount this.schedule.bookingList
        null

  setTimeSlotTapped: (e)->
    { entry } = e.model   
    console.log(entry._selectedTimeSlotIndex)
    return unless entry._selectedTimeSlotIndex > -1
    newTimeSlot = this.schedule.timeSlotList[entry._selectedTimeSlotIndex]
    oldTimeSlot = entry.timeSlot
    e.model.set('entry.timeSlot', newTimeSlot)
    this._setScheduleForDate this.schedule, =>
      this._getScheduleForDate this.dateString, =>
        message = "#{this.user.name} of #{this.chamber.name} changed your timeslot on #{this.dateString} from (#{oldTimeSlot}) to (#{newTimeSlot})"
        this._notify(entry.patientId, message)
  
  _returnSerial: (index)->
    index+1
  

  # view patient data from chamber - start
  _importPatient: (serial, pin, cbfn)->
    @callApi '/bdemr-patient-import-new', {serial: serial, pin: pin, doctorName: @user.name, organizationId: @organization.idOnServer}, (err, response)=>
      console.log "bdemr-patient-import-new", response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        patientList = response.data

        if patientList.length isnt 1
          return @domHost.showModalDialog 'Unknown error occurred.'
        patient = patientList[0]

        # patientPinObject = {patientSerial: serial, pin: pin}
        # @_savePinForLocalPatient pin, patient.serial
        patient.flags = {
          isImported: false
          isLocalOnly: false
          isOnlineOnly: false
        }
        patient.flags.isImported = true

        @removePatientIfAlreadyExist patient.serial

        @_importPatientData patient.serial, patient, cbfn

  _importPatientData: (serial, patient, cbfn)->
    @domHost.toggleModalLoader 'Importing Patient Data. Please Wait...'
    collectionNameMap = {
      'bdemr--doctor-visit': 'doctor-visit',
      'bdemr--visit-prescription': 'visit-prescription',
      'bdemr--patient-medications': 'patient-medications',
      'bdemr--doctor-notes': 'visit-note',
      'bdemr--visit-next-visit': 'visit-next-visit',
      'bdemr--visit-advised-test': 'visit-advised-test',
      'bdemr--visit-examination': 'visit-examination',
      'bdemr--visit-identified-symptoms': 'visit-identified-symptoms',
      'bdemr--anaesmon-record': 'anaesmon-record',
      'bdemr--patient-test-results': 'patient-test-results',
      'bdemr--patient-stay': 'visit-patient-stay',
      'history-and-physical-record': 'history-and-physical-record',
      'diagnosis-record': 'diagnosis-record',
      'bdemr--referral-record': 'referral-record',
      'bdemr--employee-leave-data': 'employee-leave-data',
      'bdemr--vital-blood-pressure': 'patient-vitals-blood-pressure',
      'bdemr--vital-bmi': 'patient-vitals-bmi',
      'bdemr--vital-pulse-rate': 'patient-vitals-pulse-rate',
      'bdemr--vital-respiratory-rate': 'patient-vitals-respiratory-rate',
      'bdemr--vital-spo2': 'patient-vitals-spo2',
      'bdemr--vital-temperature': 'patient-vitals-temperature',
      'bdemr--test-blood-sugar': 'patient-test-blood-sugar',
      'bdemr--other-test': 'patient-test-other',
      'bdemr--comment-patient': 'comment-patient',
      'bdemr--comment-doctor': 'comment-doctor',
      'bdemr--patient-gallery--online-attachment': 'patient-gallery--online-attachment',
      'bdemr--user-activity-log': 'activity',
      'bdemr--visit-invoice': 'visit-invoice',
      'bdemr--visit-diagnosis': 'visit-diagnosis',
      'bdemr--pcc-records': 'pcc-records',
      'bdemr--ndr-records': 'ndr-records',
    }

    data = {
      apiKey: @user.apiKey
      client: 'doctor'
      knownPatientSerialList: [ serial ]
    }
    @callApi '/bdemr--get-patient-data-on-import', data, (err, response)=>
      @domHost.toggleModalLoader()
      if err
        return @domHost.showModalDialog 'server error occured'
      else if response.hasError 
        return @domHost.showModalDialog(response.error.message)
      else 
        app.db.__allowCommit = false
        for item, index in response.data
          collectionName = collectionNameMap[item.collection];
          delete item.collection
          if index is (response.data.length - 1) 
            app.db.__allowCommit = true
          app.db.upsert(collectionName, item, ({ serial })=> item.serial is serial)
        
        app.db.__allowCommit = true

        _id = app.db.insert 'patient-list', patient

        cbfn(_id)
  
  removePatientIfAlreadyExist: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier

    if list.length is 1
      patient = list[0]
      app.db.remove 'patient-list', patient._id
      return
    else
      return

  _checkIfPatientAvailableOrImport:(patientSerial, cbfn)->
    localPatientList = app.db.find 'patient-list', ({serial})-> serial is patientSerial

    if localPatientList.length is 1
      patient = localPatientList[0]
      cbfn patient
      return
    else
      @domHost.showModalInput "Please enter patient PIN", "0000", (answer)=>
        if answer
          @_importPatient patientSerial, answer, (importedPatientLocalId)=>

            patient = (app.db.find 'patient-list', ({serial})-> serial is patientSerial)[0]

            savePinOffline = { serial: patientSerial, pin: answer}
            app.db.insert 'offline-patient-pin', savePinOffline
            cbfn patient
  
  goPatientViewPage: (patient)->
    @domHost.setCurrentPatientsDetails patient
    @createdPatientVisitedLog patient
    @domHost.navigateToPage '#/visit-editor/visit:new/patient:' + patient.serial
    @domHost.selectedPatientPageIndex = 0

  createdPatientVisitedLog: (patient)->

    visitedPatientLogObject = {
      createdByUserSerial: @user.serial
      serial: @generateSerialForVisitedPatientLog()
      patientSerial: patient.serial
      patientName: patient.name
      visitedDateTimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
    }

    app.db.insert 'visited-patient-log', visitedPatientLogObject
    

  viewChamberPatient: (e)->
    {entry} = e.model
    patientSerial = entry.patientSerial
    @_checkIfPatientAvailableOrImport patientSerial, (patient)=>
      @goPatientViewPage patient
  # view patient data from chamber - end
    
  navigatedIn: ->
    organization = @getCurrentOrganization()
    if organization
      @set 'organization', organization
    else
      @domHost.navigateToPage '#/select-organization'

    this.chamberShortCode = this.domHost.getPageParams()['chamber']
    this.dateString =  this.domHost.getPageParams()['date']
    this._getChamber =>
      this._getScheduleForDate this.dateString, =>
        this._calculatePatientsBookingStatusCount(this.schedule.bookingList)
        
        null

  _calculatePatientsBookingStatusCount: (bookingList)->
    this.awatingPatientCount = 0
    this.completedPatientCount = 0
    this.secondVisitPatientCount = 0
    for item in bookingList
      if item.status is 'awaiting'
        this.awatingPatientCount++
      if item.status is 'completed'
        this.completedPatientCount++
      if item.status is 'require-second-visit'
        this.secondVisitPatientCount++

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  chamberPatientsListPrintButtonPressed: (e)->
    this.domHost.navigateToPage "#/print-chamber-patients/chamber:#{this.chamberShortCode}/date:#{this.dateString}"

  _computeTimeSlotAvailability: ->

    map = {}
    
    for timeSlot in this.schedule.timeSlotList
      map[timeSlot] = 0

    for booking in this.schedule.bookingList
      unless booking.timeSlot of map
        map[booking.timeSlot] = 0
      map[booking.timeSlot] += 1

    freeSchedule = []
    for timeSlot, count of map
      freeSchedule.push {
        timeSlot
        availableCount: (this.chamber.maximumVisitorPerBookingSlot - count)
      }

    this.timeSlotAvailability = freeSchedule

    console.log this.timeSlotAvailability


  _changeStatusColorForPatientChamberBooking: (statusData)->
    if statusData is "booked"
      return "status booked"
    if statusData is "awaiting"
      return "status awaiting"
    else if statusData is "completed"
      return "status completed"
    else if statusData is "require-second-visit"
      return "status require-second-visit"
    else if statusData is 'canceled'
      return "status canceled" 
    else
      return 'status'
}
