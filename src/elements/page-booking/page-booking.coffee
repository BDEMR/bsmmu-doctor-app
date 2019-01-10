
Polymer {
  
  is: 'page-booking'

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
    publicInfo:
      type: Object
      value: -> null
    selectedSubViewIndex:
      type: Number
      value: 0
    serviceQueueServiceTypeList: 
      type: Array
      value: -> [
        'second-opinion'
        'online-discussion'
        'history'
      ]
    serviceQueueShouldShowOnlyPending:
      type: Boolean
      value: false

    selectedChamberEditViewIndex:
      type: Number
      value: -> 0

  # REGION START public info 

  _getSpecializationListInfo: (cbfn)->
    data = { 
      apiKey: @user.apiKey
    }
    @callApi '/get-user-specialization-list', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn(response.data.specializationList)

  _getDegreeListInfo: (cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    this.callApi '/get-user-degree-list', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        cbfn(response.data.degreeList)

  _setPublicInfo: (publicInfo, cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    Object.assign(data, publicInfo)
    this.callApi '/bdemr-booking--doctor--set-doctor-public-info', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        cbfn()

  _getPublicInfo: ->
    data = { 
      apiKey: this.user.apiKey
    }
    @callApi '/bdemr-booking--doctor--get-doctor-public-info', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        if response.data
          this.publicInfo = response.data
        else
          this._getSpecializationListInfo (specializationList)=>
            this._getDegreeListInfo (degreeList)=>
              publicInfo = {
                publicNameOfDoctor: this.user.name
                specializationList
                degreeList
                experience: ''
              }
              this._setPublicInfo(publicInfo, => this._getPublicInfo())
  
  _getPublicInfoComputed: ->
    this._getSpecializationListInfo (specializationList)=>
      this._getDegreeListInfo (degreeList)=>
        publicInfo = {
          publicNameOfDoctor: this.user.name
          specializationList
          degreeList
          experience: ''
        }
        publicInfo = this._normalizePublicInfo(publicInfo)
        this.publicInfo = publicInfo
        this._setPublicInfo publicInfo, =>
          null

  _normalizePublicInfo: (publicInfo)->
    {
      publicNameOfDoctor
      specializationList
      degreeList
      experience
    } = publicInfo

    experience = do =>
      list = (item.degreeYear for item in degreeList when item.degreeTitle is 'MBBS')
      mbbsYear = (if list.length is 0 then 0 else list[0])
      list = (item.degreeYear for item in degreeList when item.degreeYear >= mbbsYear)
      min = Math.min.apply Math, list
      if min is 0 or isNaN(min)
        return "No Experience"
      else
        years = (new Date).getTime() - (new Date (''+min)).getTime()
        years = Math.floor(years / 1000 / 60 / 60 / 24 / 365)
        return "#{years}+ Years of Experience"
      return mbbsYear

    degreeList = (item.degreeTitle for item in degreeList).join ', '

    specializationList = (item.specializationTitle for item in specializationList).join ', '

    return {
      publicNameOfDoctor
      specializationList
      degreeList
      experience
    }


  # REGION END public info 

  # REGION START online status

  _setOnlineStatus: (onlineStatus, cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    Object.assign(data, onlineStatus)
    this.callApi '/bdemr-booking--doctor--set-online-status', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        cbfn()

  _getOnlineStatus: (cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    this.callApi '/bdemr-booking--doctor--get-online-status', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        this.onlineStatus = response.data
        cbfn()
      else
        onlineStatus = {
          doesServeOnline: false
          isServingSecondOpinionNow: false
          secondOpinionFeesAmount: 0
          isServingOnllineDiscussionNow: false
          onlineDiscussionFeesAmount: 0
          isServingHistoryNow: false
          historyFeesAmount: 0
        }
        this._setOnlineStatus(onlineStatus, (=> this._getOnlineStatus(cbfn)))
        
  updateOnlineServicesTapped: (e)->
    this._setOnlineStatus(this.onlineStatus, (=> this._getOnlineStatus(=> null)))

  # REGION END online status

  # REGION START service queue

  _alllowInteraction: ->
    this.isInteractionAllowed = true
  
  _disallowInteraction:->
    this.isInteractionAllowed = false

  _getServiceQueue: (cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    this.callApi '/bdemr-booking--doctor--get-service-queue', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        this.serviceQueue = []
        serviceQueue = response.data.serviceQueue
        serviceQueue = (this._applyIndexesToServiceQueueEntry(entry) for entry in serviceQueue)
        this.serviceQueue = serviceQueue
        cbfn()
      else
        this.serviceQueue = []
        cbfn()
  
  $countPendingPatients:(serviceQueue, _)->
    return (null for entry in serviceQueue when entry.serviceStatus is 'pending').length

  _searchOnline: ->
    @matchingPatientList = []
    @callApi '/bdemr-patient-search', { apiKey: @user.apiKey, searchQuery: @searchPatientInput}, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @matchingPatientList = response.data
        
  searchPatientTapped: (e)->
    this._searchOnline()

  _setServiceQueue: (serviceQueue, cbfn)->
    data = { 
      apiKey: this.user.apiKey
    }
    Object.assign(data, {serviceQueue})
    this.callApi '/bdemr-booking--doctor--set-service-queue', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        cbfn()

  _applyIndexesToServiceQueueEntry: (entry)->
    entry._serviceTypeSelectedIndex = this.serviceQueueServiceTypeList.indexOf(entry.serviceType)
    return entry

  serviceQueueServiceTypeSelected: (e)->
    { entry } = e.model
    current = entry.serviceType
    entry.serviceType = this.serviceQueueServiceTypeList[entry._serviceTypeSelectedIndex]
    unless current is entry.serviceType
      this._disallowInteraction()
      this._setServiceQueue this.serviceQueue, 
        => this._alllowInteraction()

  serviceQueueMarkAsDoneTapped: (e)->
    { entry } = e.model
    e.model.set 'entry.serviceStatus', 'done'
    this._disallowInteraction()
    this._setServiceQueue this.serviceQueue, => 
      this._getServiceQueue => 
        this._alllowInteraction()

  serviceQueueDoctorCancelTapped: (e)->
    { entry } = e.model
    e.model.set 'entry.serviceStatus', 'doctor-canceled'
    this._disallowInteraction()
    this._setServiceQueue this.serviceQueue, => 
      this._getServiceQueue => 
        this._alllowInteraction()
  
  $applyServiceQueueFilter: (serviceQueueShouldShowOnlyPending)->
    if serviceQueueShouldShowOnlyPending
      return (entry)=>
        return entry.serviceStatus is 'pending'
    else
      return (entry)=>
        return true

  addPatientToServiceQueueTapped: (e)->
    { patient } = e.model   
    newEntry = {
      patientId: patient.idOnServer
      patientFullName: @$getFullName patient.name
      patientEmail: patient.email
      patientPhone: patient.phone
      patientSerial: patient.serial # extra
      serviceType: 'second-opinion' # 'second-opinion', 'online-discussion', 'history'
      paymentStatus: 'manual' # 'manual', 'online-pending', 'online-successful', 'online-failure'
      serviceStatus: 'pending' # 'done', 'doctor-canceled', 'pending', 'patient-canceled'
      bookedByUserType: 'doctor'
      bookedByUserId: this.user.idOnServer
      bookedDatetimeStamp: (new Date).getTime()
    }
    this._applyIndexesToServiceQueueEntry(newEntry)
    this._getServiceQueue =>
      foundIndex = -1
      for entry, index in this.serviceQueue
        if entry.patientId is newEntry.patientId
          foundIndex = index
          break
      if foundIndex > -1
        this.splice('serviceQueue', foundIndex, 1, newEntry)
      else
        this.push('serviceQueue', newEntry)
      this._setServiceQueue(this.serviceQueue, => null)

  # REGION END service queue

  # REGION START chamber

  _getChamberList: (cbfn)->
    data = { 
      apiKey: this.user.apiKey
      doctorId: this.user.idOnServer
    }
    this.callApi '/bdemr--get-all-doctor-chamber', data, (err, response)=>
      console.log response
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else if response.data
        this.chamberList = []
        this.chamberList = response.data
        cbfn()
      else
        this.chamberList = []
        cbfn()

  _setChamberList: (chamber, cbfn)->
    data = { 
      apiKey: this.user.apiKey
      chamber
    }
    this.callApi '/bdemr--chamber-set', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog response.error.message
      else
        cbfn()

  addNewChamberTapped: (e)->
    newChamber = {
      shortCode: ''
      name: ''
      address: ''
      doctorId: @user.idOnServer
      doctorName: @user.name
      doctorPhone: @user.phone
      doctorEmail: @user.email
      specialization: ''
      city: ''
      postCode: ''
      latitude: ''
      longitude: ''
      organizationId: this.getCurrentOrganization().idOnServer
      newPatientVisitFee: 0
      oldPatientVisitFee: 0
      startTimeString: '08:00:00'
      endTimeString: '11:00:00'
      bookingSlotSizeInMinutes: 60
      maximumVisitorPerBookingSlot: 5
      maximumVisitorPerDay: 60
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: ''
      _isEditMode: true
    }
    @currentlyEditingChamber = newChamber
    @selectedChamberEditViewIndex = 1

  chamberEditTapped: (e)->
    { chamber } = e.model
    @currentlyEditingChamber = chamber
    @selectedChamberEditViewIndex = 1
    

  _checkIfUnique: (shortCode, chamberName, cbfn)->
    data = { 
      apiKey: this.user.apiKey
      shortCode
      chamberName
    }
    this.callApi '/bdemr-booking--doctor--is-chamber-short-code-unique', data, (err, response)=>
      if response.hasError
        this.domHost.showModalDialog "Short Code is Not Unique"
      else
        cbfn()   

  chamberSaveTapped: (e)->
    chamber = @currentlyEditingChamber
    if (not("name" of chamber)) or (not chamber.name)
      this.domHost.showModalDialog "Please enter a chamber name"
      return 
    unless chamber.name.length > 0
      this.domHost.showModalDialog "Please enter a chamber name"
      return
    if (not("shortCode" of chamber)) or (not chamber.shortCode)
      this.domHost.showModalDialog "Please enter a Short Code"
      return 
    unless 4 <= chamber.shortCode.length <= 6
      this.domHost.showModalDialog "Short Code Must be at least 4 and at most 6 characters long"
      return
    if chamber.startTimeString >= chamber.endTimeString
      this.domHost.showModalDialog "Start time cannot be equal or greater than End time"
      return
    chamber._isEditMode = false
    chamber.lastModifiedDatetimeStamp = lib.datetime.now()
    if !chamber.serial
      chamber.serial = @generateSerialForChamber()
    this._setChamberList chamber, =>
      this._getChamberList =>
        null
        @selectedChamberEditViewIndex = 0
        @currentlyEditingChamber = {}
      
  chamberDiscardTapped: (e)->
    this._getChamberList =>
      @selectedChamberEditViewIndex = 0
      @currentlyEditingChamber = {}

  _deletedChamber:(chamberSerial)->
    data = { 
      apiKey: this.user.apiKey
      chamberSerial
    }
    @loadingCounter++
    this.callApi '/bdemr--chamber-delete', data, (err, response)=>
      @loadingCounter--
      if response.hasError
        return this.domHost.showModalDialog response.error.message
      
  chamberDeleteTapped: (e)->
    { chamber, chamberIndex } = e.model
    this.domHost.showModalPrompt 'Are you sure to delete', (answer)=>
      if (answer)
        this.splice('chamberList', chamberIndex, 1)
        this._deletedChamber chamber.serial, =>
          this._getChamberList =>
            null

  chamberManageTapped: (e)->
    { chamber } = e.model
    this.domHost.navigateToPage "#/chamber/which:#{chamber.shortCode}"

  # REGION END chamber

  navigatedIn: ->
    console.log(@user)
    this._getPublicInfoComputed()
    this._getOnlineStatus => 
      null
    this._getServiceQueue => 
      this._setServiceQueue this.serviceQueue, =>
        null
    this._getChamberList => 
      null

}
