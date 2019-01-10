Polymer {
  
  is: 'page-quick-patient-medical-info-preview'

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
      value: {}

    patient:
      type: Object
      value: {}

    matchingCurrentMedicineList:
      type: Array
      value: -> []

    currentDiagnosisList:
      type: Array
      value: -> []

  # Helper
  # ================================

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPage '#/patient-manager'

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

  _computeTotalDaysCount: (endDate, startDate)->
    return (@$TRANSLATE("As Needed", @LANG)) unless endDate
    oneDay = 1000*60*60*24;
    startDate = new Date startDate
    diffMs = endDate - startDate
    x =  Math.round(diffMs / oneDay)
    return @$TRANSLATE_NUMBER(x, @LANG)

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

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


  # === For Discharge Note [START] ===

  # Current diagnosis & precedures
  _listCurrentDiagnosis: (patientIdentifier)->
    list = app.db.find 'visit-current-diagnosis', ({patientSerial})=> patientSerial is patientIdentifier
    @set 'currentDiagnosisList', list

  # Current Operation
  _listCurrentOperation: (patientIdentifier)->
    list = app.db.find 'current-operation', ({patientSerial})=> patientSerial is patientIdentifier
    @set 'currentOperationList', list

  # Medication - Current
  _listCurrentMedications: (patientIdentifier) ->
    currentMedicineList = app.db.find 'patient-medications', ({patientSerial, data})->
      # if patientSerial is patientIdentifier and data.status is 'continue'
      if patientSerial is patientIdentifier
        if data.hasOwnProperty "status"
          if data.status is 'continue'
            return true
    medicineList = [].concat currentMedicineList
    medicineList.sort (left, right)->
      return -1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 0

    for medicine in medicineList
      medicine.flags = 
        isLocalOnly: true

    @matchingCurrentMedicineList = medicineList

  # Current Investigation
  _loadAdvisedTest: (patientIdentifier)->
    list = app.db.find 'visit-advised-test', ({patientSerial})-> patientSerial is patientIdentifier

    filteredList = []

    if list.length > 0
      for item in list
        testAdvisedList = item.data.testAdvisedList
        for subItem in testAdvisedList
          object = {}
          object.createdDatetimeStamp = item.createdDatetimeStamp
          object.investigationName = subItem.investigationName
          filteredList.push object

    @currentInvestigationList = filteredList

  # Previous Confirm diagnosis
  _listConfirmedDiagnosis: (patientIdentifier)->
    record = app.db.find 'history-and-physical-record', ({patientSerial})->
      if patientSerial is patientIdentifier
        return true

    confirmedDiagnosisList = []
    
    for item in record
      confirmedDiagnosis = lib.util.findDeepValue 'Confirmed Diagnosis', item
      if confirmedDiagnosis
        checkedValueList = lib.util.findDeepValue 'virtualChildMap', confirmedDiagnosis
        if checkedValueList
          for own key, value of checkedValueList
            diagnosis = {
              createdDatetimeStamp: item.createdDatetimeStamp
              diagnosis: key.split("_")[1]
            }
            confirmedDiagnosisList.push diagnosis
        

    visitDiagnosis = app.db.find 'visit-diagnosis', ({patientSerial})=> patientSerial is patientIdentifier
    diagnosisList = [].concat confirmedDiagnosisList, visitDiagnosis
    
    @set 'confirmedDiagnosisList', diagnosisList

  # Previous Operation Performed
  _listPreviousOperation: (patientIdentifier)->
    list = app.db.find 'previous-operation', ({patientSerial})=> patientSerial is patientIdentifier
    @set 'previousOperationList', list
    

  # === For Discharge Note [END] ===
  
  navigatedIn: ->
    @_loadUser()
    params = @domHost.getPageParams()

    if params['patient']
      @_loadPatient params['patient'], =>
        @_listCurrentMedications params['patient']
        @_listConfirmedDiagnosis params['patient']
        @_loadAdvisedTest params['patient']
        @_listCurrentDiagnosis params['patient']
        @_listCurrentOperation params['patient']
        @_listPreviousOperation params['patient']
    else
      @_notifyInvalidPatient()

    
  _loadUser: ()->
    userList = app.db.find 'user'
    if userList.length is 1
      @set 'user', userList[0]

  _loadPatient: (patientIdentifier, cbfn)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier

    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
      cbfn()
    else
      @_notifyInvalidPatient()

  _notifyInvalidPatient: ->
    @domHost.showModalDialog 'Invalid Patient Provided'

  navigatedOut: ->
    @patient = {}
    @user = {}

}