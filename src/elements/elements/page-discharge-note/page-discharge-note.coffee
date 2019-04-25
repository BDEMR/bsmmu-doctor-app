
Polymer {

  is: 'page-discharge-note'

  $toJson: (object)->
    JSON.stringify object

  $isNumber: (object)->
    typeof object is 'number'

  $listMissingKeys: (object, handledKeyList)->
    missingKeyList = []
    for key of object
      unless key in handledKeyList
        missingKeyList.push key
    return missingKeyList

  behaviors: [
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
    app.behaviors.local.patientStayMixin
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
        'Discharge Summary',
        'Discharge Certificate',
        'Discharge Record',
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
      type: Object
      notify: true
      value: ->
        title: null
        description: null

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

    computedEndDate:
      type: String
      computed: '_showComputedEndDate(duplicateMedicineEditablePart.endDateTimeStamp)'      

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


    ## operation - start
    operation:
      type: Object
      notify: true
      value: null

    isOperationValid:
      type: Boolean
      value: false

    ## operation - end

    ## confirm diagnosis - start
    confirmedDiagnosisList:
      type: Array
      notify: true
      value: []

    ## confirm diagnosis - end

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

    computedNextVisitDate:
      type: String
      notify: true
      computed: '_showComputedNextVisitDate(nextVisit.nextVisitDateTimeStamp)'

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
    ## VIEW - HistoryAndPhysicalRecord - start


    #####################################################################
    # Full Visit Preview - end
    #####################################################################


  observers : [
    '_computeQuantityPerPrescription(medicine.dose, medicine.timesPerInterval, intervalInDays, medicine.endDateTimeStamp, medicine.startDateTimeStamp)'
    '_computeIntervalInHours(medicine.timesPerInterval, intervalInDays)'
    
  ]


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
    if data is null or data is '' or data is 'undefined'
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
    
  _todaysDate: ()->
    today = new Date
    year = today.getFullYear();
    month = (today.getMonth()+1).toString();
    date = today.getDate().toString();
    month = if month.length is 1 then "0#{month}" else month
    date = if date.length is 1 then "0#{date}" else date
    console.log 'todays date ', "#{year}-#{month}-#{date}"
    return "#{year}-#{month}-#{date}"

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
        @push 'doctorInstitutionList', employmentDetails.institutionName
    else
      @doctorInstitutionList = []

  _getSpecializationList: (user)->
    if user.specializationList.length > 0
      for specializationDetails in user.specializationList
        @push 'doctorSpecialityList', specializationDetails.specializationTitle
    else
      @doctorSpecialityList = []


  $getFullName:(data)->
    if typeof data is "object"
      honorifics = ''
      first = ''
      last = ''
      middle = ''

      if data.honorifics  
        honorifics = data.honorifics + ". "
      if data.first
        first = data.first
      if data.middle
        middle = " " + data.middle
      if data.last
        last = " " + data.last
        
      return honorifics + first + middle + last

    else return data

  getDoctorSpeciality: () ->
    unless @user.specializationList.length is 0
      return @user.specializationList[0].specializationTitle
    return 'not provided yet'

  _makeNewNextVisit: ()->
    @nextVisit =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: @visit.serial
      patientSerial: @patient.serial
      doctorName: @$getFullName @user.name
      doctorSpeciality: @getDoctorSpeciality()
      organizationId: @currentOrganization.idOnServer
      data:
        nextVisitDateTimestamp: null
        priorityType: 'As Necessary'

    @isNextVisitValid = true

  _makeNewNote: ()->
    @doctorNotes =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: null
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      organizationId: @currentOrganization.idOnServer
      data:
        messageList: []

    # console.log 'doctorNotes', @doctorNotes

    @isNoteValid = true

  _loadPatient: (patientIdentifier, cbfn)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
      console.log 'PATIENT:', @patient
    else
      @_notifyInvalidPatient()

    cbfn()


  #####################################################################
  ### Prescription - start
  #####################################################################

  doseSelected: (e)->
    if e.which is 13
      @medicine.doseDirection = e.target.value

  
  _isFavoriteMedicineContentHidden: (index, favoriteMedicineShownIndex)->
    not (index is favoriteMedicineShownIndex)

  favoriteMedicineTapped:(e)->
    @favoriteMedicineShownIndex = e.model.index


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


  _listCurrentMedications: (patientIdentifier) ->
    currentMedicineList = app.db.find 'patient-medications', ({patientSerial, data})->
      if patientSerial is patientIdentifier and data.status is 'continue'
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
    


  _listFavoriteMedicine: (userIdentifier) ->

    favMedicineList = app.db.find 'favorite-medicine-list', ({createdByUserSerial}) -> userIdentifier is createdByUserSerial

    medicineList = [].concat favMedicineList
    medicineList.sort (left, right)->
      return -1 if left.data.brandName < right.data.brandName
      return 1 if left.data.brandName > right.data.brandName
      return 0

    for medicine in medicineList
      medicine.flags = 
        isLocalOnly: true

    @matchingFavoriteMedicineList = medicineList
    # console.log 'matchingFavoriteMedicineList:', @matchingFavoriteMedicineList

  _makeNewPrescription: ()->
    @prescription = 
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: @visit.serial
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      availableToPatient: true
      organizationId: @currentOrganization.idOnServer
      
    @isPrescriptionValid = true

  _makeDuplicateMedicineEditablePart: ()->
    @duplicateMedicineEditablePart =
      startDateTimeStamp: lib.datetime.now()
      endDateTimeStamp: lib.datetime.now()

    @computedEndDate = null
    @endDateTimeTypeArgument2SelectedIndex = 0
    @endDateTimeTypeSelectedIndex = 0


  _savePrescription: ()->      

    if @visit.prescriptionSerial is null
      @prescription.serial = @generateSerialForPrescription()
      @visit.prescriptionSerial = @prescription.serial
      @_saveVisit()

    @prescription.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'visit-prescription', @prescription, ({serial})=> @prescription.serial is serial
    @domHost.showToast 'Prescription Saved.'



  _notifyInvalidPrescription: ->
    @isPrescriptionValid = false
    @domHost.showModalDialog 'Invalid Prescription Provided'


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
  

  deleteMedicinePressed: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#prescribed-medicine-list-repeater'

    index = e.model.index
    medicine = @matchingPrescribedMedicineList[index]

    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        # console.log medicine.serial
        # app.db.remove 'patient-medications', medicine.serial


        id = (app.db.find 'patient-medications', ({serial})-> serial is medicine.serial)[0]._id

        app.db.remove 'patient-medications', id
        app.db.insert 'patient-medications--deleted', { serial: medicine.serial }
        @splice 'matchingPrescribedMedicineList', index, 1
        @domHost.showToast 'Medicine Deleted!'

  _saveMedicine: (data)->
    app.db.upsert 'patient-medications', data, ({serial})=> data.serial is serial


  _isNthWeekSelectedAsEndDate: (index)->
    if index isnt 0 && !(@endDateTimeTypeList.length is index + 1)
      return true
    return false


  _endDateTimeTypeSelectedIndexChanged: ->
    endDateTimeTypeValue = @get ['endDateTimeTypeList', @endDateTimeTypeSelectedIndex]
    endDateTimeTypeArgument2Value = @get ['endDateTimeTypeArgument2List', @endDateTimeTypeArgument2SelectedIndex]
    endDateTimeTypeValue += ' ' + endDateTimeTypeArgument2Value
    # make end date object from week, days
    startDate = @get 'duplicateMedicineEditablePart.startDateTimeStamp'
    week = parseInt(endDateTimeTypeValue.substr 0,1)
    days = parseInt(endDateTimeTypeArgument2Value.substr 0,1)
    if startDate and (week or days)
      endDateTimeStamp = @_makeEndDateStampfromCustom startDate, week, days
      @set 'duplicateMedicineEditablePart.endDateTimeStamp', endDateTimeStamp


  # _doseValueChanged: (e)->
  #   if @duplicateMedicineEditablePart.dose > 20
  #     @duplicateMedicineEditablePart.dose = 20
  #     e.target.value = 20
  #   if @duplicateMedicineEditablePart.dose < 1
  #     @duplicateMedicineEditablePart.dose = 1
  #     e.target.value = 1

  getClassForItem: (item, selected) ->

    if selected
      return 'item expanded'
    return 'item'

  _makeDuplicatedMedicineFromFavorite:(medicine) ->

    duplicateMedicine = 
      serial: @generateSerialForMedication 'DPMD'
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      prescriptionSerial: @prescription.serial

    duplicateMedicine.data = medicine.data

    duplicateMedicine.data.endDateTimeStamp = @duplicateMedicineEditablePart.endDateTimeStamp
    duplicateMedicine.data.startDateTimeStamp = @duplicateMedicineEditablePart.startDateTimeStamp

    app.db.insert 'patient-medications', duplicateMedicine
    @domHost.showToast 'Medicine Added.'
    @_makeDuplicateMedicineEditablePart()

  _makeDuplicatedMedicineFromCurrent: ()->
    duplicateMedicine = 
      serial: @generateSerialForMedication 'DP'
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      prescriptionSerial: @prescription.serial
      data:
        brandName: @selectedCurrentMedicineData.data.brandName
        comments: @selectedCurrentMedicineData.data.comments
        direction: @selectedCurrentMedicineData.data.direction
        dose: @selectedCurrentMedicineData.data.dose
        doseDirection: @selectedCurrentMedicineData.data.doseDirection
        timeOfDay: @selectedCurrentMedicineData.data.timeOfDay
        doseUnit: @selectedCurrentMedicineData.data.doseUnit
        endDateTimeStamp: @continueMedicineEndsOnDate
        form: @selectedCurrentMedicineData.data.form
        genericName: @selectedCurrentMedicineData.data.genericName
        intakeDateTimeStampList: @selectedCurrentMedicineData.data.intakeDateTimeStampList
        intervalInHours: @selectedCurrentMedicineData.data.intervalInHours
        manufacturer: @selectedCurrentMedicineData.data.manufacturer
        nextDoseDateTimeStamp: @selectedCurrentMedicineData.data.nextDoseDateTimeStamp
        numberOfRefill: @selectedCurrentMedicineData.data.numberOfRefill
        quantityPerPrescription: @selectedCurrentMedicineData.data.quantityPerPrescription
        remind: @selectedCurrentMedicineData.data.remind
        route: @selectedCurrentMedicineData.data.route
        startDateTimeStamp: @selectedCurrentMedicineData.data.startDateTimeStamp
        status: @selectedCurrentMedicineData.data.status
        strength: @selectedCurrentMedicineData.data.strength
        timesPerInterval: @selectedCurrentMedicineData.data.timesPerInterval

    return duplicateMedicine



  continueMedicinePressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#current-medicine-list-repeater'
    index = repeater.indexForElement el
    # currentMedicine = @matchingCurrentMedicineList[index]
    @selectedCurrentMedicineData = @matchingCurrentMedicineList[index]
    @continueMedicineEndsOnDate = lib.datetime.now()

    @$$('#dialogContinueCurrentMedication').toggle()

  

  addSelectedCurrentMedicine: ()->
    # Addeded New Medicine 
    medicine = @_makeDuplicatedMedicineFromCurrent()

    if @visit.prescriptionSerial is null
      @_savePrescription()
      medicine.prescriptionSerial = @prescription.serial
    else
      medicine.prescriptionSerial = @prescription.serial

    app.db.insert 'patient-medications', medicine
    @domHost.showToast 'Medicine Added.'

    # Set Status = 'stopped' for Selected Current Medicine
    @selectedCurrentMedicineData.data.status = 'stopped'
    @_saveMedicine @selectedCurrentMedicineData

    @selectedCurrentMedicineData = {}

    # Reload List Prescribed Medications
    @_listPrescribedMedications @prescription.serial
    @continueMedicineEndsOnDate = lib.datetime.now()

    @$$('#dialogContinueCurrentMedication').close()


  stopMedicinePressed: (e)->
    el = @locateParentNode e.target, 'PAPER-MENU-BUTTON'
    el.opened = false
    repeater = @$$ '#current-medicine-list-repeater'
    index = repeater.indexForElement el
    medicine = @matchingCurrentMedicineList[index]

    medicine.data.status = 'stopped'
    medicine.lastModifiedDatetimeStamp = lib.datetime.now()
    @_saveMedicine medicine
    @domHost.showToast 'Medicine Stopped!'

    @_listCurrentMedications @patient.serial


  addFavMedicineAsNewMedicineBtnPressed: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    repeater = @$$ '#favorite-medicine-list-repeater'
    index = repeater.indexForElement el
    favMedicine = @matchingFavoriteMedicineList[index]

    params = @domHost.getPageParams()

    @_savePrescription()

    @_makeDuplicatedMedicineFromFavorite favMedicine

    @_listPrescribedMedications @prescription.serial


  deleteFavoriteMedicinePressed: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    repeater = @$$ '#favorite-medicine-list-repeater'
    index = repeater.indexForElement el
    medicine = @matchingFavoriteMedicineList[index]

    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        # console.log medicine.serial
        # app.db.remove 'patient-medications', medicine.serial


        id = (app.db.find 'favorite-medicine-list', ({serial})-> serial is medicine.serial)[0]._id

        app.db.remove 'favorite-medicine-list', id
        app.db.insert 'favorite-medicine-list--deleted', { serial: medicine.serial }
        # @splice 'prescribedMedicineList', index, 1
        @domHost.showToast 'Favorite Medicine Deleted!'
        @_listFavoriteMedicine(@user.serial)



  _resetMedicineForm: ()->
    @medicine =
      serial: @generateSerialForMedication()
      organizationId: @currentOrganization.idOnServer
      genericName: ''
      strength: ''
      brandName: ''
      manufacturer: ''
      dose: 1
      doseDirection: ''
      timeOfDay: {
        morning: 0
        noon: 0
        night: 0
      }
      doseUnit: ''
      form: ''
      startDateTimeStamp: lib.datetime.mkDate new Date
      endDateTimeStamp: null
      route: ()-> return @routeList[@routeSelectedIndex]
      direction: ()-> return @directionList[@directionSelectedIndex]
      quantityPerPrescription: 1
      numberOfRefill: 1
      comments: ''
      intakeDateTimeStampList: []
      nextDoseDateTimeStamp: null
      timesPerInterval: 1
      intervalInHours: 24
      remind: false
      status: 'continue'
    
    @strengthSelectedIndex = 0
    @medicineFormSelectedIndex = 0
    @doseUnitSelectedIndex = 0
    @routeSelectedIndex = 0
    @endDateTimeTypeSelectedIndex = 0
    @endDateTimeTypeArgument2SelectedIndex = 0
    @showCustomDoseDropdown = false
    @directionSelectedIndex = 0




  _checkValidity: (inputsToValidate, cbfn)->
    validationStatusList = []
    for item in inputsToValidate
      unless @medicine.item
        isValid = @.$$("##{item}").validate()
        validationStatusList.push isValid
    
    status = validationStatusList.every (value)->
      return value
    
    cbfn status  

  validate: (e)->
    e.target.validate()
  
  cancelButtonClicked: (e)->
    @_resetMedicineForm()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  # makeNewVisitButtonPressed: (e)->
  #   @domHost.setSelectedVisitSerial 'new'
  #   @domHost.selectedPatientPageIndex = 1
  #   @domHost.selectedPatientPageIndex = 0

  toggleGuideline: (e)->
    @.$.guidelineContainer.toggle()

  
    
  _loadDefaultMedicineCompositionList: ->  
    brandNameMap = {}
    manufacturerMap = {}
    genericNameMap = {}
    for item in @medicineCompositionList
      brandNameMap[item.brandName] = null
      manufacturerMap[item.manufacturer] = null
      if item.composition
        genericNameMap[item.composition[0].genericName] = null
    # @brandNameSourceDataList = ({text: item, value: item} for item in Object.keys brandNameMap)
    @manufacturerSourceDataList = ({text: item, value: item} for item in Object.keys manufacturerMap)
    @genericNameSourceDataList = ({text: item, value: item} for item in Object.keys genericNameMap)

    # Combining Brand Strengh and Type in One line
    for item in @medicineCompositionList
      if item.composition?.length > 1
        for comp in item.composition
          @brandNameSourceDataList.push {text: "#{item.brandName} [#{comp.strength}] #{item.type}", value: item.brandName}
      else
        @brandNameSourceDataList.push {text: "#{item.brandName} [#{item.composition?[0].strength}] #{item.type}", value: item.brandName}



  brandNameAutocompleteSelected: (e)->
    brandName = e.detail.value
    @matchingMedicineList = (item for item in @medicineCompositionList when item.brandName is brandName)
    
    if @matchingMedicineList.length isnt 0
      @set 'medicine.manufacturer', @matchingMedicineList[0].manufacturer
      @set 'medicine.genericName', @matchingMedicineList[0].composition[0].genericName
      
      selectedMedicineFormList = lib.array.unique (item.type for item in @matchingMedicineList)
      @medicineFormList = []
      @medicineFormList = selectedMedicineFormList
      @push 'medicineFormList', 'Custom'
      @set 'medicineFormSelectedIndex', null
      # HACK - to fix setting selected index to other paper-menu element
      lib.util.delay 5, ()=>
        @set 'medicineFormSelectedIndex', 0
      # HACK End

    # @populateDoseGuideline()

    # Validation
    inputsToValidate = ['genericName', 'brandName', 'manufacturer']
    @_checkValidity inputsToValidate, ()=>
    
    @.$.form.invalid = false
    @.$.doseUnit.invalid = false
    
  
  genericNameAutocompleteSelected: (e)->
    genericName = e.detail.text
    # For populating matching medicine brand name
    
    for item in @medicineCompositionList
     if item.composition
       if item.composition[0].genericName is genericName
        @matchingMedicineList.push item

    brandNameMap = {}
    manufacturerMap = {}
    for item in @matchingMedicineList
      brandNameMap[item.brandName] = null
      manufacturerMap[item.manufacturer] = null
    @brandNameSourceDataList = ({text: item, value: item} for item in Object.keys brandNameMap)
    @manufacturerSourceDataList = ({text: item, value: item} for item in Object.keys manufacturerMap)
    # @genericNameDependency = "by #{genericName} only"

    # ==============
    # @populateDoseGuideline()

  manufacturerAutocompleteSelected: (e)->
    manufacturer = e.detail.text
    matchingMedicineList = (item for item in @medicineCompositionList when item.manufacturer is manufacturer)
    if matchingMedicineList.length isnt 0
      genericNameMap = {}
      brandNameMap = {}
      for item in matchingMedicineList
        brandNameMap[item.brandName] = null
        if item.composition
          genericNameMap[item.composition[0].genericName] = null
      @genericNameSourceDataList = ({text: item, value: item} for item in Object.keys genericNameMap)
      @brandNameSourceDataList = ({text: item, value: item} for item in Object.keys brandNameMap)
      # @manufacturerDependency = "by #{manufacturer} only"

  brandNameCleared: (e)->
    @_resetMedicineForm()
    @activeDoseGuideline = {}
    @_loadDefaultMedicineCompositionList()

  manufacturerCleared: (e)->
    @set 'medicine.manufacturer', null
    @_loadDefaultMedicineCompositionList()
    
  genericNameCleared: (e)->
    @set 'medicine.genericName', null
    @activeDoseGuideline = {}
    @_loadDefaultMedicineCompositionList()
  
  
  _isNthWeekSelectedAsEndDate: (index)->
    if index isnt 0 && !(@endDateTimeTypeList.length is index + 1)
      return true
    return false

  _isCustomSelectedAsEndDate: (index)->
    if (@endDateTimeTypeList.length is index + 1)
      return true
    return false

  _isRouteCustom: ->
    return true if @routeSelectedIndex is @routeList.length-1
    return false

  _isUnitCustom: ->
    return true if @doseUnitSelectedIndex is @doseUnitList.length-1
    return false
  
  _isStregnthDropdown: ->
    return true if @matchingMedicineList.length

  _isStregnthCustom: ->
    return true if @matchingMedicineList.length is 0
    return true if @strengthSelectedIndex is @strengthList.length-1

  _isFormCustom: ->
    return true if @medicineFormSelectedIndex is @medicineFormList.length-1

  _makeEndDateStampfromCustom: (startDate, week, days)->
    unless week <= 0
      days += week*7
    endDate = new Date(startDate)
    endDate = endDate.setDate(endDate.getDate() + days)
  

  # Observing Changes

  _doseValueChanged: (e)->
    if @medicine.dose > 20
      @medicine.dose = 20
      e.target.value = 20
    if @medicine.dose < 1
      @medicine.dose = 1
      e.target.value = 1
    
  
  _compouteTimesPerInterval: (morning, noon, night)->
    interval = (parseInt morning) + (parseInt noon) + (parseInt night)
    
    if interval is 0
      @set 'medicine.timesPerInterval', 1
    else
      @set 'medicine.timesPerInterval', interval
  
  _computeIntervalInHours: (timesPerInterval, intervalInDays)->
    # console.log intervalInDays
    # console.log timesPerInterval
    intervalInHours = Math.floor ((intervalInDays*24) / timesPerInterval)
    @set 'medicine.intervalInHours', intervalInHours

  _directionSelectedIndexChanged: ()->
    item = @get ['directionList', @directionSelectedIndex]
    @set 'medicine.direction', item

  _medicineFormSelectedIndexChanged: ()->
    return if @medicineFormSelectedIndex is null
    item = @get ['medicineFormList', @medicineFormSelectedIndex]
    if @medicineFormSelectedIndex is @medicineFormList.length-1
      # If Form is Custom Set Unit & Route to Custom
      @doseUnitSelectedIndex = @doseUnitList.length-1
      @routeSelectedIndex = @routeList.length-1
      @set 'medicine.form', ''
      @set 'medicine.doseUnit', ''
      @set 'medicine.strength', ''
    else
      @set 'medicine.form', item

    # Change strength depending on form
    if @matchingMedicineList
      strengthList = []
      for medicine in @matchingMedicineList
        if medicine.type is item
          strengthList.push medicine.composition[0].strength
     
      @set 'strengthList', []
      @set 'strengthList', strengthList
      @push 'strengthList', 'Custom'
      @set 'strengthSelectedIndex', null
      # HACK - to fix setting selected index to other paper-menu element
      lib.util.delay 10, =>
        @set 'strengthSelectedIndex', 0
      # HACK End

    # Change dose unit depending on form
    unitMap = {
      'Tablet': ['Tablet']
      'Injection': ['Injection']
      'Syrup': ['ml', 't.s.f', 'teaspoonfull']
      'Drop': ['Drop']
      'Capsule': ['Capsule']
      'Suspension': ['ml', 't.s.f', 'teaspoonfull']
      'I.V Injection': ['ampoule', 'm/l', 'vial']
      'I.M injection': ['ampoule', 'm/l', 'vial']
      'I.M/I.V Injection': ['ampoule', 'm/l', 'vial']
      'IV/IM Injection': ['ampoule', 'm/l', 'vial']
      'S/C Injection' : ['Injection']
      'PR (Per Rectal)':  ['Suppository']
      'Suppository':  ['Suppository']
      'Solution': ['ml']
      'Ointment': ['application']
      'Cream': ['application']
      'Skin Patch': ['skin patch']
    }

    routeMap = {
      'Tablet': ['p.o']
      'Injection': ['i.v injection', 'i.m injection', 's/c injection']
      'Syrup': ['p.o']
      'Drop': ['p.o', 'topical application ear', 'topical application eye']
      'Capsule': ['p.o']
      'Suspension': ['p.o']
      'I.V Injection': ['i.v injection']
      'I.M Injection': ['i.m injection']
      'S/C Injection': ['s/c injection']
      'PR (Per Rectal)':  ['p.r (per rectal)']
      'Suppository':  ['p.r (per rectal)']
      'Solution': ['nebulizer']
      'Cream': ['topical application skin', 'topical application eye', 'topical application ear', 'intravaginal']
      'Ointment': ['topical application skin','topical application eye', 'topical application ear', 'intravaginal']
      'Skin Patch': ['transdermal']
    }

    for key, value of unitMap
      if key is item
        @set 'doseUnitList', []
        @set 'doseUnitList', value
        @push 'doseUnitList', 'Custom'
        @set 'doseUnitSelectedIndex', null
        # HACK - to fix setting selected index to other paper-menu element
        lib.util.delay 10, =>
          @set 'doseUnitSelectedIndex', 0
        # HACK End
        break

    for key, value of routeMap
      if key is item
        @set 'routeList', []
        @set 'routeList', value
        @push 'routeList', 'Custom'
        @set 'routeSelectedIndex', null
        # HACK - to fix setting selected index to other paper-menu element
        lib.util.delay 10, =>
          @set 'routeSelectedIndex', 0
        # HACK End
        break

    @.$.form.invalid = false
    @.$.doseUnit.invalid = false

  _routeSelectedIndexChanged: ->
    if @routeSelectedIndex is @routeList.length-1
      @set 'medicine.route', ''
    else
      item = @get ['routeList', @routeSelectedIndex]
      @set 'medicine.route', item
    
  _strengthSelectedIndexChanged: ->
    item = @get ['strengthList', @strengthSelectedIndex]
    unless @strengthSelectedIndex is @strengthList.length-1
      @set 'medicine.strength', item

  _doseUnitSelectedIndexChanged: ->
    unless @doseUnitSelectedIndex is @doseUnitList.length-1
      item = @get ['doseUnitList', @doseUnitSelectedIndex]
      @set 'medicine.doseUnit', item

  _showComputedEndDate: (endDate)->
    return null if @endDateTimeTypeSelectedIndex is 0
    return lib.datetime.mkDate endDate, 'dd-mmm-yyyy'

  _computeQuantityPerPrescription: (dose, timesPerInterval, intervalInDays, endDate, startDate)->
    # console.log (Date.parse startDate)
    if (Date.parse endDate) > 0
      oneDay = 1000*60*60*24
      diffMs = (Date.parse endDate) - (Date.parse startDate)
      totalDay =  Math.round(diffMs / oneDay)
      #FOR ROUNDING TO 2 Decimal, quantityPerPrescription = (Math.round (timesPerInterval * (totalDay/intervalInDays)) * 100)/100
      quantityPerPrescription = ( Math.ceil (timesPerInterval * (totalDay / intervalInDays)) ) * dose
    else
       quantityPerPrescription = timesPerInterval * dose
    @set 'medicine.quantityPerPrescription', quantityPerPrescription

  asNeededSelected: (e)->
    if e.target.checked
      @.$.endDate.disabled = true
      @medicine.endDateTimeStamp = null
    else
      @.$.endDate.disabled = false

  
  saveMedicineButtonClicked: (e)->
    params = @domHost.getPageParams()

    # Check Validation then send
    
    if @medicineFormSelectedIndex is @medicineFormList.length-1
      inputsToValidate = ['brandName', 'strength', 'custom-form', 'custom-dose-unit', 'custom-route']
    else
      inputsToValidate = ['brandName', 'form', 'doseUnit']

    @_checkValidity inputsToValidate, (status)=>
      if status
        # HACK to match object signature with Doctor App Medication Object for syncing purpose
        medicine = {}
        medicine.data = @medicine
        medicine.serial = @medicine.serial
        delete medicine.data.serial
        #HACK end

        

        medicine.createdDatetimeStamp = lib.datetime.now()
        medicine.lastSyncedDatetimeStamp = null
        medicine.createdByUserSerial = @user.serial
        medicine.patientSerial = params['patients']

        if @visit.prescriptionSerial is null
          @_savePrescription()
          medicine.prescriptionSerial = @prescription.serial
        else
          medicine.prescriptionSerial = @prescription.serial

        medicine.lastModifiedDatetimeStamp = lib.datetime.now()

        app.db.insert 'patient-medications', medicine

        @domHost.showToast "Medicine Added!"
        @_resetMedicineForm()
        @_listPrescribedMedications @prescription.serial


      else
        @domHost.showModalDialog "Enter Required Inputs"


  _makeNewFavoriteMedicine: (medicine) ->
    # console.log medicine
    
    favoriteMedicine = 
      serial: @generateSerialForFavoriteMedicine()
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
    favoriteMedicine.data = medicine.data
    favoriteMedicine.data.startDateTimeStamp = lib.datetime.now()
      

    # console.log 'favoriteMedicine', favoriteMedicine
        

    app.db.insert 'favorite-medicine-list', favoriteMedicine




  saveAndAddAsFavoriteMedicinePressed: (e)->
    params = @domHost.getPageParams()
    # Check Validation then send
    
    if @medicineFormSelectedIndex is @medicineFormList.length-1
      inputsToValidate = ['genericName', 'brandName', 'manufacturer', 'strength', 'custom-form', 'custom-dose-unit', 'custom-route']
    else
      inputsToValidate = ['genericName', 'brandName', 'manufacturer', 'strength', 'form', 'doseUnit']

    @_checkValidity inputsToValidate, (status)=>
      if status
        # HACK to match object signature with Doctor App Medication Object for syncing purpose
        medicine = {}
        medicine.data = @medicine
        medicine.serial = @medicine.serial
        delete medicine.data.serial
        #HACK end
        medicine.createdDatetimeStamp = lib.datetime.now()
        medicine.lastSyncedDatetimeStamp = null
        medicine.createdByUserSerial = @user.serial
        medicine.patientSerial = params['patients']

        if @visit.prescriptionSerial is null
          @_savePrescription()
          medicine.prescriptionSerial = @prescription.serial
        else
          medicine.prescriptionSerial = @prescription.serial

        medicine.lastModifiedDatetimeStamp = lib.datetime.now()
        # console.log medicine
        app.db.insert 'patient-medications', medicine

        @_makeNewFavoriteMedicine medicine
        @_resetMedicineForm()
        @_listPrescribedMedications @prescription.serial
        @_listFavoriteMedicine @user.serial
        @domHost.showToast 'Added & Saved As a Favorite!'

      else
        @domHost.showModalDialog "Enter Required Inputs"


      

  # editMedicinePressed: (e)->
  #   # TODO - Validation message
  #   unless @medicine.data.brandName is null
  #     @medicine.lastModifiedDatetimeStamp = lib.datetime.now()
  #     @_saveMedicine(@medicine)
  #     @domHost.showToast 'Updated Successfully!'
  #     window.history.back()







  ## REGION: doseGuideline - Start
  shouldShowDisclaimer: (showGuidelineDisclaimer)->
    val = lib.localStorage.getItem 'showGuidelineDisclaimer'
    if val or (val is 'null')
      return true 
    else 
      return false

  showGuidelineDisclaimerChanged: (e)->
    lib.localStorage.setItem 'showGuidelineDisclaimer', !e.target.checked
    @set 'showGuidelineDisclaimer', !e.target.checked
    val = lib.localStorage.getItem 'showGuidelineDisclaimer'
    # console.log val
  
  $doesPassFilter: (doseGuideline, dose, subDose, guidelineIndicationSelectedIndex, guidelineAgeSelectedIndex)->
    guidelineAgeText = @guidelineAgeList[guidelineAgeSelectedIndex]
    guidelineIndicationText = @guidelineIndicationList[guidelineIndicationSelectedIndex]

    unless subDose is 'not-available'
      alert 'something went wrong'

    agePasses = false
    if guidelineAgeText is 'No Age Indicated'
      agePasses = true
    else
      agePasses = (guidelineAgeText is (@_ageToText dose))

    indicationPasses = false
    if guidelineIndicationText is 'No Special Indications'
      indicationPasses = true
    else
      indicationPasses = (guidelineIndicationText in (@_extractIndication dose))

    if agePasses and indicationPasses
      return true
    else
      return false

  _extractIndication: (item)->
    keyList = [ 'indication', 'secondaryIndication', 'tertiaryIndication', 'condition', 'secondaryCondition' ]
    array = []
    for key in keyList
      if key of item
        array.push item[key]
    return array

  _ageToText: (dose)->
    if 'ageGroup' of dose
      text = dose.ageGroup

    if 'ageRange' of dose

      if 'min' of dose.ageRange
        if 'max' of dose.ageRange
          text = "from #{dose.ageRange.min} #{dose.ageRange.unit}(s) to #{dose.ageRange.max} #{dose.ageRange.unit}(s)"
        else
          text = "#{dose.ageRange.min} #{dose.ageRange.unit}(s) and upwards"
      else
        text = "Upto #{dose.ageRange.max} #{dose.ageRange.unit}(s)"

    return text

  _setActiveDoseGuideline: (doseGuideline)->
    @set 'activeDoseGuideline', doseGuideline

    guidelineIndicationList = []
    for dose in doseGuideline.doseList
      keyList = @_extractIndication dose
      guidelineIndicationList = [].concat guidelineIndicationList, keyList

      # for subDose in dose.subDoseList
      #   keyList = @_extractIndication subDose
      #   guidelineIndicationList = [].concat guidelineIndicationList, keyList

    guidelineIndicationList = lib.array.unique guidelineIndicationList

    guidelineIndicationList.unshift 'No Special Indications'

    @set 'guidelineIndicationList', guidelineIndicationList
    @set 'guidelineIndicationSelectedIndex', 0

    guidelineAgeList = []
    for dose in doseGuideline.doseList

      text = @_ageToText dose

      if text.length > 0
        guidelineAgeList.push text

    guidelineAgeList = lib.array.unique guidelineAgeList

    guidelineAgeList.unshift 'No Age Indicated'

    @set 'guidelineAgeList', guidelineAgeList
    @set 'guidelineAgeSelectedIndex', 0


  populateDoseGuideline: ->
    genericName = @get 'medicine.genericName'

    matchingDoseGuideline = null
    for doseGuideline in @doseGuidelineList
      if genericName is doseGuideline.genericName
        matchingDoseGuideline = doseGuideline
        break

    if matchingDoseGuideline
      @_setActiveDoseGuideline matchingDoseGuideline


  runSanitizationCheckForDoseGuidelineList: (doseGuidelineList)->
    handledDoseKeyList = [ 'subDoseList', 'route', 'ageGroup', 'description', 'ageRange', 'notRecommended', 'indication', 'secondaryIndication', 'notes', 'condition', 'alternateRoiute', "secondaryCondition", "tertiaryIndication" ]
    handledDoseKeyList = [].concat handledDoseKeyList, []
    knownMissingDoseKeyList = []

    handledSubDoseKeyList = [ "type", "unit", "amount", "timesDaily", "connectionToMeal", "notes", "condition" ]
    handledSubDoseKeyList = [].concat handledSubDoseKeyList, [ "Interval","treatmentPeriod","timesWeekly","notRecommended","secondaryIndication","timesMonthly","indication" ]
    ## NOTE - the list below is ignored. they are too advanced for the interface we have currently.
    # we don't even support most of them in our data structure.
    handledSubDoseKeyList = [].concat handledSubDoseKeyList, [  ] # ignored
    knownMissingSubDoseKeyList = []

    for doseGuideline in doseGuidelineList

      for dose in doseGuideline.doseList
        missingKeyList = @$listMissingKeys dose, handledDoseKeyList
        for missingKey in missingKeyList
          unless missingKey in knownMissingDoseKeyList
            knownMissingDoseKeyList.push missingKey

        if 'subDoseList' of dose
          for subDose in dose.subDoseList
            # if 'route' of subDose
            #   console.log 'continue'
            #   continue
            missingKeyList = @$listMissingKeys subDose, handledSubDoseKeyList
            for missingKey in missingKeyList
              if missingKey is 'condition'
                console.log subDose
              unless missingKey in knownMissingSubDoseKeyList
                knownMissingSubDoseKeyList.push missingKey

    # console.log 'missing dose keys', knownMissingDoseKeyList
    # console.log 'missing sub dose keys', knownMissingSubDoseKeyList

  _fillCommons: (dose, subDose)->

    if subDose.connectionToMeal

      strMap = {
        "after meal": 'After meal'
        "with meal": 'After meal'
        "with food": 'After meal'
        "after food": 'After meal'
        "after a meal": 'After meal'
        "with meals": 'After meal'
        "before": "Before meal"
      }

      if subDose.connectionToMeal.when of strMap
        index = @directionList.indexOf strMap[subDose.connectionToMeal.when]
        @set 'directionSelectedIndex', index

  _fillMinOrMax: (dose, subDose, minOrMaxKey)->
    if subDose.timesDaily and subDose.timesDaily[minOrMaxKey]
      @set 'medicine.timesPerInterval', subDose.timesDaily[minOrMaxKey]

    if subDose.amount and subDose.amount[minOrMaxKey]
      'todo when interface supports'

    if subDose.route
      'todo when interface supports. take hints from subDose.connectionToMeal'

  fillMinimumPressed: (e)->
    { dose, subDose } = e.model
    @_fillCommons dose, subDose
    @_fillMinOrMax dose, subDose, 'min'

  fillMaximumPressed: (e)->
    { dose, subDose } = e.model
    @_fillCommons dose, subDose
    @_fillMinOrMax dose, subDose, 'max'


  ## REGION: doseGuideline - End

  #####################################################################
  ### Prescription - end
  #####################################################################

  #####################################################################
  ### Stymptoms - start
  #####################################################################

  ## Make New Symptoms Object
  _makeNewIdentifiedSymptomsObject: ()->
    @identifiedSymptomsObject =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      organizationId: @currentOrganization.idOnServer
      data:
        symptomsList: []
      availableToPatient: true

    # console.log @identifiedSymptomsObject
      
    @isIdentifiedSymptomsValid = true
      

  # _makeCustomSymptomsObject : ()->
  #   @customSymptomsObject
  #     serial: @generateSerialForCustomSymptoms
  #     lastModifiedDatetimeStamp: lib.datetime.now()
  #     createdDatetimeStamp: lib.datetime.now()
  #     lastSyncedDatetimeStamp: 0
  #     createdByUserSerial: @user.serial
  #     data:
  #       name: ''


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

  _loadSymptomsListFromSystem: (userIdentifier)->
    @set 'symptomsDataList', []
    @domHost.getStaticData 'symptomsList', (symptomsList)=>
      # console.log symptomsList

      unless symptomsList.length is 0
        for item in symptomsList
          unless item.name is ''
            object = {}
            object.label = item.name
            object.value = item    
            @push "symptomsDataList", object

      # get all custom symptoms
      customSymptomslist = app.db.find 'custom-symptoms-list', ({createdByUserSerial})=> userIdentifier is createdByUserSerial
      # console.log customInvestigationlist
      
      # pushed all custom symptoms on master investigatin list
      unless customSymptomslist.length is 0
        for item in customSymptomslist

          customObject = {}
          customObject.label = item.data.name
          customObject.value = item.data.name

          # console.log investigation

          @push "symptomsDataList", customObject

      @symptomsDataList.sort (left, right)->
        return -1 if left.label < right.label
        return 1 if left.label > right.label
        return 0

      # console.log @symptomsDataList


  ## User Added Custom Symptoms
  saveUserAddedCustomSymptoms: (symptomName)->

    object =
      serial: @generateSerialForCustomSymptoms
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      data:
        name: symptomName

    app.db.insert 'custom-symptoms-list', object
    
  _duplicationSymptomsCheck: (symptomName)->
    for item in @symptomsDataList
      if item.label is symptomName
        return true
  
  _notifyInvalidIdentifeidSymptoms: ->
    @isIdentifiedSymptomsValid = false
    @domHost.showModalDialog 'Invalid Stymptoms Provided'

  ## Added Identified Symtoms
  _selectedAddedIdentifiedSymtomsDeleteBtnPressed: (e) ->
    index = e.model.index
    @splice('addedIdentifiedSymptomsList', index, 1)

    # todo :: delete object from db if addedIdentifiedSymptomsList length is 0
    identifiedSymtomsSerial = @identifiedSymptomsObject.serial
    if @addedIdentifiedSymptomsList.length is 0
      list = app.db.find 'visit-identified-symptoms', ({serial})-> serial is identifiedSymtomsSerial
      # console.log list
      id = list[ 0 ]._id
      app.db.remove 'visit-identified-symptoms', id
      app.db.insert 'visit-identified-symptoms--deleted', { serial: @identifiedSymptomsObject.serial }
      @visit.identifiedSymptomsSerial = null
      @_saveVisit()
      @domHost.showToast 'Deleted Successfully!'

    else
      @saveIdentifiedSymptoms()
      @domHost.showToast 'Deleted Successfully!'


  comboBoxKeyUpSymptomsValueChanged: (e)->
    unless @comboBoxSymptomsInputValue is ''

      if e.which is 13 # ENTER/RETURN

        # console.log @comboBoxSymptomsInputValue

        if typeof @comboBoxSymptomsInputValue is 'object'
          # Push on Added Identified Symptoms List
          @push 'addedIdentifiedSymptomsList', {name: @comboBoxSymptomsInputValue.name}

        else
          # Push on Added Identified Symptoms List
          @push 'addedIdentifiedSymptomsList', {name: @comboBoxSymptomsInputValue}

          unless @_duplicationSymptomsCheck @comboBoxSymptomsInputValue
            # Save User added custom Symptoms
            @saveUserAddedCustomSymptoms @comboBoxSymptomsInputValue

          # Push Custom Symptoms Name on Master Symptoms List
          @push "symptomsDataList", { label: @comboBoxSymptomsInputValue, value: @comboBoxSymptomsInputValue }

          # Load Symptoms Data

        

        # Save Identified Symptoms
        @saveIdentifiedSymptoms()




  addSymptoms:() ->
    unless @comboBoxSymptomsInputValue is ''
      if typeof @comboBoxSymptomsInputValue is 'object'
        trimmedVal = @comboBoxSymptomsInputValue.name.trim()
        # Push on Added Identified Symptoms List if doesnt exist
        unless @_duplicateIdentifiedSymptom trimmedVal
          @push 'addedIdentifiedSymptomsList', {name: trimmedVal}
        else
          @domHost.showToast 'Symptom already added!'
          return

      else
        trimmedVal = @comboBoxSymptomsInputValue.trim()
        unless trimmedVal is ''
          # Push on Added Identified Symptoms List if doesnt exist
          unless @_duplicateIdentifiedSymptom trimmedVal
            @push 'addedIdentifiedSymptomsList', {name: trimmedVal}
          else
            @domHost.showToast 'Symptom already added!'
            return

          unless @_duplicationSymptomsCheck trimmedVal
            # Save User added custom Symptoms
            @saveUserAddedCustomSymptoms trimmedVal

          # Push Custom Symptoms Name on Master Symptoms List
          @push "symptomsDataList", { label: trimmedVal, value: trimmedVal }
          # Load Symptoms Data
        else
          @domHost.showToast 'Type/Add a Symptom first!'
          return

      # Save Identified Symptoms
      @saveIdentifiedSymptoms()


  _duplicateIdentifiedSymptom: (newSymptom)->
    console.log 'test symptom list ', @addedIdentifiedSymptomsList
    for symptomName in @addedIdentifiedSymptomsList
      return true if symptomName.name is newSymptom


  saveIdentifiedSymptoms: ()->
    # console.log @identifiedSymptomsObject
    unless @addedIdentifiedSymptomsList.length is 0
      @identifiedSymptomsObject.data.symptomsList = @addedIdentifiedSymptomsList

      if @visit.identifiedSymptomsSerial is null
        @identifiedSymptomsObject.serial = @generateSerialForIdentifiedSymptoms()

        ## updated current visit object
        @visit.identifiedSymptomsSerial = @identifiedSymptomsObject.serial
        @_saveVisit()

        @identifiedSymptomsObject.visitSerial = @visit.serial
     
      # Updated Identified Symptoms List
      @identifiedSymptomsObject.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'visit-identified-symptoms', @identifiedSymptomsObject, ({serial})=> @identifiedSymptomsObject.serial is serial
      
      @set 'comboBoxSymptomsInputValue', ''
      @domHost.showToast 'Symptoms Added.'


  #####################################################################
  ### Stymptoms - end
  #####################################################################

  #####################################################################
  ### Examination - start
  #####################################################################


  _loadExaminationList: (userIdentifier)->
  
    @domHost.getStaticData 'examinationList', (examinationList)=>
      for object in examinationList
        unless object.name is ''
          
          unless typeof object.examinationValueList is 'undefined'
            unless object.examinationValueList.length is 0

              if object.examinationValueList.length > 1
                groupExamination = {}
                groupExamination.label = object.name
                groupExamination.value = object
                @push "examinationDataList", groupExamination

                for item in object.examinationValueList
                  if typeof item.name is 'string'

                    # push every examination object
                    examination = {}
                    examination.label = item.name
                    examination.value = {
                      name: item.name
                      examinationValueList: [
                        {
                          value: item.name
                        }
                      ]

                    }
                      
                    @push "examinationDataList", examination
                    

              else
                singleExamination = {}
                singleExamination.label = object.name
                singleExamination.value = object    
                @push "examinationDataList", singleExamination

      # get all custom examination
      customExaminationlist = app.db.find 'custom-examination-list', ({createdByUserSerial})=> userIdentifier is createdByUserSerial
      # console.log customInvestigationlist
      
      # pushed all custom symptoms on master investigatin list
      unless customExaminationlist.length is 0
        for item in customExaminationlist

          customObject = {}
          customObject.label = item.data.name
          customObject.value = item.data

          # console.log investigation

          @push "examinationList", customObject

      # console.log 'examinationDataList', @examinationDataList


  ## Make New Examination Object
  _makeNewExaminationObject: ()->
    @examinationObject =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      organizationId: @currentOrganization.idOnServer
      data:
        examinationValueList: []
      availableToPatient: true

    # console.log @identifiedSymptomsObject
      
    @isExaminationValid = true
      

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
  
  _notifyInvalidExamination: ->
    @isExaminationValid = false
    @domHost.showModalDialog 'Invalid Examination Provided'

  ## User Added Custom Examination
  saveUserAddedCustomExamination: (examinationName)->

    object =
      serial: @generateSerialForCustomExamination
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      data:
        name: examinationName
        examinationValueList: []

    app.db.insert 'custom-examination-list', object

  removeExaminationMember: (e)->
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#added-examination-list-repeater'
    index = repeater.indexForElement el
    memberIndex = e.model.index
    
    string = 'addedExaminationList.' + index + '.examinationValueList'
    @splice string, memberIndex, 1
    # Save Examination
    @saveExamination()

  checkExaminationMember: (e)->
    addedExaminationList = @addedExaminationList
    @set 'addedExaminationList', addedExaminationList

    # Save Examination
    @saveExamination()

      


  ## Added Examination
  _selectedAddedExaminationDeleteBtnPressed: (e) ->
    index = e.model.index
    @splice('addedExaminationList', index, 1)

    # todo :: delete object from db if addedExaminationList length is 0
    examinationSerial = @examinationObject.serial
    if @addedExaminationList.length is 0
      list = app.db.find 'visit-examination', ({serial})-> serial is examinationSerial
      # console.log list
      id = list[ 0 ]._id
      app.db.remove 'visit-examination', id
      app.db.insert 'visit-examination--deleted', { serial: examinationSerial }
      @visit.examinationSerial = null
      @_saveVisit()
      @domHost.showToast 'Deleted Successfully!'

    else
      @saveExamination()
      @domHost.showToast 'Deleted Successfully!'


  comboBoxKeyUpExaminationValueChanged: (e)->
    unless @comboBoxExaminationInputValue is ''

      if e.which is 13 # ENTER/RETURN

        if typeof @comboBoxExaminationInputValue is 'object'
          modifiedList = []

          unless @comboBoxExaminationInputValue.examinationValueList is 0
            for item, index in @comboBoxExaminationInputValue.examinationValueList
              object = {}
              object.value = item.value
              object.checked = false
              modifiedList.push object

            modifiedObject =
              name: @comboBoxExaminationInputValue.name
              examinationValueList: modifiedList

            console.log 'modifiedObject', modifiedObject

            # Push on Added Examination List
            @unshift 'addedExaminationList', modifiedObject

        else
          object =
            name: @comboBoxExaminationInputValue
            examinationValueList: []
          # Push on Added Examination List
          @unshift 'addedExaminationList', object      

        # Save Examination
        @saveExamination()

  openDialogForExaminationMember: (e)->
    @customExaminationValue = ''
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#added-examination-list-repeater'
    @ARBITARY_INDEX = repeater.indexForElement el
    @$$('#dialogExaminationMemberValue').toggle()


  addExaminationMember: ()->
    # console.log 'addedExaminationList', @addedExaminationList
    trimmedVal = @customExaminationValue.trim()
    unless trimmedVal is ''
      unless @_duplicateExaminationMember @addedExaminationList[@ARBITARY_INDEX].examinationValueList, trimmedVal
        object = 
          value: trimmedVal
          checked: true
        # console.log @ARBITARY_INDEX
        string = "addedExaminationList." + @ARBITARY_INDEX + '.examinationValueList'
        
        @push string, object

        # Save Examination
        @saveExamination()
        @$$('#dialogExaminationMemberValue').close()
      
      else
        @domHost.showToast 'Already added!'
        return

    else
      @domHost.showToast 'Type Examination first!'
      return


  _duplicateExaminationMember: (membersList, newMember)->
    for examination in membersList
      return true if examination.value is newMember

  addExamination:() ->
    unless @comboBoxExaminationInputValue is ''
      if typeof @comboBoxExaminationInputValue is 'object'
        trimmedVal = @comboBoxExaminationInputValue.name.trim()
        # Push on Added Examination List if doesnt exist
        unless @_duplicateAddedExamination trimmedVal
          modifiedList = []
          unless @comboBoxExaminationInputValue.examinationValueList is 0
            for item, index in @comboBoxExaminationInputValue.examinationValueList
              object = {}
              object.index = index
              object.value = item.value
              object.checked = false
              modifiedList.push object

            modifiedObject =
              name: @comboBoxExaminationInputValue.name
              examinationValueList: modifiedList

            # console.log 'modifiedObject', modifiedObject

            # Push on Added Examination List
            @unshift 'addedExaminationList', modifiedObject

        else
          @domHost.showToast 'Examination already added!'
          return

      else
        # first check if trimmed empty string
        trimmedVal = @comboBoxExaminationInputValue.trim()
        unless trimmedVal is ''
          unless @_duplicateAddedExamination trimmedVal
            # Push onto Added Examination List if already not added
            object =
              name: trimmedVal
              examinationValueList: []
            @unshift 'addedExaminationList', object
          else
            @domHost.showToast 'Examination already added!'
            return
        
        else
          @domHost.showToast 'Type/Add an Examination first!'
          return
          
      console.log 'addedExaminationList', @addedExaminationList

      # Save Examination
      @saveExamination()


  _duplicateAddedExamination: (newExamination)->
    for examinationName in @addedExaminationList
      return true if examinationName.name is newExamination


  filterExaminationList: (examinationList)->
    modifiedAddedExaminationList = []

    for object in examinationList
      unless object.examinationValueList is 0
        modifiedValueList = []
        for item in object.examinationValueList
          if item.checked
            modifiedValueList.push item

        modifiedObject =
          name: object.name
          examinationValueList: modifiedValueList

      modifiedAddedExaminationList.push modifiedObject

    return modifiedAddedExaminationList



  saveExamination: ()->
    # console.log 'addedExaminationList:', @addedExaminationList
    # console.log "@filterExaminationList:", @filterExaminationList @addedExaminationList

    unless @addedExaminationList.length is 0
      @examinationObject.data.examinationValueList = @filterExaminationList @addedExaminationList
      
      if @visit.examinationSerial is null
        @examinationObject.serial = @generateSerialForExamination()

        ## updated current visit object
        @visit.examinationSerial = @examinationObject.serial
        @_saveVisit()

        @examinationObject.visitSerial = @visit.serial
     
      @examinationObject.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'visit-examination', @examinationObject, ({serial})=> @examinationObject.serial is serial

      @set 'comboBoxExaminationInputValue', ''
      @domHost.showToast 'Examination Updated!'


  #####################################################################
  ### Examination - end
  #####################################################################


  #####################################################################
  ### Test Advised - start
  #####################################################################
  
  ## Make New Object
  _makeNewTestAdvisedObject: ()->
    @testAdvisedObject =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      organizationId: @currentOrganization.idOnServer
      data:
        testAdvisedName: null
        testAdvisedList: []
      availableToPatient: true

    # console.log @testAdvisedObject
      
    @isTestAdvisedValid = true
      
  _makeNewAddedInvestigationObject: (data)->
    # console.log data
    object = {}
    objectStatus = {}
    objectStatus.hasTestResults = false
    objectStatus.testResultsSerial = null

    object.investigationName = data.name
    object.testList = data.investigationList
    object.status = objectStatus
    object.serial = @generateSerialForTestAdvisedInvestigation()

    unless @machingUserAddedInstitutionList.length is 0
      object.suggestedInstitutionName = @machingUserAddedInstitutionList[0].label
    object.suggestedInstitutionName = ''

    return object

  _makeCustomInvestigationObject : ()->
    @customInvestigationObject = {
      serial: @generateSerialForCustomInvestigation
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: @visit.serial
      patientSerial: @patient.serial
      data:
        name: ''
        investigationList: [
          {
            name: ''
            referenceRange: ''
            unitList: []
          }
        ]
    }


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

  _loadInvestigationList: (userIdentifier)->
  
    @domHost.getStaticData 'investigationList', (investigationList)=>
      # console.log investigationList

      childList = []
      parentList = []

      for object in investigationList
        unless object.name is ''
          
          unless typeof object.investigationList is 'undefined'
            unless object.investigationList.length is 0

              if object.investigationList.length > 1
                groupInvestigation = {}
                groupInvestigation.label = object.name
                groupInvestigation.value = object
                @push "investigationDataList", groupInvestigation

                for item in object.investigationList
                  if typeof item.name is 'string'

                    # push every investigation object
                    investigation = {}
                    investigation.label = item.name
                    investigation.value = {
                      name: item.name
                      investigationList: [
                        {
                          name: item.name
                          referenceRange: item.referenceRange
                          unitList: item.unitList
                        }
                      ]

                    }
                      
                    @push "investigationDataList", investigation
                    

              else
                singleInvestigation = {}
                singleInvestigation.label = object.name
                singleInvestigation.value = object    
                @push "investigationDataList", singleInvestigation

    
    # get all custom investigation list by curernt user
    customInvestigationlist = app.db.find 'custom-investigation-list', ({createdByUserSerial})=> userIdentifier is createdByUserSerial
    # console.log customInvestigationlist
    
    # pushed all custom investigation on master investigatin list
    unless customInvestigationlist.length is 0
      for item in customInvestigationlist

        investigation = {}
        investigation.label = item.data.name
        investigation.value = {name: item.data.name, investigationList: item.data.investigationList}

        # console.log investigation

        @push "investigationDataList", investigation

    @investigationDataList.sort (left, right)->
      return -1 if left.label < right.label
      return 1 if left.label > right.label
      return 0

    # console.log @investigationDataList

  _loadUserAddedInstitutionList: (userIdentifier) ->

    list = app.db.find 'user-added-institution-list', ({createdByUserSerial})=> userIdentifier is createdByUserSerial

    unless list.length is 0
      institutionList = [].concat list

      for item in institutionList
        object = {}
        object.label = item.data.institutionName
        object.value = item.data.institutionName
        @push 'machingUserAddedInstitutionList', object

      @machingUserAddedInstitutionList.sort (left, right)->
        return -1 if left.label < right.label
        return 1 if left.label > right.label
        return 0

  ## User Added Custom Investigation
  saveUserAddedCustomInvestigation: (data)->
    # console.log data
    app.db.insert 'custom-investigation-list', data
    
  _duplicationInvestigationCheck: (data)->
    for item in @investigationDataList
      if item.label is data
        return true

  ## User Added Institution Name
  saveUserAddedInstituion: ()->
    userAddedInsitution = {
      serial: @generateSerialForUserAddedInstituion
      createdDatetimeStamp: lib.datetime.now()
      lastModifiedDatetimeStamp: lib.datetime.now()
      createdByUserSerial: @user.serial
      data:
        institutionName: @suggestedInstitutionValue
    }

    @push "machingUserAddedInstitutionList", {label: @suggestedInstitutionValue, value: @suggestedInstitutionValue}
    app.db.upsert "user-added-institution-list", userAddedInsitution, ({serial})-> serial is userAddedInsitution.serial

  comboBoxKeyUpSeggestedInstitutionNameChanged: (e) ->
    unless @suggestedInstitutionValue is ''
      if e.which is 13 # ENTER/RETURN
        if typeof @suggestedInstitutionValue is 'object'
          @addedInvestigationList[@addedInvestigationNameIndex].suggestedInstitutionName = @suggestedInstitutionValue.value
          # Check if Institution Already Added By User
          if !@_isInstitutionAddedByUserAlready @suggestedInstitutionValue.value
            @saveUserAddedInstituion()
        else
          @addedInvestigationList[@addedInvestigationNameIndex].suggestedInstitutionName = @suggestedInstitutionValue

          # Check if Institution Already Added By User
          if !@_isInstitutionAddedByUserAlready @suggestedInstitutionValue
            @saveUserAddedInstituion()

        # Updating Currnt Added Investigation Data
        @saveAdvisedTest()

        @_loadAdvisedTest @visit.advisedTestSerial
        @$$('#dialogSuggestedInstitution').toggle()

  _saveSuggestedInstituonName: (e)->
    unless @suggestedInstitutionValue is ''
      if typeof @suggestedInstitutionValue is 'object'
        @addedInvestigationList[@addedInvestigationNameIndex].suggestedInstitutionName = @suggestedInstitutionValue.value
        # Check if Institution Already Added By User
        if !@_isInstitutionAddedByUserAlready @suggestedInstitutionValue.value
          @saveUserAddedInstituion()
      else
        @addedInvestigationList[@addedInvestigationNameIndex].suggestedInstitutionName = @suggestedInstitutionValue

        # Check if Institution Already Added By User
        if !@_isInstitutionAddedByUserAlready @suggestedInstitutionValue
          @saveUserAddedInstituion()

      # Updating Currnt Added Investigation Data
      @saveAdvisedTest()


      @_loadAdvisedTest @visit.advisedTestSerial
      @$$('#dialogSuggestedInstitution').close()
  
  _isInstitutionAddedByUserAlready: (institutionName)->
    for item, index in @machingUserAddedInstitutionList
      if @machingUserAddedInstitutionList.value is institutionName
        return true
    return false
      
  _notifyInvalidTestAdvised: ->
    @isTestAdvisedValid = false
    @domHost.showModalDialog 'Invalid Test Advised Provided'

  ## Added Advised Test(s)
  _selectedAddedInvestigationtDeleteBtnPressed: (e) ->
    index = e.model.index
    @splice('addedInvestigationList', index, 1)

    # todo :: delete object from db if addedInvestigationList length is 0
    advisedTestSerial = @testAdvisedObject.serial
    if @addedInvestigationList.length is 0
      list = app.db.find 'visit-advised-test', ({serial})-> serial is advisedTestSerial
      # console.log list
      id = list[ 0 ]._id
      app.db.remove 'visit-advised-test', id
      app.db.insert 'visit-advised-test--deleted', { serial: @testAdvisedObject.serial }
      @visit.advisedTestSerial = null
      @_saveVisit()
      @domHost.showToast 'Deleted Successfully!'

    else
      @saveAdvisedTest()
      @domHost.showToast 'Deleted Successfully!'



  removeInvestigationMember: (e)->
    memberIndex = e.model.index

    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#added-advised-test-list-repeater'
    index = repeater.indexForElement el

    string = 'addedInvestigationList.' + index + '.testList'
    @splice string, memberIndex, 1

    @saveAdvisedTest()


  
  showInevestigationMemberDialog: (e) ->
    @investigationMemberValue = ''
    el = @locateParentNode e.target, 'PAPER-ICON-BUTTON'
    el.opened = false
    repeater = @$$ '#added-advised-test-list-repeater'
    @ARBITARY_INDEX = repeater.indexForElement el
    @$$('#dialogInvestigationMemberValue').toggle()

  addInvestigationMember: (e)->
    trimmedVal = @investigationMemberValue.trim()
    if trimmedVal is ''
      @domHost.showToast 'Type/Add a Test first!'
      return
    else if @_duplicateInvestigationMemberCheck trimmedVal
      @domHost.showToast 'Test already added!'
      return
    else
      object = {}
      string = 'addedInvestigationList.' + @ARBITARY_INDEX + '.testList'
      object.name = @investigationMemberValue
      @push string, object
      @saveAdvisedTest()
      @$$('#dialogInvestigationMemberValue').close()


  _duplicateInvestigationMemberCheck: (newTest)->
    for test in @addedInvestigationList[@ARBITARY_INDEX].testList
      return true if test.name is newTest


  _openSuggestedInstitutionDialog: (e) ->
    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#added-advised-test-list-repeater'
    @addedInvestigationNameIndex = repeater.indexForElement el

    # console.log @addedInvestigationNameIndex
    
    @set 'suggestedInstitutionValue', @addedInvestigationList[@addedInvestigationNameIndex].suggestedInstitutionName
    @$$('#dialogSuggestedInstitution').toggle()

  onComboBoxInvestigationValueChanged: (e)->
    # console.log e.detail.value

  comboBoxKeyUpInvestigationValueChanged: (e)->
    unless @comboBoxInvestigationInputValue is ''
      if e.which is 13 # ENTER/RETURN
        # console.log @comboBoxInvestigationInputValue
        
        if typeof @comboBoxInvestigationInputValue is 'object'
          @push 'addedInvestigationList', @_makeNewAddedInvestigationObject @comboBoxInvestigationInputValue
          # Save Advised Test
          @saveAdvisedTest()
          
        else
          unless @_duplicationInvestigationCheck @comboBoxInvestigationInputValue
            @_makeCustomInvestigationObject()
            @customInvestigationObject.data.name = @comboBoxInvestigationInputValue
            @customInvestigationObject.data.investigationList[0].name = @comboBoxInvestigationInputValue

            @$$('#dialogCustomInvestigation').toggle()

  addInvestigation: ()->

    if ((@comboBoxInvestigationInputValue is '') or (@comboBoxInvestigationInputValue is null))
      @domHost.showToast 'Type/Add a Test first!'
      return
    if typeof @comboBoxInvestigationInputValue is 'object'
      unless @_duplicateAddedInvestigation @comboBoxInvestigationInputValue.name
        @push 'addedInvestigationList', @_makeNewAddedInvestigationObject @comboBoxInvestigationInputValue
        # @addInvestigationAsFavorite @comboBoxInvestigationInputValue
        # Save Advised Test
        @saveAdvisedTest()
      else
        @domHost.showToast 'Already added!'
        return
      
    else
      # custom investigation provided
      trimmedVal = @comboBoxInvestigationInputValue.trim()
      if trimmedVal is ''
        @domHost.showToast 'Type/Add a Test first!'
        return
      else if @_duplicationInvestigationCheck trimmedVal
        # this checks the master list
        @domHost.showToast 'Already exists!'
        return
      else
        # valid custom investigation provided
        unless @_duplicateAddedInvestigation trimmedVal
          @_makeCustomInvestigationObject =>
            @customInvestigationObject.data.name = trimmedVal
            @customInvestigationObject.data.investigationList[0].name = trimmedVal

            @$$('#dialogCustomInvestigation').toggle()
        
        else
          @domHost.showToast 'Already added!'
          return


  _duplicateAddedInvestigation: (newInvestigation)->
    for investigation in @addedInvestigationList
      return true if investigation.investigationName is newInvestigation


  loadFavoriteInvestigationList: (userIdentifier, cbfn)->
    list = app.db.find 'favorite-advised-test', ({createdByUserSerial})-> userIdentifier is createdByUserSerial 
    list.sort (left, right)->
      return -1 if left.data.investigationName > right.data.investigationName
      return 1 if left.data.investigationName < right.data.investigationName
      return 0

    @favoriteInvestigaitonList = list

    cbfn()


  addInvestigationAsFavorite: (data)->
    if @_duplicatieInvestigationCheck data.name
      return
    else
      object =
        createdByUserSerial: @user.serial
        isSelected: false
        data: data
      app.db.insert 'favorite-advised-test', object



  _duplicatieInvestigationCheck: (investigationIdentifier)->
    userIdentifier = @user.serial
    list = app.db.find 'favorite-advised-test', ({createdByUserSerial})-> userIdentifier is createdByUserSerial
    if list.length > 0
      for item in list
        if item.data.name is investigationIdentifier
          return true
        else
          continue
      return false
    else
      return false
        

  _addUnitValueForCustomInvestigation: ()->
    unless @customInvestigationUnitValue is ''
      # Note: Dialog not showing deeper level data binding, thats why i created @customInvestigationUnitList in order to view Investigation name only
      @push 'customInvestigationUnitList', @customInvestigationUnitValue
      @set 'customInvestigationUnitValue', ''

  _saveCustomInvestigation: ()->

    # Added Custom Investigation Unit list from array
    @customInvestigationObject.data.investigationList[0].unitList = @customInvestigationUnitList

    # Save User added custom investigation
    @saveUserAddedCustomInvestigation @customInvestigationObject

    # Push Custom Investigation Name on Master Investigation List
    @push "investigationDataList", { label: @customInvestigationObject.data.investigationName, value: @customInvestigationObject.data  }

    # Push on Added Advised Test List Array
    @push 'addedInvestigationList', @_makeNewAddedInvestigationObject @customInvestigationObject.data

    @addInvestigationAsFavorite @customInvestigationObject.data

    # Save Advised Test
    @saveAdvisedTest()

    # Load Investigation Data
    @_loadInvestigationList @user.serial

    # clear combobox input
    @set 'comboBoxInvestigationInputValue', ''

    # Close Dialog
    @$$('#dialogCustomInvestigation').close()

  _deleteSelectedUnit: (e)->
    index = e.model.index
    @splice 'customInvestigationUnitList', index, 1

  _onAddedInvestigationTestChange: (e)->

    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#added-advised-test-list-repeater'
    selectedTestIndex = repeater.indexForElement el
    selectedChildTestIndex = e.model.index
    # @pop 'addedInvestigationList.#{selectedTestIndex}.testList.#{selectedChildTestIndex}'
    @addedInvestigationList[selectedTestIndex].testList.splice(selectedChildTestIndex, 1)
    
    # Save Advised Test
    @saveAdvisedTest()

    # console.log @addedInvestigationList

  saveAdvisedTest: ()->
    # console.log @testAdvisedObject
    unless @addedInvestigationList.length is 0
      @testAdvisedObject.data.testAdvisedList = @addedInvestigationList

      if @visit.advisedTestSerial is null
        @testAdvisedObject.serial = @generateSerialForTestAdvised()

        ## updated current visit object
        @visit.advisedTestSerial = @testAdvisedObject.serial
        @_saveVisit()
     
      # Updated Advised Test List
      @testAdvisedObject.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'visit-advised-test', @testAdvisedObject, ({serial})=> @testAdvisedObject.serial is serial
      
      @set 'comboBoxInvestigationInputValue', ''
      @domHost.showToast 'Test Added.'

  showFavoriteInvestigationDialog: ()->
    @loadFavoriteInvestigationList @user.serial, =>
      @$$('#dialogFavoriteInvestigation').toggle()


  addInvestigationFromFavorite: ()->
    alreadyAddedItems = []
    for item in @favoriteInvestigaitonList
      if item.isSelected
        if @_duplicateAddedInvestigation item.data.name
          alreadyAddedItems.push item.data.name
        else
          @push 'addedInvestigationList', @_makeNewAddedInvestigationObject item.data

    unless alreadyAddedItems.length is 0
      itemsTogether = alreadyAddedItems.reduce (result, value)->
        return result += (', '+value)
      
      @domHost.showToast ('These Investigations were already added : '.concat itemsTogether)
      console.log 'already added items ', alreadyAddedItems 

    @$$('#dialogFavoriteInvestigation').close()


  deleteSelectedFavoriteInvestigation: (e)->
    index = e.model.index

    id = @favoriteInvestigaitonList[index]._id
    @splice 'favoriteInvestigaitonList', index, 1

    app.db.remove 'favorite-advised-test', id

    @domHost.showToast 'Test removed from favorite list'

  addAsFavoriteInvestigation: (e)->
    if ((@comboBoxInvestigationInputValue is '') or (@comboBoxInvestigationInputValue is null))
      @domHost.showToast 'Type/Add a Test first!'
      return
    else
      if typeof @comboBoxInvestigationInputValue is 'object'
        @addInvestigationAsFavorite @comboBoxInvestigationInputValue
      else
        trimmedVal = @comboBoxInvestigationInputValue.trim()
        unless trimmedVal is ''
          @addInvestigationAsFavorite {name: trimmedVal}
        else
          @domHost.showToast 'Type/Add a Test first!'
          return



  #####################################################################
  ### Test Advised - end
  #####################################################################

  #####################################################################
  ### Vitals - start
  #####################################################################

  _isAllVitalsAdded: (isBPAdded, isHRAdded, isBMIAdded, isRRAdded, isSpO2Added, isTempAdded)->
    if ((isBPAdded is true) and (isHRAdded is true) and (isBMIAdded is true) and (isRRAdded is true) and (isSpO2Added is true) and (isTempAdded is true))
      return true
    else
      return false

  _makeBloodPressure: ->
    @bloodPressure =
      serial: null
      visitSerial: @visit.serial
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      organizationId: @currentOrganization.idOnServer
      data:
        systolic: ''
        diastolic: ''
        random: ''
        unit: 'mm Hg'
        flags:
          flagAsError: false

  _makePulseRate: ->
    @pulseRate =
      serial: null
      visitSerial: @visit.serial
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      organizationId: @currentOrganization.idOnServer
      data:
        bpm: ''
        unit: 'bpm'
        flags:
          flagAsError: false
  _makeBmi: ->
    @bmi =
      serial: null
      visitSerial: @visit.serial
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      organizationId: @currentOrganization.idOnServer
      data:
        height: ''
        heightInFt: ''
        heightInInch: ''
        heightUnit: 'cm'
        weight: ''
        weightUnit: 'kg'
        calculatedBMI: ''
        flags:
          flagAsError: false
  _makeRespiratoryRate: ->
    @respiratoryRate =
      serial: null
      visitSerial: @visit.serial
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      organizationId: @currentOrganization.idOnServer
      data:
        respiratoryRate: ''
        unit: 'rpm'
        flags:
          flagAsError: false
  _makeOxygenSaturation: ->
    @oxygenSaturation =
      serial: null
      visitSerial: @visit.serial
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      organizationId: @currentOrganization.idOnServer
      data:
        spO2Percentage: ''
        unit: '%'
        flags:
          flagAsError: false

  _makeTemperature: ->
    @temperature =
      serial: null
      visitSerial: @visit.serial
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      organizationId: @currentOrganization.idOnServer
      data:
        temperature: ''
        unit: '°C'
        flags:
          flagAsError: false


  # SAVE TO DB
  # ===========================

  _saveBloodPressure: (data)->
    app.db.upsert 'patient-vitals-blood-pressure', data, ({serial})=> data.serial is serial

  _savePulseRate: (data)->
    app.db.upsert 'patient-vitals-pulse-rate', data, ({serial})=> data.serial is serial

  _saveBmi: (data)->
    app.db.upsert 'patient-vitals-bmi', data, ({serial})=> data.serial is serial

  _saveRespiratoryRate: (data)->
    app.db.upsert 'patient-vitals-respiratory-rate', data, ({serial})=> data.serial is serial

  _saveOxygenSaturation: (data)->
    app.db.upsert 'patient-vitals-spo2', data, ({serial})=> data.serial is serial

  _saveTemperature: (data)->
    app.db.upsert 'patient-vitals-temperature', data, ({serial})=> data.serial is serial

  _addToVitalList: (object, type)->
    lib.util.delay 5, ()=>

      @push 'addedVitalList', {
        vitalType: type
        vitalObject: object
      }

    # console.log @addedVitalList




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

  _addedVitalsSaveButtonPressed:()->

    if @addedVitalList.length is 0
      @domHost.showToast "Please Add atleast 1 Vital."

    else

      for item in  @addedVitalList

        if item.vitalType is 'Blood Pressure'
          @_saveBloodPressure item.vitalObject

        else if item.vitalType is 'Heart Rate'
          @_savePulseRate item.vitalObject

        else if item.vitalType is 'BMI'
          @_saveBmi item.vitalObject

        else if item.vitalType is 'Respirtory Rate'
          @_saveRespiratoryRate item.vitalObject

        else if item.vitalType is 'SpO2'
          @_saveOxygenSaturation item.vitalObject

        else if item.vitalType is 'Temperature'
          @_saveTemperature item.vitalObject

      # console.log app.db.find 'patient-vitals-blood-pressure'
      @arrowBackButtonPressed()

  _deleteAddedVitalItemClicked:(e)->
    index = e.model.index
    vital = @addedVitalList[index]
    @deleteFromCollection vital
    @splice 'addedVitalList', index, 1
    @domHost.showToast 'Vital Deleted!'

  deleteFromCollection: (data)->
    console.log data
    id = data.vitalObject._id
    if data.vitalType is 'Blood Pressure'
      app.db.remove 'patient-vitals-blood-pressure', id
      @_makeBloodPressure()
      @isBPAdded = false
      @visit.vitalSerial.bp = null

    else if data.vitalType is 'Heart Rate'
      app.db.remove 'patient-vitals-pulse-rate', id
      @_makePulseRate()
      @isHRAdded = false
      @visit.vitalSerial.hr = null


    else if data.vitalType is 'BMI'
      app.db.remove 'patient-vitals-bmi', id
      @_makeBmi()
      @isBMIAdded = false
      @visit.vitalSerial.bmi = null

    else if data.vitalType is 'Respirtory Rate'
      app.db.remove 'patient-vitals-respiratory-rate', id
      @_makeRespiratoryRate()
      @isRRAdded = false
      @visit.vitalSerial.rr = null

    else if data.vitalType is 'Spo2'
      app.db.remove 'patient-vitals-spo2', id
      @_makeOxygenSaturation()
      @isSpO2Added = false
      @visit.vitalSerial.spo2 = null

    else if data.vitalType is 'Temperature'
      app.db.remove 'patient-vitals-temperature', id
      @_makeTemperature()
      @isTempAdded = false
      @visit.vitalSerial.temp = null


    @_saveVisit()

  updateVisitForVital: (vitalSerial, vitalType)->
    console.log 'VitalSerial: ', vitalSerial, "and vitalType: ", vitalType

    if vitalType is 'Blood Pressure'
      @visit.vitalSerial.bp = vitalSerial
      @isBPAdded = true

    else if vitalType is 'Heart Rate'
      @visit.vitalSerial.hr = vitalSerial
      @isHRAdded = true

    else if vitalType is 'BMI'
      @visit.vitalSerial.bmi = vitalSerial
      @isBMIAdded = true

    else if vitalType is 'Respirtory Rate'
      @visit.vitalSerial.rr = vitalSerial
      @isRRAdded = true

    else if vitalType is 'SpO2'
      @visit.vitalSerial.spo2 = vitalSerial
      @isSpO2Added = true

    else if vitalType is 'Temperature'
      @visit.vitalSerial.temp = vitalSerial
      @isTempAdded = true

    # @selectedVitalIndex = 0
    @_saveVisit()

  # BLOOD PRESSURE
  # =====================================================
  
  addBloodPressureButtonClicked: ->
    systolic = parseInt @get 'bloodPressure.data.systolic'
    diastolic = parseInt @get 'bloodPressure.data.diastolic'

    unless systolic and diastolic
      @domHost.showToast 'Please Enter All The Data'
      return
    unless 1<=systolic<=300
      @domHost.showToast 'Systolic value must be betwen 1-300'
      return
    unless 1<=diastolic<=200
      @domHost.showToast 'Diastolic Value must be betwen 1-200'
      return
    unless diastolic<=systolic
      @domHost.showToast 'Diastolic value must not be greater than Systolic Value'
      return

    @addBP()
      
  addBP: ()->
    @set 'bloodPressure.serial', @generateSerialForVitals 'BP'
    @set 'bloodPressure.lastModifiedDatetimeStamp', lib.datetime.now()
    @set 'bloodPressure.createdByUserSerial', @userSerial
    @set 'bloodPressure.patientSerial', @patient.serial
    @set 'bloodPressure.createdDatetimeStamp', lib.datetime.now()


    @_addToVitalList @bloodPressure, 'Blood Pressure'
    @updateVisitForVital @bloodPressure.serial, 'Blood Pressure'
    @_saveBloodPressure @bloodPressure
   
   # Activity LOG for BLOOD PRESSURE -START
  # =====================================================   
    @domHost.addActivityLog 'blood-pressure', 'add', {
      patientSerial: @patient.serial,
      # bloodPressureSerial: @bloodPressure.serial,
      createdByUserSerial: @userSerial,
      createdDatetimeStamp: lib.datetime.now()
    }
  # ===================================================== 
   # Activity LOG for BLOOD PRESSURE -END

    @domHost.showToast 'Added Successfully'
    @_makeBloodPressure()


  # PULSE RATE
  # =====================================================
  
  addPulseRateButtonClicked: ->
    bpm = parseInt @get 'pulseRate.data.bpm'

    unless bpm
      @domHost.showToast 'Please Enter BPM'
      return

    if 20 <= bpm <=225
      @set 'pulseRate.lastModifiedDatetimeStamp', lib.datetime.now()
      @set 'pulseRate.serial', @generateSerialForVitals 'P'
      @set 'pulseRate.createdByUserSerial', @userSerial
      @set 'pulseRate.patientSerial', @patient.serial
      @set 'pulseRate.createdDatetimeStamp', lib.datetime.now()

      @updateVisitForVital @pulseRate.serial, 'Heart Rate'
      @_savePulseRate @pulseRate

      @_addToVitalList @pulseRate, 'Heart Rate'
   
   # Activity LOG for PULSE RATE -START
  # =====================================================   
      @domHost.addActivityLog 'pulse-rate', 'add', {
        patientSerial: @patient.serial,
        # pulseRate: @bloodPressure.serial,
        createdByUserSerial: @userSerial,
        createdDatetimeStamp: lib.datetime.now()
      }
  # ===================================================== 
   # Activity LOG for PULSE RATE -END

      @domHost.showToast 'Added Successfully'
      @_makePulseRate()


  # BMI Calculator
  # =====================================================

  isHeightCmOrM: (unit)->
    return true unless unit is 'ft/inch'
  isHeightFtInch: (unit)->
    return true if unit is 'ft/inch'

  heightUnitSelectedIndexChanged: ->
    if @heightUnitSelectedIndex is 0
      @set 'bmi.data.heightUnit', 'cm'
    else if @heightUnitSelectedIndex is 1
      @set 'bmi.data.heightUnit', 'm'
    else
      @set 'bmi.data.heightUnit', 'ft/inch'

  weightUnitSelectedIndexChanged: ->
    if @weightUnitSelectedIndex is 0
      @set 'bmi.data.weightUnit', 'kg'
    else if @weightUnitSelectedIndex is 1
      @set 'bmi.data.weightUnit', 'lbs'
    else
      @set 'bmi.data.weightUnit', 'st-lbs'

  ifChosenCmMtAsHeight: (index)->
    if index isnt 2 or index is 0
      return true
    return false

  ifChosenFtInchAsHeight: (index)->
    if index is 2
      return true
    return false

  _convertHeightToMeter: ->
    heightUnit = @get 'bmi.data.heightUnit'
    heightInMeter = 0
    if heightUnit is 'cm'
      heightInMeter = (@get 'bmi.data.height') * 0.01
    else if heightUnit is 'm'
      heightInMeter = @get 'bmi.data.height'
    else if heightUnit is 'ft/inch'
      heightInMeter = ((@get 'bmi.data.heightInFt') * 0.3048 ) + ((@get 'bmi.data.heightInInch') * 0.0254)

    return heightInMeter

  _convertWeightToKg: ->
    weightUnit = @get 'bmi.data.weightUnit'
    weightInKg = 0
    if weightUnit is 'lbs'
      weightInKg = (@get 'bmi.data.weight') * 0.453592
    else if weightUnit is 'st-lbs'
      weightInKg = (@get 'bmi.data.weight') * 6.35029
    else if weightUnit is 'kg'
      weightInKg = @get 'bmi.data.weight'

    return weightInKg

  _calculateBMI: (heightInMeter, weightInKg)->
    return (weightInKg / heightInMeter) / heightInMeter

  _calculateBMIVerdict: (result)->
    if result is 0 or not result
      return 'Pending'
    else if result < 18.5
      return 'Underweight'
    else if 18.5 <= result < 24.9
      return 'Normal'
    else if 25 <= result < 29.9
      return 'Overweight'
    else
      return 'Obese'

  calculateBMIButtonClicked: ->
    unless (@bmi.data.height or @bmi.data.heightFt) and @bmi.data.weight
      @domHost.showToast 'Please Enter All The Data'
    if (@bmi.data.height>0 or @bmi.data.heightInFt>0) and @bmi.data.weight>0
      weightInKg = @_convertWeightToKg()
      heightInMeter = @_convertHeightToMeter()
      bmiResult = @_calculateBMI heightInMeter, weightInKg
      @set 'bmi.data.calculatedBMI', (bmiResult.toPrecision 3)
      @set 'bmi.lastModifiedDatetimeStamp', lib.datetime.now()
      @set 'bmi.serial', @generateSerialForVitals 'BMI'
      @set 'bmi.createdByUserSerial', @userSerial
      @set 'bmi.patientSerial', @patient.serial
      @set 'bmi.createdDatetimeStamp', lib.datetime.now()
   
   # Activity LOG for BMI -START
  # =====================================================   
      @domHost.addActivityLog 'bmi', 'add', {
        patientSerial: @patient.serial,
        # bmi: @bloodPressure.serial,
        createdByUserSerial: @userSerial,
        createdDatetimeStamp: lib.datetime.now()
      }
  # ===================================================== 
   # Activity LOG for BMI -END

      @_addToVitalList @bmi, 'BMI'
      @updateVisitForVital @bmi.serial, 'BMI'
      @_saveBmi @bmi
      @domHost.showToast 'Added Successfully!'
      # @bmiList = app.db.find 'patient-vitals-bmi'
    else
      @domHost.showToast 'Correct Required Input'


  # Respirtory Rate
  # =====================================================
  addRespiratoryRateButtonClicked: (e)->
    unless @respiratoryRate.data.respiratoryRate
      @domHost.showToast 'Please Enter RPM'
    if 1 < @respiratoryRate.data.respiratoryRate <=65
      @set 'respiratoryRate.lastModifiedDatetimeStamp', lib.datetime.now()
      @set 'respiratoryRate.serial', @generateSerialForVitals 'RR'
      @set 'respiratoryRate.createdByUserSerial', @userSerial
      @set 'respiratoryRate.patientSerial', @patient.serial
      @set 'respiratoryRate.createdDatetimeStamp', lib.datetime.now()

      @updateVisitForVital @respiratoryRate.serial, 'Respirtory Rate'
      @_saveRespiratoryRate @respiratoryRate
      @_addToVitalList @respiratoryRate, 'Respirtory Rate'
      # @respiratoryRateList = app.db.find 'patient-vitals-respiratory-rate'
   
   # Activity LOG for RESPIRATORY RATE -START
  # =====================================================   
      @domHost.addActivityLog 'respiratory-rate', 'add', {
        patientSerial: @patient.serial,
        # pulseRate: @bloodPressure.serial,
        createdByUserSerial: @userSerial,
        createdDatetimeStamp: lib.datetime.now()
      }
  # ===================================================== 
   # Activity LOG for RESPIRATORY RATE -END

      @domHost.showToast 'Added Successfully'
      @_makeRespiratoryRate()
    else
      @.$.rr.invalid = true

  # Oxygen Saturation
  # =====================================================
  addOxygenSaturationButtonClicked: (e)->
    # TODO - Validation message
    unless @oxygenSaturation.data.spO2Percentage
      @domHost.showToast 'Please Enter Percentage'
    if 0<=@oxygenSaturation.data.spO2Percentage<=100
      @set 'oxygenSaturation.lastModifiedDatetimeStamp', lib.datetime.now()
      @set 'oxygenSaturation.serial', @generateSerialForVitals 'OS'
      @set 'oxygenSaturation.createdByUserSerial', @userSerial
      @set 'oxygenSaturation.patientSerial', @patient.serial
      @set 'oxygenSaturation.createdDatetimeStamp', lib.datetime.now()

      @updateVisitForVital @oxygenSaturation.serial, 'SpO2'
      @_saveOxygenSaturation @oxygenSaturation
      @_addToVitalList @oxygenSaturation, 'SpO2'
      # @oxygenSaturationList = app.db.find 'patient-vitals-spo2'

   # Activity LOG for OxygenSaturation -START
  # =====================================================   
      @domHost.addActivityLog 'oxygen-saturation', 'add', {
        patientSerial: @patient.serial,
        # oxygenSaturation: @bloodPressure.serial,
        createdByUserSerial: @userSerial,
        createdDatetimeStamp: lib.datetime.now()
      }
  # ===================================================== 
   # Activity LOG for OxygenSaturation -END

      @domHost.showToast 'Added Successfully'
      @_makeOxygenSaturation()


  # Temparature
  # =====================================================
  
  isTempCelsius: (tempUnitSelectedIndex)->
    if tempUnitSelectedIndex is 0
      return true
    else
      return false
  
  tempUnitSelected: (e)->
    lib.localStorage.setItem 'lastSelectedTempUnit', @tempUnitSelectedIndex
    if @tempUnitSelectedIndex is 0
      @set 'temperature.data.unit', '°C'
    else
      @set 'temperature.data.unit', '°F'

  
  addTemperatureButtonClicked: (e)->
    unitValue = parseInt @get 'temperature.data.temperature'
    
    # Validation
    unless unitValue
      @domHost.showToast 'Please Enter value'
    if @tempUnitSelectedIndex
      if 0<=unitValue<=115
        @addTemperature()
      else
        @domHost.showToast 'Correct Required Input'
    else
      if 0<=unitValue<=48
        @addTemperature()
      else
        @domHost.showToast 'Correct Required Input'
    
  addTemperature: ->
    if @temperature.data.unit is null
      if @tempUnitSelectedIndex is 0
        @set 'temperature.data.unit', '°C'
      else
        @set 'temperature.data.unit', '°F'
    @set 'temperature.lastModifiedDatetimeStamp', lib.datetime.now()
    @set 'temperature.serial', @generateSerialForVitals 'T'
    @set 'temperature.createdByUserSerial', @userSerial
    @set 'temperature.patientSerial', @patient.serial
    @set 'temperature.createdDatetimeStamp', lib.datetime.now()
    @updateVisitForVital @temperature.serial, 'Temperature'
    @_saveTemperature @temperature
    @_addToVitalList @temperature, 'Temperature'
   
  # Activity LOG for temperature -START
  # =====================================================   
    @domHost.addActivityLog 'temperature', 'add', {
      patientSerial: @patient.serial,
      # temperature: @bloodPressure.serial,
      createdByUserSerial: @userSerial,
      createdDatetimeStamp: lib.datetime.now()
      temperature: @temparature
    }
  # ===================================================== 
   # Activity LOG for temperature -END

    @domHost.showToast 'Added Successfully'
    @_makeTemperature()

  #####################################################################
  ### Vitals - end
  #####################################################################


  #####################################################################
  ### Next Visit - start
  #####################################################################

  _showComputedNextVisitDate: (date)->
    return null if @nextVisitDurationTypeSelectedIndex is 0
    return lib.datetime.mkDate date, 'dd-mmm-yyyy'


  _nextVisitDurationTypeSelectedIndexChanged: ->

    console.log 'nextVisit', @nextVisit
    
    getDurationValue = @nextVisitDurationTypeList[@nextVisitDurationTypeSelectedIndex]
    getDurationValue = getDurationValue.toLowerCase()

    if getDurationValue.search('day') isnt -1
      days = parseInt getDurationValue
      @_setNextVisitDateTimestamp days

    else if getDurationValue.search('week') isnt -1
      weeks = parseInt(getDurationValue.substr 0, 1)
      days = weeks * 7
      @_setNextVisitDateTimestamp days

    else if getDurationValue.search('month') isnt -1
      # Note: 1 month = 30days 
      months = parseInt(getDurationValue.substr 0, 1)
      days = months * 30
      @_setNextVisitDateTimestamp days

    else if getDurationValue.search('year') isnt -1
      # Note: 1 year = 365days 
      years = parseInt(getDurationValue.substr 0, 1)
      days = years * 365
      @_setNextVisitDateTimestamp days

    else if getDurationValue.search('custom') isnt -1
      @isCustomDateTypeSelected  = true


  _setNextVisitDateTimestamp:(days)->
    getCurrentDateTimestamp = lib.datetime.now()
    nextVisitDateTimestamp = getCurrentDateTimestamp + (days * 24 * 60 * 60 * 1000)
    @nextVisit.data.nextVisitDateTimestamp = nextVisitDateTimestamp

  _nextVisitPriorityTypeSelectedIndexChanged: ->

    # console.log @priorityTypeList[@nextVisitPriorityTypeSelectedIndex]
    @nextVisit.data.priorityType = @priorityTypeList[@nextVisitPriorityTypeSelectedIndex]

  _saveNextVisit: (data)->
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'visit-next-visit', data, ({serial})=> data.serial is serial


    
  _addNextVisitPressed: ()->
    unless @nextVisit.data.nextVisitDateTimestamp is 0
      @nextVisit.serial = @generateSerialForNextVisit()
      @nextVisit.createdDatetimeStamp = lib.datetime.now()
      if @visit.nextVisitSerial is null
        @visit.nextVisitSerial = @nextVisit.serial
        @_saveVisit()


      @nextVisit.data.priorityType = @priorityValue
      @_saveNextVisit @nextVisit
      @_loadNextVisit @nextVisit.serial
      @domHost.showToast 'Next Visit Saved!'


  #####################################################################
  ### Next Visit - end
  #####################################################################

  #####################################################################
  ### Note - start
  #####################################################################
  _saveNote: (data)->
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'visit-note', data, ({serial})=> data.serial is serial

    # console.log app.db.find 'visit-note'
    

  _addNotePressed: ()->
    if @doctorNotesMessage.title is null or @doctorNotesMessage.title.trim() is ''
      @domHost.showToast 'Add Note Title!'
      return
    else
      @push 'doctorNotes.data.messageList', @doctorNotesMessage

      if @doctorNotes.serial is null
        @doctorNotes.createdDatetimeStamp = lib.datetime.now()
        @doctorNotes.serial = @generateSerialForNote()
      if @visit.doctorNotesSerial is null
        @visit.doctorNotesSerial = @doctorNotes.serial
        @_saveVisit()
    
      @_saveNote @doctorNotes
      @doctorNotesMessage = {
        title: null
        description: null
      }
      @_loadVisitNote @doctorNotes.serial
      @domHost.showToast 'Note Saved.'

  #####################################################################
  ### Note - end
  #####################################################################

  $findCreator: (creatorSerial)-> 'me'


  printFullVisitPressed: (e)->
    params = @domHost.getPageParams()
    # console.log @visit

    @domHost.navigateToPage '#/page-print-full-visit/patient:' + @patient.serial + '/visit:' + @visit.serial + '/record:' + @visit.historyAndPhysicalRecordSerial + '/prescription:' + @prescription.serial + '/test-adviced:' + @visit.advisedTestSerial + '/doctor-note:' + @visit.doctorNotesSerial + '/next-visit:' + @visit.nextVisitSerial + '/patient-stay:' + @visit.patientStaySerial + '/diagnosis:' + @visit.diagnosisSerial



  printPrescriptionPressed: (e)->
    params = @domHost.getPageParams()
    # console.log @visit

    if params['prescription'] != 'new'
      @domHost.navigateToPage '#/print-record/prescription:' + @prescription.serial + '/patient:' + @patient.serial

  $findCreator: (creatorSerial)-> 'me'

  _institutionSelectedIndexChanged: ()->
    return if @doctorInstitutionSelectedIndex is null
    item = @doctorInstitutionList[@doctorInstitutionSelectedIndex]
    @visit.hospitalName = item

  _specialitySelectedIndexChanged: ()->
    return if @doctorSpecialitySelectedIndex is null
    item = @doctorSpecialityList[@doctorSpecialitySelectedIndex]
    @visit.doctorSpeciality = item


  _makeNewVisit: (cbfn)->
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
      recordType: 'discharge-note'
      doctorName: @user.name
      hospitalName: @currentOrganization.name
      doctorSpeciality: null
      prescriptionSerial: null
      doctorNotesSerial: null
      nextVisitSerial: null
      advisedTestSerial: null
      patientStaySerial: null
      invoiceSerial: null
      historyAndPhysicalRecordSerial: null
      diagnosisSerial: null
      operationSerial: null
      identifiedSymptomsSerial: null
      examinationSerial: null
      recordTitle: 'Discharge Summary'
      unitHead: ''
      vitalSerial: {
        bp: null
        hr: null
        bmi: null
        rr: null
        spo2: null
        temp: null
      }
      testResults: {
        serial: null
        name: null
        attachmentSerialList: []
      }

    @isVisitValid = true
    @isThatNewVisit = true

    cbfn()


  _saveVisit: ()->
    params = @domHost.getPageParams()

    if params['visit'] is 'new'
      @isThatNewVisit = false
      @visit.serial = @generateSerialForVisit()
      ## _callAuthorizeRecordApi: (visitSerial, recordSerial, recordType, serverDb, organizationId)
      @_callAuthorizeRecordApi @visit.serial, @visit.serial, "Visit Record", 'bdemr--doctor-visit', @authorizedOrganiztionId, =>

        @domHost.modifyCurrentPagePath '#/discharge-note/visit:' + @visit.serial + '/patients:' + @patient.serial

    fn = =>
      @visit.lastModifiedDatetimeStamp = lib.datetime.now()
      app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial
      # @domHost.setSelectedVisitSerial @visit.serial

    if @visit.isPaidUp
      fn()
    else
      this._chargePatient @patient.idOnServer, 5, 'Payment BDEMR Doctor Generic', (err)=>
        @visit.isPaidUp = true
        if (err)
          @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
          return
        fn()



  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'

  _notifyInvalidVisit: ->
    @isVisitValid = false
    # @domHost.showModalDialog 'Invalid Visit Provided'

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



  _checkForTestResults: (data)->
    if data.hasTestResults
      list = app.db.find 'patient-test-results', ({serial})-> serial is data.testResultsSerial
      if list.length is 1
        return true
      return false

    return false

  

  _loadInvoice: (invoiceIndentifier)->
    list = app.db.find 'visit-invoice', ({serial})-> serial is invoiceIndentifier

    if list.length is 1
      @isInvoiceValid = true
      @invoice = list[0]
      return true
    else
      @isInvoiceValid = false
      return false


  _onDoctorNoteDeletedButtonPressed: (e)->

    index = e.model.index
    @domHost.showModalPrompt 'Are you sure?', (answer)=>
      if answer is true
        @splice 'doctorNotes.data.messageList', index, 1
        app.db.upsert 'visit-note', @doctorNotes, ({serial})=> @doctorNotes.serial is serial



  #####################################################################
  # Full Visit Preview - start
  #####################################################################
  _headerTitleListIndexChanged: ()->
    if @visit.serial
      @visit.recordTitle = ''
      @set 'visit.recordTitle', @visitHeaderTitleList[@visitHeaderTitleSelectedIndex]
      @_saveVisit()
  

  _getSettings: ->
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()
    if list.length 
      return list[0]
   

  ## Settings - end

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
    
    if @visit.historyAndPhysicalRecordSerial
      return false
    if @visit.identifiedSymptomsSerial
      return false
    else if @visit.examinationSerial
      return false
    else if @visit.vitalSerial.bp
      return false
    else if @visit.vitalSerial.hr
      return false
    else if @visit.vitalSerial.bmi
      return false
    else if @visit.vitalSerial.rr
      return false
    else if @visit.vitalSerial.spo2
      return false
    else if @visit.vitalSerial.temp
      return false
    else if @visit.advisedTestSerial
      return false
    else if @visit.diagnosisSerial
      return false
    else if @visit.operationSerial
      return false
    else if @visit.doctorNotesSerial
      return false
    else if @visit.nextVisitSerial
      return false
    else
      return true


  printButtonPressed: (e)->
 
    @set 'addedExaminationList2', []

    @printPrescriptionOnly = @checkForPrintPreviewType()
    
    # hack for addedExamination List not updated on print preview
    lib.util.delay 200, ()=>
      @set 'addedExaminationList2', @addedExaminationList
      lib.util.delay 200, ()=>
        console.log 'addedExaminationList2', @addedExaminationList2
        window.print()

  saveVisitSettings: ()->
    @recordTitleValueChanged()
    @$$('#dialogVisitSettings').close()


  _getRecordSerial: (data)->
    if typeof data is 'undefined'
      return 'new'
    else if data is 'new'
      return data
    else return data




  #####################################################################
  # Full Visit Preview - end
  #####################################################################

  getExaminationValueList: (list)->
    string = ''
    unless list.length is 0
      for item in list
        if item.checked
          string = string + item.value + ", "
        else
          string = string + ""
      return "(" + string + ")"
    return ""

  loadMedicineList: ()->
    @domHost.getStaticData 'pccMedicineList', (medicineCompositionList)=>
      @medicineCompositionList = medicineCompositionList
      @_loadDefaultMedicineCompositionList()


  _loadInsulinList: (patientIdentifier)->
    list = app.db.find 'patient-insulin-list', ({patientSerial})-> patientSerial is patientIdentifier
    @insulineMedicineList = list

    console.log 'insulineMedicineList', @insulineMedicineList

  _makeInsulinMedicine: (cbfn)->
    @insulinMedicine =
      serial: null
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: null
      visitSerial: null
      patientSerial: @patient.serial
      doctorName: @user.name
      doctorSpeciality: @getDoctorSpeciality()
      data:
        type: null
        drugName: null
        dosageList: [
          {
            time: 'Morning'
            value: ''
            unit: 'unit'
          }
          {
            time: 'Noon'
            value: ''
            unit: 'unit'
          }
          {
            time: 'Night'
            value: ''
            unit: 'unit'
          }
        ]

    cbfn()

  callSaveVisit: (cbfn)->
    @_saveVisit()
    cbfn()
  
  deleteInsulinMedicin: (e)->
    index = e.model.index
    item = @insulineMedicineList[index]
    @splice 'insulineMedicineList', index, 1

    id = (app.db.find 'patient-insulin-list', ({serial})-> serial is item.serial)[0]._id

    app.db.remove 'patient-insulin-list', id

    


  showAddInsulinMedicineDialog: ()->
    console.log @visit
    @_makeInsulinMedicine =>
      body = document.querySelector('body')
      @domHost.appendChild(@$.dialogInsulinMedicine);
      @$$('#dialogInsulinMedicine').toggle()
    
      

  saveInsulinMedicine: (data, cbfn)->
    console.log 'data', data
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'patient-insulin-list', data, ({serial})=> data.serial is serial
    cbfn()

  upsertInsulinMedicine: ()->
    @callSaveVisit =>
      if @insulinMedicine.serial is null
        @insulinMedicine.serial = @generateSerialForMedication 'IN'
        @insulinMedicine.createdDatetimeStamp = lib.datetime.now()
        @insulinMedicine.visitSerial = @visit.serial

      @saveInsulinMedicine @insulinMedicine, =>
        @domHost.showToast 'Medicine Saved!'
        @_loadInsulinList @patient.serial
        @$$('#dialogInsulinMedicine').close()


  _checkUserAccess: (accessId)->

    if accessId is 'none'
      return true
    else
      if @currentOrganization

        if @currentOrganization.isCurrentUserAnAdmin
          return true
        else if @currentOrganization.isCurrentUserAMember
          if @currentOrganization.userActiveRole
            privilegeList = @currentOrganization.userActiveRole.privilegeList
            unless privilegeList.length is 0
              for privilege in privilegeList
                if privilege.serial is accessId
                  return true
          else
            return true

          return false
        else
          return false

      else
        # @navigateToPage "#/select-organization"
        return true

  _loadVariousWallets: ->
    @_loadPatientWallet(@patient.idOnServer)
    @_loadPatientOrganizationWallet @currentOrganization.idOnServer, @patient.idOnServer, (patientOrganizationWallet)=>
      unless patientOrganizationWallet
        this.domHost.set('patientOrganizationWalletIndoorBalance', 0)
        this.domHost.set('patientOrganizationWalletOutdoorBalance', 0)
        return
      this.domHost.set('patientOrganizationWalletIndoorBalance', patientOrganizationWallet.indoorBalance)
      this.domHost.set('patientOrganizationWalletOutdoorBalance', patientOrganizationWallet.outdoorBalance)


  onVitalIndexChange: ()->
    console.log @selectedVitalIndex
  # psedo lifecycle callback


  _callAuthorizeRecordApi: (visitSerial, recordSerial, recordType, serverDb, organizationId, cbfn)->

    data = { 
      apiKey: @user.apiKey
      visitSerial
      recordSerial
      recordType
      serverDb
      organizationId
      masterType: 'doctor-app'
    }
    @callApi '/bdemr-organization-authorize-particular-type-of-record', data, (err, response)=>

      if response.hasError
        @domHost.showModalDialog response.error.message
      else

    cbfn()

  navigatedIn: ->

    # @domHost.selectedPatientPageIndex = 0

    @currentOrganization = @getCurrentOrganization()
    unless @currentOrganization
      @domHost.navigateToPage "#/select-organization"

    @authorizedOrganiztionId = localStorage.getItem("authorizedOrganiztionId")

    # Load User
    @_loadUser =>
      params = @domHost.getPageParams()

      # Load Settings Data
      @settings = @_getSettings()
      console.log "SETTINGS:", @settings

      # Load Patient
      unless params['patients']
        @_notifyInvalidPatient()
        return
      else
        @_loadPatient params['patients'], =>

          # load Wallets
          @_loadVariousWallets => null

          # Set SelectedVisitPageIndex
          if params['selected']
           @selectedVisitPageIndex = params['selected']
          else
            @selectedVisitPageIndex = 0

          # Reset Properties - History and Physical
          @historyAndPhysicalRecord = {}

          # Reset Properties - Prescription
          @_resetMedicineForm()
          @_makeDuplicateMedicineEditablePart()
          @matchingPrescribedMedicineList = []

          # Reset Properties - Symptoms
          @addedIdentifiedSymptomsList = []
          @comboBoxSymptomsInputValue = ''

          # Reset Properties - Examination
          @comboBoxExaminationInputValue = ''


          # Reset Properties - Vitals
          tempUnitSelectedIndex = parseInt (lib.localStorage.getItem 'lastSelectedTempUnit')
          if tempUnitSelectedIndex 
            @tempUnitSelectedIndex = tempUnitSelectedIndex
          else
            @tempUnitSelectedIndex = 0

          @addedVitalList = []


          # Reset Properties - Test Advised
          @investigationDataList = []
          @addedInvestigationList = []
          @comboBoxInvestigationInputValue = ''


          # Preloaded Data - Prescription
          @loadMedicineList()
          @_loadInsulinList params['patients']
          @_listFavoriteMedicine @user.serial
          @_listCurrentMedications params['patients']

          # Preloaded Data - Symptoms
          @_loadSymptomsListFromSystem @user.serial

          # Preloaded Data - Examination
          @_loadExaminationList @user.serial

          
          # Preloaded Data - Test Advised
          @_loadInvestigationList @user.serial
          @_loadUserAddedInstitutionList @user.serial

          # Preloaded Data - Diagnosis
          @loadDiagnosisListData()

          # Load Confirm Diagnosis (Previous)
          @_listConfirmedDiagnosis params['patients']
          
          ## Load Visit Record
          unless params['visit']
            @_notifyInvalidVisit()
            return

          if params['visit'] is 'new'
            @_makeNewVisit =>
              @_makeNewPrescription()
              @_makeNewIdentifiedSymptomsObject()
              @_makeNewExaminationObject()

              @_makeBloodPressure()
              @_makePulseRate()
              @_makeBmi()
              @_makeRespiratoryRate()
              @_makeOxygenSaturation()
              @_makeTemperature()

              @_makeNewTestAdvisedObject()
              @_makeNewDiagnosis()
              @_makeNewOperation()
              @_makeNewNote()
              @_makeNewNextVisit()
              @invoice = {}
              @_loadOrganizationsIBelongTo()
              @_makeNewPatientStay()

          else
            @_loadVisit params['visit'], =>
              # @domHost.setSelectedVisitSerial params['visit']
              ## Visit - HistoryAndPhysical - start
              if @visit.hasOwnProperty('historyAndPhysicalRecordSerial')
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
                  @historyAndPhysicalRecord = {}
              else
                @visit.historyAndPhysicalRecordSerial = null
                @historyAndPhysicalRecord = {}
              ## Visit - HistoryAndPhysical - end

              ## Visit - Prescription - start
              if @visit.hasOwnProperty('prescriptionSerial')
                if @visit.prescriptionSerial
                  @_loadPrescription @visit.prescriptionSerial
                else
                  @_makeNewPrescription()
              else
                @visit.prescriptionSerial = null
                @_makeNewPrescription()

              # hack medicine object timesPerInterval
              @medicine.timesPerInterval = 1

              # showGuidelineDisclaimer = lib.localStorage.getItem 'showGuidelineDisclaimer'
              # if showGuidelineDisclaimer is null
              #   @set 'showGuidelineDisclaimer', true
              # else
              #   @set 'showGuidelineDisclaimer', showGuidelineDisclaimer

              ## Visit - Prescription - end

              ## Visit - Symptoms - start
              if @visit.hasOwnProperty('identifiedSymptomsSerial')
                if @visit.identifiedSymptomsSerial
                  @_loadIdentifiedSymptoms @visit.identifiedSymptomsSerial
                else
                  @_makeNewIdentifiedSymptomsObject()
              else
                @visit.identifiedSymptomsSerial = null
                @_makeNewIdentifiedSymptomsObject()
              ## Visit - Symptoms - end

              ## Visit - Examination - start
              if @visit.hasOwnProperty('examinationSerial')
                if @visit.examinationSerial
                  @_loadExamination @visit.examinationSerial
                else
                  @_makeNewExaminationObject()
                  
              else
                @visit.examinationSerial = null
                @_makeNewExaminationObject()

              ## Visit - Examination - end

              ## Visit - Vitals - start
              
              if @visit.hasOwnProperty 'vitalSerial'

                if @visit.vitalSerial.bp
                   @_loadVitalsForVisit @visit.vitalSerial.bp, 'Blood Pressure'
                else
                  @_makeBloodPressure()

                if @visit.vitalSerial.hr
                  @_loadVitalsForVisit @visit.vitalSerial.hr, 'Heart Rate'
                else
                  @_makePulseRate()

                if @visit.vitalSerial.bmi
                  @_loadVitalsForVisit @visit.vitalSerial.bmi, 'BMI'
                else
                  @_makeBmi()

                if @visit.vitalSerial.rr
                  @_loadVitalsForVisit @visit.vitalSerial.rr, 'Respirtory Rate'
                else
                  @_makeRespiratoryRate()

                if @visit.vitalSerial.spo2
                  @_loadVitalsForVisit @visit.vitalSerial.spo2, 'Spo2'
                else
                  @_makeOxygenSaturation()

                if @visit.vitalSerial.temp
                  @_loadVitalsForVisit @visit.vitalSerial.temp, 'Temperature'
                else
                  @_makeTemperature()

              else
                @_makeBloodPressure()
                @_makePulseRate()
                @_makeBmi()
                @_makeRespiratoryRate()
                @_makeOxygenSaturation()
                @_makeTemperature()

                @visit.vitalSerial =
                  bp: null
                  hr: null
                  bmi: null
                  rr: null
                  spo2: null
                  temp: null
        
              ## Visit - Vitals - end


              ## Visit - Test Advised - start
              if @visit.hasOwnProperty('advisedTestSerial')
                if @visit.advisedTestSerial
                  @_loadAdvisedTest @visit.advisedTestSerial
                else
                  @_makeNewTestAdvisedObject()
              else
                @visit.advisedTestSerial = null
                @_makeNewTestAdvisedObject()
                  
              ## Visit - Test Advised - start

              ## Visit - Diagnosis - start
              if @visit.hasOwnProperty('diagnosisSerial')
                if @visit.diagnosisSerial
                  @_loadDiagnosis @visit.diagnosisSerial
                else
                  @_makeNewDiagnosis()
              else
                @visit.diagnosisSerial = null
                @_makeNewDiagnosis()
              ## Visit - Diagnosis - end

              ## Visit - Operation - start
              if @visit.hasOwnProperty('operationSerial')
                if @visit.operationSerial
                  @_loadOperation @visit.operationSerial
                else
                  @_makeNewOperation()
              else
                @visit.operationSerial = null
                @_makeNewOperation()
              ## Visit - Operation - end

              ## Visit - Notes - start
              if @visit.hasOwnProperty('doctorNotesSerial')
                if @visit.doctorNotesSerial
                  @_loadVisitNote @visit.doctorNotesSerial
                else
                  @_makeNewNote()
              else
                @visit.doctorNotesSerial = null
                @_makeNewNote()

              ## Visit - Next Visit - start
              if @visit.hasOwnProperty('nextVisitSerial')
                if @visit.nextVisitSerial
                  @_loadNextVisit @visit.nextVisitSerial
                else
                  @_makeNewNextVisit()
              else
                @visit.nextVisitSerial = null
                @_makeNewNextVisit() is null

              ## Visit - Next Visit - end

              ## Visit - Patient Stay - start
              @_loadOrganizationsIBelongTo()

              if @visit.hasOwnProperty('patientStaySerial')
                if @visit.patientStaySerial
                  @_loadVisitPatientStay @visit.patientStaySerial
                else
                  @_makeNewPatientStay()
              else
                @visit.patientStaySerial = null
                @_makeNewPatientStay() is null
              
              ## Visit - Patient Stay - end

              ## Visit - Invoice - start
              if @visit.hasOwnProperty('invoiceSerial')
                if @visit.invoiceSerial
                  @_loadInvoice @visit.invoiceSerial
                else
                  @invoice = {}
              else
                @visit.invoiceSerial = null
                @invoice = {}
              ## Visit - Invoice - end


  navigatedOut: ->
    @visit = {}
    @patient = {}
    @doctorNotes = {}
    @patientStay = {}
    @isVisitValid = false
    @isPatientValid = false
    @isNoteValid = false
    @isPatientStayValid = false
    @isInvoiceValid = false
    
    @doctorInstitutionList = []
    @doctorSpecialityList = []

    ## Prescription
    @prescription = {}
    @isPrescriptionValid = false

    @matchingPrescribedMedicineList = []
    @matchingCurrentMedicineList = []
    @matchingFavoriteMedicineList = []

    @medicine = {}

    @isMedicineValid = false

    ## Advised Test
    @isTestAdvisedValid = false
    @testAdvisedObject = {}
    @matchingFavoriteInvestigationList = []
    @investigationDataList = []

    ##Examination
    @addedExaminationList = []
    
    ## patient stay
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

    ## Visit Details :: View - HistoryAndPhysical
    @shouldRender = false

    @historyAndPhysicalRecord = {}



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

    if params['patients']
      patientIdentifier = params['patients'] 

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
      diagnosis = if typeof @comboBoxDiagnosisInputValue is 'object' then @comboBoxDiagnosisInputValue.name.trim() else @comboBoxDiagnosisInputValue.trim()
      if diagnosis is ''
        # no need to proceed
        @domHost.showToast 'Add/Type a Diagnosis first!'
        return
      else if @_duplicateDiagnosisCheck diagnosis
        @domHost.showToast 'Already added!'
        return
      else
        # proper name provided
        @push 'diagnosis.data.diagnosisList', { name: diagnosis }
        @_saveDiagnosis()
        @domHost.showToast 'Diagnosis Added!'
        @comboBoxDiagnosisInputValue = ''


  _duplicateDiagnosisCheck: (newDiagnosis)->
    for diagnosis in @diagnosis.data.diagnosisList
      return true if diagnosis.name is newDiagnosis


  _deleteSelectedDiagnosisButtonPressed: (e)->
    index = e.model.index
    @splice 'diagnosis.data.diagnosisList', index, 1
    @_saveDiagnosis()
    @domHost.showToast 'Diagnosis Deleted!'

  ## diagnosis - end


  ## operation - end
  _loadOperation: (operationSerialIdentifier)->
    lib.util.delay 5, ()=>
      list = app.db.find 'operation-record', ({serial})-> serial is operationSerialIdentifier
      
      if list.length is 1
        @isOperationValid = true
        @isFullVisitValid = true
        @operation = list[0]
        console.log 'OPERATION:', @operation
        return true
      else
        @isOperationValid = false
        return false

  _makeNewOperation: ()->
    @operation =
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
        operationList: []

  _saveOperation: ()->

    unless @visit.serial isnt null
      @_saveVisit()
      # @visit.serial = @generateSerialForVisit()
      @operation.visitSerial = @visit.serial
      
    
    unless @operation.serial isnt null
      @operation.serial = @generateSerialForOperation()
      @visit.operationSerial = @operation.serial
      @operation.visitSerial = @visit.serial
      @_saveVisit()
        
    console.log 'visit', @visit
    console.log 'operation', @operation

    @operation.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'operation-record', @operation, ({serial})=> @operation.serial is serial

    @comboBoxOperationInputValue = ''



  comboBoxKeyUpOperationValueChanged: (e)->

    unless @comboBoxOperationInputValue is ''

      if e.which is 13 # ENTER/RETURN
        operation = ''
        if typeof @comboBoxOperationInputValue is 'object'
          operation = @comboBoxOperationInputValue.name
        else
          operation = @comboBoxOperationInputValue

        @push 'operation.data.operationList', { name: operation }
        @_saveOperation()
        @domHost.showToast 'Operation Added!'
        @comboBoxOperationInputValue = ''

  addOperation: ()->
    unless @comboBoxOperationInputValue is ''
      operation = if typeof @comboBoxOperationInputValue is 'object' then @comboBoxOperationInputValue.name.trim() else @comboBoxOperationInputValue.trim()
      if operation is ''
        # no need to proceed
        @domHost.showToast 'Add/Type an Operation first!'
        return
      else if @_duplicateOperationCheck operation
        @domHost.showToast 'Already added!'
        return
      else
        # proper name provided
        @push 'operation.data.operationList', { name: operation }
        @_saveOperation()
        @domHost.showToast 'Operation Added!'
        @comboBoxOperationInputValue = ''



  _duplicateOperationCheck: (newOp)->
    for operation in @operation.data.operationList
      return true if operation.name is newOp


  _deleteSelectedOperationButtonPressed: (e)->
    index = e.model.index
    @splice 'operation.data.operationList', index, 1
    @_saveOperation()
    @domHost.showToast 'Operation Deleted!'

  ## operation - end

  ## confirm diagnosis (previous) - start
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
  ## confirm diagnosis (previous) - end



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
