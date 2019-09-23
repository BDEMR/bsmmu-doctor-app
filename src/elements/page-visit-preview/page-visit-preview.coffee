
Polymer {

  is: 'page-visit-preview'



  behaviors: [
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
  ]

  properties:

    comboBoxSymptomsInputValue:
      type: String
      notify: true
      value: null

    walletBalance:
      type: Number
      value: -1
    
    currentOrganization:
      type: Object
      notify: true
      value: null

    selectedMedicinePage:
      type: Number
      notify: false
      value: 0

    printPrescriptionOnly:
      type: Boolean
      notify: true
      value: true


    isBPAdded:
      type: Boolean
      notify: true
      value: false

    isHRAdded:
      type: Boolean
      notify: true
      value: false

    isBMIAdded:
      type: Boolean
      notify: true
      value: false

    isSpO2Added:
      type: Boolean
      notify: true
      value: false

    isRRAdded:
      type: Boolean
      notify: true
      value: false

    isTempAdded:
      type: Boolean
      notify: true
      value: false

    isThatNewVisit:
      type: Boolean
      notify: true
      value: true


    visitHeaderTitleList:
      type: Array
      notify: false
      value: [
        'Complete Visit',
        'Discharge Note',
      ]

    insulineMedicineList:
      type: Array
      notify: true
      value: -> []


    visitHeaderTitleSelectedIndex:
      type: Number
      notify: false
      value: 0



    isVisitValid:
      type: Boolean
      notify: false
      value: false

    selectedVisitPageIndex:
      type: Number
      notify: false
      value: false

    isPrescriptionValid:
      type: Boolean
      notify: false
      value: false

    isNoteValid:
      type: Boolean
      notify: false
      value: false

    isNextVisitValid:
      type: Boolean
      notify: true
      value: false

    isInvoiceValid:
      type: Boolean
      notify: false
      value: false

    isTestAdvisedValid:
      type: Boolean
      notify: false
      value: false


    isPatientValid:
      type: Boolean
      notify: false
      value: false

    isFullVisitValid:
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

    doctorNotes:
      type: Object
      notify: true
      value: null

    doctorNotesMessage:
      type: String
      notify: true
      value: ''

    nextVisit:
      type: Object
      notify: true
      value: null

    testAdvised:
      type: Object
      notify: true
      value: null

    invoice:
      type: Object
      notify: true
      value: null

    matchingPrescribedMedicineList:
      type: Array
      notify: true
      value: []

    doctorInstitutionList:
      type: Array
      notify: true
      value: []

    doctorSpecialityList:
      type: Array
      notify: true
      value: []

    doctorInstitutionSelectedIndex:
      type: Number
      notify: true
      value: 0

    doctorSpecialitySelectedIndex:
      type: Number
      notify: true
      value: 0

    hasTestResults:
      type: Boolean
      notify: true
      value: false

    ## historyAndPhysicalRecord - start
    historyAndPhysicalRecord:
      type: Object
      notify: true
      value: null

    matchingRecordList:
      type: Object
      notify: true
      value: null

    ## historyAndPhysicalRecord - end

    ## diagnosis - start
    diagnosis:
      type: Object
      notify: true
      value: null

    isDiagnosisValid:
      type: Boolean
      value: false

    diagnosisListArray:
      type: Array
      notify: true
      value: []

    selectedDiagnosisListArray:
      type: Array
      notify: true
      value: []

    ## diagnosis - end

    #####################################################################
    ### Prescription - start
    #####################################################################
    prescription:
      type: Object
      notify: true
      value: null

    matchingPrescribedMedicineList:
      type: Array
      notify: true
      value: []

    matchingCurrentMedicineList:
      type: Array
      notify: true
      value: []

    matchingFavoriteMedicineList:
      type: Array
      notify: true
      value: []

    duplicateMedicineEditablePart:
      type: Object
      notify: true
      value: null

    favoriteMedicineShownIndex:
      type: Number
      value: 0

    isMedicineValid:
      type: Boolean
      notify: false
      value: true  

    isThatNewMedicine:
      type: Boolean
      notify: false
      value: true

    medicine:
      type: Object
      notify: true
      value: {}

    strengthList:
      type: Array
      value: []

    continueMedicineEndsOnDate:
      type: String
      value: null

    doseList:
      type: Array
      value: -> [
        "1+1+1"
        "1+0+1"
        "0+0+1"
        "1+0+0"
        "1+1+1+1"
        "2+2+2"
        "2+0+2"
        "0+0+2"
        "2+0+0"
        "1/2+1/2+1/2"
        "1/2+0+1/2"
        "0+0+1/2"
        "1/2+0+0"
        "1/4+1/4+1/4"
        "1/4+0+1/4"
        "0+0+1/4"
        "1/4+0+0"
        "1/4+1/4+1/4+1/4"
      ]
    
    medicineFormList:
      type: Array
      value: [
        'Tablet'
        'Injection'
        'Syrup'
        'Drop'
        'Capsule'
        'Suspension'
        'I.V Injection'
        'I.M injection'
        'S/C Injection'
        'PR (Per Rectal)'
        'Suppository'
        'Solution'
        'Ointment'
        'Cream'
        'Skin Patch'
        'Custom'
      ]
    doseUnitList:
      type: Array
      value: ['Custom']
    endDateTimeTypeList:
      type: Array
      value: [
        'As Needed'
        '0 Weeks'
        '1 Week'
        '2 Weeks'
        '3 Weeks'
        'Custom'
      ]
    endDateTimeTypeArgument2List:
      type: Array
      value: [
        '0 Day'
        '1 Day'
        '2 Days'
        '3 Days'
        '4 Days'
        '5 Days'
        '6 Days'
      ]
    directionList:
      type: Array
      value: [
        'Anytime'
        'Before Meal'
        'After Meal'
        'Full Stomach'
        'Empty Stomach'
      ]
    routeList:
      type: Array
      value: [
        'Oral'
        'I.V injection'
        'I.M injection'
        'PR (Per Rectal)'
        'S/L'
        'S/C'
        'Nebulizer'
        'Inhaler'
        'Topical application skin'
        'Topical application ear'
        'Topical application eye'
        'Intravaginal'
        'Transdermal'
        'Custom'
      ]

    intervalInDays:
      type: Number
      value: 1
    medicineFormSelectedIndex:
      type: Number
      value: 0
    doseUnitSelectedIndex:
      type: Number
      value: 0
    directionSelectedIndex:
      type: Number
      value: 0
    routeSelectedIndex:
      type: Number
      value: 0
    endDateTimeTypeSelectedIndex:
      type: Number
      value: 0
    endDateTimeTypeArgument2SelectedIndex:
      type: Number
      value: 0
    strengthSelectedIndex:
      type: Number
      value: 0
      notify: true
    
    matchingMedicineList:
      type: Array
      value: []
    
    doseGuidelineList:
      type: Array
    activeDoseGuideline:
      type: Object
      value: null
    guidelineIndicationSelectedIndex:
      type: Number
      value: null
    guidelineAgeSelectedIndex:
      type: Number
      value: null
    guidelineIndicationList:
      type: Array
      value: -> []
    guidelineAgeList:
      type: Array
      value: -> []
    
    insulinMedicine:
      type: Object
      value: -> null
    
    medicineCompositionList:
      type: Array
      value: []

    brandNameSourceDataList:
      type: Array
      value: []
    brandNameSelectedObjectList:
      type: Array
      value: []
    genericNameSourceDataList:
      type: Array
      value: []
    
    showDetailedForm:
      type: Boolean
      value: false
    
    showGuidelineDisclaimer:
      type: Boolean
      value: true
      notify: true
    

    selectedCurrentMedicineData:
      type: Object
      value: null

    #####################################################################
    ### Prescription - end
    #####################################################################

    #####################################################################
    ### Symptoms - start
    #####################################################################
    symptomsDataList:
      type: Array
      notify: true
      value: []

    addedIdentifiedSymptomsList:
      type: Array
      notify: true
      value: []

    customSymptomsObject:
      type: Object
      notify: true
      value: {}
    #####################################################################
    ### Symptoms - end
    #####################################################################

    #####################################################################
    ### Examination - start
    #####################################################################
    examinationDataList:
      type: Array
      notify: true
      value: []

    addedExaminationList:
      type: Array
      notify: true
      value: []

    addedExaminationList2:
      type: Array
      notify: true
      value: ()-> []

    examinationObject:
      type: Object
      notify: true
      value: {}



    #####################################################################
    ### Examination - end
    #####################################################################



    #####################################################################
    ### Test Advised - start
    #####################################################################

    favoriteInvestigaitonList:
      type: Array
      notify: true
      value: []

    investigationMemberValue:
      type: String
      notify: true
      value: ''

    investigationDataList:
      type: Array
      notify: true
      value: []

    addedInvestigationList:
      type: Array
      notify: true
      value: []

    testAdvisedObject:
      type: Object
      notify: true
      value: {}

    suggestedInstitutionValue:
      type: String
      value: ''
      notify: true

    machingUserAddedInstitutionList:
      type: Array
      value: []
      notify: true

    addedInvestigationNameIndex:
      type: Number
      value: 0

    customInvestigationObject:
      type: Object
      notify: true
      value: {}

    customInvestigationUnitValue:
      type: String
      value: ''
      notify: true

    customInvestigationUnitList:
      type: Array
      value: []
      notify: true



    #####################################################################
    ### Test Advised - end
    #####################################################################

    #####################################################################
    ### Vitals - start
    #####################################################################

    selectedVitalIndex:
      type: Number
      value: -1
      notify: true

    heightUnitSelectedIndex:
      type: Number
      value: 0
      notify: true
    weightUnitSelectedIndex:
      type: Number
      value: 0
      notify: true
    tempUnitSelectedIndex:
      type: Number
      value: 0
      notify: true

    bloodPressure:
      type: Object
      notify: true
      value: {}
    pulseRate:
      type: Object
      notify: true
      value: {}
    bmi:
      type: Object
      notify: true
      value: {}
    respiratoryRate:
      type: Object
      notify: true
      rpm: {}
    oxygenSaturation:
      type: Object
      notify: true
      value: {}
    temperature:
      type: Object
      notify: true
      value: {}

    addedVitalList:
      type: Array
      value: []

    #####################################################################
    # Vitals - end
    #####################################################################

    #####################################################################
    # Next Visit - start
    #####################################################################


    priorityTypeList:
      type: Array
      value: [
        'As Necessary'
        'Others'
      ]

    nextVisitDurationTypeList:
      type: Array
      value: [
        '0 Day'
        '1 Day'
        '2 Days'
        '3 Days'
        '4 Days'
        '5 Days'
        '6 Days'
        '7 Days'
        '8 Days'
        '9 Days'
        '10 Days'
        '11 Days'
        '12 Days'
        '13 Days'
        '14 Days'
        '15 Days'
        '1 Week'
        '2 Weeks'
        '3 Weeks'
        '4 Weeks'
        '1 month'
        '2 months'
        '3 months'
        '4 months'
        '5 months'
        '6 months'
        '7 months'
        '8 months'
        '9 months'
        '11 month'
        '1 year'
        '2 years'
        '3 years'
        'Custom'
      ]

    nextVisitDurationTypeSelectedIndex:
      type: Number
      notify: true
      value: 0

    nextVisitPriorityTypeSelectedIndex:
      type: Number
      notify: true
      value: 0

    isCustomDateTypeSelected:
      type: Boolean
      notify: true
      value: false

    insulinTypeList:
      type: Array
      value: ->
        [
          {
            label: 'Bolus (Mealtime Insulin)'
            value: 'Bolus (Mealtime Insulin)'
          }
          {
            label: 'Premix'
            value: 'Premix'
          }
          {
            label: 'Split Mix'
            value: 'Split Mix'
          }
          {
            label: 'Basal & Bolus'
            value: 'Basal & Bolus'
          }
          {
            label: 'Basal Plus'
            value: 'Basal Plus'
          }
          {
            label: 'Basal Only'
            value: 'Basal Only'
          }
        ]

    insulinDrugList:
      type: Array
      value: ->
        [
          {
            label: 'Insulatard 100 IU Vial'
            value: 'Insulatard 100 IU Vial'
          }
          {
            label: 'Insulatard Penfill'
            value: 'Insulatard Penfill'
          }
          {
            label: 'Levemir'
            value: 'Levemir'
          }
          {
            label: 'Tresiba'
            value: 'Tresiba'
          }
          {
            label: 'Victoza'
            value: 'Victoza'
          }
          {
            label: 'Insulatard Flexpen'
            value: 'Insulatard Flexpen'
          }

          {
            label: 'Actrapid Penfill'
            value: 'Actrapid Penfill'
          }
          {
            label: 'NovoRapid FlexPen'
            value: 'NovoRapid FlexPen'
          }
          {
            label: 'NovoRapid Penfill'
            value: 'NovoRapid Penfill'
          }
          {
            label: 'Actrapid 100 IU Vial'
            value: 'Actrapid 100 IU Vial'
          }
          {
            label: 'Actrapid FlexPen-Humean Insulin'
            value: 'Actrapid FlexPen-Humean Insulin'
          }

          {
            label: 'Mixtard 30 100 IU Vial'
            value: 'Mixtard 30 100 IU Vial'
          }
          {
            label: 'Mixtard 30 Penfill'
            value: 'Mixtard 30 Penfill'
          }
          {
            label: 'Mixtard 50 Penfill'
            value: 'Mixtard 50 Penfill'
          }
          {
            label: 'NovoMix 30 FlexPen'
            value: 'NovoMix 30 FlexPen'
          }
          {
            label: 'Ryzodeg'
            value: 'Ryzodeg'
          }
          {
            label: 'NovoMix 30 Penfill'
            value: 'NovoMix 30 Penfill'
          }
          {
            label: 'Mixtard 30 FlexPen'
            value: 'Mixtard 30 FlexPen'
          }
        ]


    #####################################################################
    # Full Visit Preview - start
    #####################################################################
    settings:
      type: Object
      notify: true

    ## VIEW - HistoryAndPhysicalRecord - start
    record:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null

    recordDatabaseCollectionName:
      type: String
      value: null

    recordPartName:
      type: String
      value: null

    recordPartData:
      type: Object
      value: null

    recordPartDef:
      type: Object
      value: null

    recordPartTitle:
      type: String
      value: null

    recordPartHtmlContent:
      type: String
      value: null

    shouldRender:
      type: Boolean
      value: false

    delayRendering:
      type: Boolean
      value: false


  # Util Functions - start
  $of: (a, b)->
    unless b of a
      a[b] = null
    return a[b]

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
    if data is null or data is undefined or data is '' or data is 'undefined'
      return true
    else
      return false

  _compareFn: (left, op, right) ->
    # lib.util.delay 5, ()=>
    if op is '<'
      return left < right
    if op is '>'
      return left > right
    if op is '=='
      return left == right
    if op is '>='
      return left >= right
    if op is '<='
      return left <= right
    if op is '!='
      return left != right

  _sortByDate: (a, b)->
    if a.lastModifiedDatetimeStamp < b.lastModifiedDatetimeStamp
      return 1
    if a.lastModifiedDatetimeStamp > b.lastModifiedDatetimeStamp
      return -1

  _computeTotalDaysCount: (endDate, startDate)->
    return (@$TRANSLATE 'As Needed', @LANG) unless endDate
    oneDay = 1000*60*60*24;
    startDate = new Date startDate
    endDate = new Date endDate
    diffMs = endDate - startDate
    return @$TRANSLATE (Math.round(diffMs / oneDay)), @LANG

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
  # Util Functions - end
    

  _loadUser:(cbfn)->
    list = app.db.find 'user'
    console.log 'USER: ', list[0]
    if list.length is 1
      @user = list[0]
      @_getEmploymentList @user
      @_getSpecializationList @user

    else
      @domHost.showModalDialog 'Invalid User!'

    cbfn()

  _getEmploymentList: (user)->
    if user.employmentDetailsList.length > 0
      for employmentDetails in user.employmentDetailsList
        @push 'doctorInstitutionList', employmentDetails?.institutionName
    else
      @doctorInstitutionList = []

  _getSpecializationList: (user)->
    if user.specializationList.length > 0
      for specializationDetails in user.specializationList
        @push 'doctorSpecialityList', specializationDetails.specializationTitle
    else
      @doctorSpecialityList = []


  _loadPatient: (patientIdentifier, cbfn)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
      console.log 'PATIENT:', @patient
    else
      @_notifyInvalidPatient()

    cbfn()

  _listPrescribedMedications: (prescriptionIdentifier) ->
    # console.log prescriptionIdentifier
    prescribedMedicineList = app.db.find 'patient-medications', ({prescriptionSerial})=> prescriptionIdentifier is prescriptionSerial

    medicineList = [].concat prescribedMedicineList
    medicineList.sort (left, right)->
      return -1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 0

    @matchingPrescribedMedicineList = medicineList
    console.log "MEDICINE LIST:", @matchingPrescribedMedicineList


  ## Load Prescription
  _loadPrescription: (prescriptionIdentifier)->
    list = app.db.find 'visit-prescription', ({serial})-> serial is prescriptionIdentifier
    if list.length is 1
      @isPrescriptionValid = true
      @prescription = list[0]
      console.log "PRESCRIPTION: ", @prescription
      @_listPrescribedMedications @prescription.serial
      return true
    else
      @_notifyInvalidPrescription()
      return false
  
  ## Load Symptoms Data
  _loadIdentifiedSymptoms: (symptomsIdentifier)->

    list = app.db.find 'visit-identified-symptoms', ({serial})-> serial is symptomsIdentifier
    if list.length is 1
      @isIdentifiedSymptomsValid = true
      @identifiedSymptomsObject = list[0]
      console.log 'SYMPTOMS: ', @identifiedSymptomsObject
      @addedIdentifiedSymptomsList = list[0].data.symptomsList
      
      return true
    else
      @_notifyInvalidIdentifeidSymptoms()
      return false
      
  ## Load Examination Data
  _loadExamination: (examinationIdentifier)->

    list = app.db.find 'visit-examination', ({serial})-> serial is examinationIdentifier
    if list.length is 1
      @isExaminationValid = true
      @examinationObject = list[0]
      console.log 'EXAMINATION: ', @examinationObject
      @addedExaminationList = list[0].data.examinationValueList
      
      return true
    else
      @_notifyInvalidExamination()
      return false

  ## Load Test Advised Data
  _loadAdvisedTest: (adviseTestIdentifier)->

    list = app.db.find 'visit-advised-test', ({serial})-> serial is adviseTestIdentifier
    if list.length is 1
      @isTestAdvisedValid = true
      @testAdvisedObject = list[0]
      console.log "ADVISED TEST: ", @testAdvisedObject
      @addedInvestigationList = list[0].data.testAdvisedList
      return true
    else
      @_notifyInvalidTestAdvised()
      return false


  _pritifyVitalData: (masterVitalObject)->

    if masterVitalObject.vitalType is 'Blood Pressure'
      return masterVitalObject.vitalObject.data.systolic + "/" + masterVitalObject.vitalObject.data.diastolic

    if masterVitalObject.vitalType is 'Heart Rate'
      return masterVitalObject.vitalObject.data.bpm + " " + masterVitalObject.vitalObject.data.unit

    if masterVitalObject.vitalType is 'BMI'

      if masterVitalObject.vitalObject.data.heightUnit is "ft/inch"
        heightValue = masterVitalObject.vitalObject.data.heightInFt + "'" + masterVitalObject.vitalObject.data.heightInInch + "'' " + masterVitalObject.vitalObject.data.heightUnit
      else
        heightValue = masterVitalObject.vitalObject.data.height + " " + masterVitalObject.vitalObject.data.heightUnit

      weightValue = masterVitalObject.vitalObject.data.weight + masterVitalObject.vitalObject.data.weightUnit


      return masterVitalObject.vitalObject.data.calculatedBMI + ", " + "Height: " + heightValue + ", " + "Weight: " + weightValue

    if masterVitalObject.vitalType is 'Respirtory Rate'
      return masterVitalObject.vitalObject.data.respiratoryRate + masterVitalObject.vitalObject.data.unit

    if masterVitalObject.vitalType is 'SpO2'
      return masterVitalObject.vitalObject.data.spO2Percentage + masterVitalObject.vitalObject.data.unit

    if masterVitalObject.vitalType is 'Temperature'
      return masterVitalObject.vitalObject.data.temperature + masterVitalObject.vitalObject.data.unit



  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'

  _notifyInvalidVisit: ->
    @isVisitValid = false
    @domHost.showModalDialog 'Invalid Visit Provided'

  _loadVisit: (visitIdentifier, cbfn)->
    console.log 'visitIdentifier', visitIdentifier
    list = app.db.find 'doctor-visit', ({serial})-> serial is visitIdentifier
    console.log "VISIT LIST", list
    if list.length is 1
      @isVisitValid = true
      @visit = list[0]
      
    else
      @_notifyInvalidVisit()
      return

    cbfn()
     

  _loadVitalsForVisit: (vitalIdentifier, vitalType)->

    if vitalType is 'Blood Pressure'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-blood-pressure'
      @isBPAdded = true

    else if vitalType is 'Heart Rate'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-pulse-rate'
      @isHRAdded = true

    else if vitalType is 'BMI'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-bmi'
      @isBMIAdded = true

    else if vitalType is 'Respirtory Rate'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-respiratory-rate'
      @isRRAdded = true

    else if vitalType is 'Spo2'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-spo2'
      @isSpO2Added = true

    else if vitalType is 'Temperature'
      @loadIdentifiedVitalData vitalIdentifier, vitalType, 'patient-vitals-temperature'
      @isTempAdded = true
  
  loadIdentifiedVitalData: (vitalIdentifier, vitalType, collectionName) ->
    list = app.db.find collectionName, ({serial})=> serial is vitalIdentifier

    if list.length is 1
      vitalData = list[0]
      console.log vitalType, ': ', vitalData
      @_addToVitalList vitalData, vitalType
      return true
    else
      return false

  _addToVitalList: (object, type)->
    lib.util.delay 5, ()=>

      @push 'addedVitalList', {
        vitalType: type
        vitalObject: object
      }

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')



  _loadVisitPrescription: (prescriptionSerial)->
    list = app.db.find 'visit-prescription', ({serial})-> serial is prescriptionSerial
    if list.length is 1
      @isPrescriptionValid = true
      @isFullVisitValid = true
      @prescription = list[0]
      @_listPrescribedMedications @prescription.serial
      # console.log "PrescriptionObj:",  @prescription
      return true
    else
      @isPrescriptionValid = false
      return false



  _loadVisitNote: (doctorNotesSerialIdentifier)->

    list = app.db.find 'visit-note', ({serial})-> serial is doctorNotesSerialIdentifier
    if list.length is 1
      @isNoteValid = true
      @isFullVisitValid = true
      @doctorNotes = list[0]
      console.log 'NOTES: ', @doctorNotes
      return true
    else
      @isNoteValid = false
      return false

  
  _loadNextVisit: (nextVisitSerial)->
    list = app.db.find 'visit-next-visit', ({serial})-> serial is nextVisitSerial

    if list.length is 1
      @isNextVisitValid = true
      @isFullVisitValid = true
      @nextVisit = list[0]
      console.log "NEXT VISIT: ", @nextVisit
      return true
    else
      @isNextVisitValid = false
      return false


  ## VIEW :: HistoryAndPhysical - start
  _getRecord: (recordIdentifier, desiredRecordType)->
    list = app.db.find desiredRecordType, ({serial})-> serial is recordIdentifier
    if list.length is 1
      return list[0]
    else
      return null

  ## NOTE - PRINT ======================================================================================
  # The code below is unavoidably messy looking due to the various requirements in the data 
  # definition. If the namespace is not polluted then we will not have any serious consequences
  # when it comes to performance.

  generateHtmlContent: (def, data)->
    html = @handle_type def, data.data
    html = @filterHtmlContent html
    return html

  filterHtmlContent: (html)->
    html = html.replace /@VALUE@/g, ''
    return html

  printOutStyleSheet: ->
    """
    <style>
      
      .default-category {
        /* font-size: 20px; 
        font-weight: bold; */
        text-align: center; 
      }
      .default-collection {
        /* font-size: 16px; 
        font-weight: bold; */
      }
      .default-group {
        /* text-decoration: overline; */
      }
      .default-card {
        /* text-decoration: underline; */
      }
      span {
        font-size: 14px;
      }
      .unprocessed {
        color: red;
      }
    </style>
    """

  handle_children: (def, data)->
    html = ''
    # console.log data
    if 'childMap' of data and 'childList' of def and def.childList isnt null
      for child, childIndex in def.childList
        if child.key of data.childMap
          childHtml = @handle_type child, data.childMap[child.key]
          if childHtml and not (childHtml in [ ';', ':;', ': ;' ])
            childHtml = @sanitizeOutput childHtml
            html += childHtml
    else
      console.log 'end-case'
    return html

  handle_type: (def, data)->
    # console.log def.key, @listPrintDirectives def
    def.print = {} unless 'print' of def
    if def.type is 'systemRoot'
      @flattenStyle def
      return @type_systemRoot def, data
    else if def.type is 'category'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 18 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_category def, data
    else if def.type is 'collection'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 16 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_collection def, data
    else if def.type is 'group'
      def.print.passThrough = true unless 'passThrough' of def.print
      def.print.fontSize = 14 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_group def, data
    else if def.type is 'card'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 14 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_card def, data
    else if def.type is 'checkbox'
      @flattenStyle def
      return @type_checkbox def, data
    else if def.type is 'toggleableContainer'
      @flattenStyle def
      return @type_toggleableContainer def, data
    else if def.type is 'label'
      @flattenStyle def
      return @type_label def, data
    else if def.type is 'autocomplete'
      if 'selectionType' of def and def.selectionType is 'label'
        def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_autocomplete def, data
    else if def.type is 'container'
      @flattenStyle def
      return @type_container def, data
    else if def.type is 'checkList'
      def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_checkList def, data
    else if def.type is 'radioList'
      def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_radioList def, data
    else if def.type is 'input'
      @flattenStyle def
      return @type_input def, data
    else if def.type is 'singleSelectDropdown'
      @flattenStyle def
      return @type_singleSelectDropdown def, data
    else if def.type is 'incrementalCounter'
      @flattenStyle def
      return @type_incrementalCounter def, data
    else
      return '<span class="unprocessed">UNPROCESSED ' + def.type + ' - ' + def.key + '</span>'


  flattenStyle: (def)->
    if 'passThrough' of def.print
      unless 'hideLabel' of def.print
        def.print.hideLabel = true
      unless 'noColonAfterThis' of def.print
        def.print.noColonAfterThis = true
      unless 'noSemicolonAfterThis' of def.print
        def.print.noSemicolonAfterThis = false
      # delete def.print['passThrough']
    if 'newLineBeforeThis' of def.print
      if typeof def.print.newLineBeforeThis is 'boolean'
        def.print.newLineBeforeThis = (if def.print.newLineBeforeThis is true then 1 else 0)
      else
        def.print.newLineBeforeThis = parseInt def.print.newLineBeforeThis
    if 'newLineAfterThis' of def.print
      if typeof def.print.newLineAfterThis is 'boolean'
        def.print.newLineAfterThis = (if def.print.newLineAfterThis is true then 1 else 0)
      else
        def.print.newLineAfterThis = parseInt def.print.newLineAfterThis
    if 'newLineAfterThisAndChildren' of def.print
      if typeof def.print.newLineAfterThisAndChildren is 'boolean'
        def.print.newLineAfterThisAndChildren = (if def.print.newLineAfterThisAndChildren is true then 1 else 0)
      else
        def.print.newLineAfterThisAndChildren = parseInt def.print.newLineAfterThisAndChildren
    if 'newLineAfterEachValue' of def.print
      if typeof def.print.newLineAfterEachValue is 'boolean'
        def.print.newLineAfterEachValue = (if def.print.newLineAfterEachValue is true then 1 else 0)
      else
        def.print.newLineAfterEachValue = parseInt def.print.newLineAfterEachValue

  sanitizeOutput: (content)->
    for i in [0..2]
      content = content.replace /\;;/g, ';'
      content = content.replace /\;;/g, ';'
      content = content.replace /\; ;/g, ';'
      content = content.replace /\: ;/g, ';'
      content = content.replace /\: :/g, ':'
      content = content.replace /\, ;/g, ';'
      content = content.replace /\; ,/g, ';'
      content = content.replace /\,;/g, ';'

      content = content.replace /<\/span style=""><\/span>/g, ''
      content = content.replace /<\/span>;<\/span>/g, '<\/span><\/span>'
      content = content.replace /<\/span>; <\/span>/g, '<\/span><\/span>'
      content = content.replace /<\/span> ,<\/span>/g, '<\/span><\/span>'

    return content


  ###
    REGION - VARIOUS TYPES
  ###

  _computeElementStyle: (def)->
    style = ''
    if def.print.fontSize
      style += "font-size: #{def.print.fontSize}px;"
    if def.print.hide
      style += "display: none;"
    return style

  _computeTitleOrLabelStyle: (def)->
    style = ''
    if def.print.boldLabel
      style += "font-weight: bold;"
    return style

  type_systemRoot: (def, data)->
    content = (@handle_children def, data)
    return @printOutStyleSheet() + content

  type_category: (def, data)->
    content = @handle_children def, data
    return '' if content.length is 0
    style = @_computeTitleOrLabelStyle def
    title = """<span style="#{style}">#{def.label}</span>"""
    style = @_computeElementStyle def
    html = """<div class="default-category" style="#{style}">#{title}</div>#{content}"""
    return html

  type_collection: (def, data)->
    return '' if (Object.keys data.childMap).length is 0
    if def.defaultGroup and not data.isDefaultGroupDismissed
      content = @handle_type def.defaultGroup, data.childMap[def.defaultGroup.key]
    else
      content = @handle_children def, data
    style = @_computeTitleOrLabelStyle def
    title = """<br><span style="#{style}">#{def.label}</span><br>"""
    style = @_computeElementStyle def
    html = """<span class="default-collection" style="#{style}">#{title}</span>: #{content}<br>"""
    return html

  type_group: (def, data)->
    content = @handle_children def, data
    style = @_computeTitleOrLabelStyle def
    title = """<span style="#{style}">#{def.label}</span>"""
    if def.print.passThrough
      html = """#{content};"""
    else
      style = @_computeElementStyle def
      html = """<span class="default-group" style="#{style}">#{title}</span>: #{content}; """
    return html

  _makePrintableContent: (label, content, value, def, data)->
    return '' if content.length is 0 and value.length is 0 and def.type isnt 'label'
    print = def.print

    # console.log label, print

    labelHtml = ''
    contentHtml = ''
    valueHtml = ''

    return '' if print.hide

    if label.length > 0
      unless print.hideLabel
        style = ''
        if print.boldLabel
          style += 'font-weight: bold;'
        if print.fontSize
          style += "font-size:#{print.fontSize}px;"
        labelHtml = """<span style="#{style}">#{label}</span>"""

    if value.length > 0
      unless print.hideValue
        style = ''
        if print.boldValue
          style += 'font-weight: bold;'
        if print.fontSize
          style += "font-size:#{print.fontSize}px;"
        valueHtml = """<span style="#{style}">#{value}</span>"""    

    if content.length > 0
      unless print.hideChildren
        style = ''
        if print.boldChildren
          style += 'font-weight: bold;'
        contentHtml = """<span style="#{style}">#{content}</span>"""

    if (labelHtml + contentHtml + valueHtml).length is 0
      return ''

    if 'newLineBeforeThis' of print
      for i in [0...print.newLineBeforeThis]
        labelHtml = '<br>' + labelHtml

    if 'newLineAfterThis' of print
      for i in [0...print.newLineAfterThis]
        labelHtml = labelHtml + '<br>'

    colon = (if ('noColonAfterThis' of print and print.noColonAfterThis) or labelHtml.length is 0 then '' else ': ')
    semicolon = (if 'noSemicolonAfterThis' of print and print.noSemicolonAfterThis then '' else '; ')
    html = labelHtml + colon + contentHtml + valueHtml + semicolon

    if 'newLineAfterThisAndChildren' of print
      for i in [0...print.newLineAfterThisAndChildren]
        html = html + '<br>'

    return html


  type_card: (def, data)->
    content = (@handle_children def, data)
    label = def.label
    value = null
    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data
    
  type_checkbox: (def, data)->
    content = null
    label = null

    if data.isChecked
      value = def.label
    else
      value = ''

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_label: (def, data)->
    content = null
    label = data.label or def.label or def.defaultLabel
    value = null
    
    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_toggleableContainer: (def, data)->
    return '' unless data.isChecked

    content = @handle_children def, data
    label = def.label
    value = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_container: (def, data)->
    content = @handle_children def, data
    label = data.label or def.defaultLabel
    value = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_checkList: (def, data)->
    print = def.print

    stringList = []
    for item in data.checkedValueList
      stringList.push item

    separatorString = print.separatorString
    if 'newLineAfterEachValue' of print
      for i in [0...print.newLineAfterEachValue]
        separatorString += '<br>'

    value = stringList.join separatorString 

    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_radioList: (def, data)->
    value = data.selectedValue
    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_singleSelectDropdown: (def, data)->
    value = def.possibleValueList[data.selectedIndex]
    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_input: (def, data)->
    content = data.value

    if def.unitDetails
      unit = def.unitDetails.unitList[data.selectedUnitIndex]
      # content += ' ' + unit.name

    value = content
    label = def.label
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_autocomplete: (def, data)->
    print = def.print

    if def.selectionType is 'label'

      stringList = []
      for key, value of data.virtualChildMap
        title = key.split '_'
        title.pop()
        title.shift()
        title = title.join '_'
        stringList.push title

      separatorString = print.separatorString
      if 'newLineAfterEachValue' of print
        for i in [0...print.newLineAfterEachValue]
          separatorString += '<br>'

      value = stringList.join separatorString 

      label = def.label
      content = null

      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

    else
      content = ''
      for key, value of data.virtualChildMap
        title = key.split '_'
        title.pop()
        title.shift()
        title = title.join '_'

        virtualContainer = 
          type: 'container'
          defaultLabel: title
          key: key
          childList: def.childListForEachContainer

        childContent = (@handle_type virtualContainer, value) + ', '
        content += childContent

      value = null
      label = def.label

      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_incrementalCounter: (def, data)->
    content = ''
    for key, value of data.virtualChildMap
      title = key.replace 'item', ''
      serial = parseInt title

      virtualContainer = 
        type: 'container'
        defaultLabel: (try def.unit.singular catch ex then 'unit') + ' #' + (serial + 1)
        key: key
        childList: def.childListForEachContainer

      content += (@handle_type virtualContainer, value) + ';'

      value = null
      label = def.label
      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  ###
    REGION - PRINT RELATED CHECKS
  ###

  should_boldLabel: (def)->
    'print' of def and 'boldLabel' of def.print and def.print.boldLabel

  should_passThrough: (def)->
    'print' of def and 'passThrough' of def.print and def.print.passThrough

  should_newLineBeforeThis: (def)->
    'print' of def and 'newLineBeforeThis' of def.print and def.print.newLineBeforeThis

  inject_passThrough_special_card: (def, data)->
    if def.key is def.label and def.key in [ "Details", 'Default' ]
      def.print = {} unless def.print
      def.print.passThrough = true

  inject_passThrough_special_group: (def, data)->
    if def.key is def.label and def.key in [ "List", 'Default' ]
      def.print = {} unless def.print
      def.print.passThrough = true

  __debug_print: (def, handledDirectiveList)->
    all = if 'print' of def then Object.keys(def.print) else []
    left = lib.array.minus all, handledDirectiveList
    if left.length > 0
      console.log 'UNHANDLED print directives', def, left

  ## VIEW :: HistoryAndPhysical - end
  checkForPrintPreviewType: ()->
    
    if @visit?.historyAndPhysicalRecordSerial
      return false
    if @visit?.identifiedSymptomsSerial
      return false
    else if @visit?.examinationSerial
      return false
    else if @visit?.vitalSerial.bp
      return false
    else if @visit?.vitalSerial.hr
      return false
    else if @visit?.vitalSerial.bmi
      return false
    else if @visit?.vitalSerial.rr
      return false
    else if @visit?.vitalSerial.spo2
      return false
    else if @visit?.vitalSerial.temp
      return false
    else if @visit?.advisedTestSerial
      return false
    else if @visit?.diagnosisSerial
      return false
    else if @visit?.doctorNotesSerial
      return false
    else if @visit?.nextVisitSerial
      return false
    else
      return true


  printButtonPressed: (e)->
    @printPrescriptionOnly = @checkForPrintPreviewType()
    window.print()
        

  _getSettings: (cbfn) ->
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()
    @settings = list[0]

    console.log @settings
    cbfn()

  navigatedIn: ->


    @currentOrganization = @getCurrentOrganization()
    unless @currentOrganization
      @domHost.navigateToPage "#/select-organization"


    # Load User
    @_loadUser =>
      params = @domHost.getPageParams()

      # Load Settings Data
      @_getSettings =>

        # Load Patient
        unless params['patient']
          @_notifyInvalidPatient()
          return
        else
          @_loadPatient params['patient'], =>
            ## Load Visit Record
            unless params['visit']
              @_notifyInvalidVisit()
              return

            @_loadVisit params['visit'], =>
              ## Visit - HistoryAndPhysical - start
              if @visit.historyAndPhysicalRecordSerial
                @historyAndPhysical_navigatedIn()

                @set 'recordPartName', 'history-and-physical-record'

                @recordDatabaseCollectionName = 'history-and-physical-record'

                @record = @_getRecord @visit.historyAndPhysicalRecordSerial, @recordDatabaseCollectionName

                @recordPartData = @record

                @recordPartTitle = 'History and Physical Record'

                @domHost.getStaticData 'dynamicElementDefinitionPreoperativeAssessment', (def)=>
                  
                  @recordPartDef = def

                  @recordPartHtmlContent = @generateHtmlContent @recordPartDef, @recordPartData

                  # console.log @recordPartHtmlContent

                  unless @delayRendering
                    
                    @shouldRender = true

              else
                @visit.historyAndPhysicalRecordSerial = null
                @historyAndPhysicalRecord = {}
              ## Visit - HistoryAndPhysical - end

              ## Visit - Prescription - start
              if @visit.prescriptionSerial
                @_loadPrescription @visit.prescriptionSerial

              ## Visit - Symptoms - start
              if @visit.identifiedSymptomsSerial
                @_loadIdentifiedSymptoms @visit.identifiedSymptomsSerial
              ## Visit - Symptoms - end

              ## Visit - Examination - start
              if @visit.examinationSerial
                @_loadExamination @visit.examinationSerial

              ## Visit - Vitals - start
              if @visit.vitalSerial.bp
                 @_loadVitalsForVisit @visit.vitalSerial.bp, 'Blood Pressure'

              if @visit.vitalSerial.hr
                @_loadVitalsForVisit @visit.vitalSerial.hr, 'Heart Rate'

              if @visit.vitalSerial.bmi
                @_loadVitalsForVisit @visit.vitalSerial.bmi, 'BMI'
   
              if @visit.vitalSerial.rr
                @_loadVitalsForVisit @visit.vitalSerial.rr, 'Respirtory Rate'

              if @visit.vitalSerial.spo2
                @_loadVitalsForVisit @visit.vitalSerial.spo2, 'Spo2'

              if @visit.vitalSerial.temp
                @_loadVitalsForVisit @visit.vitalSerial.temp, 'Temperature'

              ## Visit - Test Advised - start
              if @visit.advisedTestSerial
                @_loadAdvisedTest @visit.advisedTestSerial

              ## Visit - Diagnosis - start
              if @visit.diagnosisSerial
                @_loadDiagnosis @visit.diagnosisSerial

              ## Visit - Notes - start
              if @visit.doctorNotesSerial
                @_loadVisitNote @visit.doctorNotesSerial

              ## Visit - Next Visit - start
              if @visit.nextVisitSerial
                @_loadNextVisit @visit.nextVisitSerial


  navigatedOut: ->
  

  ## ------------------------------- History and physical - start

  historyAndPhysical_navigatedIn: ->
    @_loadHistoryAndPhysicalRecord()
    @_loadRecordInClipboard()

  historyAndPhysicalRecordCreate: (e)->
    params = @domHost.getPageParams()
    if params['visit'] is 'new'
      @_saveVisit()
    # console.log @visit.serial
    @historyAndPhysicalRecord = {
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      serial: @generateSerialForHistoryAndPhysical()
      patientSerial: @patient.serial
      visitSerial: @visit.serial
      availableToPatient: true
    }

    @visit.historyAndPhysicalRecordSerial = @historyAndPhysicalRecord.serial
    @visit.lastModifiedDatetimeStamp = lib.datetime.now()

    # updated visit object for History and Physical
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial


    @_saveHistoryAndPhysicalRecord()
    @_loadHistoryAndPhysicalRecord()
    @domHost.navigateToPage '#/record-history-and-physical/record:' + @historyAndPhysicalRecord.serial
    window.location.reload()


  _loadRecordInClipboard: ->
    recordInClipboard = sessionStorage.getItem 'HISTORY-AND-PHYSICAL-IN-CLIPBOARD'
    if recordInClipboard
      recordInClipboard = JSON.parse recordInClipboard
    @recordInClipboard = recordInClipboard

  historyAndPhysicalRecordCopy: (e)->
    record = @historyAndPhysicalRecord
    # console.log record

    sessionStorage.setItem 'HISTORY-AND-PHYSICAL-IN-CLIPBOARD', JSON.stringify record
    @domHost.showModalDialog "This record has been copied to clipboard"
    @_loadRecordInClipboard()

  pasteRecordPressed: (e)->
    params = @domHost.getPageParams()
    if params['visit'] is 'new'
      @_saveVisit()

    @recordInClipboard.patientSerial = @patient.serial
    @recordInClipboard.visitSerial = @visit.serial
    @recordInClipboard.lastChangedDatetimeStamp = lib.datetime.now()
    @recordInClipboard.serial = @generateSerialForRecord()

    @visit.historyAndPhysicalRecordSerial = @recordInClipboard.serial
    @historyAndPhysicalRecord = @recordInClipboard


    # updated visit object for History and Physical
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial

    @_saveHistoryAndPhysicalRecord()
    @_loadHistoryAndPhysicalRecord()

    @recordInClipboard = null
    sessionStorage.removeItem 'HISTORY-AND-PHYSICAL-IN-CLIPBOARD'

    @domHost.showModalDialog "Successfully Imported. Reloading Interface."

    @domHost.navigateToPage '#/record-history-and-physical/record:' + @historyAndPhysicalRecord.serial
    window.location.reload()


    

  _updateVisitForHistoryAndPhysicalRecord: (historyAndPhysicalRecordIdentifier)->


  historyAndPhysicalRecordPrint: (e)->
    @domHost.navigateToPage '#/print-history-and-physical-record/record:' + @historyAndPhysicalRecord.serial

  historyAndPhysicalRecordEdit: (e)->
    @domHost.navigateToPage '#/record-history-and-physical/record:' + @historyAndPhysicalRecord.serial

  historyAndPhysicalRecordRemove: (e)->
    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer
        app.db.remove 'history-and-physical-record', @historyAndPhysicalRecord._id
        @_loadHistoryAndPhysicalRecord()

  _loadHistoryAndPhysicalRecord: ->
    currentVisitSerial = @visit.serial
    list = app.db.find 'history-and-physical-record', ({visitSerial})=> visitSerial is currentVisitSerial
    if list.length is 1
      @set 'historyAndPhysicalRecord', list[0]
    else
      @set 'historyAndPhysicalRecord', null

    console.log '_loadHistoryAndPhysicalRecord', @historyAndPhysicalRecord

  _saveVisitPrescription:->
    app.db.upsert 'visit-prescription', @prescription, ({serial})=> @prescription.serial is serial
    @domHost.showToast 'Record Saved'

  _saveVisitTestAdvised:->
    app.db.upsert 'visit-advised-test', @testAdvised, ({serial})=> @testAdvised.serial is serial
    @domHost.showToast 'Record Saved'


  _saveHistoryAndPhysicalRecord:->
    app.db.upsert 'history-and-physical-record', @historyAndPhysicalRecord, ({serial})=> @historyAndPhysicalRecord.serial is serial
    @domHost.showToast 'Record Saved'


  ## ------------------------------- History and physical - end

  ## --- Patient Specific Sync - Start

  _updatePatientSerialSyncByCollection: (collectionNameIdentifier, patientIdentifier, isSync)->

    list = app.db.find 'filterd-patient-serial-list-for-sync', ({collectionName})-> collectionName is collectionNameIdentifier
    if list.length is 1
      itemObject = list[0]
      # console.log 'itemObject', itemObject
      newItemObject = {}
      for item, index in itemObject.patientSerialList
        if item.patientSerial is patientIdentifier
          itemObject.patientSerialList[index].isSync = isSync
          app.db.upsert 'filterd-patient-serial-list-for-sync', itemObject, ({_id})=> itemObject._id is _id
          return true

  historyAndPhysicalSyncCheckboxChanged: (e)->

    params = @domHost.getPageParams()

    if params['patient']
      patientIdentifier = params['patient'] 

    if e.target.checked
      @_updatePatientSerialSyncByCollection 'history-and-physical-record', patientIdentifier, true
     
    else
      @_updatePatientSerialSyncByCollection 'history-and-physical-record', patientIdentifier, false
        
  ## --- Patient Specific Sync - End


  historyAndPhysicalAvailableToPatientCheckBoxChanged: (e)->
    if @historyAndPhysicalRecord
      if e.target.checked
        @historyAndPhysicalRecord.availableToPatient = true
        @_saveHistoryAndPhysicalRecord()
      else
        @historyAndPhysicalRecord.availableToPatient = false
        @_saveHistoryAndPhysicalRecord()


  prescriptionAvailableToPatientCheckBoxChanged: (e)->
    if @prescription
      if e.target.checked
        @prescription.availableToPatient = true
        @_saveVisitPrescription()
      else
        @prescription.availableToPatient = false
        @_saveVisitPrescription()

  testAdvisedAvailableToPatientCheckBoxChanged: (e)->
    if @testAdvised
      if e.target.checked
        @testAdvised.availableToPatient = true
        @_saveVisitTestAdvised()
      else
        @testAdvised.availableToPatient = false
        @_saveVisitTestAdvised()


  ## diagnosis - start
  _loadDiagnosis: (diagnosisSerialIdentifier)->
    lib.util.delay 5, ()=>
      list = app.db.find 'diagnosis-record', ({serial})-> serial is diagnosisSerialIdentifier
      
      if list.length is 1
        @isDiagnosisValid = true
        @isFullVisitValid = true
        @diagnosis = list[0]
        console.log 'DIAGNOSIS:', @diagnosis
        return true
      else
        @isDiagnosisValid = false
        return false

  _makeNewDiagnosis: ()->
    @diagnosis =
      serial: null
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @visit.doctorName
      doctorSpeciality: @visit.doctorSpeciality
      organizationId: @currentOrganization.idOnServer
      data:
        diagnosisList: []

  _saveDiagnosis: ()->

    unless @visit.serial isnt null
      @_saveVisit()
      # @visit.serial = @generateSerialForVisit()
      @diagnosis.visitSerial = @visit.serial
      
    
    unless @diagnosis.serial isnt null
      @diagnosis.serial = @generateSerialForDiagnosis()
      @visit.diagnosisSerial = @diagnosis.serial
      @diagnosis.visitSerial = @visit.serial
      @_saveVisit()
        
    console.log 'visit', @visit
    console.log 'diagnosis', @diagnosis

    @diagnosis.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'diagnosis-record', @diagnosis, ({serial})=> @diagnosis.serial is serial

    @comboBoxDiagnosisInputValue = ''

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()


  loadDiagnosisListData: ()->
  
    @domHost.getStaticData 'diagnosisList', (diagnosisList)=>
      list = ({label: item.name, value: item.name} for item in diagnosisList when item.name)
      @set 'diagnosisListArray', list
      
      # @diagnosisListArray.sort (left, right)->
      #   return -1 if left.label < right.label
      #   return 1 if left.label > right.label
      #   return 0

      # @push 'diagnosisListArray', {label: 'hello', value: 'hello'}

      # console.log 'diagnosisList', diagnosisList

  comboBoxKeyUpRecordTitleValueChanged: (e)->
    if @visit.recordTitle isnt '' or @visit.recordTitle isnt null
      if e.which is 13 # ENTER/RETURN
        @_saveVisit()

  recordTitleValueChanged: ()->
    if @visit.recordTitle isnt '' or @visit.recordTitle isnt null
      @_saveVisit()


  openVisitSettingsDialog: (e)->
    @$$('#dialogVisitSettings').toggle()



  comboBoxKeyUpDiagnosisValueChanged: (e)->
    # console.log @comboBoxDiagnosisInputValue

    unless @comboBoxDiagnosisInputValue is ''

      if e.which is 13 # ENTER/RETURN
        diagnosis = ''
        if typeof @comboBoxDiagnosisInputValue is 'object'
          diagnosis = @comboBoxDiagnosisInputValue.name
        else
          diagnosis = @comboBoxDiagnosisInputValue

        @push 'diagnosis.data.diagnosisList', { name: diagnosis }
        @_saveDiagnosis()
        @domHost.showToast 'Diagnosis Added!'
        @comboBoxDiagnosisInputValue = ''

  addDiagnosis: ()->
    unless @comboBoxDiagnosisInputValue is ''
      diagnosis = ''
      if typeof @comboBoxDiagnosisInputValue is 'object'
        diagnosis = @comboBoxDiagnosisInputValue.name
      else
        diagnosis = @comboBoxDiagnosisInputValue

      @push 'diagnosis.data.diagnosisList', { name: diagnosis }
      @_saveDiagnosis()
      @domHost.showToast 'Diagnosis Added!'
      @comboBoxDiagnosisInputValue = ''




  _deleteSelectedDiagnosisButtonPressed: (e)->
    index = e.model.index
    @splice 'diagnosis.data.diagnosisList', index, 1
    @_saveDiagnosis()
    @domHost.showToast 'Diagnosis Deleted!'


  

  ## diagnosis - end



  # INVOICE START 
  # ================================================================
  _getServiceRendered: (index)->
    optionList = [ 'Doctor Visit', '2nd Visit', 'Online Phone Consultation', 'In Patient (Hospital/Clinic Visits)', 'Report Assessment', 'Custom' ]
    if index is 5
      return @invoice.customServiceRendered
    else
      return optionList[index]

  
  createInvoicePressed: ->
    params = @domHost.getPageParams()

    if params['visit'] is 'new'
      @visit.serial = @generateSerialForVisit()
      @visit.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial

    @domHost.navigateToPage  '#/visit-invoice/visit:' + @visit.serial + '/patient:' + @patient.serial + '/invoice:new'

  editInvoicePressed: (e)->
    @domHost.navigateToPage  '#/visit-invoice/visit:' + @visit.serial + '/patient:' + @patient.serial + '/invoice:' + @invoice.serial

  printInvoicePressed: ()->
    params = @domHost.getPageParams()
    if params['visit-invoice'] != 'new'
      @domHost.navigateToPage '#/print-invoice/visit:' + @visit.serial + '/patient:' + @patient.serial + '/invoice:' + @invoice.serial



}
