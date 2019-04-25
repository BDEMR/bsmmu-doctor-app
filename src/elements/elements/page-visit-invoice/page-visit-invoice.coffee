
Polymer {

  is: 'page-visit-invoice'

  behaviors: [ 
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
  ]

  $isLast: (list, index)-> index is (list.length - 1)

  $toReadbleStatus: (status)-> @possiblePaymentStatusses[status]

  _calculateRemaining: (feePaidAmount, feeBilledAmount)->
    remainingAmount = (parseInt feeBilledAmount) - (parseInt feePaidAmount)
    if remainingAmount < 0 then return 0 else return remainingAmount

  possiblePaymentStatusses:
    notBilled: 'Not Billed'
    unpaid: 'Unpaid'
    partiallyPaid: 'Partially Paid'
    fullyPaid: 'Fully Paid'

  properties:
    invoice:
      type: Object

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

    organization:
      type: Object
      value: null

    feePaidByOptionList:
      type: Array
      value: ->  [ 'Hospital/Clinic' , 'Surgeon', 'Patient', 'Insurance', 'Custom' ]

    serviceRenderedOptionList: 
      type: Array
      value: -> [ 'Doctor Visit', '2nd Visit', 'Online Phone Consultation', 'In Patient (Hospital/Clinic Visits)', 'Report Assessment', 'Custom' ]

    sourceOfPatientOptionList: 
      type: Array
      value: -> [ 'Hospital/Clinic', 'Surgeon', 'Insurance', 'Custom' ]
    
    feeRemainingAmount:
      type: Number
      value: 0

  observers: [
    'ComputePaymentStatus(invoice.data.isCleared, invoice.data.feeBilledAmount, invoice.data.feePaidAmount)'

  ]

  ComputePaymentStatus: (isCleared, feeBilledAmount, feePaidAmount)->
    
    feeBilledAmount = (parseInt feeBilledAmount) or 0
    feePaidAmount = (parseInt feePaidAmount) or 0
    if isCleared
      @feeRemainingAmount = 0
    else
      @feeRemainingAmount = @_calculateRemaining feePaidAmount, feeBilledAmount

    if feeBilledAmount is 0
      @set 'invoice.data.paymentStatus', 'notBilled'
    else if feeBilledAmount <= feePaidAmount
      @set 'invoice.data.paymentStatus', 'fullyPaid'
    else 
      if feePaidAmount is 0
        @set 'invoice.data.paymentStatus', 'unpaid'
      else
        @set 'invoice.data.paymentStatus', 'partiallyPaid'
    


  navigatedIn: ->
    @organization = @getCurrentOrganization()
    unless @organization
      @domHost.navigateToPage "#/select-organization"
      
    @_loadUser()

    params = @domHost.getPageParams()

    unless params['visit']
      @_notifyInvalidVisit()
      return
    else
      @_loadVisit(params['visit'])

    unless params['patient']
      @_notifyInvalidPatient()
      return
    else
      @_loadPatient(params['patient'])
    
    if params['invoice'] is 'new'
      @_makeNewInvoice()
    else
      @_loadInvoice(params['invoice'])


  _makeNewInvoice: ->
    @invoice =
      serial: @generateSerialForinvoice()
      lastModifiedDatetimeStamp: 0
      createdDatetimeStamp: lib.datetime.now()
      lastSyncedDatetimeStamp: 0
      createdByUserSerial: @user.serial
      visitSerial: @visit.serial
      patientSerial: @patient.serial
      doctorName: @$getFullName(@user.name)
      doctorSpeciality: @getDoctorSpeciality()
      organizationId: @organization.idOnServer
      data:
        nameOfInstitution: @organization.name
        nameOfPatient: @$getFullName(@patient.name)
        billingPersonsName: @$getFullName(@user.name)
        serviceRenderedSelectedIndex: 0
        customServiceRendered: ''
        sourceOfPatientSelectedIndex: 0
        customSourceOfPatient: ''
        datePerformed: lib.datetime.mkDate lib.datetime.now()
        dateDue: lib.datetime.mkDate lib.datetime.now()
        timeFrom: lib.datetime.mkTime lib.datetime.now()
        timeTo: lib.datetime.mkTime lib.datetime.now()
        isCleared: false
        paymentStatus: 'notBilled'
        feeBilledAmount: 0
        isThereAnyPaymentMade: false
        feePaidAmount: 0
        feePaidOn: lib.datetime.mkDate lib.datetime.now()
        feePaidBySelectedIndex: 0
        comments: ''
    

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
  
  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  _loadInvoice: (invoiceIdentifier)->
    list = app.db.find 'visit-invoice', ({serial})-> serial is invoiceIdentifier
    if list.length is 1
      @invoice = list[0]
      return true
    else
      @_notifyInvalidInvoice()
      return false

  _loadVisit: (visitIdentifier)->
    list = app.db.find 'doctor-visit', ({serial})-> serial is visitIdentifier
    if list.length is 1
      @visit = list[0]
      return true
    else
      @_notifyInvalidVisit()
      return false
  
  _notifyInvalidPatient: ->
    @domHost.showModalDialog 'Invalid Patient Provided'

  _notifyInvalidInvoice: ->
    @domHost.showModalDialog 'Invalid Invoice Provided'

  _notifyInvalidVisit: ->
    @domHost.showModalDialog 'Invalid Visit Provided'


  getDoctorSpeciality: () ->
    unless @user.specializationList.length is 0
      return @user.specializationList[0].specializationTitle
    return 'not provided yet'
  
  _updateVisit: (invoiceSerial)->
    if @visit.invoiceSerial is null
      @visit.invoiceSerial = invoiceSerial
    @visit.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'doctor-visit', @visit, ({serial})=> @visit.serial is serial
  
  _saveInvoice: ->
    @invoice.lastModifiedDatetimeStamp = lib.datetime.now()
    @_updateVisit @invoice.serial
    app.db.upsert 'visit-invoice', @invoice, ({serial})=> @invoice.serial is serial

    console.log 'invoice', @invoice
  
  
  # BUTTON EVENTS -------------------->

  _getService: (e)->
    @invoice.data.serviceRenderedSelectedIndex = e.target.selected
  
  savePressed: (e)->
    @_saveInvoice()
    @domHost.showToast 'Invoice Saved'
    @arrowBackButtonPressed()

  printPressed: (e)->
    @_saveInvoice()
    params = @domHost.getPageParams()
    if params['visit-invoice'] != 'new'
      @domHost.navigateToPage '#/print-invoice/visit:' + @visit.serial + '/patient:' + @patient.serial + '/invoice:' + @invoice.serial
    

  sendtoPatientPressed: (e)->
    @_saveInvoice()
    @domHost._syncOnlyInvoice ()=>
      @_sendNotification 'A New Invoice Has been issued to you', @patient.idOnServer
      @domHost.showToast 'Saved & Sent to Patient'

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  
  _sendNotification: (message, targetId)->
    user = @getCurrentUser()
    request = {
      operation: 'notify-single'
      apiKey: user.apiKey
      notificationCategory: 'general'
      notificationMessage: message
      notificationTargetId: targetId
      sender: user.name
    }
    @domHost.ws.send JSON.stringify request


}
