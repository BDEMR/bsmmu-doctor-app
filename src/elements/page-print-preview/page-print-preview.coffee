

Polymer {

  is: 'page-print-preview'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
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
    @settings = @_getSettings() 

    if params['patient']
      @_loadPatient params['patient']
    else
      @_notifyInvalidPatient()


    # if params['anaesmon-record']
    # if params['both-medicine']
    # if params['current-medicine']
    # if params['diagnosis']
    # if params['doctor-note']
    # if params['full-visit']
    # if params['history-physical']
    # if params['invoice']
    # if params['next-visit']
    # if params['old-medicine']
    # if params['patient-stay']
    # if params['test-advised']
    # if params['blood-sugar']
    # if params['other-test']
    # if params['test-results']
    # if params['bmi']
    # if params['bp']
    # if params['pr']
    # if params['rr']
    # if params['spo2']

   
         

  navigatedOut: ->
    @patient = null
    @isPatientValid = false
   
    @patient = null

  

  ready: ()->


}
