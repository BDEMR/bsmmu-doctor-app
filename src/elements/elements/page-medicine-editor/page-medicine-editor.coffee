Polymer {
  is: "page-medicine-editor"

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
    app.behaviors.dbUsing
    app.behaviors.apiCalling
    app.behaviors.pageLike
    app.behaviors.translating
  ]
  
  properties:
    user:
      type: Object
      notify: true
      value: {}

    patient:
      type: Object
      notify: true
      value: {}

    prescription:
      type: Object
      notify: true
      value: {}

    isPrescriptionValid: 
      type: Boolean
      notify: false
      value: true

    isPatientValid:
      type: Boolean
      notify: false
      value: true 

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

    doseList:
      type: Array
      value: [
        '0'
        '1/4'
        '1/2'
        '1'
        '2'
        '3'
        '4'
        '5'
      ]

    morningDoseSelectedIndex:
      type: Number
      value: 0

    noonDoseSelectedIndex:
      type: Number
      value: 0

    nightDoseSelectedIndex:
      type: Number
      value: 0

    doseUnitList:
      type: Array
      value: []
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
    
    computedEndDate:
      type: String
      computed: '_showComputedEndDate(medicine.endDateTimeStamp)'

  observers : [
    '_computeQuantityPerPrescription(medicine.dose, medicine.timesPerInterval, intervalInDays, medicine.endDateTimeStamp, medicine.startDateTimeStamp)'
    '_computeIntervalInHours(medicine.timesPerInterval, intervalInDays)'
    '_compouteTimesPerInterval(medicine.timeOfDay.morning, medicine.timeOfDay.noon, medicine.timeOfDay.night)'
  ]

  # psedo lifecycle callback
  navigatedIn: ->
   
    params = @domHost.getPageParams()

    @_loadUser()
    @_loadPatient(params['patient'])
    @_loadPrescription(params['prescription'])

    # Resetting Form------->
    @_resetMedicineForm()

    # Load Data --------------->
    # @domHost.getStaticData 'doseGuidelineList', (doseGuidelineList)=>
    #   @runSanitizationCheckForDoseGuidelineList doseGuidelineList
    #   @doseGuidelineList = doseGuidelineList
    @domHost.getStaticData 'medicineList', (medicineCompositionList)=>
      @medicineCompositionList = medicineCompositionList
      @_loadDefaultMedicineCompositionList()

    showGuidelineDisclaimer = lib.localStorage.getItem 'showGuidelineDisclaimer'
    if showGuidelineDisclaimer is null
      @set 'showGuidelineDisclaimer', true
    else
      @set 'showGuidelineDisclaimer', showGuidelineDisclaimer


    unless params['medicine']
      @_notifyInvalidMedicine()
      return

    if params['medicine'] is 'new'
      @isThatNewMedicine = true
      @_resetMedicineForm()

    else
      @isThatNewMedicine  = false
      @_loadMedicine(params['medicine'])


  navigatedOut: ->
    @user = {}
    @patient = {}
    @prescription = {}
    @medicine = {}
    @favoriteMedicine = {}
    @isPrescriptionValid = false
    @isPatientValid = false
    @isMedicineValid = false
    @.$.guidelineContainer.close()
    

  _resetMedicineForm: ()->
    @medicine =
      serial: @generateSerialForMedication()
      genericName: ''
      strength: ''
      brandName: ''
      manufacturer: ''
      dose: 1
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
    
    @strengthSelectedIndex = null
    @medicineFormSelectedIndex = null
    @doseUnitSelectedIndex = null
    @routeSelectedIndex = 0
    @endDateTimeTypeSelectedIndex = 0
    @endDateTimeTypeArgument2SelectedIndex = 0

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  _loadPrescription: (prescriptionIdentifier)->
    list = app.db.find 'visit-prescription', ({serial})-> serial is prescriptionIdentifier
    if list.length is 1
      @isPrescriptionValid = true
      @prescription = list[0]
    else
      @_notifyInvalidPrescription()

  _loadMedicine: (medicineIdentifier)->
    list = app.db.find 'patient-medications', ({serial})-> serial is medicineIdentifier
    # console.log list
    if list.length is 1
      @isMedicineValid = true
      @medicine = list[0]
      # console.log(@medicine)
      return true
    else
      @_notifyInvalidMedicine()
      return false

  _notifyInvalidPatient:() ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided!'

  _notifyInvalidPrescription:() ->
    @isPrescriptionValid = false
    @domHost.showModalDialog 'Invalid Prescription Provided!'

  _notifyInvalidMedicine:() ->
    @isMedicineValid = false
    @domHost.showModalDialog 'Invalid Medicine Provided!'


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
    @arrowBackButtonPressed()

  arrowBackButtonPressed: (e)->
    window.history.back()

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
    @brandNameSourceDataList = ({text: item, value: item} for item in Object.keys brandNameMap)
    @manufacturerSourceDataList = ({text: item, value: item} for item in Object.keys manufacturerMap)
    @genericNameSourceDataList = ({text: item, value: item} for item in Object.keys genericNameMap)


  brandNameAutocompleteSelected: (e)->
    brandName = e.detail.text
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
    @set 'medicine.timesPerInterval', interval
  
  _computeIntervalInHours: (timesPerInterval, intervalInDays)->
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
      'PR (Per Rectal)':  ['Suppository']
      'Suppository':  ['Suppository']
      'Solution': ['ml']
      'Ointment': ['application']
      'Cream': ['application']
      'Skin Patch': ['skin patch']
    }

    routeMap = {
      'Tablet': ['p.o']
      'Injection': ['i.v injection', 'i.m injection']
      'Syrup': ['p.o']
      'Drop': ['p.o', 'topical application ear', 'topical application eye']
      'Capsule': ['p.o']
      'Suspension': ['p.o']
      'I.V Injection': ['i.v injection']
      'I.M injection': ['i.m injection']
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

  _morningDoseSelectedIndexChanged: ->
    item = @get ['doseList', @morningDoseSelectedIndex]
    dose = switch
      when item is "1/4" then 0.25
      when item is "1/2" then 0.50
      else Number item
    @set 'medicine.timeOfDay.morning', dose

  _noonDoseSelectedIndexChanged: ->
    item = @get ['doseList', @noonDoseSelectedIndex]
    dose = switch
      when item is "1/4" then 0.25
      when item is "1/2" then 0.50
      else Number item
    @set 'medicine.timeOfDay.noon', dose

  _nightDoseSelectedIndexChanged: ->
    item = @get ['doseList', @nightDoseSelectedIndex]
    dose = switch
      when item is "1/4" then 0.25
      when item is "1/2" then 0.50
      else Number item
    @set 'medicine.timeOfDay.night', dose
  
  _doseUnitSelectedIndexChanged: ->
    unless @doseUnitSelectedIndex is @doseUnitList.length-1
      item = @get ['doseUnitList', @doseUnitSelectedIndex]
      @set 'medicine.doseUnit', item

  _showComputedEndDate: (endDate)->
    return null if @endDateTimeTypeSelectedIndex is 0
    return lib.datetime.mkDate endDate, 'dd-mmm-yyyy'

  _endDateTimeTypeSelectedIndexChanged: ->
    endDateTimeTypeValue = @get ['endDateTimeTypeList', @endDateTimeTypeSelectedIndex]
    endDateTimeTypeArgument2Value = @get ['endDateTimeTypeArgument2List', @endDateTimeTypeArgument2SelectedIndex]
    endDateTimeTypeValue += ' ' + endDateTimeTypeArgument2Value
    # make end date object from week, days
    startDate = @get 'medicine.startDateTimeStamp'
    week = parseInt(endDateTimeTypeValue.substr 0,1)
    days = parseInt(endDateTimeTypeArgument2Value.substr 0,1)
    if startDate and (week or days)
      endDateTimeStamp = @_makeEndDateStampfromCustom startDate, week, days
      @set 'medicine.endDateTimeStamp', endDateTimeStamp

  _computeQuantityPerPrescription: (timesPerInterval, intervalInDays, endDate, startDate)->
    if endDate > 0
      oneDay = 1000*60*60*24;
      startDate = new Date startDate
      diffMs = endDate - startDate
      totalDay =  Math.round(diffMs / oneDay)
      #FOR ROUNDING TO 2 Decimal, quantityPerPrescription = (Math.round (timesPerInterval * (totalDay/intervalInDays)) * 100)/100
      quantityPerPrescription = Math.ceil (timesPerInterval * (totalDay / intervalInDays)) 
    else
       quantityPerPrescription = timesPerInterval
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
        medicine.patientSerial = params['patient']
        medicine.prescriptionSerial = params['prescription'] 
        medicine.lastModifiedDatetimeStamp = lib.datetime.now()
        # console.log medicine
        app.db.insert 'patient-medications', medicine

        window.history.back()

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
      data:
        brandName: medicine.data.brandName
        comments: medicine.data.comments
        direction: medicine.data.direction
        dose: medicine.data.dose
        doseUnit: medicine.data.doseUnit
        endDateTimeStamp: medicine.data.endDateTimeStamp
        form: medicine.data.form
        genericName: medicine.data.genericName
        intakeDateTimeStampList: medicine.data.intakeDateTimeStampList
        intervalInHours: medicine.data.intervalInHours
        manufacturer: medicine.data.manufacturer
        nextDoseDateTimeStamp: null
        numberOfRefill: medicine.data.numberOfRefill
        quantityPerPrescription: medicine.data.quantityPerPrescription
        remind: medicine.data.remind
        route: medicine.data.route
        startDateTimeStamp: lib.datetime.now()
        status: medicine.data.status
        strength: medicine.data.strength
        timesPerInterval: medicine.data.timesPerInterval

    # console.log favoriteMedicine
        

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
        medicine.patientSerial = params['patient']
        medicine.prescriptionSerial = params['prescription'] 
        medicine.lastModifiedDatetimeStamp = lib.datetime.now()
        # console.log medicine
        app.db.insert 'patient-medications', medicine
        @_makeNewFavoriteMedicine(medicine)
        @domHost.showToast 'Added & Saved As a Favorite!'
        window.history.back()

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


}