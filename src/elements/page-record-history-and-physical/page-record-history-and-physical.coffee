

Polymer {

  is: 'page-record-history-and-physical'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.recordPage
  ]

  properties:
    def:
      type: Object
      notify: false
      value: null
    data:
      type: Object
      notify: false
      value: null

  $isDynamicElementReady: (def, data)->
    return def isnt null and data isnt null

  printButtonPressed: (e)->
    @saveButtonPressed()
    @domHost.navigateToPage '#/print-history-and-physical-record/record:' + @record.serial
    window.location.reload()

  navigatedIn: ->
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"
      
    @data = null
    @def = null
    @genericNavigatedIn 'history-and-physical-record'
    @domHost.getStaticData 'dynamicElementDefinitionPreoperativeAssessment', (def)=>
      unless 'data' of @record
        @record.data = {}
      @data = @record.data
      @def = def

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

  dynamicDataAltered: (type, pathArray)->
    path = pathArray.join '//'

    gcs1 = '<root>//Examination//Chronic pain/Neurological Examination//GCS//<array>//Eye Opening (E)//<array>//Eye Opening (E)'
    gcs2 = '<root>//Examination//Chronic pain/Neurological Examination//GCS//<array>//Verbal Response (V)//<array>//Verbal Response (V)'
    gcs3 = '<root>//Examination//Chronic pain/Neurological Examination//GCS//<array>//Motor Response (M)//<array>//Motor Response (M)'
    gcsRes = '<root>//Examination//Chronic pain/Neurological Examination//GCS//GCS//GCS'

    rcri = '<root>//Risk Assesment//ASA, Risk index & Others//List//<array>//Revised Cardiac Risk Index//<array>//Revised Cardiac Risk Index'
    rcriCal = '<root>//Risk Assesment//ASA, Risk index & Others//List//<array>//Revised Cardiac Risk Index//<array>//Calculated Cardiac Risk Index'

    lmp = '<root>//History//History of Current Medical Problem / Diagnosis//Obstetric History//<array>//Obstetric history list//<array>//Obstetric history//<array>//LMP and EDD//<array>//LMP'
    edd = '<root>//History//History of Current Medical Problem / Diagnosis//Obstetric History//<array>//Obstetric history list//<array>//Obstetric history//<array>//LMP and EDD//<array>//EDD'
    console.log path

    bmiHeight = "<root>//History//Physical Parameter//List//<array>//height//<array>//height"
    bmiWeight = "<root>//History//Physical Parameter//List//<array>//weight//<array>//weight"
    bmi = "<root>//History//Physical Parameter//List//<array>//BMI//<array>//bmi"
    bmiVerdict = "<root>//History//Physical Parameter//List//<array>//BMI//<array>//bmi Verdict"

    if path in [ gcs1, gcs2, gcs3 ]

      str = (gcs1.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      v1 = @safeExtractItem str

      str = (gcs2.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      v2 = @safeExtractItem str

      str = (gcs3.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      v3 = @safeExtractItem str

      val1 = parseInt v1.selectedValue
      val2 = parseInt v2.selectedValue
      val3 = parseInt v3.selectedValue

      gcs = val1 + val2 + val3

      str = (gcsRes.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      v = @safeExtractItem str

      v.label = 'GCS = ' + gcs

    else if path is rcri

      str = (rcri.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      v1 = @safeExtractItem str
      count = v1.checkedValueList.length
      val = '11%'
      val = '0.4%' if count is 0
      val = '0.9%' if count is 1
      val = '6.6%' if count is 2

      str = (rcriCal.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      v1 = @safeExtractItem str

      v1.label = 'Calculated risk index = ' + val

    else if path is lmp

      str = (lmp.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      v1 = @safeExtractItem str

      date = new Date v1.value
      date.setDate (date.getDate() + 280)

      str = (edd.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      v1 = @safeExtractItem str
      v1.label = 'EDD = ' + (lib.datetime.mkDate date)
      console.log v1

    else if path in [ bmiHeight, bmiWeight, bmi, bmiVerdict]
      str = (bmiHeight.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      height = @safeExtractItem str

      # convertHeightToMeter
      heightUnit = height.selectedUnitIndex
      heightInMeter = 0
      if heightUnit is 0
        heightInMeter = height.value * 0.01
      else if heightUnit is 2
        heightInMeter = height
      else if heightUnit is 1
        heightInMeter = height.value * 0.0254

      str = (bmiWeight.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      weight = @safeExtractItem str

      # _convertWeightToKg: ->
      weightUnit = weight.selectedUnitIndex
      weightInKg = 0
      if weightUnit is 1
        weightInKg = weight.value * 0.453592
      else if weightUnit is 0
        weightInKg = weight.value

      bmiRes = Math.round ((weightInKg / (heightInMeter*heightInMeter))*100)/100
      
      str = (bmi.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      bmi = @safeExtractItem str
      bmi.label = bmiRes

      
      str = (bmiVerdict.replace '<root>', 'preopAssessment')
      str = str.replace /\/\/\<array\>/g, ''
      bmiVerdictRes = @safeExtractItem str
      bmiVerdictRes.label = @_calculateBMIVerdict bmiRes




}