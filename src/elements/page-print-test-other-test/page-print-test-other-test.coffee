

Polymer {

  is: 'page-print-test-other-test'

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

    matchingOtherTestList:
      type: Array
      notify: true
      value: []
    matchingVitalPulseRateList:
      type: Array
      notify: true
      value: []

    matchingVitalBMIList:
      type: Array
      notify: true
      value: []

    matchingVitalRespiratoryRateList:
      type: Array
      notify: true
      value: []

    matchingVitalSpO2List:
      type: Array
      notify: true
      value: []

    matchingVitalTemperatureList:
      type: Array
      notify: true
      value: []

    settings:
      type: Object
      notify: true

  

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
    # @set 'selectedMedicinePage', 0
    @set 'selectedVitalPage', 0
    # @set 'selectedTestPage', 0
    # @set 'selectedTestPage', 0
    # @set 'selectedCommentPage', 0
    # @set 'matchingVisitList', []
    # @set 'modifiedVisitList', []
    
    
    if params['patient']
      @_loadPatient params['patient']
    else
      @_notifyInvalidPatient()

    # if @isPatientValid
    #   @_listVisits()

    # @_listCurrentMedications(params['patient'])
    # @_listOldMedications(params['patient'])
    # @_listVitalBloodPressure(params['patient'])
    # @_listVitalPulseRate(params['patient'])
    # @_listVitalBMI(params['patient'])
    # @_listVitalRespiratoryRate(params['patient'])
    # @_listVitalSpO2(params['patient'])
    # @_listVitalTemperature(params['patient'])
    # @_listTestBloodSugar(params['patient'])
    @_listOtherTest(params['patient'])
    # @_listDoctorComment(params['patient'])
    # @_listPatientComment(params['patient'])

    # @_makeDoctorComment()

    # @_openLocalDataUriDb()
    # @_makeBlankAttachment()
    # @_loadAttachmentList()
    # @_updateSpaceCalculation()
    
    @settings = @_getSettings() 

  navigatedOut: ->
    @patient = null
    @isPatientValid = false
    
    # @matchingVisitList = []
    # @modifiedVisitList = []
    # @matchingCurrentMedicineList = []
    # @matchingOldMedicineList = []
    # @matchingVitalBloodPressureList = []
    # @matchingVitalPulseRateList = []
    # @matchingVitalBMIList = []
    # @matchingVitalRespiratoryRateList = []
    # @matchingVitalSpO2List = []
    # @matchingVitalTemperatureList = []

    # @matchingPatientCommentList = []
    # @matchingDoctorCommentList = []

    # @matchingTestBloodSugarList = []
    @matchingOtherTestList = []
    @patient = null

  
  # Visits [START]
  # ================================

  # _listVisits: ->

  #   doctorVisitList = app.db.find 'doctor-visit', ({patientSerial})=> @patient.serial is patientSerial

  #   visitList = [].concat doctorVisitList

  #   for visit in visitList
  #     if visit.prescriptionSerial isnt null
  #       @push 'modifiedVisitList', @_makeVisitRecordForReportType visit, 'Prescription', visit.prescriptionSerial

  #   #   if visit.doctorNoteSerial isnt null
  #   #     @push 'modifiedVisitList', @_makeVisitRecordForReportType visit, 'Doctor Note', visit.doctorNoteSerial

  #   #   if visit.nextVisitSerial isnt null
  #   #     @push 'modifiedVisitList', @_makeVisitRecordForReportType visit, 'Next Visit', visit.nextVisitSerial

  #   #   if visit.advisedTestSerial isnt null
  #   #     @push 'modifiedVisitList', @_makeVisitRecordForReportType visit, 'Test Advised', visit.advisedTestSerial

  #   # @modifiedVisitList.sort (left, right)->
  #   #   return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #   #   return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #   #   return 0


    # @matchingVisitList = @modifiedVisitList

  # _makeVisitRecordForReportType: (visitObject, visitRecordTypeName, visitRecordTypeSerial) ->
  #   modifiedVisitObject = {
  #     serial: visitObject.serial
  #     createdDatetimeStamp: visitObject.createdDatetimeStamp
  #     hospitalName: visitObject.hospitalName
  #     doctorName: visitObject.doctorName
  #     doctorSpeciality: visitObject.doctorSpeciality
  #     recordTypeSerial: visitRecordTypeSerial
  #     recordTypeName: visitRecordTypeName
  #   }

  #   return modifiedVisitObject

  # visitReportPrintPreviewBtnPressed: (e)->
  #   @domHost.showToast 'Work in Progress!'


  # createNewVisitPressed: (e)->
  #   @domHost.navigateToPage  '#/visit-editor/visit:new/patient:' + @patient.serial

  # printCurrentMedicinePressed: (e)->
  #   @domHost.navigateToPage  '#/print-current-medicine/patient:' + @patient.serial

  # printOldMedicinePressed: (e)->
  #   @domHost.navigateToPage  '#/print-old-medicine/patient:' + @patient.serial

  # printBothMedicinePressed: (e)->
  #   @domHost.navigateToPage  '#/print-both-medicine/patient:' + @patient.serial

  # printVitalBPPressed: (e)->
  #   @domHost.navigateToPage  '#/print-vital-bp/patient:' + @patient.serial

  # printVitalPRPressed: (e)->
  #   @domHost.navigateToPage  '#/print-vital-pr/patient:' + @patient.serial

  # viewVisitPressed: (e)->
  #   el = @locateParentNode e.target, 'PAPER-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#visit-list-repeater'

  #   index = repeater.indexForElement el
  #   visit = @matchingVisitList[index]

  #   @domHost.navigateToPage '#/visit-editor/patient:' + @patient.serial + '/visit:' + visit.serial 

  # duplicateVisitPressed: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#visit-list-repeater'

  #   index = repeater.indexForElement el
  #   visit = @matchingVisitList[index]

  #   @domHost.showModalDialog 'TODO'

  # deleteVisitPressed: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#visit-list-repeater'

  #   index = repeater.indexForElement el
  #   visit = @matchingVisitList[index]
  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       app.db.remove 'doctor-visit', visit._id
  #       @_listVisits()

  # visitCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdList = (item for item in @matchingVisitList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingVisitList = filterdList
  
  # visitSearchClearButtonClicked: (e)->
  #   @_listVisits()

  # computeVisitFilter: (searchString)->
  #   if !searchString
  #     return null
  #   else
  #     return (item)->
  #       searchString = searchString.toLowerCase()
  #       hospital = if item.hospitalName then item.hospitalName.toLowerCase() else ''
  #       nameOfDoctor = if item.doctorName then item.doctorName.toLowerCase() else ''
  #       specialty = if item.doctorSpeciality then item.doctorSpeciality.toLowerCase() else ''
  #       recordTypeName = if item.recordTypeName then item.recordTypeName.toLowerCase() else ''

  #       regex = new RegExp "\\b#{searchString}", 'gi'
  #       if ((hospital.search regex) isnt -1) or ((nameOfDoctor.search regex) isnt -1) or ((specialty.search regex) isnt -1)or ((recordTypeName.search regex) isnt -1)
  #         return true

  # # === Visit [END] ===




  # # Medication - Current [START]
  # # ================================

  # _listCurrentMedications: (patientIdentifier) ->
  #   currentMedicineList = app.db.find 'patient-medications', ({patientSerial, data})->
  #     if patientSerial is patientIdentifier and data.status is 'continue'
  #       return true

  #   console.log currentMedicineList

  #   medicineList = [].concat currentMedicineList
  #   medicineList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 0

  #   for medicine in medicineList
  #     medicine.flags = 
  #       isLocalOnly: true

  #   @matchingCurrentMedicineList = medicineList


  # # === Medication - Current [END] ===



  # # Medication - Old [START]
  # # ================================

  # _listOldMedications: (patientIdentifier) ->
  #   oldMedicineList = app.db.find 'patient-medications', ({patientSerial, data})->
  #     if patientSerial is patientIdentifier and data.status is 'stopped'
  #       return true

  #   medicineList = [].concat oldMedicineList
  #   medicineList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   for medicine in medicineList
  #     medicine.flags = 
  #       isLocalOnly: true

  #   @matchingOldMedicineList = medicineList

  # # === Medication - Old [END] ===


  # Vitals
  # ================================

  # _addVitalsButtonClicked: ->
  #   @domHost.navigateToPage '#/patient-vitals-editor/patient:' + @patient.serial


  # Vital - Blood Pressure [START]
  # ================================

  # _listVitalBloodPressure: (patientIdentifier) ->
  #   vitalBloodPressureList = app.db.find 'patient-vitals-blood-pressure', ({patientSerial})=> @patient.serial is patientSerial

  #   vitalList = [].concat vitalBloodPressureList
  #   vitalList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   @matchingVitalBloodPressureList = vitalList

  #   params = @domHost.getPageParams()

  #   if params['startDate'] isnt 'null' and params['startDate'] isnt 'undefined' and params['endDate'] isnt 'null' and params['endDate'] isnt 'undefined'
  #     startDate = new Date params['startDate']
  #     endDate = new Date params['endDate']

  #     endDate.setHours 24 + endDate.getHours()
  #     filterdBPList = (item for item in @matchingVitalBloodPressureList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #     @matchingVitalBloodPressureList = filterdBPList

  # addBloodPressureItemClicked: ->
  #   @domHost.navigateToPage '#/vital-blood-pressure/patient:' + @patient.serial + '/vital:new'

  # editBloodPressureItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-blood-pressure-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalBloodPressureList[index]

  #   @domHost.navigateToPage '#/vital-blood-pressure/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteBloodPressureItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-blood-pressure-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalBloodPressureList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-blood-pressure', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-blood-pressure', id
  #       app.db.insert 'patient-vitals-blood-pressure--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalBloodPressure(params['patient'])

  # bloodPressureCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdBPList = (item for item in @matchingVitalBloodPressureList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingVitalBloodPressureList = filterdBPList
  
  # bloodPressureSearchClearButtonClicked: (e)->
  #   params = @domHost.getPageParams()
  #   @_listVitalBloodPressure(params['patient'])


  # === Vital - Blood Pressure [END] ===


  # # Vital - Pulse Rate
  # # ================================

  # _listVitalPulseRate: (patientIdentifier) ->
  #   vitalPulseRateList = app.db.find 'patient-vitals-pulse-rate', ({patientSerial})=> @patient.serial is patientSerial

  #   vitalList = [].concat vitalPulseRateList
  #   vitalList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   for vital in vitalList
  #     vital.flags = 
  #       isLocalOnly: true

  #   @matchingVitalPulseRateList = vitalList


  # addPulseRateItemClicked: ->
  #   @domHost.navigateToPage '#/vital-pulse-rate/patient:' + @patient.serial + '/vital:new'

  # editPulseRateItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-pulse-rate-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalPulseRateList[index]

  #   @domHost.navigateToPage '#/vital-pulse-rate/patient:' + @patient.serial + '/vital:' + vital.serial

  # deletePulseRateItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-pulse-rate-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalPulseRateList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-pulse-rate', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-pulse-rate', id
  #       app.db.insert 'patient-vitals-pulse-rate--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalPulseRate(params['patient'])

  # pulseRateCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdList = (item for item in @matchingVitalPulseRateList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingVitalPulseRateList = filterdList
  
  # pulseRateSearchClearButtonClicked: (e)->
  #   params = @domHost.getPageParams()
  #   @_listVitalPulseRate(params['patient'])

  # # === Vital - Pulse Rate [END] ===



  # # Vital - BMI [START]
  # # ================================

  # _listVitalBMI: (patientIdentifier) ->
  #   vitalBMIList = app.db.find 'patient-vitals-bmi', ({patientSerial})=> @patient.serial is patientSerial

  #   vitalList = [].concat vitalBMIList
  #   vitalList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   for vital in vitalList
  #     vital.flags = 
  #       isLocalOnly: true

  #   @matchingVitalBMIList = vitalList

  # addBMIItemClicked: ->
  #   @domHost.navigateToPage '#/vital-bmi/patient:' + @patient.serial + '/vital:new'

  # editBMIItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-bmi-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalBMIList[index]

  #   @domHost.navigateToPage '#/vital-bmi/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteBMIItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-pulse-rate-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalBMIList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-bmi', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-bmi', id
  #       app.db.insert 'patient-vitals-bmi--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalBMI(params['patient'])

  # _calculateBMIVerdict: (result)->
  #   if result is 0 or not result
  #     return 'Pending'
  #   else if result < 18.5
  #     return 'Underweight'
  #   else if 18.5 <= result < 24.9
  #     return 'Normal'
  #   else if 25 <= result < 29.9
  #     return 'Overweight'
  #   else
  #     return 'Obese'

  # isHeightCmOrM: (unit)-> 
  #   return true unless unit is 'ft/inch'
  # isHeightFtInch: (unit)->
  #   return true if unit is 'ft/inch'


  # BMICustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdList = (item for item in @matchingVitalBMIList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingVitalBMIList = filterdList
  
  # BMISearchClearButtonClicked: (e)->
  #   params = @domHost.getPageParams()
  #   @_listVitalBMI(params['patient'])

  # # === Vital - BMI [END] ===



  # # Vital - Respiratory Rate [START]
  # # ================================
  # _listVitalRespiratoryRate: (patientIdentifier) ->
  #   vitalRespiratoryRateList = app.db.find 'patient-vitals-respiratory-rate', ({patientSerial})=> @patient.serial is patientSerial

  #   vitalList = [].concat vitalRespiratoryRateList
  #   vitalList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   for vital in vitalList
  #     vital.flags = 
  #       isLocalOnly: true

  #   @matchingVitalRespiratoryRateList = vitalList


  # addRespiratoryRateItemClicked: ->
  #   @domHost.navigateToPage '#/vital-respiratory-rate/patient:' + @patient.serial + '/vital:new'

  # editRespiratoryRateItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-respiratory-rate-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalRespiratoryRateList[index]

  #   @domHost.navigateToPage '#/vital-respiratory-rate/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteRespiratoryRateItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-respiratory-rate-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalRespiratoryRateList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-respiratory-rate', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-respiratory-rate', id
  #       app.db.insert 'patient-vitals-respiratory-rate--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalRespiratoryRate(params['patient'])

  # respiratoryRateCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdList = (item for item in @matchingVitalRespiratoryRateList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingVitalRespiratoryRateList = filterdList
  
  # respiratoryRateSearchClearButtonClicked: (e)->
  #   params = @domHost.getPageParams()
  #   @_listVitalRespiratoryRate(params['patient'])

  # # === Vital - Respirator Rate [END] ===



  # # Vital - SpO2
  # # ================================

  # _listVitalSpO2: (patientIdentifier) ->
  #   vitalSpO2List = app.db.find 'patient-vitals-spo2', ({patientSerial})=> @patient.serial is patientSerial

  #   vitalList = [].concat vitalSpO2List
  #   vitalList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   for vital in vitalList
  #     vital.flags = 
  #       isLocalOnly: true

  #   @matchingVitalSpO2List = vitalList

  # addSpO2ItemClicked: ->
  #   @domHost.navigateToPage '#/vital-spo2/patient:' + @patient.serial + '/vital:new'

  # editSpO2ItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-spo2-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalSpO2List[index]

  #   @domHost.navigateToPage '#/vital-spo2/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteSpO2ItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-spo2-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalSpO2List[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-spo2', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-spo2', id
  #       app.db.insert 'patient-vitals-spo2--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalSpO2(params['patient'])

  # spO2CustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdList = (item for item in @matchingVitalSpO2List when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingVitalSpO2List = filterdList
  
  # spO2SearchClearButtonClicked: (e)->
  #   params = @domHost.getPageParams()
  #   @_listVitalSpO2(params['patient'])

  # # === Vital - SpO2 [END] ===



  # # Vital - Temperature [START]
  # # ================================

  # _listVitalTemperature: (patientIdentifier) ->
  #   vitalTemperatureList = app.db.find 'patient-vitals-temperature', ({patientSerial})=> @patient.serial is patientSerial

  #   vitalList = [].concat vitalTemperatureList
  #   vitalList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   for vital in vitalList
  #     vital.flags = 
  #       isLocalOnly: true

  #   @matchingVitalTemperatureList = vitalList

  # addTemperatureItemClicked: ->
  #   @domHost.navigateToPage '#/vital-temperature/patient:' + @patient.serial + '/vital:new'

  # editTemperatureItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-temperature-list-repeater'

  #   index = repeater.indexForElement el
  #   vital = @matchingVitalTemperatureList[index]

  #   @domHost.navigateToPage '#/vital-temperature/patient:' + @patient.serial + '/vital:' + vital.serial

  # deleteTemperatureItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#vital-temperature-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   vital = @matchingVitalTemperatureList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-vitals-temperature', ({serial})-> serial is vital.serial)[0]._id
  #       app.db.remove 'patient-vitals-temperature', id
  #       app.db.insert 'patient-vitals-temperature--deleted', { serial: vital.serial }
  #       @domHost.showToast 'Vital Deleted!'
  #       @_listVitalTemperature(params['patient'])

  # temperatureCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdList = (item for item in @matchingVitalTemperatureList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingVitalTemperatureList = filterdList
  
  # temperatureSearchClearButtonClicked: (e)->
  #   params = @domHost.getPageParams()
  #   @_listVitalTemperature(params['patient'])

  # # === Vital - Temperature [END] ===


  # # Test - Blood Sugar [START]
  # # ================================

  # _listTestBloodSugar: (patientIdentifier) ->
  #   testBloodSugarList = app.db.find 'patient-test-blood-sugar', ({patientSerial})=> @patient.serial is patientSerial
  #   testList = [].concat testBloodSugarList
  #   testList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   for test in testList
  #     test.flags = 
  #       isLocalOnly: true

  #   @matchingTestBloodSugarList = testList

  #   params = @domHost.getPageParams()

  #   if params['startDate'] isnt 'null' and params['startDate'] isnt 'undefined' and params['endDate'] isnt 'null' and params['endDate'] isnt 'undefined'
  #     startDate = new Date params['startDate']
  #     endDate = new Date params['endDate']

  #     endDate.setHours 24 + endDate.getHours()
  #     filterdBSList = (item for item in @matchingTestBloodSugarList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #     @matchingTestBloodSugarList = filterdBSList

  # addBloodSugarItemClicked: ->
  #   @domHost.navigateToPage '#/test-blood-sugar/patient:' + @patient.serial + '/test:new'

  # editBloodSugarItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#test-blood-sugar-list-repeater'

  #   index = repeater.indexForElement el
  #   test = @matchingTestBloodSugarList[index]

  #   @domHost.navigateToPage '#/test-blood-sugar/patient:' + @patient.serial + '/test:' + test.serial

  # deleteBloodSugarItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#test-blood-sugar-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   test = @matchingTestBloodSugarList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-test-blood-sugar', ({serial})-> serial is test.serial)[0]._id
  #       app.db.remove 'patient-test-blood-sugar', id
  #       app.db.insert 'patient-test-blood-sugar--deleted', { serial: test.serial }
  #       @domHost.showToast 'Test Deleted!'
  #       @_listTestBloodSugar(params['patient'])

  # bloodSugarCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdList = (item for item in @matchingTestBloodSugarList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingTestBloodSugarList = filterdList
  
  # bloodSugarSearchClearButtonClicked: (e)->
  #   params = @domHost.getPageParams()
  #   @_listTestBloodSugar(params['patient'])

  # # === Test - Blood Sugar [END] ===


  # # Test - Other Test
  # # ================================

  _listOtherTest: (patientIdentifier) ->
    testOtherList = app.db.find 'patient-test-other', ({patientSerial})=> @patient.serial is patientSerial
    testList = [].concat testOtherList
    testList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for test in testList
      test.flags = 
        isLocalOnly: true

    @matchingOtherTestList = testList


    params = @domHost.getPageParams()

    if params['startDate'] isnt 'null' and params['startDate'] isnt 'undefined' and params['endDate'] isnt 'null' and params['endDate'] isnt 'undefined'
      startDate = new Date params['startDate']
      endDate = new Date params['endDate']

      endDate.setHours 24 + endDate.getHours()
      filterdOtherTestList = (item for item in @matchingOtherTestList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
      @matchingOtherTestList = filterdOtherTestList

  # addOtherTestItemClicked: ->
  #   @domHost.navigateToPage '#/other-test/patient:' + @patient.serial + '/test:new'

  # editOtherTestItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#other-test-list-repeater'

  #   index = repeater.indexForElement el
  #   test = @matchingOtherTestList[index]

  #   @domHost.navigateToPage '#/other-test/patient:' + @patient.serial + '/test:' + test.serial

  # deleteOtherTestItemClicked: (e)->
  #   el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
  #   el.opened = false
  #   repeater = @$$ '#other-test-list-repeater'
  #   params = @domHost.getPageParams()

  #   index = e.model.index
  #   test = @matchingOtherTestList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'patient-test-other', ({serial})-> serial is test.serial)[0]._id
  #       app.db.remove 'patient-test-other', id
  #       app.db.insert 'patient-test-other--deleted', { serial: test.serial }
  #       @domHost.showToast 'Test Deleted!'
  #       @_listOtherTest(params['patient'])

  # otherTestCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 24 + endDate.getHours()
  #   filterdList = (item for item in @matchingOtherTestList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
  #   @matchingOtherTestList = filterdList
  
  
  # otherTestsSearchClearButtonClicked: ()->
  #   params = @domHost.getPageParams()
  #   @_listOtherTest(params['patient'])


  # computeOtherTestFilter: (otherTestSearchString)->
  #   if !otherTestSearchString
  #     return null
  #   else
  #     return (item)->
  #       searchString = otherTestSearchString.toLowerCase()
  #       name = if item.name then item.name.toLowerCase() else ''
  #       institution = if item.institution then item.institution.toLowerCase() else ''

  #       regex = new RegExp "\\b#{searchString}", 'gi'
  #       if ((name.search regex) isnt -1) or ((institution.search regex) isnt -1)
  #         return true

  # # === Test - Other Test [END] ===


  # # Comment - Patient [START]
  # # ================================

  # _listPatientComment: (patientIdentifier) ->
  #   patientCommentList = app.db.find 'comment-patient', ({patientSerial})=> patientIdentifier is patientSerial
  #   commentList = [].concat patientCommentList
  #   commentList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   @matchingPatientCommentList = commentList

  # # === Comment - Patient [END] ===


  # # Comment - Doctor [START]
  # # ================================

  # _listDoctorComment: (patientIdentifier) ->
  #   doctorCommentList = app.db.find 'comment-doctor', ({patientSerial})=> patientSerial is patientIdentifier
  #   commentList = [].concat doctorCommentList

  #   commentList.sort (left, right)->
  #     return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
  #     return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
  #     return 0

  #   @matchingDoctorCommentList = commentList

  # _makeDoctorComment:() ->
  #   @doctorCommentMessage =
  #     serial: null
  #     createdDatetimeStamp: 0
  #     lastModifiedDatetimeStamp: 0
  #     lastSyncedDatetimeStamp: 0
  #     patientSerial: @patient.serial
  #     doctorSerial: @user.serial
  #     doctorName: @$getFullName(@user.name)
  #     doctorSpeciality: @getDoctorSpeciality()
  #     data:
  #       message: ''
      

  # _saveDoctorCommentMessage: (data)->
  #   app.db.upsert 'comment-doctor', data, ({serial})=> data.serial is serial


  # addCommentButtonClicked: (e) ->
  
  #   @doctorCommentMessage.serial = @generateSerialForCommentMessage 'DCT'
  #   @doctorCommentMessage.createdDatetimeStamp = lib.datetime.now()
  #   @_saveDoctorCommentMessage @doctorCommentMessage
  #   @domHost.showToast 'Comment Added!'
  #   @_makeDoctorComment()
  #   @_listDoctorComment(@patient.serial)


  # deleteUserCommentItemClicked: (e)->

  #   index = e.model.index
  #   comment = @matchingDoctorCommentList[index]

  #   @domHost.showModalPrompt 'Are you sure?', (answer)=>
  #     if answer is true
  #       id = (app.db.find 'comment-doctor', ({serial})-> serial is comment.serial)[0]._id

  #       app.db.remove 'comment-doctor', id

  #       @domHost.showToast 'Comment Deleted!'
  #       @_listDoctorComment(@patient.serial)


  # # === Comment - Doctor [END] ===



  # # Gallary [START]
  # # ================================

  # _updateSpaceCalculation: ->
  #   if @localDataUriDb
  #     taken = @localDataUriDb.computeTotalSpaceTaken()
  #     used = 1 - ((@maximumLocalDataUriDbSizeInChars - taken) / @maximumLocalDataUriDbSizeInChars)
  #     @localDataUsedPercentage = Math.floor ((used) * 100)

  # _openLocalDataUriDb: ->

  #   localDataUriDb = new lib.DatabaseEngine {
  #     name: 'local-data-uri-db'
  #     storageEngine: lib.localStorage
  #     serializationEngine: lib.json
  #     config:
  #       commitDelay: 0
  #   }

  #   localDataUriDb.initializeDatabase { removeExisting: false }

  #   localDataUriDb.defineCollection {
  #     name: 'local-attachment'
  #   }

  #   @localDataUriDb = localDataUriDb

  #   sessionDataUriDb = new lib.DatabaseEngine {
  #     name: 'session-data-uri-db'
  #     storageEngine: lib.tabStorage
  #     serializationEngine: lib.json
  #     config:
  #       commitDelay: 0
  #   }

  #   sessionDataUriDb.initializeDatabase { removeExisting: false }

  #   sessionDataUriDb.defineCollection {
  #     name: 'local-attachment'
  #   }

  #   @sessionDataUriDb = sessionDataUriDb

  
  
  # _makeBlankAttachment: ->
  #   @set 'newAttachment', {
  #     title: ''
  #     description: ''
  #     dataUri: ''
  #     originalName: null 
  #     originalType: null
  #     sizeInBytes: 0
  #     sizeInChars: 0
  #     isImage: false
  #     isLoaded: false
  #     progress: 0
  #   }

  # _loadAttachmentList: ->

  #   # unless 'attachmentList' of @record.content.attachment
  #   #   @record.content.attachment.attachmentList = []
    
  #   localAttachmentList = app.db.find 'patient-gallery--local-attachment'
  #   onlineAttachmentList = app.db.find 'patient-gallery--online-attachment'
  #   uploadedFileList = []

  #   lib.util.iterate onlineAttachmentList, (next, index, item)=>
  #     @callApi 'bdemr/get-uploaded-file', {attachmentId: item.attachmentId}, (err, response)=>
  #       if response.hasError
  #         @domHost.showModalDialog response.error.message
  #       else
  #         uploadedFileList.push response.data
  #         next()
  #   .finally =>
  #     attachmentList = [].concat localAttachmentList, uploadedFileList
  #     @set 'attachmentList', attachmentList
    

  # _saveAttachment: (attachment)->
  #   app.db.upsert 'patient-gallery--local-attachment', attachment, ({serial})=> attachment.serial is serial
  

    

  # $toMega: (value)-> (Math.ceil ((value / 1000 / 1000) * 100)) / 100

  # $getImageSrc: (attachment)->
  #   if attachment.mainStorage is 'local'
  #     list = @localDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial
  #     if list.length > 0
  #       return list[0].dataUri
  #     else
  #       return 'assets/not-found.png'
  #   else if attachment.mainStorage is 'server'
  #     return attachment.dataURI
  #   else if attachment.mainStorage is 'session'
  #     list = @sessionDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial
  #     if list.length > 0
  #       return list[0].dataUri
  #     else
  #       return 'assets/not-found.png'


  # fileInputChanged: (e)->
  #   reader = new FileReader
  #   file = e.target.files[0]

  #   if file.size > @maximumImageSizeAllowedInBytes
  #     @domHost.showModalDialog "Please provide a file less than #{Math.floor(@maximumImageSizeAllowedInBytes / 1000 / 1000)}mb in size."
  #     return

  #   reader.readAsDataURL file

  #   reader.onprogress = (e)=>
  #     @set 'newAttachment.progress', ((e.loaded / e.total) * 100)

  #   reader.onload = =>
  #     dataUri = reader.result
  #     @set 'newAttachment.isImage', file.type.indexOf('image/') > -1

  #     @set 'newAttachment.sizeInBytes', file.size
  #     @set 'newAttachment.title', file.name
  #     @set 'newAttachment.dataUri', dataUri
  #     @set 'newAttachment.originalType',  file.type
  #     @set 'newAttachment.originalName', file.name
  #     @set 'newAttachment.sizeInChars', dataUri.length
      
  #     @set 'newAttachment.isLoaded', true

  # _prepareAtachment: ->
  #   { 
  #     title
  #     description
  #     dataUri
  #     isImage
  #     originalName
  #     originalType
  #     sizeInBytes
  #     sizeInChars
  #   } = @newAttachment

  #   attachment = {
  #     serial: @generateSerialForAttachment()
  #     mainStorage: null # could be 'server' or 'local' or 'session'
  #     title
  #     description
  #     # dataUri
  #     isImage
  #     originalName
  #     originalType
  #     sizeInBytes
  #     sizeInChars
  #   }

  #   return attachment

  # uploadPressed: (e)->
  #   # @domHost.showModalDialog 'Feature Coming Soon...'
  #   attachment = @_prepareAtachment()
  #   attachment.mainStorage = 'server'
  #   attachment.apiKey = (app.db.find 'user')[0].apiKey
  #   attachment.dataURI = @newAttachment.dataUri

  #   @callApi 'bdemr/file-uploader', attachment, (err, response)=>
  #     if response.hasError
  #       @domHost.showModalDialog response.error.message
  #     else
  #       @push 'attachmentList', attachment
  #       app.db.upsert 'patient-gallery--online-attachment', {serial: attachment.serial, attachmentId: response.data.attachmentId}, ({serial})=> attachment.serial is serial
  #       @_makeBlankAttachment()


  # saveLocallyPressed: (e)->
  #   attachment = @_prepareAtachment()
  #   attachment.mainStorage = 'local' 

  #   uploadData = {
  #     attachmentSerial: attachment.serial
  #     dataUri: @newAttachment.dataUri
  #   }

  #   currentSize = @localDataUriDb.computeTotalSpaceTaken()
  #   maxSize = @maximumLocalDataUriDbSizeInChars
  #   sizeLeft = maxSize - currentSize
  #   sizeNeededForThisAttachment = (JSON.stringify uploadData).length

  #   if sizeLeft < sizeNeededForThisAttachment
  #     extraNeeded = sizeNeededForThisAttachment - sizeLeft
  #     message = "Sorry. Can not save image. Your browser needs #{@$toMega(extraNeeded)}MB additional storage."
  #     @domHost.showModalDialog message
  #   else
  #     @localDataUriDb.insert 'local-attachment', uploadData
  #     @push 'attachmentList', attachment
  #     @_saveAttachment attachment
  #     @_makeBlankAttachment()
  #     @_updateSpaceCalculation()
  
  # keepUntilBrowserClosedPressed: (e)->
  #   attachment = @_prepareAtachment()
  #   attachment.mainStorage = 'session' 

  #   uploadData = {
  #     attachmentSerial: attachment.serial
  #     dataUri: @newAttachment.dataUri
  #   }

  #   currentSize = @sessionDataUriDb.computeTotalSpaceTaken()
  #   maxSize = 50 * 1000 * 1000
  #   sizeLeft = maxSize - currentSize
    
  #   sizeNeededForThisAttachment = (JSON.stringify uploadData).length

  #   if sizeLeft < sizeNeededForThisAttachment
  #     extraNeeded = sizeNeededForThisAttachment - sizeLeft
  #     message = "Sorry. Can not save image. Your browser needs #{@$toMega(extraNeeded)}MB additional storage."
  #     @domHost.showModalDialog message
  #   else
  #     try
  #       @sessionDataUriDb.insert 'local-attachment', uploadData  
  #       @push 'attachmentList', attachment
  #       @_makeBlankAttachment()
  #     catch e
  #       message = "Sorry. Can not save image. Your browser do not have enough memory."
  #       @domHost.showModalDialog message

  # deletePressed: (e)->
  #   { attachmentIndex, attachment } = e.model
  #   if attachment.mainStorage is 'local'
  #     attachmentData = (@localDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial)
  #     if attachmentData.length > 0
  #       @localDataUriDb.remove 'local-attachment', attachmentData[0]._id
  #     app.db.remove 'patient-gallery--local-attachment', attachment._id
  #     @splice 'attachmentList', attachmentIndex, 1
  #     @_updateSpaceCalculation()
  #   else if attachment.mainStorage is 'session'
  #     attachmentData = (@sessionDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial)
  #     if attachmentData.length > 0
  #       @sessionDataUriDb.remove 'local-attachment', attachmentData[0]._id
  #     app.db.remove 'patient-gallery--local-attachment', attachment._id
  #     @splice 'attachmentList', attachmentIndex, 1
  #   else
  #     @callApi 'bdemr/delete-uploaded-file', {attachmentId: attachment._id}, (err, response)=>
  #       if response.hasError
  #         @domHost.showModalDialog response.error.message
  #       else
  #         attachmentData = (app.db.find 'patient-gallery--online-attachment', ({serial})-> serial is attachment.serial)
  #         if attachmentData.length > 0
  #           x=app.db.remove 'patient-gallery--online-attachment', attachmentData[0]._id
  #           @splice 'attachmentList', attachmentIndex, 1


  # downloadPressed: (e)->
  #   attachment = e.model.attachment
  #   src = @$getImageSrc attachment

  #   if (src.indexOf 'data:') is 0
  #     blob = dataURItoBlob src
  #     objectURL = window.URL.createObjectURL blob, { type: attachment.originalType }
  #   else
  #     objectURL = src

  #   identifier = attachment.originalName
  #   a = window.document.createElement 'a'
  #   a.href = objectURL
  #   a.target = '_blank'
  #   a.download = identifier
  #   document.body.appendChild a
  #   a.click()
  #   document.body.removeChild a

  # # === Gallary [END] ===


  ready: ()->


}
