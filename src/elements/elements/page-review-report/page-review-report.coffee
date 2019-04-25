Polymer {

  is: 'page-review-report'

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

    reviewReport:
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
    @domHost.navigateToPage '#/reports-manager/selected:1'


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

  _loadReviewReport: (reportIdentifier)->
    data = {
      apiKey: @user.apiKey
      serial: reportIdentifier
      doctorSerial: @user.serial
    }

    @callApi '/bdemr-get-review-report', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @reviewReport = {}
        @patient = {}
        @reviewReport = response.data.report
        @patient = response.data.patient



  _updateTestResults: ()->
    data = {
      apiKey: @user.apiKey
      modifiedTestResultObject: @reviewReport
    }

    @callApi '/bdemr-test-result-update-from-pending-reports', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @arrowBackButtonPressed()
        @domHost.showToast "Updated Successfully!"


  seenByAdvisedDoctor: (e)->
    @reviewReport.data.flags.seenByAdvisedDoctor = true
    @_updateTestResults()


  flagAsErrorTestResultsItemClicked: ()->
    @reviewReport.data.flags.seenByAdvisedDoctor = true
    @reviewReport.data.flags.flagAsError = true
    @_updateTestResults()


  navigatedIn: ->
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"
      

    params = @domHost.getPageParams()

    @_loadUser()

    if params['serial']
      @_loadReviewReport params['serial']


  navigatedOut: ->
    @reviewReport = {}



      
  

}
