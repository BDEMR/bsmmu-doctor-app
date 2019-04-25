
Polymer {
  
  is: 'page-print-chamber-patients'

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

    chamberShortCode:
      type: Object
      value: null

    timeSlotAvailability:
      type: Object
      value: null

    organization:
      type: Object
      notify: true
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
      console.log response
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        this.scheduleForMonth = []
        scheduleForMonth = response.data 
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
      this.schedule = null
      this.schedule = selectedSchedule
      console.log "SCHEDULE", schedule
      this._computeTimeSlotAvailability()
      cbfn()


  _notifyInvalidOrganization: ->
    @showModal 'No Organization is Present. Please Select an Organization first.'

  _loadOrganization: ->
    organizationList = app.db.find 'organization'
    if organizationList.length is 1
      @set 'organization', organizationList[0]
    else
      @_notifyInvalidOrganization()

  _returnSerial: (index)->
    index+1

  navigatedIn: ->
    @_loadOrganization()
    this.chamberShortCode = this.domHost.getPageParams()['chamber']
    this.dateString =  this.domHost.getPageParams()['date']
    this._getChamber =>
      this._getScheduleForDate this.dateString, => null
      
  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()
  
  printButtonPressed: (e)->
    window.print()

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

}
