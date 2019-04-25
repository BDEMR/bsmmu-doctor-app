
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

    invoiceListOriginal:
      type: Array
      value: []
    
    searchString:
      type: String
      value: ''
      observer: '_filterByPatientOrInstitution'

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

  _calculateTotalFeeBilled: (invoiceList)->
    totalBilled = 0
    for item in invoiceList
      totalBilled += ( parseInt item.data.feeBilledAmount)
    return totalBilled

  _calculateTotalFeePaid: (invoiceList)->
    totalPaid = 0
    for item in invoiceList
      totalPaid += ( parseInt item.data.feePaidAmount)
    return totalPaid
    
  _calculateTotalFeeBalance: (invoiceList)->
    totalRemaining = 0
    for item in invoiceList
      totalRemaining += @$calculateRemaining item.data.feePaidAmount, item.data.feeBilledAmount
    return totalRemaining
    

  
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

  # filterFn: (searchString)->
  #   if !searchString
  #     return null
  #   else
  #     return (item)->
  #       regex = new RegExp "\\b#{searchString}", 'gi'
  #       return true if ((regex.test item.data.nameOfPatient) or (regex.test item.data.nameOfInstitution))


  filterByDateClicked: (e)->
    startDate = new Date e.detail.startDate
    startDate.setHours 0,0,1
    endDate = new Date e.detail.endDate
    endDate.setHours 23,59,59
    @set 'invoiceList', (item for item in @invoiceList when (startDate.getTime() <= (new Date item.lastModifiedDatetimeStamp).getTime() <= endDate.getTime()))
    

  filterByDateClearButtonClicked: (e)->
    @set 'invoiceList', @invoiceListOriginal

  
  _filterByPatientOrInstitution: ()->
    @debounce 'filter-by-string', ()=>
      tempStr = @searchString.trim() unless @searchString is null
      regex = new RegExp "\\b#{tempStr}", 'gi'
      @invoiceList = @invoiceListOriginal.filter (item)->
        return true if ((regex.test item.data.nameOfPatient) or (regex.test item.data.nameOfInstitution))
      console.log 'filtered invoice list ', @invoiceList
    , 500
    

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  showServiceName: (serviceIndex)->
    return @serviceRenderedOptionList[serviceIndex]


}
