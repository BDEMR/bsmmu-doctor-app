
Polymer {

  is: 'page-invoice-manager'

  behaviors: [ 
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  possiblePaymentStatusses:
    notBilled: 'Not Billed'
    unpaid: 'Unpaid'
    partiallyPaid: 'Partially Paid'
    fullyPaid: 'Fully Paid'

  properties:
    invoiceList:
      type: Array
      value: []

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

    feePaidByOptionList:
      type: Array
      value: ->  [ 'Hospital/Clinic' , 'Surgeon', 'Patient', 'Insurance', 'Custom' ]

    serviceRenderedOptionList: 
      type: Array
      value: -> [ 'Doctor Visit', '2nd Visit', 'Online Phone Consultation', 'In Patient (Hospital/Clinic Visits)', 'Report Assessment', 'Custom' ]

    sourceOfPatientOptionList: 
      type: Array
      value: -> [ 'Hospital/Clinic', 'Surgeon', 'Insurance', 'Custom' ]

    possiblePaymentStatusses:
      any: 'Any'
      notBilled: 'Not Billed'
      unpaid: 'Unpaid'
      partiallyPaid: 'Partially Paid'
      fullyPaid: 'Fully Paid'

  observers: [
    'ComputePaymentStatus(invoice.data.isCleared, invoice.data.feeBilledAmount, invoice.data.feePaidAmount)'
  ]

  $toReadbleStatus: (status)-> @possiblePaymentStatusses[status]

  $calculateRemaining: (feePaidAmount, feeBilledAmount)->
    return (parseInt feeBilledAmount) - (parseInt feePaidAmount)
  
  ComputePaymentStatus: (isCleared, feeBilledAmount, feePaidAmount)->
    feeBilledAmount = (parseInt feeBilledAmount) or 0
    feePaidAmount = (parseInt feePaidAmount) or 0
    if isCleared or feeBilledAmount < feePaidAmount
      @set 'invoice.data.paymentStatus', 'fullyPaid'
    else if feeBilledAmount is 0
      @set 'invoice.data.paymentStatus', 'notBilled'
    else 
      if feePaidAmount is 0
        @set 'invoice.data.paymentStatus', 'unpaid'
      else
        @set 'invoice.data.paymentStatus', 'partiallyPaid'

  
  navigatedIn: ->
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"
      
    @_loadUser()

    @_loadInvoices @user.serial

  
  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]
  
   _loadInvoices: (invoiceIdentifier)->
    @invoiceListOriginal = app.db.find 'visit-invoice', ({createdByUserSerial})-> createdByUserSerial is invoiceIdentifier
    console.log @invoiceListOriginal
    @set 'invoiceList', @invoiceListOriginal
    
  _notifyInvalidPatient: ->
    @domHost.showModalDialog 'Invalid Patient Provided'

  _notifyInvalidInvoice: ->
    @domHost.showModalDialog 'Invalid Invoice Provided'


  $calculateRemaining: (feePaidAmount, feeBilledAmount)->
    return (parseInt feeBilledAmount) - (parseInt feePaidAmount)

  filterFn: (searchString)->
    if !searchString
      return null
    else
      return (item)->
        regex = new RegExp "\\b#{searchString}", 'gi'
        return true if ((regex.test item.data.nameOfPatient) or (regex.test item.data.nameOfInstitution))


  filterByDateClicked: (e)->
    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    @invoiceList = (item for item in @invoiceListOriginal when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    

  filterByDateClearButtonClicked: (e)->
    @set 'invoiceList', @invoiceListOriginal
    

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  showServiceName: (serviceIndex)->
    return @serviceRenderedOptionList[serviceIndex]


}
