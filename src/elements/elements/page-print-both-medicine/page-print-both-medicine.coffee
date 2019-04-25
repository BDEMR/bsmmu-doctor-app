dataURItoBlob = (dataURI) ->
  byteString = atob(dataURI.split(',')[1])
  mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
  ab = new ArrayBuffer(byteString.length)
  ia = new Uint8Array(ab)
  i = 0
  while i < byteString.length
    ia[i] = byteString.charCodeAt(i)
    i++
  blob = new Blob([ ab ], type: mimeString)
  blob

Polymer {

  is: 'page-print-both-medicine'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:



    isPatientValid: 
      type: Boolean
      notify: false
      value: true

    user:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null


    matchingVisitList:
      type: Array
      notify: true
      value: []

    modifiedVisitList:
      type: Array
      notify: true
      value: []

    matchingCurrentMedicineList:
      type: Array
      notify: true
      value: []

    matchingOldMedicineList:
      type: Array
      notify: true
      value: []


    localDataUriDb:
      type: Object
      value: null

    maximumImageSizeAllowedInBytes: 
      type: Number
      value: 10 * 1000 * 1000

    maximumLocalDataUriDbSizeInChars: 
      type: Number
      value: 2 * 1000 * 1000

    localDataUsedPercentage:
      type: Number
      value: 0
      
    settings:
      type: Object
      notify: true

  ## SETTINGS ======================================================================================

  _makeSettings: ->
    settings = 
      serial: 'only'
      isSyncEnabled: false
      printDecoration: 
        leftSideLine1: 'My Institution'
        leftSideLine2: 'My Institution Address'
        leftSideLine3: 'My Institution Contact'
        rightSideLine1: 'My Name'
        rightSideLine2: 'My Degrees'
        rightSideLine3: 'My Contact'
        footerLine: 'A simple message on the bottom'
        logoDataUri: null
      billingTargetEmailAddress: ''
      nsqipTargetEmailAddress: ''
      monetaryUnit: 'BDT'

  _getSettings: ->
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()
    return list[0] if list.length

 
  # Helper
  # ================================

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  $findCreator: (creatorSerial)-> 'me'

  _isEmptyString: (data)->
    if data == null || data == 'undefined' || data == ''
      return true
    else
      return false

  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

  _computeTotalDaysCount: (endDate, startDate)->
      return 'As Needed' unless endDate
      oneDay = 1000*60*60*24;
      startDate = new Date startDate
      diffMs = endDate - startDate
      return Math.round(diffMs / oneDay)

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

  printButtonPressed: (e)->
    window.print()

  _sortByDate: (a, b)->
    if a.date < b.date
      return 1
    if a.date > b.date
      return -1

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')

  _returnSerial: (index)->
    index+1

  getDoctorSpeciality: () ->
    unless @user.specializationList.length is 0
      return @user.specializationList[0].specializationTitle

  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  _notifyInvalidPatient: ->
    @isPatientValid = false
    @showModal 'Invalid Patient Provided'


  navigatedIn: ->

    params = @domHost.getPageParams()

    @_loadUser()
    @set 'selectedMedicinePage', 0
    
    
    if params['patient']
      @_loadPatient params['patient']
    else
      @_notifyInvalidPatient()

    if @isPatientValid
      @_listVisits()

    @_listCurrentMedications(params['patient'])
    @_listOldMedications(params['patient'])

    @settings = @_getSettings()      

  navigatedOut: ->
    @patient = null
    @isPatientValid = false
    
    @matchingCurrentMedicineList = []
    @matchingOldMedicineList = []

    @patient = null

  
  # Visits [START]
  # ================================

  _listVisits: ->

    doctorVisitList = app.db.find 'doctor-visit', ({patientSerial})=> @patient.serial is patientSerial

    visitList = [].concat doctorVisitList

    for visit in visitList
      if visit.prescriptionSerial isnt null
        @push 'modifiedVisitList', @_makeVisitRecordForReportType visit, 'Prescription', visit.prescriptionSerial


  _makeVisitRecordForReportType: (visitObject, visitRecordTypeName, visitRecordTypeSerial) ->
    modifiedVisitObject = {
      serial: visitObject.serial
      createdDatetimeStamp: visitObject.createdDatetimeStamp
      hospitalName: visitObject.hospitalName
      doctorName: visitObject.doctorName
      doctorSpeciality: visitObject.doctorSpeciality
      recordTypeSerial: visitRecordTypeSerial
      recordTypeName: visitRecordTypeName
    }

    return modifiedVisitObject


  # Medication - Current [START]
  # ================================

  _listCurrentMedications: (patientIdentifier) ->
    currentMedicineList = app.db.find 'patient-medications', ({patientSerial, data})->
      if patientSerial is patientIdentifier and data.status is 'continue'
        return true

    # console.log currentMedicineList

    medicineList = [].concat currentMedicineList
    medicineList.sort (left, right)->
      return -1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 0

    for medicine in medicineList
      medicine.flags = 
        isLocalOnly: true

    @matchingCurrentMedicineList = medicineList


  # === Medication - Current [END] ===



  # Medication - Old [START]
  # ================================

  _listOldMedications: (patientIdentifier) ->
    oldMedicineList = app.db.find 'patient-medications', ({patientSerial, data})->
      if patientSerial is patientIdentifier and data.status is 'stopped'
        return true

    medicineList = [].concat oldMedicineList
    medicineList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for medicine in medicineList
      medicine.flags = 
        isLocalOnly: true

    @matchingOldMedicineList = medicineList

  # === Medication - Old [END] ===



  ready: ()->


}
