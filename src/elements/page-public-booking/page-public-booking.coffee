Polymer {
  is: 'page-public-booking'

  behaviors: [
    app.behaviors.commonComputes
    app.behaviors.apiCalling    
    app.behaviors.pageLike
    app.behaviors.dbUsing
    app.behaviors.translating
  ]

  properties:

    newMember:
      type: Object
      value: {}

    selectedSchedule:
      type: Object
      value: {}

    dateString:
      type: String
      value: ()-> ""

    organizationSearchQuery:
      type: String
      value: -> ""
      observer: 'organizationSearchInputChanged'

    organizationList:
      type: Array
      value: ()-> []

    filteredSpecializationList:
      type: Array
      value: -> []

    filteredDoctorList:
      type: Array
      value: -> []      

    selectedTimeSlotFromSchduleDateDrpdwn:
      type: Array
      value: -> []
    
    degreeList:
      type: Array
      value: ->
        [
          { text: 'MBBS', value: null }
          { text: 'BDS', value: null }
        ]

    selectedChamber:
      type: Object
      value: null

    selectedScheduleIdFromDateDropdown:
      type: String
      value: ""

    selectedSchedulePage:
      type: Number
      value: 0

    selectedDateString:
      type: String
      value: null

    specialMessageOrganizationList:
      type: Array
      value: [
        {organizationId: '5ca1b674ad6ab7161f30467a', organizationSerial: '', organizationName: 'বিএসএমএমইউ '}
      ]
    
    isOrganizationPreselected:
      type: Boolean
      value: false


  $gte: (a, b)-> parseInt(a) >= parseInt(b)

  $diff: (a, b)-> parseInt(a) - parseInt(b)



  _getOrganizationDetails: (organizationId, cbfn)->
    console.log {organizationId}
    data = { organizationId: organizationId }
    this.domHost.callApi '/bdemr--public-get-organization-details', data, (err, response)=>
      if response.hasError
        console.log 'error while organization details', response.error.message
        # this.domHost.showModalDialog response.error.message
      else
        @isOrganizationPreselected = true
        organization = response.data
        @set 'filterByOrganizationId', organization.idOnServer
        @set 'filterByOrganizationName', organization.name
        # now call api to get specializatoin for this org
        @_loadSpecializationForOrganisation()
        cbfn()
        
  
  navigatedIn: ()->
    # params = @domHost.getPageParams()
    # if params['id']
    #   @_getOrganizationDetails params['id'], ()=>
    #     warningData = sessionStorage.getItem('warningShown')
    #     if warningData
    #       return
    #     else
    #       @_showBookingWarningToUser()

    # ONLY for BSMMU. id is hardcoded and rest is left as it is
    bsmmuId = "5ca1b674ad6ab7161f30467a"
    @_getOrganizationDetails bsmmuId, ()=>
      warningData = sessionStorage.getItem('warningShown')
      if warningData
        return
      else
        @_showBookingWarningToUser()
  
  # ====================================== NEW BOOK START

  showSignupFormDialog: (cbfn)->
    newMember = 
      name: null
      dateOfBirth: null
      gender: null
      emailOrPhone: null
      password: '123456'
      doctorAccessPin: '0000'
      effectiveRegion: 'Bangladesh'
      couponCode: null

    @set 'newMember', newMember
    cbfn()
  
  _sendBookingConfirmationSmsToUserIfOrganizaionHaveBalance: (patient, bookingSerial)->
    serialString = ''
    if bookingSerial
      serialString = 'Your serial is ' + bookingSerial

    timeSlot = @selectedTimeSlotFromSchduleDateDrpdwn[@selectedChamber._selectedTimeSlotIndex].timeSlot
    message = "#{this.selectedChamber.name} created an appointment for you on #{this.selectedDateString} at #{timeSlot.replace(/\-/g,':')}. #{serialString}"
    
    organizationId = @selectedChamber.organizationId

    data =
      receiverUserId: patient.userId
      phoneNumber: patient.phone
      smsBody: message
      organizationId: organizationId
    @isLoading = true
    @callApi '/bdemr--send-public-sms-from-organization-account', data, (err, response)=>
      @isLoading = false
      # if response.hasError
      #   @domHost.showModalDialog response.error.message
      # else
      #   @domHost.showModalDialog 'Successfuly Sent'

  signupAndBookThePatient:()->
    unless @newMember.name and @newMember.dateOfBirth and @newMember.gender and @newMember.emailOrPhone
      @domHost.showToast 'Please fill up required fields'  
    
    console.log 'new member ', @newMember

    @newMember.name = @$makeNameObject @newMember.name
    
    data = { 
      signUpData: @newMember
      chamber: @selectedChamber
      selectedDateStringFromUser: @selectedDateString
      selectedTimeSlotFromUser: @selectedTimeSlotFromSchduleDateDrpdwn
    }

    console.log {data}

    this.domHost.callApi '/bdemr--patient-app-public-booking-signup-api', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        organizationId = @selectedChamber.organizationId
        patient = response.data.newPatient
        serial = response.data.serial
        @_sendBookingConfirmationSmsToUserIfOrganizaionHaveBalance patient, serial

        @$$('#dialogSignupForm').close()
        @$$('#bookingCompleteAndDisclaimer').toggle()
        

  bookThisDoctorPressed: (e)->
    { chamber } = e.model
    @selectedChamber = chamber
    if typeof chamber._selectedTimeSlotIndex isnt 'number'
      this.domHost.showModalDialog 'Please Select a Timeslot for Booking'
      return
    console.log 'chamber pressed', @selectedChamber
    @selectedSchedule = {
      scheduleId: @selectedScheduleIdFromDateDropdown
      chamberId: chamber._id
    }
    @showSignupFormDialog =>
      @$$('#dialogSignupForm').toggle()


  _searchDoctorToBook: (filters, cbfn)->
    data = {}
    Object.assign(data, filters)
    this.domHost.callApi '/bdemr-public-booking--patient--search-doctor-to-book', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data.chamberList.length
        this.chamberList = []
        chamberList = response.data.chamberList
        this.chamberList = chamberList
        console.log 'Chambers', chamberList
        cbfn()
      else
        this.chamberList = []
        cbfn()


  _loadSpecializationForOrganisation: ()->
    data = {
      organizationId: @get 'filterByOrganizationId'
    }
    
    @domHost.callApi '/bdemr--public-patient-get-specializations-of-doctors-in-a-organization', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        # all chambers info
        chambers = response.data
        specList = []

        # ** this uses chamber specialization
        # for chamber in chambers
        #   unless specList.includes chamber.specialization
        #     specList.push chamber.specialization

        # ** this uses assigned doctors specializationList
        for chamber in chambers
          for doctor in chamber.assignedDoctors
            unless specList.includes doctor.specializationList
              specList.push doctor.specializationList

        @set 'filteredSpecializationList', specList
        console.log 'filtered specs ', @filteredSpecializationList;


  organizationSearchInputChanged: (searchQuery)->
    @debounce 'search-organization', ()=>
      @_searchOrganization(searchQuery)
    , 300

  _searchOrganization: (searchQuery)->
    return unless searchQuery
    @fetchingOrganizationSearchResult = true;
    @domHost.callApi '/bdemr--public-organization-search', { searchString: searchQuery }, (err, response)=>
      @fetchingOrganizationSearchResult = false
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        data = response.data.matchingOrganizationList
        console.log 'orgs', data
        if data.length > 0
          @$$("#organizationSearch").items = data


  organizationSelected: (e)->
    return unless e.detail.value
    organization = e.detail.value
    @set 'filterByOrganizationId', organization.idOnServer
    @set 'filterByOrganizationName', organization.name

    # now call api to get specializatoin for this org
    @_loadSpecializationForOrganisation()
    
  
  doctorSelected: (e)->
    return unless e.detail.value
    doctor = e.detail.value
    console.log 'selected doctor', doctor
    @set 'filterByDoctorId', doctor.idOnServer
    @set 'filterByDoctorName', doctor.name.trim()

  
  specializationSelected: (e)->
    return unless e.detail.value
    specialization = e.detail.value
    console.log 'selected spec', specialization
    @set 'filterBySpecialization', specialization
    @_loadDoctorsForSpecializationAndOrganisation specialization


  _loadDoctorsForSpecializationAndOrganisation: (specialization)->
    data = {
      organizationId: @get 'filterByOrganizationId'
      specialization
    }
    
    @domHost.callApi '/bdemr--patient-get-doctors-of-specialization-in-an-organization', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
        # clear previously loaded data
        @filteredDoctorList = []
        @filterByDoctorName = ''

      else
        @filterByDoctorName = ''
        # doctors of specialization
        doctorList = response.data

        # sort doctors name
        doctorList.sort (prev, after)->
          return -1 if prev < after
          return 1 if prev > after
          return 0;

        @set 'filteredDoctorList', doctorList
        console.log 'filtered doctor list ', @filteredDoctorList;


  _scheduleSelected: (e)->
    selectedDateStringIndex = e.model.__data__.chamber.selectedSchedulePage
    if selectedDateStringIndex is 0
      schedule = e.model.__data__.chamber.scheduleList[selectedDateStringIndex]
      @selectedDateString = schedule.dateString
      @selectedScheduleIdFromDateDropdown = schedule.scheduleId
      @selectedTimeSlotFromSchduleDateDrpdwn = schedule.timeSlotList

  searchBookingTapped: (e = null)->
    d = new Date();
    d.setFullYear(d.getFullYear());

    {
      filterByExperience
      filterByDegree
      filterBySpecialization
      filterByDoctorName
      filterByShortCode
      filterByChamberAddress
      filterByOrganizationId
      dateString
    } = this

    data = {
      filterByExperience: filterByExperience or null
      filterByDegree: filterByDegree or null
      filterBySpecialization: filterBySpecialization or null
      filterByDoctorName: filterByDoctorName or null
      filterByShortCode: filterByShortCode or null
      filterByChamberAddress: filterByChamberAddress or null
      filterByOrganizationId: filterByOrganizationId or null
      dateString: dateString or lib.datetime.mkDate(d)
    }

    console.log 'org name', @filterByOrganizationName
    console.log 'all filters', data
    # if !data.dateString
    #   @domHost.showModalDialog @$TRANSLATE('Select the Date of the Booking', @LANG)
    # else
    this._searchDoctorToBook data, =>
      console.log(this.chamberList)
      null

  bookingInfoAndDisclaimerOkayClicked: (e)->
    @$$('#bookingCompleteAndDisclaimer').close()
    window.location.reload()

  prevSchedule: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#search-result-card-repeater'
    index = repeater.indexForElement el
    chamber = @chamberList[index]

    path = 'chamberList.' + index + '.selectedSchedulePage'
    timeSlotPath = 'chamberList.' + index + '._selectedTimeSlotIndex'
    @set timeSlotPath, -1

    if chamber.selectedSchedulePage > 0
      @set path, chamber.selectedSchedulePage - 1
      schedule = chamber.scheduleList[chamber.selectedSchedulePage]
      @selectedDateString = schedule.dateString
      @selectedTimeSlotFromSchduleDateDrpdwn = schedule.timeSlotList           
    else
      @set path, chamber.scheduleList.length - 1
      schedule = chamber.scheduleList[chamber.scheduleList.length - 1]
      @selectedDateString = schedule.dateString
      @selectedTimeSlotFromSchduleDateDrpdwn = schedule.timeSlotList          


  nextSchedule: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#search-result-card-repeater'
    index = repeater.indexForElement el
    chamber = @chamberList[index]

    path = 'chamberList.' + index + '.selectedSchedulePage'
    timeSlotPath = 'chamberList.' + index + '._selectedTimeSlotIndex'
    @set timeSlotPath, -1    

    if chamber.selectedSchedulePage < chamber.scheduleList.length - 1
      @set path, chamber.selectedSchedulePage + 1
      schedule = chamber.scheduleList[chamber.selectedSchedulePage]
      console.log schedule
      @selectedDateString = schedule.dateString
      @selectedTimeSlotFromSchduleDateDrpdwn = schedule.timeSlotList
    else
      @set path, 0
      schedule = chamber.scheduleList[0]
      @selectedDateString = schedule.dateString
      @selectedTimeSlotFromSchduleDateDrpdwn = schedule.timeSlotList     
    
    

  loginTapped: ()->
    @domHost.navigateToPage '#/login'   
  # ====================================== NEW BOOK END

  showMessageIfSpecialOrganization: (orgId)->
    for org in @specialMessageOrganizationList
      if org.organizationId is orgId
        @domHost.showModalDialog "অনুগ্রহ করে #{org.organizationName} এর বহির্বিভাগে সরাসরি যোগাযোগ করুন"
        return


  _showBookingWarningToUser: ()->
    @domHost.showModalPrompt "আপনার অসুস্থতায় কোন বিভাগের চিকিৎসা প্রয়োজন তা নির্বাচনে আপনি কি সক্ষম?", (answer)=>
      if answer
        warningData = sessionStorage.setItem('warningShown', 'true')
      else
        # show the message below only for BSMMU
        @showMessageIfSpecialOrganization @filterByOrganizationId

    
    # @domHost.showModalDialog "-- !!লক্ষ্য করুন!! -- আপনি কোন বিভাগের ডাক্তারের সাক্ষাৎ চান তা জানা থাকলে পরবর্তী ধাপে (Ok) কিল্ক করুন!"
    #Here used session storage so that user can refresh the page without gettng the warning everytime.
    #Only After leaving the site will clear the warning, true


}
