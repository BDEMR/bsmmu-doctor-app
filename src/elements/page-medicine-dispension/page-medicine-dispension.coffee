
Polymer {

  is: 'page-medicine-dispension'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
  ]

  properties:     

    user:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null

    organization:
      type: Object
      value: -> null

    selectedSeatsPageIndex:
      type: Number
      notify: true
      value: 0

    matchingMedicationList:
      type: Array
      notify: true
      value: []

    patientStayObject:
      type: Object
      notify: true
      value: -> null

    organizationsIBelongToList:
      type: Array
      value: -> []

    selectedOrganizationIndex:
      type: Number
      value: -> null

    selectedDepartmentIndex:
      type: Number
      value: -> null
      
    selectedUnitIndex:
      type: Number
      value: -> null
      
    selectedWardIndex:
      type: Number
      value: -> null
      
    seatList:
      type: Array
      value: -> []


  navigatedIn: ->
    @_loadUser()
    @_loadOrganizationsIBelongTo()

  navigatedOut: ->

  # Utils
  $notUndefined: (value)-> if value? then true else false

  
  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]


  _returnSerial: (index)->
    index+1


  _sortByDate: (a, b)->
    if a.date < b.date
      return 1
    if a.date > b.date
      return -1

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  $findCreator: (creatorSerial)-> 'me'

  _isEmptyString: (data)->
    if data == null || data == 'undefined' || data == ''
      return true
    else
      return false

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
  

  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

  

  _computeTotalDaysCount: (endDate, startDate)->
    return (@$TRANSLATE("As Needed", @LANG)) unless endDate
    oneDay = 1000*60*60*24;
    startDate = new Date startDate
    diffMs = endDate - startDate
    x =  Math.round(diffMs / oneDay)
    return @$TRANSLATE_NUMBER(x, @LANG)


  # LOAD PATIENT STAY
  # =============================================
  
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
        cbfn() if cbfn
  
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
  
  organizationSelected: (e)->
    @set 'organization', @organizationsIBelongToList[@selectedOrganizationIndex]
    @_loadPatientStayObject @organization.idOnServer, ()=>
      @selectedDepartmentIndex = null
      @selectedUnitIndex = null
      @selectedWardIndex = null
      
  departmentSelected: (e)->
    @department = @patientStayObject.departmentList[@selectedDepartmentIndex]
    @set 'unitList', @department.unitList
    @selectedUnitIndex = null
    @selectedWardIndex = null
      
  unitSelected: (e)->
    @unit = @department.unitList[@selectedUnitIndex]
    @set 'wardList', @unit.wardList
    @selectedWardIndex = null

  wardSelected: (e)->
    @ward = @unit.wardList[@selectedWardIndex]
    seatList = []
    for seat in @patientStayObject.seatList
      continue unless @department.name is seat.department
      continue unless @unit.name is seat.unit
      continue unless @ward.name is seat.ward
      unless seat.patientSerial is null
        seatList.push seat

    @_getPatientMedication seatList, (response)=>
      if response.length
        @set 'matchingMedicationList', response
      else
        @domHost.showToast 'No Data Yet'

  _getPatientMedication: (seatList, cbfn)->
    @isLoading = true

    data = {
      apiKey: @user.apiKey
      seatList
    }

    @callApi '/bdemr-get-patient-current-medications', data, (err, response)=>
      return err if err
      if response.hasError
        @domHost.showModalDialog response.error.message
        @isLoading = false
        return
      else
        @isLoading = false
        cbfn response.data


  #COPY FROM PATINT APP MY-MEDICINE
  _formatDateTime: (dateTimeInMs)->
    lib.datetime.format((new Date dateTimeInMs), 'mmm d, yyyy h:MMTT')

  _getFirstDoseDateTime: (intakeDateTimeStampList)->
    if intakeDateTimeStampList.length isnt 0
      firstDoseValue = intakeDateTimeStampList[0]
      return @_formatDateTime(firstDoseValue)
    return 'Never Taken'

  _getLastDoseDateTime: (intakeDateTimeStampList)->
    if intakeDateTimeStampList.length isnt 0
      lastDoseValue = intakeDateTimeStampList[intakeDateTimeStampList.length-1]
      return @_formatDateTime(lastDoseValue)
    return 'Never Taken'

  _getNextDoseDateTime: (intakeDateTimeStampList, nextDoseDateTimeStamp)->
    if intakeDateTimeStampList.length isnt 0
      nextDoseValue = nextDoseDateTimeStamp
      return @_formatDateTime(nextDoseValue)
    return 'Taken Immediately'

  _getItemDose: (dose)->
    return switch
      when dose is 0.25 then "1/4"
      when dose is 0.50 then "1/2"
      else @$TRANSLATE_NUMBER dose, @LANG
  
  _getDosesLeft: (qty, intakeDateTimeStampListLength)->
    dosesLeft = qty - intakeDateTimeStampListLength
    if dosesLeft > 0
      return dosesLeft
    else
      return 0

  deleteMedicationClicked: (e)->
    { index, item } = e.model
    @domHost.showModalPrompt 'Are you sure to delete this medication', (answer)=>
      if answer
        app.db.remove 'patient-medications', item._id
        app.db.insert 'patient-medications--deleted', { serial: item.serial }
        if item.data.status is 'continue'
          @splice 'medicationList', index, 1
        else
          @splice 'stoppedMedicationList', index, 1


  tookDoseClicked: (e)->
    { index, medicine } = e.model
    e.model.push 'medicine.data.intakeDateTimeStampList', (new Date().getTime())
    intakeValue = e.model.get ['medicine.data.intakeDateTimeStampList', (medicine.data.intakeDateTimeStampList.length - 1)]
    next = new Date intakeValue
    next.setHours (next.getHours() + (e.model.get 'medicine.data.intervalInHours'))
    e.model.set 'medicine.data.nextDoseDateTimeStamp', next.getTime()
    @_updateMedicationData(medicine)

  refillDoseButtonClicked: (e)->
    {item} = e.model
    e.model.set 'item.data.quantityPerPrescription', (item.data.quantityPerPrescription + 10)
    @_updateMedicationData(item)


  isMedicineOverdue: (nextDoseDateTimeStamp)->
    if nextDoseDateTimeStamp < lib.datetime.now()
      return true
    return false

  _updateMedicationData: (prescription)->
    prescription.lastModifiedDatetimeStamp = lib.datetime.now()
    
    data =
      apiKey: @user.apiKey
      prescription: prescription

    @callApi 'bdemr-update-patient-medication-data', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Updated Successfully'

  


}
