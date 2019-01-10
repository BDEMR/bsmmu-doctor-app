
Polymer {

  is: 'page-print-invoice'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
  ]

  properties:

    isVisitValid: 
      type: Boolean
      notify: false
      value: false

    isPatientValid:
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

    invoice:
      type: Object
      notify: true
      value: null

    settings:
      type: Object
      notify: true

    feePaidByOptionList:
      type: Array
      value: ->  [ 'Hospital/Clinic' , 'Surgeon', 'Patient', 'Insurance', 'Custom' ]

    serviceRenderedOptionList: 
      type: Array
      value: -> [ 'Doctor Visit', '2nd Visit', 'Online Phone Consultation', 'In Patient (Hospital/Clinic Visits)', 'Report Assessment', 'Custom' ]

    sourceOfPatientOptionList: 
      type: Array
      value: -> [ 'Hospital/Clinic', 'Surgeon', 'Insurance', 'Custom' ]

  ## SETTINGS ======================================================================================

  _loadSettings: (cbfn)->
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()
    @settings = list[0]
    cbfn()


  
  
  _loadUser:()->
    userList = app.db.find 'user'
    # console.log userList
    if userList.length is 1
      @user = userList[0]

      # for employmentDetails in userList[0].employmentDetailsList
      #   @push 'doctorInstitutionList', employmentDetails.institutionName

      # for specializationDetails in userList[0].specializationList
      #   @push 'doctorSpecialityList', specializationDetails.specializationTitle


  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  $of: (a, b)->
    unless b of a
      a[b] = null
    return a[b]


  printButtonPressed: (e)->
    window.print()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'

  _notifyInvalidVisit: ->
    @isVisitValid = false
    @domHost.showModalDialog 'Invalid Visit Provided'

  _loadVisit: (visitIdentifier)->
    list = app.db.find 'doctor-visit', ({serial})-> serial is visitIdentifier
    if list.length is 1
      @isVisitValid = true
      @visit = list[0]
    else
      @_notifyInvalidVisit()
      return false

  _loadInvoice: (invoiceIdentifier)->
    list = app.db.find 'visit-invoice', ({serial})-> serial is invoiceIdentifier
    if list.length is 1
      @invoice = list[0]
      return true
    else
      @_notifyInvalidInvoice()
      return false

  _notifyInvalidInvoice: ->
    @domHost.showModalDialog 'Invalid Invoice Provided'

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

  _computeTotalDaysCount: (endDateTimeStamp, startDateTimeStamp)->
    oneDay = 1000*60*60*24;
    diffMs = endDateTimeStamp - startDateTimeStamp
    return Math.round(diffMs/oneDay); 

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

  navigatedIn: ->

    @_loadUser()

    @_loadSettings =>

      params = @domHost.getPageParams()

      unless params['visit']
        @_notifyInvalidVisit()
        return

      unless params['patient']
        @_notifyInvalidPatient()
        return
      else
        @_loadPatient(params['patient'])

      @_loadVisit(params['visit'])

      @_loadInvoice(params['invoice'])


  navigatedOut: ->
    @visit = {}
    @patient = {}
    @invoice = {}
    @isVisitValid = false
    @isPatientValid = false

  _formatDateTime: (dateTime)->
    lib.datetime.format(dateTime, 'mmm d, yyyy h:MMTT')

  _formatDate: (dateTime)->
    lib.datetime.format(dateTime, 'mmm d, yyyy')

  
  $fromListOrCustom: (list, index, custom)->
    if index is list.length - 1
      return custom
    else
      return list[index]

  possiblePaymentStatusses:
    notBilled: 'Not Billed'
    unpaid: 'Unpaid'
    partiallyPaid: 'Partially Paid'
    fullyPaid: 'Fully Paid'

  $toReadbleStatus: (status)-> @possiblePaymentStatusses[status]

  $calculateRemaining: (feePaidAmount, feeBilledAmount, isCleared)->
    return if isCleared
    return (parseInt feeBilledAmount) - (parseInt feePaidAmount)

}
