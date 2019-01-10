
Polymer {

  is: 'page-print-diagnosis'

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

    diagnosis:
      type: Object
      notify: true
      value: null

    isDiagnosisValid:
      type: Boolean
      value: false

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


  _loadUser:()->
    userList = app.db.find 'user'
    # console.log userList
    if userList.length is 1
      @user = userList[0]

      # for employmentDetails in userList[0].employmentDetailsList
      #   @push 'doctorInstitutionList', employmentDetails.institutionName

      # for specializationDetails in userList[0].specializationList
      #   @push 'doctorSpecialityList', specializationDetails.specializationTitle




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


  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient!'

  _notifyInvalidDiagnosis: ->
    @isDiagnosisValid = false
    @domHost.showModalDialog 'Invalid Diagnosis!'


  _loadDiagnosis: (diagnosisSerialIdentifier)->

    list = app.db.find 'diagnosis-record', ({serial})-> serial is diagnosisSerialIdentifier
    if list.length is 1
      @isDiagnosisValid = true
      @diagnosis = list[0]
      console.log @diagnosis
      @_loadPatient @diagnosis.patientSerial
      return true
    else
      @_notifyInvalidDiagnosis()
      return false

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--

    return age



  _isEmpty: (data)->
    if data is 0
      return true
    else
      return false

  _returnSerial: (index)->
    index+1



  navigatedIn: ->

    @_loadUser()

    params = @domHost.getPageParams()

    unless params['diagnosis']
      @_notifyInvalidDiagnosis()
      return
  
    @_loadDiagnosis(params['diagnosis'])
    @settings = @_getSettings()

  navigatedOut: ->
    @visit = {}
    @patient = {}
    @diagnosis = {}
    @isVisitValid = false
    @isPatientValid = false
    @isDiagnosisValid = false


  _formatDateTime: (dateTime)->
    lib.datetime.format(dateTime, 'mmm d, yyyy h:MMTT')

  _formatDate: (dateTime)->
    lib.datetime.format(dateTime, 'mmm d, yyyy')

}
