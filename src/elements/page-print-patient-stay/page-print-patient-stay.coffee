
Polymer {

  is: 'page-print-patient-stay'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
  ]

  properties:

    isVisitValid: 
      type: Boolean
      notify: false
      value: false

    isPatientValid:
      type: Boolean
      notify: false
      value: false      

    user:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null

    visit:
      type: Object
      notify: true
      value: null

    isPatientStayValid:
      type: Boolean
      notify: false
      value: false

    patientStay:
      type: Object
      notify: true
      value: null


    settings:
      type: Object
      notify: true

  _getSettings: ->
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()
    return list[0] if list.length


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
      console.log @user


  _makeNewNextVisit: ()->
    @nextVisit =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: null
      visitSerial: null
      patientSerial: null
      doctorName: null
      doctorSpeciality: null
      data:
        nextVisitDateTimestamp: 0
        priorityType: null

  _makeNewPatientStay: ()->
    @patientStay =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: null
      visitSerial: null
      patientSerial: null
      data:
        typeNameOfTheInstitution: null
        typeOutPatientDischargedAdvised: null
        typeOutPatientAdmissionAdvised: null
        typeEmergencyDischargedAdvised: null
        typeEmergencyAdmissionAdvised: null
        admissionToHospitalName: null
        admissionToDepartment: null
        admissionToDateOfAdmissionDateTimeStamp: 0
        admissionToHospitalName: null
        admissionToLocationDepartment: null
        admissionToLocationNameOfWard: null
        admissionToNameOfBed: null
        admissionToLocationDateOfAdmissionDateTimeStamp: 0
        dischargeDatetimeStamp: 0
        dischargeReason: null
        dischargeReasonGotBetter: null
        dischargeReasonRequireCare: null
        dischargeReasonCurrentCareNotPossible: null
        dischargeReasonNotRequiredStayHospital: null
        dischargeReasonDeath: null
        dischargeToHome: null
        dischargeToRehabilitation: null
        dischargeToMortualry: null
        dischargeToCustom: null

  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  $of: (a, b)->
    unless b of a
      a[b] = null
    return a[b]


  printButtonPressed: (e)->
    window.print()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _makeNewVisit: ()->

    @visit = 
      serial: null
      idOnServer: null
      source: 'local'
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      doctorsPrivateNote: ''
      patientSerial: @patient.serial
      recordType: 'doctor-visit'
      doctorName: @$getFullName(@user.name)
      hospitalName: null
      doctorSpeciality: null
      prescriptionSerial: null
      doctorNotesSerial: null
      nextVisitSerial: null
      advisedTestSerial: null
      patientStaySerial: null
      
    @isVisitValid = true


  _saveVisit: ()->
    @visit.serial = @generateSerialForVisit 'PRSC'
    @visit.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial
    @domHost.modifyCurrentPagePath '#/visit-editor/visit:' + @visit.serial + '/patient:' + @patient.serial
    @domHost.showToast 'Visit Saved'

  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'

  _notifyInvalidVisit: ->
    @isVisitValid = false
    @domHost.showModalDialog 'Invalid Visit Provided'

  _loadVisit: (visitIdentifier)->
    list = app.db.find 'doctor-visit', ({serial})-> serial is visitIdentifier
    if list.length is 1
      @isVisitValid = true
      @visit = list[0]

      unless @visit.patientStaySerial is null
        @_loadVisitPatientStay @visit.patientStaySerial

      return true
    else
      @_notifyInvalidVisit()
      return false

  _loadVisitPatientStay: (patientStaySerial)->
    # console.log patientStaySerial
    list = app.db.find 'visit-patient-stay', ({serial})=> serial is patientStaySerial
    # console.log list

    if list.length is 1
      @isPatientStayValid = true
      @patientStay = list[0]
      # console.log "patientStayObj: ", @patientStay
      return true
    else
      @isPatientStayValid = false
      return false


  createNewPatientStayPressed: (e)->
    params = @domHost.getPageParams()

    if params['visit'] is 'new'
      @_saveVisit()
    @domHost.navigateToPage  '#/patient-stay-editor/visit:' + @visit.serial + '/patient:' + @patient.serial + '/patient-stay:new'


  editPatientStayPressed: (e)->
    @domHost.navigateToPage  '#/patient-stay-editor/visit:' + @visit.serial + '/patient:' + @patient.serial + '/patient-stay:' + @patientStay.serial



  _isEmpty: (data)->
    if data is 0
      return true
    else
      return false

  _isEmptyArray: (data)->
    if data.length is 0
      return true
    else
      return false

  _isEmptyString: (data)->
    if data is null or data is '' or data is 'undefined'
      return true
    else
      return false

  _computeTotalDaysCount: (endDateTimeStamp, startDateTimeStamp)->
    oneDay = 1000*60*60*24;
    diffMs = endDateTimeStamp - startDateTimeStamp
    return Math.round(diffMs/oneDay); 

  _returnSerial: (index)->
    index+1

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

  navigatedIn: ->

    @_loadUser()
    

    params = @domHost.getPageParams()

    @_makeNewPatientStay()

    @_makeNewNextVisit()

    unless params['visit']
      @_notifyInvalidVisit()
      return

    unless params['patient']
      @_notifyInvalidPatient()
      return
    else
      @_loadPatient(params['patient'])


    if params['visit'] is 'new'
      @_makeNewVisit()
    else
      @_loadVisit(params['visit'])


    @settings = @_getSettings()
    console.log @settings

  navigatedOut: ->
    @visit = {}
    @patient = {}
    @patientStay = {}
    @isVisitValid = false
    @isPatientValid = false
    @isPatientStayValid = false

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')

  _formatDate: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy')

}
