Polymer {

  is: 'page-reports-manager'

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

    selectedPendingReportsPage:
      type: Number
      notify: true
      value: 0

    selectedReviewReportsPage:
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

    unseenPendingReportsList:
      type: Array
      notify: true
      value: -> []

    unseenReviewReportsList:
      type: Array
      notify: true
      value: -> []

    seenPendingReportsList:
      type: Array
      notify: true
      value: -> []

    seenReviewReportsList:
      type: Array
      notify: true
      value: -> []

    reportCounter:
      type: Object
      notify: true
      value: -> {
        unseenPendingReportCounter: 0
        seenPendingReportCounter: 0
        unseenReviewReportCounter: 0
        seenReviewReportCounter: 0
      }
    

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


  _updatePendingReportsData: (object)->
    data = {
      apiKey: @user.apiKey
      serial: object.serial
      availableToPatient: object.availableToPatient
      flagAsError: object.data.flags.flagAsError
    }

    @callApi '/bdemr-test-result-update', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        if response.message is 'Updated'
          return response.message

  _getUnseenPendingReportsList:()->
    data = {
      userIdentifier: @user.serial
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-unseen-pending-reports-list', data, (err, response)=>
      console.log 'UNSEEN PENDING REPORTS LIST:', response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @unseenPendingReportsList = []
        @unseenPendingReportsList = response.data
        @set 'reportCounter.unseenReviewReportCounter', response.data.length

        ## Sorting Data by createdDatetimeStamp
        @unseenPendingReportsList.sort (left, right)->
          return -1 if left.createdDateTimeStamp > right.createdDateTimeStamp
          return 1 if left.createdDateTimeStamp < right.createdDateTimeStamp
          return 0

  _getSeenPendingReportsList:()->
    data = {
      userIdentifier: @user.serial
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-seen-pending-reports-list', data, (err, response)=>
      console.log 'SEEN PENDING REPORTS LIST:', response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @seenPendingReportsList = []
        @seenPendingReportsList = response.data
        @set 'reportCounter.seenPendingReportCounter', response.data.length

        ## Sorting Data by createdDatetimeStamp
        @seenPendingReportsList.sort (left, right)->
          return -1 if left.createdDateTimeStamp > right.createdDateTimeStamp
          return 1 if left.createdDateTimeStamp < right.createdDateTimeStamp
          return 0

  _getUnseenReviewReportsList:()->
    data = {
      userIdentifier: @user.serial
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-unseen-review-reports-list', data, (err, response)=>
      console.log 'UNSEEN REVIEW REPORTS LIST:', response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @unseenReviewReportsList = []
        @unseenReviewReportsList = response.data
        @set 'reportCounter.unseenReviewReportCounter', response.data.length

        ## Sorting Data by createdDatetimeStamp
        @unseenReviewReportsList.sort (left, right)->
          return -1 if left.createdDateTimeStamp > right.createdDateTimeStamp
          return 1 if left.createdDateTimeStamp < right.createdDateTimeStamp
          return 0

  _getSeenReviewReportsList:()->
    data = {
      userIdentifier: @user.serial
      apiKey: @user.apiKey
    }
    @callApi '/bdemr-seen-review-reports-list', data, (err, response)=>
      console.log 'SEEN REVIEW REPORTS LIST:', response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @seenReviewReportsList = []
        @seenReviewReportsList = response.data
        @set 'reportCounter.seenReviewReportCounter', response.data.length

        ## Sorting Data by createdDatetimeStamp
        @seenReviewReportsList.sort (left, right)->
          return -1 if left.createdDateTimeStamp > right.createdDateTimeStamp
          return 1 if left.createdDateTimeStamp < right.createdDateTimeStamp
          return 0

  


  _setReportsAvailableToPatient: (e)->

    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#pending-reports-list-repeater'

    index = repeater.indexForElement el

    report = @matchingPendingReportsList[index]

    report.availableToPatient = true
    @splice 'matchingPendingReportsList', index, 1

    ## Update Pending Reports
    message = @_updatePendingReportsData report
    if message is 'Updated'
      @domHost.showToast "Results Now Available For Patient!"

  flagAsErrorTestResultsItemClicked: (e)->
    el = @locateParentNode e.target, 'PAPER-ITEM'
    el.opened = false
    repeater = @$$ '#pending-reports-list-repeater'

    index = repeater.indexForElement el
    report = @matchingPendingReportsList[index]

    report.data.flags.flagAsError = true

    @set 'matchingPendingReportsList.#{index}.data.flags.flagAsError', true

    ## Update Pending Reports
    message = @_updatePendingReportsData report

    if message is 'Updated'
      @domHost.showToast "Flagged Successfully!"
      window.location.reload()

  viewPendingReport: (e)->
    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#pending-reports-list-repeater'

    index = repeater.indexForElement el
    report = @unseenPendingReportsList[index]

    @domHost.navigateToPage '#/pending-report/serial:' + report.reportSerial

  viewReviewReport: (e)->
    el = @locateParentNode e.target, 'PAPER-BUTTON'
    el.opened = false
    repeater = @$$ '#review-reports-list-repeater'

    index = repeater.indexForElement el
    report = @unseenReviewReportsList[index]

    @domHost.navigateToPage '#/review-report/serial:' + report.reportSerial


  _selectedPendingReportsPageChanged: ()->
    if @selectedPendingReportsPage is 0
      @_getUnseenPendingReportsList()

    if @selectedPendingReportsPage is 1
      @_getSeenPendingReportsList()

  _selectedReviewReportsPageChanged: ()->
    if @selectedReviewReportsPage is 0
      @_getUnseenReviewReportsList()

    if @selectedReviewReportsPage is 1
      @_getSeenReviewReportsList()


  navigatedIn: ->

    @_loadUser()

    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"

    params = @domHost.getPageParams()

    # Set Main paper-tabs Index to 0
    @selectedReportPageIndex = 0

    if params['selected'] is "1"
      @set 'selectedReportPageIndex', 1

    @domHost._syncOnlyPatientTestResults ()=>

      @_getUnseenPendingReportsList()
      @_getSeenPendingReportsList()

      @_getUnseenReviewReportsList()
      @_getSeenReviewReportsList()


  navigatedOut: ->
    @patient = null
    @isPatientValid = false


      
  

}
