unless app.behaviors.local.patientStayMixin
  app.behaviors.local.patientStayMixin = {}
app.behaviors.local.patientStayMixin =

  properties:

    selectedView:
      type: Number
      value: -> 0
    
    patientStay:
      type: Object
      notify: true
      value: -> null

    patientStayObject:
      type: Object
      notify: true
      value: -> null

    organizationsIBelongToList:
      type: Array
      value: -> []

    admissionTypeList:
      type: Array
      value: -> [
        'Out patient/ Discharged with advice'
        'Out patient/ Advised admission'
        'Seen in emergency/ Discharged with advice'
        'Seen in emergency/ Advised admission'
      ]
    
    locationList:
      type: Array
      value: -> []

    dischargeReasonList:
      type: Array
      value: -> [
        'Patient Got better'
        'Patient require care at bigger facility'
        'Patient care not possible at current facility'
        'Patient do not require further stay at hospital'
        'Death'
      ]
    
    dischargedToList:
      type: Array
      value: -> [
        'Home'
        'Rehabilitation'
        'Mortuary'
      ]

    selectedOrganizationIndex:
      type: Number
      value: -> null

    selectedDepartmentIndex:
      type: Number
      value: -> null
      observer: 'departmentSelected'
      

    selectedUnitIndex:
      type: Number
      value: -> null
      observer: 'unitSelected'
      
    selectedWardIndex:
      type: Number
      value: -> null
      observer: 'wardSelected'
      
    seatList:
      type: Array
      value: -> []

    patientDischarged:
      type: Boolean
      value: -> false

    advisedAdmission:
      type: Boolean

    
  _notifyInvalidPatientStay: ->
    @isPatientStayValid = false
    @domHost.showModalDialog 'Invalid Patient Stay Provided'
  
  _loadVisitPatientStay: (patientStayIdentifier)->
    list = app.db.find 'visit-patient-stay', ({serial})-> serial is patientStayIdentifier
    if list.length is 1
      @isPatientStayValid = true
      @isFullVisitValid = true
      @set 'patientStay', list[0]
      return if @patientStay.adviseOnly is true
      @async ()=> @patientStay.data.admissionDateTimeStamp = @$mkDate @patientStay.data.admissionDateTimeStamp
      @_loadOrganizationsIBelongTo ()=>
        organizationQueryParameters = @patientStay.organizationQueryParameters
        @set 'selectedOrganizationIndex', organizationQueryParameters.selectedOrganizationIndex
        @_loadPatientStayObject @organizationsIBelongToList[@selectedOrganizationIndex].idOnServer, ()=>
          @_loadDropdowns()
    else
      @_notifyInvalidPatientStay()
  
  _loadOrganizationsIBelongTo: (cbfn)->
    data = { 
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-organization-list-those-user-belongs-to', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'organizationsIBelongToList', response.data.organizationObjectList
        cbfn() if cbfn

  _loadDropdowns: ->
    # if record is in edit mode
    if 'organizationQueryParameters' of @patientStay
      organizationQueryParameters = @patientStay.organizationQueryParameters
      @set 'selectedOrganizationIndex', organizationQueryParameters.selectedOrganizationIndex
      @set 'selectedDepartmentIndex', organizationQueryParameters.selectedDepartmentIndex
      @set 'selectedUnitIndex', organizationQueryParameters.selectedUnitIndex
      @set 'selectedWardIndex', organizationQueryParameters.selectedWardIndex

  $notUndefined: (value)-> if value? then true else false

  _loadPatientStayObject: (organizationId, cbfn)->
    data = { 
      apiKey: @user.apiKey
      organizationId: organizationId
    }
    @callApi '/bdemr-organization-patient-stay-get-object', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'patientStayObject', response.data.patientStayObject
        unless @patientStayObject.locations
          @patientStayObject.locations = [
            "Absconded"
            "Bed"
            "CT"
            "Discharged but waiting in bed"
            "Doctors chamber outside hospital"
            "Laboratory"
            "Out of bed on permission"
            "Pathology"
            "Ultrasound"
            "X-ray"
            "Nil"
          ]
        cbfn() if cbfn

  organizationSelected: (e)->
    if @selectedOrganizationIndex?
      @set 'organization', @organizationsIBelongToList[@selectedOrganizationIndex]
      @async ()-> @_populateSeatList()
  
  departmentSelected: (e)->
    if @selectedDepartmentIndex?
      department = @patientStayObject.departmentList[@selectedDepartmentIndex]
      @department = department
      console.log 'inside mixin dept selected', @department
      @set 'unitList', department.unitList
      # @selectedUnitIndex = null
      @debounce 'iron-select', (()-> @_populateSeatList @department), 50

  unitSelected: (e)->
    if @selectedUnitIndex?
      unit = @department.unitList[@selectedUnitIndex]
      @unit = unit
      @set 'wardList', unit.wardList
      # @selectedWardIndex = null
      @debounce 'iron-select', (()-> @_populateSeatList @department, @unit), 50

  wardSelected: (e)->
    if @selectedWardIndex?
      ward = @unit.wardList[@selectedWardIndex]
      @ward = ward
      @debounce 'iron-select', (()-> @_populateSeatList @department, @unit, @ward), 50
      

  _populateSeatList: (department=null, unit=null, ward=null)->
    if ward
      seatList = (seat for seat in @patientStayObject.seatList when (department.name is seat.department and unit.name is seat.unit and ward.name is seat.ward))
      return @set 'seatList', seatList
    if unit
      seatList = (seat for seat in @patientStayObject.seatList when (department.name is seat.department and unit.name is seat.unit))
      return @set 'seatList', seatList
    if department
      seatList = (seat for seat in @patientStayObject.seatList when department.name is seat.department)
      return @set 'seatList', seatList

    @set 'seatList', @patientStayObject.seatList
    @$$("#seatList").fire('iron-resize')


  fillTapped: (e)->
    for seat, index in @seatList
      if seat.patientSerial is @patient.serial
        @set "seatList.#{index}.patientSerial", null
        @set "seatList.#{index}.location", ''
    @set "seatList.#{e.model.index}.patientSerial", @patient.serial
    @set "seatList.#{e.model.index}.patientAdmittedDatetimeStamp", lib.datetime.now()
    @set "seatList.#{e.model.index}.patientName", @$getFullName @patient.name
    @set "seatList.#{e.model.index}.patientEmailOrPhone", if @patient.phone then @patient.phone else
    @savePatientStayObject()

  removePatientDoctorAccessPin: (patientIdentifier)->
    list = app.db.find 'local-patient-pin-code-list', ({patientSerial})-> patientSerial is patientIdentifier

    if list.length is 1
      patient = list[0]
      app.db.remove 'local-patient-pin-code-list', patient._id

  dischargeTapped: (e)->
    @set "seatList.#{e.model.index}.patientSerial", null
    @set "seatList.#{e.model.index}.patientAdmittedDatetimeStamp", null
    @set "seatList.#{e.model.index}.patientName", ''
    @set "seatList.#{e.model.index}.patientEmailOrPhone", ''
    @set "seatList.#{e.model.index}.location", ''
    @unshift 'patientStay.data.currentLocation', {datetimeStamp: lib.datetime.now(), location: 'Discharged'}
    @patientDischarged = true
    @removePatientDoctorAccessPin @patient.serial
    @set 'selectedView', 1
    @patientStay.data.dischargedByDoctorName = @user.name


  addOverflow: ->
    seat = {
      department: @department.name
      unit: @unit.name
      ward: @ward.name
    }
    seat.patientSerial = @patient.serial
    seat.patientName = @$getFullName @patient.name
    seat.patientEmailOrPhone = if @patient.phone then @patient.phone else 
    seat.patientAdmittedDatetimeStamp = lib.datetime.now()
    seat.name = 'Overflow Seat'
    seat.uid = (@patientStayObject.seatSeed++)
    seat.isOverflow = true
    @push 'seatList', seat

  
  admissionTypeChanged: (e)->
    switch @patientStay.data.admissionType
      when 'Out patient/ Discharged with advice', 'Seen in emergency/ Discharged with advice' then @advisedAdmission = false
      when 'Out patient/ Advised admission', 'Seen in emergency/ Advised admission' then @advisedAdmission = true
      else @showAdmission = true
    
  customLocationAdded: (e)->
    if e.keyCode is 13
      value = e.target.value
      e.target.value = ""
      @push 'patientStayObject.locations', value
      el = @$$("#locationRadioGroup")
      el.selected = value
      for seat, index in @seatList
        if seat.patientSerial is @patient.serial
          @set "seatList.#{index}.location", value

  
  locationChanged: (e)->
    for seat, index in @seatList
      if seat.patientSerial is @patient.serial
        @set "seatList.#{index}.location", @selectedLocation
        @unshift 'patientStay.data.currentLocation', {datetimeStamp: lib.datetime.now(), location: @selectedLocation}
        break


  dischargeReasonChanged: (e)->
    checked = e.target.checked
    value = e.target.name
    if checked
      @push 'patientStay.data.dischargeReason', value
    else
      if (index = @patientStay.data.dischargeReason.indexOf value) > -1
        @splice 'patientStay.data.dischargeReason', index, 1
  
  customDischargeReasonAdded: (e)->
    if e.keyCode is 13
      value = e.target.value
      e.target.value = ""
      @push 'patientStay.data.dischargeReason', value

  dischargedToChanged: (e)->
    checked = e.target.checked
    value = e.target.name
    if checked
      @push 'patientStay.data.dischargeTo', value
    else
      if (index = @patientStay.data.dischargeTo.indexOf value) > -1
        @splice 'patientStay.data.dischargeTo', index, 1
  
  customDischargeToAdded: (e)->
    if e.keyCode is 13
      value = e.target.value
      e.target.value = ""
      @push 'patientStay.data.dischargeTo', value


  $findCreator: (creatorSerial)-> 'me'

  _makeNewPatientStay: ()->
    patientStay = 
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: @patient.serial
      adviseOnly: false
      organizationId: @currentOrganization.idOnServer
      data:
        referredByDoctorName: ''
        admittedByDoctorName: @user.name
        admissionDateTimeStamp: @$mkDate new Date
        admissionType: ''
        advise: ''
        locationHospitalName: ''
        locationDepartment: ''
        locationUnit: ''
        locationWard: ''
        locationBed: ''
        currentLocation: []
        dischargedByDoctorName: ''
        dischargeDatetimeStamp: null
        dischargeReason: []
        dischargeTo: []
    
    @set 'patientStay', patientStay
    @isPatientStayValid = true
    

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  $of: (a, b)->
    unless b of a
      a[b] = null
    return a[b]

  _sortByDate: (a, b)->
    return (b.datetimeStamp - a.datetimeStamp)

  addCustomDischargedPressed:(e)->
    if e.which is 13
      value = e.target.value
      e.target.value = ''
      
      @patientStay.data.dischargeCustomCheckedMap[value] = false
      @push 'patientStay.data.dischargeCustomList', value
  
  patientStayDischargeChanged: (e)->
    { item } = e.model
    value = not @get ('patientStay.data.dischargeCustomCheckedMap.' + item)
    # console.log value
    @set ('patientStay.data.dischargeCustomCheckedMap.' + item), value


  _saveBedInfo: ->
    @patientStay.data.locationHospitalName = @organizationsIBelongToList[@selectedOrganizationIndex].name
    @patientStay.data.locationDepartment = @department.name
    console.log 'saved clinic and dept', @patientStay.data
    # for item in @seatList
    #   if item.patientSerial is @patient.serial
    #     @patientStay.data.locationHospitalName = @organizationsIBelongToList[@selectedOrganizationIndex].name
    #     @patientStay.data.locationDepartment = item.department
    #     @patientStay.data.locationUnit = item.unit
    #     @patientStay.data.locationWard = item.ward
    #     @patientStay.data.locationBed = item.name
    #     break
  
  _validatePatientStayData: (patientStay)->
    if @patientDischarged 
      unless patientStay.data.dischargeDatetimeStamp
        @domHost.showToast 'Discharge Date is required'
        return false
      unless patientStay.data.dischargeReason.length
        @domHost.showToast 'Please specify a discharge reason'
        return false
    else 
      if @advisedAdmission
        # unless patientStay.data.admissionDateTimeStamp
        #   @domHost.showToast 'Admission Date is required'
        #   return false
        # unless patientStay.data.currentLocation.length
        #   @domHost.showToast 'Please spcify patient current location'
        #   return false
      else
        unless patientStay.data.advise
          @domHost.showToast 'Specify Advise to patient'
          return false
    
    return true
  
  savePatientStayPressed: ()->
    return unless @_validatePatientStayData(@patientStay)
    if @advisedAdmission
      @_savePatientStay()
    else
      @_savePatientStayAdviseOnly()


  # _updateVisitForPatientStay: (patientStaySerial)->

  #   if @visit.patientStaySerial is null
  #     @visit.patientStaySerial = patientStaySerial
      
  #   @visit.lastModifiedDatetimeStamp = lib.datetime.now()
  #   app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial

  
  savePatientStayObject: (cbfn)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      patientStayObject: @patientStayObject
    }
    @callApi '/bdemr-organization-patient-stay-set-object', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn() if cbfn

  _savePatientStay: ()->
    # Check if patient Stay serial not logged on current visit object

    if @visit.patientStaySerial is null
      if @patientStay.serial is null
        # Craete a new serial for patient stay object
        @patientStay.serial = @generateSerialForPatientStay()
        @patientStay.createdDatetimeStamp = lib.datetime.now()
        
        # updating current visit object
        @visit.patientStaySerial = @patientStay.serial
        @_saveVisit()
    console.log 'patient stay serial', @patientStay.serial
    @_saveBedInfo()
    
    @patientStay.organizationQueryParameters = {
      selectedOrganizationIndex: @selectedOrganizationIndex
      selectedDepartmentIndex: @selectedDepartmentIndex
      selectedUnitIndex: @selectedUnitIndex
      selectedWardIndex: @selectedWardIndex
    }

    @patientStay.data.admissionDateTimeStamp = (new Date @patientStay.data.admissionDateTimeStamp).getTime()
    if @patientDischarged
      @patientStay.data.dischargeDatetimeStamp = (new Date @patientStay.data.dischargeDatetimeStamp).getTime()
    
    
    # Save Patient Stay data with organization values
    if @organization.idOnServer
      @savePatientStayObject =>
        @patientStay.lastModifiedDatetimeStamp = lib.datetime.now()
        app.db.upsert 'visit-patient-stay', @patientStay, ({serial})=> @patientStay.serial is serial
        @domHost.showToast 'Patient Stay Saved!'
    else
      # Save Patient Stay data without organization values
      @patientStay.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'visit-patient-stay', @patientStay, ({serial})=> @patientStay.serial is serial
      @domHost.showToast 'Patient Stay Saved!'

    # HACK - Force data system to pick up subproperty changes 
    patientStay = @patientStay
    @set 'patientStay', {}
    @set 'patientStay', patientStay

    console.log 'saved patient stay', @patientStay
    @selectedVisitPageIndex = 0
  
  _savePatientStayAdviseOnly: ->
    if @visit.patientStaySerial is null
      if @patientStay.serial is null
        # Craete a new serial for patient stay object
        @patientStay.serial = @generateSerialForPatientStay()
        @patientStay.createdDatetimeStamp = lib.datetime.now()

        # updating current visit object
        @visit.patientStaySerial = @patientStay.serial
        @_saveVisit()

    @patientStay.lastModifiedDatetimeStamp = lib.datetime.now()
    @patientStay.adviseOnly = true
    app.db.upsert 'visit-patient-stay', @patientStay, ({serial})=> @patientStay.serial is serial
    @domHost.showToast 'Patient Stay Saved!'

    # HACK - Force data system to pick up subproperty changes 
    patientStay = @patientStay
    @set 'patientStay', {}
    @set 'patientStay', patientStay

    @selectedVisitPageIndex = 0
  
  _notifyInvalidPatientStay: ->
    @isVisitValid = false
    @domHost.showModalDialog 'Invalid Patient Stay Provided'

  calculateLengthOfStay: (admissionDate, dischargeDate)->
    diff = lib.datetime.diff (new Date dischargeDate), (new Date admissionDate)
    return diff/(1000*60*60*24)

  
  navigatedOut: ->
    @patientStay = {}
    @isPatientStayValid = true
    @selectedView = 0
    @patientStay = null
    @patientStayObject = null
    @organizationsIBelongToList = []
    @selectedOrganizationIndex = null
    @selectedDepartmentIndex = null
    @selectedUnitIndex = null
    @selectedWardIndex = null
    @seatList = []
    @patientDischarged = false
    @advisedAdmission = null

