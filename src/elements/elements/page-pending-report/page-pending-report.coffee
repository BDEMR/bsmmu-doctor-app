Polymer {

  is: 'page-pending-report'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:
    selectedReportPageIndex:
      type: Number
      notify: true
      value: 0

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

    pendingReport:
      type: Object
      notify: true
      value: null


    

  # Helper
  # ================================
  $findCreator: (creatorSerial)-> 'me'

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()


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

  _compareFn: (left, op, right) ->
    if op is '<'
      return left < right
    if op is '>'
      return left > right
    if op is '=='
      return left == right
    if op is '>='
      return left >= right
    if op is '<='
      return left <= right
    if op is '!='
      return left != right



  _sortByDate: (a, b)->
    if a.date < b.date
      return 1
    if a.date > b.date
      return -1

  _formatDateTime: (dateTime)->
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy')

  _returnSerial: (index)->
    index+1


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  _loadPendingReport: (reportIdentifier)->
    data = {
      apiKey: @user.apiKey
      serial: reportIdentifier
      doctorSerial: @user.serial
    }

    @callApi '/bdemr-get-pending-report', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @pendingReport = response.data.report
        @patient = response.data.patient


  _updateTestResults: ()->
    if @pendingReport.data.flags.hasOwnProperty ('seenByReportedDoctor')
      @pendingReport.data.flags.seenByReportedDoctor = true
    ## or else todo

    @pendingReport.lastModifiedDatetimeStamp = lib.datetime.now()
    data = {
      apiKey: @user.apiKey
      modifiedTestResultObject: @pendingReport
    }

    @callApi '/bdemr-test-result-update-from-pending-reports', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @arrowBackButtonPressed()
        @domHost.showToast "Updated Successfully!"


  _setReportsAvailableToPatient: (e)->
    @pendingReport.availableToPatient = true
    @_updateTestResults()


  flagAsErrorTestResultsItemClicked: ()->
    @pendingReport.data.flags.flagAsError = true
    @_updateTestResults()


  navigatedIn: ->
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"

    params = @domHost.getPageParams()

    @_loadUser()

    if params['serial']
      @_loadPendingReport params['serial']


  navigatedOut: ->
    @pendingReport = {}



      
  

}
