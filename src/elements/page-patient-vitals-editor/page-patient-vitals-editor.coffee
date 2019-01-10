Polymer {
  is: 'page-patient-vitals-editor'

  behaviors: [
    app.behaviors.pageLike
    app.behaviors.dbUsing
    app.behaviors.translating
  ]

  properties:
    patient:
      type: Object
      notify: true
      value: null

    selectedSubViewIndex:
      type: Number
      value: 0
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

    # bloodPressureList:
    #   type: Array
    #   value: []
    # pulseRateList:
    #   type: Array
    #   value: []
    # bmiList:
    #   type: Object
    #   value: []
    # respiratoryRateList:
    #   type: Object
    #   value: []
    # oxygenSaturationList:
    #   type: Object
    #   value: []
    # temperatureList:
    #   type: Object
    #   value: []

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

    # filterDateRange:
    #  type: String
    #  value: ''

    addedVitalList:
      type: Array
      value: []

  _makeBloodPressure: ->
    @bloodPressure =
      serial: null
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
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
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      data:
        bpm: ''
        unit: 'bpm'
        flags:
          flagAsError: false
  _makeBmi: ->
    @bmi =
      serial: null
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      data:
        height: ''
        heightInFt: ''
        heightInInch: ''
        heightUnit: ''
        weight: ''
        weightUnit: ''
        calculatedBMI: ''
        flags:
          flagAsError: false
  _makeRespiratoryRate: ->
    @respiratoryRate =
      serial: null
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      data:
        respiratoryRate: ''
        unit: 'rpm'
        flags:
          flagAsError: false
  _makeOxygenSaturation: ->
    @oxygenSaturation =
      serial: null
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      data:
        spO2Percentage: ''
        unit: '%'
        flags:
          flagAsError: false

  _makeTemperature: ->
    @temperature =
      serial: null
      createdByUserSerial: null
      patientSerial: null
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: null
      lastSyncedDatetimeStamp: null
      data:
        temperature: ''
        unit: ''
        flags:
          flagAsError: false

  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()



  # psuedo lifecycle callback
  navigatedIn: ()->
    @set 'selectedSubViewIndex', 0
    
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"

    params = @domHost.getPageParams()

    @_loadPatient(params['patient'])
    @addedVitalList = []
    @_makeBloodPressure()
    @_makePulseRate()
    @_makeBmi()
    @_makeRespiratoryRate()
    @_makeOxygenSaturation()
    @_makeTemperature()

    tempUnitSelectedIndex = parseInt (lib.localStorage.getItem 'lastSelectedTempUnit')
    if tempUnitSelectedIndex 
      @set 'tempUnitSelectedIndex', tempUnitSelectedIndex
    else
      @set 'tempUnitSelectedIndex', 0

    @userSerial = (app.db.find 'user')[0].serial

  
  
  # Helper
  # ======================================================
  
  _sortByDate: (a, b)->
    if a.lastModifiedDatetimeStamp < b.lastModifiedDatetimeStamp
      return 1
    if a.lastModifiedDatetimeStamp > b.lastModifiedDatetimeStamp
      return -1

  _returnSerial: (index)->
    index+1

  _formatDateTime: (dateTime)->
    lib.datetime.format dateTime, 'mmm d, yyyy h:MMTT'

  _isEmptyTable: (list)->
    return true if list.length <= 0

  _isEmpty: (data)->

    if data is 0
      return true
    else
      return false

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()


  
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

    @push 'addedVitalList', {
      vitalType: type
      vitalObject: object
    }


  _pritifyVitalData: (masterVitalObject)->

    if masterVitalObject.vitalType is 'Blood Pressure'
      return "Systolic/Diastolic: " + masterVitalObject.vitalObject.data.systolic + "/" + masterVitalObject.vitalObject.data.diastolic

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


      @domHost.showToast @addedVitalList.length + " Vitals Saved."
      @arrowBackButtonPressed()

  _deleteAddedVitalItemClicked:(e)->
    index = e.model.index
    @splice('addedVitalList', index, 1);
    @domHost.showToast 'Vital Deleted!'




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
    # @_saveBloodPressure @bloodPressure
    # @bloodPressureList = app.db.find 'patient-vitals-blood-pressure'
   
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

  # deleteBloodPressureItemButtonClicked: (e)->
  #   @domHost.showModalPrompt 'Are you sure to delete this item?', (answer)=>
  #     if answer
  #       app.db.remove 'patient-vitals-blood-pressure', e.model.item._id
  #       app.db.insert 'patient-vitals-blood-pressure--deleted', { serial: e.model.item.serial }
  #       @bloodPressureList = app.db.find 'patient-vitals-blood-pressure'
  #       @domHost.showToast 'Deleted'

  # bloodPressureCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 23,59
  #   @bloodPressureList = app.db.find 'patient-vitals-blood-pressure', ({lastModifiedDatetimeStamp})=>
  #     itemDate = new Date lastModifiedDatetimeStamp
  #     if startDate.getTime() <= itemDate.getTime() <= endDate.getTime()
  #       return true
  
  # bloodPressureSearchClearButtonClicked: (e)->
  #   @bloodPressureList = app.db.find 'patient-vitals-blood-pressure'


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
      @_addToVitalList @pulseRate, 'Heart Rate'
      # @_savePulseRate @pulseRate
      # @pulseRateList = app.db.find 'patient-vitals-pulse-rate'
   
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

  # deletePulseRateItemButtonClicked: (e)->
  #   @domHost.showModalPrompt 'Are you sure to delete this item?', (answer)=>
  #     if answer
  #       app.db.remove 'patient-vitals-pulse-rate', e.model.item._id
  #       app.db.insert 'patient-vitals-pulse-rate--deleted', { serial: e.model.item.serial }
  #       @pulseRateList = app.db.find 'patient-vitals-pulse-rate'
  #       @domHost.showToast 'Deleted'

  # pulseRateCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 23,59
  #   @pulseRateList = app.db.find 'patient-vitals-pulse-rate', ({lastModifiedDatetimeStamp})=>
  #     itemDate = new Date lastModifiedDatetimeStamp
  #     if startDate.getTime() <= itemDate.getTime() <= endDate.getTime()
  #       return true
  
  # pulseRateSearchClearButtonClicked: (e)->
  #   @pulseRateList = app.db.find 'patient-vitals-pulse-rate'



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
      # @_saveBmi @bmi
      # @bmiList = app.db.find 'patient-vitals-bmi'
    else
      @domHost.showToast 'Correct Required Input'

  # deleteBmiItemButtonClicked: (e)->
  #   @domHost.showModalPrompt 'Are you sure to delete this item?', (answer)=>
  #     if answer
  #       app.db.remove 'patient-vitals-bmi', e.model.item._id
  #       app.db.insert 'patient-vitals-bmi--deleted', { serial: e.model.item.serial }
  #       @bmiList = app.db.find 'patient-vitals-bmi'
  #       @domHost.showToast 'Deleted'

  
  # bmiCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 23,59
  #   @bmiList = app.db.find 'patient-vitals-bmi', ({lastModifiedDatetimeStamp})=>
  #     itemDate = new Date lastModifiedDatetimeStamp
  #     if startDate.getTime() <= itemDate.getTime() <= endDate.getTime()
  #       return true
  
  # bmiSearchClearButtonClicked: (e)->
  #   @bmiList = app.db.find 'patient-vitals-bmi'

    

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
      @_addToVitalList @respiratoryRate, 'Respirtory Rate'
      # @_saveRespiratoryRate @respiratoryRate
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

  # deleteRespiratoryRateItemButtonClicked: (e)->
  #   @domHost.showModalPrompt 'Are you sure to delete this item?', (answer)=>
  #     if answer
  #       app.db.remove 'patient-vitals-respiratory-rate', e.model.item._id
  #       app.db.insert 'patient-vitals-respiratory-rate--deleted', { serial: e.model.item.serial }
  #       @respiratoryRateList = app.db.find 'patient-vitals-respiratory-rate'
  #       @domHost.showToast 'Deleted'

  # respiratoryRateCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 23,59
  #   @respiratoryRateList = app.db.find 'patient-vitals-respiratory-rate', ({lastModifiedDatetimeStamp})=>
  #     itemDate = new Date lastModifiedDatetimeStamp
  #     if startDate.getTime() <= itemDate.getTime() <= endDate.getTime()
  #       return true
  
  # respiratoryRateSearchClearButtonClicked: (e)->
  #   @respiratoryRateList = app.db.find 'patient-vitals-respiratory-rate'


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
      @_addToVitalList @oxygenSaturation, 'SpO2'
      # @_saveOxygenSaturation @oxygenSaturation
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

  # deleteOxygenSaturationItemButtonClicked: (e)->
  #   @domHost.showModalPrompt 'Are you sure to delete this item?', (answer)=>
  #     if answer
  #       app.db.remove 'patient-vitals-spo2', e.model.item._id
  #       app.db.insert 'patient-vitals-spo2--deleted', { serial: e.model.item.serial }
  #       @oxygenSaturationList = app.db.find 'patient-vitals-spo2'
  #       @domHost.showToast 'Deleted'

  # oxygenSaturationCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 23,59
  #   @oxygenSaturationList = app.db.find 'patient-vitals-spo2', ({lastModifiedDatetimeStamp})=>
  #     itemDate = new Date lastModifiedDatetimeStamp
  #     if startDate.getTime() <= itemDate.getTime() <= endDate.getTime()
  #       return true
  
  # oxygenSaturationSearchClearButtonClicked: (e)->
  #   @oxygenSaturationList = app.db.find 'patient-vitals-spo2'



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
    @_addToVitalList @temperature, 'Temperature'
    # @_saveTemperature @temperature
    # @temperatureList = app.db.find 'patient-vitals-temparature'
   
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

  # deleteTemperatureItemButtonClicked: (e)->
  #   @domHost.showModalPrompt 'Are you sure to delete this item?', (answer)=>
  #     if answer
  #       app.db.remove 'patient-vitals-temparature', e.model.item._id
  #       app.db.insert 'patient-vitals-temparature--deleted', { serial: e.model.item.serial }
  #       @temperatureList = app.db.find 'patient-vitals-temparature'
  #       @domHost.showToast 'Deleted'

  
  # temperatureCustomSearchClicked: (e)->
  #   startDate = new Date e.detail.startDate
  #   endDate = new Date e.detail.endDate
  #   endDate.setHours 23,59
  #   @temperatureList = app.db.find 'my-vitals-oxygen-temperature', ({lastModifiedDatetimeStamp})=>
  #     itemDate = new Date lastModifiedDatetimeStamp
  #     if startDate.getTime() <= itemDate.getTime() <= endDate.getTime()
  #       return true
  
  # temperatureSearchClearButtonClicked: (e)->
  #   @temperatureList = app.db.find 'my-vitals-oxygen-temperature'

}
