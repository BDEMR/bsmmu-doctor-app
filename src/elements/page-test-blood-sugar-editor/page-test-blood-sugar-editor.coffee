Polymer {
  is: "page-test-blood-sugar-editor"
  
  behaviors: [
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
  ]
  
  properties:
    user:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: {}

    isPatientValid:
      type: Boolean
      notify: false
      value: true 

    isThatNewTest:
      type: Boolean
      notify: false
      value: true

    bloodSugarUnitSelectedIndex:
      type: Number
      value: 0
      notify: true              
    bloodSugarTimeSelectedIndex:
      type: Number
      value: 0
      notify: true
    bloodSugar:
      type: Object
      notify: true
      value: {}

    bloodSugarTimeType:
      type: Array
      value: -> [
        'before-meal'
        'after-meal'
        'random'
      ]

    currentDate:
      type: String
      value: ()->
        return lib.datetime.mkDate new Date

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

  _makeBloodSugar: ->
    @bloodSugar =
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      createdDatetimeStamp: lib.datetime.mkDate()
      lastModifiedDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      data:
        type: ""
        value: null
        unit: null


  _isEmptyString: (data)->
    if data == null || data == 'undefined' || data == ''
      return true
    else
      return false

  _loadBloodSugar: (testIdentifier)->
    list = app.db.find 'patient-test-blood-sugar', ({serial})-> serial is testIdentifier
 
    if list.length is 1
      @isTestValid = true
      @bloodSugar = list[0]

      switch @bloodSugar.data.type
        when 'before-meal' then @bloodSugarTimeSelectedIndex = 0
        when 'after-meal' then @bloodSugarTimeSelectedIndex = 1
        when 'random' then @bloodSugarTimeSelectedIndex = 2
      return true
    else
      @_notifyInvalidTest()
      return false

  updateBloodSugarPressed: (e)->
    unless @bloodSugar.data.value
      @domHost.showToast 'Please Enter Data'
    if @bloodSugar.data.type or @bloodSugar.data.value or @bloodSugar.data.unit
      if @bloodSugarUnitSelectedIndex is 0
        @set 'bloodSugar.data.unit', 'mmol/L'
      if @bloodSugarUnitSelectedIndex is 1
        @set 'bloodSugar.data.unit', 'mg/dl'
      @set 'bloodSugar.lastModifiedDatetimeStamp', lib.datetime.now()
      @_saveBloodSugar @bloodSugar
      @domHost.showToast 'Updated Successfully!'
      @arrowBackButtonPressed()

  cancelButtonClicked: (e)->
    @arrowBackButtonPressed()

  arrowBackButtonPressed: (e)->
    window.history.back()

  _notifyInvalidTest:() ->
    @isTestValid = false
    @domHost.showModalDialog 'Invalid Test Provided'

  _saveBloodSugar: (data)->
    app.db.upsert 'patient-test-blood-sugar', data, ({serial})=> data.serial is serial
    # console.log app.db.find 'patient-test-blood-sugar'

  addBloodSugarButtonClicked: ->

    @bloodSugar.data.type = @bloodSugarTimeType[@bloodSugarTimeSelectedIndex]

    if @bloodSugar.data.value >= 1
      @set 'bloodSugar.lastModifiedDatetimeStamp', lib.datetime.now()
      @set 'bloodSugar.serial', @generateSerialForVitals 'BS'
      @bloodSugar.createdDatetimeStamp = (+new Date @bloodSugar.createdDatetimeStamp)
      @bloodSugar.data.value = parseInt @bloodSugar.data.value
      if @bloodSugarUnitSelectedIndex is 0
        @set 'bloodSugar.data.unit', 'mmol/L'
      if @bloodSugarUnitSelectedIndex is 1
        @set 'bloodSugar.data.unit', 'mg/dl'
      @_saveBloodSugar @bloodSugar
      @domHost.showToast 'Added Successfully'
      @_makeBloodSugar()
      @arrowBackButtonPressed()

    else
       @domHost.showToast 'Please Input correct value'
       return


  # psedo lifecycle callback
  navigatedIn: ()->
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"
      
    params = @domHost.getPageParams()

    @_loadUser()
    @_loadPatient(params['patient'])

    unless params['test']
      @_notifyInvalidTest()
      return

    if params['test'] is 'new'
      @isThatNewTest = true
      @_makeBloodSugar()

    else
      @isThatNewTest  = false
      @_loadBloodSugar(params['test'])

  navigatedOut: ->
    @user = {}
    @patient = {}
    @isTestValid = false
    @isPatientValid = false


    
  

}