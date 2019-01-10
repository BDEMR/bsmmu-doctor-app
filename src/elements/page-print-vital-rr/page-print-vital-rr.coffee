
Polymer {

  is: 'page-print-vital-rr'

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


    matchingVitalRespiratoryRateList:
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
    @set 'selectedVitalPage', 0
    
    
    if params['patient']
      @_loadPatient params['patient']
    else
      @_notifyInvalidPatient()

    @_listVitalRespiratoryRate(params['patient'])

    @settings = @_getSettings()   
      

  navigatedOut: ->
    @patient = null
    @isPatientValid = false
    
    @matchingVitalRespiratoryRateList = []

    @patient = null



  # Vital - Respiratory Rate [START]
  # ================================
  _listVitalRespiratoryRate: (patientIdentifier) ->
    vitalRespiratoryRateList = app.db.find 'patient-vitals-respiratory-rate', ({patientSerial})=> @patient.serial is patientSerial

    vitalList = [].concat vitalRespiratoryRateList
    vitalList.sort (left, right)->
      return -1 if left.createdDatetimeStamp > right.createdDatetimeStamp
      return 1 if left.createdDatetimeStamp < right.createdDatetimeStamp
      return 0

    for vital in vitalList
      vital.flags = 
        isLocalOnly: true

    @matchingVitalRespiratoryRateList = vitalList

    params = @domHost.getPageParams()

    if params['startDate'] isnt 'null' and params['startDate'] isnt 'undefined' and params['endDate'] isnt 'null' and params['endDate'] isnt 'undefined'
      startDate = new Date params['startDate']
      endDate = new Date params['endDate']

      endDate.setHours 24 + endDate.getHours()
      filterdBPList = (item for item in @matchingVitalRespiratoryRateList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
      @matchingVitalRespiratoryRateList = filterdBPList



  ready: ()->


}
