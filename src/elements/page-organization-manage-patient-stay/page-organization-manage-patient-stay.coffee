
Polymer {

  is: 'page-organization-manage-patient-stay'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:

    selectedPageIndex:
      type: Number
      value: -> 0
    
    shouldKeepRefreshingUi:
      type: Boolean
      value: -> false

    shouldShowAdd:
      type: Boolean
      value: -> false

    shouldShowVacant:
      type: Boolean
      value: -> true

    shouldShowOccupied:
      type: Boolean
      value: -> true

    shouldShowOverflow:
      type: Boolean
      value: -> true

    user:
      type: Object
      notify: true
      value: null

    isOrganizationValid: 
      type: Boolean
      notify: true
      value: false

    organization:
      type: Object
      notify: true
      value: null

    level:
      type: String
      value: 'hospital' # 'department' 'unit' 'ward'

    showingLevel:
      type: String
      computed: 'getCurrentLevel(level)'

    patientStayObject:
      type: Object
      value: null

    selectedDepartmentDropdownIndex:
      type: Number
      value: -> 0

    selectedUnitDropdownIndex:
      type: Number
      value: -> 0

    selectedWardDropdownIndex:
      type: Number
      value: -> 0

    selectedDepartmentName:
      type: String
      value: null

    selectedUnitName:
      type: String
      value: null

    locationQueryParameters: 
      type: Object
      value: {}

    selectedWardName:
      type: String
      value: null

    newItemName:
      type: String
      value: ''

    memberSearchResultList:
      type: Array
      value: -> []

    shownLocationList:
      type: Array
      value: -> []

    itemList:
      type: Array
      value: -> []

    listStack:
      type: Array
      value: -> []

    seatList:
      type: Array
      value: -> []

    unitList:
      type: Array
      value: -> []

    wardList:
      type: Array
      value: -> []

    viewSeatItemsClicked:
      type: Boolean
      value: -> false

  observers: [
    'viewSeatsDropdownValueChanged(selectedDepartmentName, selectedUnitName, selectedWardName)'
  ]

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _notifyInvalidOrganization: ->
    @isOrganizationValid = false
    @domHost.showModalDialog 'Invalid Organization Provided'

  runPatientStayLoop: ->
    # console.log 'shouldKeepRefreshingUi', @shouldKeepRefreshingUi
    if @shouldKeepRefreshingUi and (@domHost.page.name is 'organization-manage-patient-stay')
      unless @queryParameters
        @domHost.showToast 'Please select a department for auto refresh.'
      else
        @_loadPatientStayObject =>
          @fillSeats @queryParameters
    lib.util.delay 30000, @runPatientStayLoop

  navigatedIn: ->
    # currentOrganization = @getCurrentOrganization()
    # unless currentOrganization
    #   @domHost.navigateToPage "#/select-organization"
      
    @_loadUser()
    
    params = @domHost.getPageParams()
    if params['organization']
      @_loadOrganization params['organization']
    else
      @_notifyInvalidOrganization()

  navigatedOut: ->
    @organization = null
    @isOrganizationValid = false
    @memberSearchResultList = []
    @itemList = []

  _loadOrganization: (idOnServer)->
    data = { 
      apiKey: @user.apiKey
      idList: [ idOnServer ]
    }
    @callApi '/bdemr-organization-list-organizations-by-ids', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        unless response.data.matchingOrganizationList.length is 1
          @domHost.showModalDialog "Invalid Organization"
          return
        @set 'organization', response.data.matchingOrganizationList[0]
        @_loadPatientStayObject()

  _loadPatientStayObject: (cbfn)->
    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
    }
    @callApi '/bdemr-organization-patient-stay-get-object', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @set 'patientStayObject', response.data.patientStayObject
        @set 'itemList', @patientStayObject.departmentList
        @set 'isOrganizationValid', true
        @set 'seatList', @patientStayObject.seatList
        @patientStayObject.locations = @patientStayObject.locations or []
        console.log @patientStayObject
        
      @runPatientStayLoop = @runPatientStayLoop.bind @
      unless '__runPatientStayLoop__flag' of window
        window.__runPatientStayLoop__flag = true
        @runPatientStayLoop()
      cbfn() if cbfn

  getCurrentLevel: (level)->
    levelMap = 
      'hospital': 'department'
      'department': 'unit'
      'unit': 'ward'
    return levelMap[@level]
  
  upTapped: ->
    itemList = @listStack.pop()
    @set 'itemList', itemList
    previousLevelMap = 
      'department': 'hospital'
      'unit': 'department'
      'ward': 'unit'
    @set 'level', previousLevelMap[@level]
    @shouldShowAdd = false
    

  itemOpenTapped: (e)->
    { item, index } = e.model
    if @level is 'hospital'
      @set 'selectedDepartmentIndex', index
      @set 'selectedDepartmentName', item.name
      @set 'level', 'department'
      @listStack.push @itemList
      @set 'itemList', item.unitList
    else if @level is 'department'
      @set 'selectedUnitIndex', index
      @set 'selectedUnitName', item.name
      @set 'level', 'unit'
      @listStack.push @itemList
      @set 'itemList', item.wardList
    else if @level is 'unit'
      @set 'selectedWardIndex', index
      @set 'selectedWardName', item.name
      @set 'level', 'ward'
      @listStack.push @itemList
      @set 'itemList', []

  itemDeleteTapped: (e)->
    { item, index } = e.model
    @splice 'itemList', index, 1
    if @level is 'hospital'
      matchedList = (index for seat, index in @patientStayObject.seatList when (seat.department is item.name ))
    else if @level is 'department'
      matchedList = (index for seat, index in @patientStayObject.seatList when (seat.department is @selectedDepartmentName and seat.unit is item.name))
    else if @level is 'unit'
      matchedList = (index for seat, index in @patientStayObject.seatList when (seat.department is @selectedDepartmentName and seat.unit is @selectedUnitName and seat.ward is item.name))

    for item in matchedList by -1
      @patientStayObject.seatList.splice item, 1


  addNewItemTapped: (e)->
    return unless @newItemName

    return unless (null for item in @itemList when item.name is @newItemName).length is 0

    listNameMap = 
      'hospital': 'unitList'
      'department': 'wardList'

    item = {
      name: @newItemName
    }
    if @level of listNameMap
      item[listNameMap[@level]] = []

    @push 'itemList', item

    @newItemName = ""

  addNewItemOnEnter: (e)->
    if e.keyCode is 13
      @addNewItemTapped()
  
  itemViewSeatsTapped: (e)->
    { item, index } = e.model
    queryParameters = {
      organizationId: @organization.idOnServer
    }
    if @level is 'hospital'
      queryParameters.department = item.name
      queryParameters.unit = null
      queryParameters.ward = null
    else if @level is 'department'
      queryParameters.department = @selectedDepartmentName
      queryParameters.unit = item.name
      queryParameters.ward = null
    else if @level is 'unit'
      queryParameters.department = @selectedDepartmentName
      queryParameters.unit = @selectedUnitName
      queryParameters.ward = item.name
    @queryParameters = queryParameters
    @fillSeats queryParameters
    @viewSeatItemsClicked = true

  fillSeats: (queryParameters)->
    unless 'seatSeed' of @patientStayObject
      @patientStayObject.seatSeed = 0
    unless 'seatList' of @patientStayObject
      @patientStayObject.seatList = []

    seatList = []
    for seat in @patientStayObject.seatList
      if queryParameters.department
        continue unless queryParameters.department is seat.department
      if queryParameters.unit
        continue unless queryParameters.unit is seat.unit
      if queryParameters.ward
        continue unless queryParameters.ward is seat.ward
      unless 'location' of seat
        seat.location = 'Nil'
      seatList.push seat

    @set 'seatList', []
    @set 'seatList', seatList

  saveTapped: (e)->
    for seat in @seatList
      matchedList = (index for seat2, index in @patientStayObject.seatList when seat2.uid is seat.uid)
      if matchedList.length is 1
        @patientStayObject.seatList.splice matchedList[0], 1, seat
      else
        @patientStayObject.seatList.push seat

    data = { 
      apiKey: @user.apiKey
      organizationId: @organization.idOnServer
      patientStayObject: @patientStayObject
    }
    @callApi '/bdemr-organization-patient-stay-set-object', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        @domHost.showToast 'Saved'

  addTapped: (e)->
    return unless @level is 'unit'
    
    { item, index } = e.model
    queryParameters = {
      organizationId: @organization.idOnServer
    }
    queryParameters.department = @selectedDepartmentName
    queryParameters.unit = @selectedUnitName
    queryParameters.ward = item.name

    seat = lib.util.deepCopy queryParameters
    seat.patientSerial = null
    seat.name = "Seat #{@seatList.length+1}"
    if !@patientStayObject.seatSeed
      @patientStayObject.seatSeed = 0
    seat.uid = (@patientStayObject.seatSeed++)
    seat.isOverflow = false
    @viewSeatItemsClicked = true
    @unshift 'seatList', seat

  seatDeleteTapped: (e)->
    { index } = e.model
    @splice 'seatList', index, 1

  _seatStatus: (patientSerial)->
    if patientSerial
      return "Occupied by #{patientSerial}"
    else
      return "Vacant"

  seatVacantTapped: (e)->
    { seat, index } = e.model
    e.model.set 'seat.patientSerial', ''
    e.model.set 'seat.location', ''

  seatAssignTapped: (e)->
    { seat, index } = e.model
    @domHost.showModalInput 'Patient Serial?', '', (answer)=>
      # TODO, check if patient exist with that serial number 
      if answer
        e.model.set 'seat.patientSerial', answer

  $_shouldHideBecauseOfLocation: (shownLocationList, location)->
    # console.log location, shownLocationList
    if shownLocationList.length is 0
      return false
    else
      return true unless location
      unless location in shownLocationList
        return true
      return false

  $shouldHide: (patientSerial, shouldShowVacant, shouldShowOccupied, shouldShowOverflow, isOverflow, shownLocationList, shownLocationListLength, location)->
    # console.log '$shouldHide'
    if patientSerial
      if @$_shouldHideBecauseOfLocation(shownLocationList, location)
        return true
    if patientSerial and shouldShowOccupied
      return false
    if (not patientSerial) and shouldShowVacant
      return false
    if isOverflow and shouldShowOverflow
      return false
    return true

  $countSeatList: (seatList, type, seatListLength, shownLocationList, shownLocationListLength)->
    # console.log '$countSeatList'
    resultList = []
    @seatList2 = []
    for seat in @seatList
      # console.log '??', shownLocationList, seat.location
      unless @$_shouldHideBecauseOfLocation(shownLocationList, seat.location)
        @seatList2.push seat
    if type is 'vacant'
      for seat in @seatList2
        if not seat.patientSerial
          resultList.push seat
    else if type is 'occupied'
      for seat in @seatList2
        if seat.patientSerial
          resultList.push seat
    else if type is 'overflow'
      for seat in @seatList2
        if seat.isOverflow
          resultList.push seat
    return resultList.length

  locationCheckboxTapped: (e)->
    checked = Polymer.dom(e).localTarget.checked
    location = (Polymer.dom(e).localTarget.getAttribute 'data-loc')
    if checked
      @push 'shownLocationList', location
    else
      if (index = @shownLocationList.indexOf location) > -1
        @splice 'shownLocationList', index, 1

    seatList = (item for item in @patientStayObject.seatList when item.location in @shownLocationList)
    @set 'seatList', seatList
    @$$(".seat-list").fire('iron-resize')
    
    unless @shownLocationList.length
      @async ()-> 
        @set 'seatList', @patientStayObject.seatList
        @$$(".seat-list").fire('iron-resize')

 
  saveButtonPressed: ->
    @saveTapped()


  viewSeatsDropdownValueChanged: (depName, unitName, wardName)->
    return unless @organization
    
    unless depName
      @set 'seatList', @patientStayObject.seatList
      return
    
    queryParameters = {
      organizationId: @organization.idOnServer
    }
    queryParameters.department = depName
    queryParameters.unit = unitName
    queryParameters.ward = wardName
    @fillSeats queryParameters
  
  
  departmentDropdownValueChanged: ->
    if @selectedDepartmentDropdownIndex >= 1
      selectedDepartment = @patientStayObject.departmentList[@selectedDepartmentDropdownIndex-1]
      @set 'selectedDepartmentName', selectedDepartment.name
      @set 'selectedUnitName', null
      @set 'selectedWardName', null
      @set 'selectedUnitDropdownIndex', 0
      @set 'selectedWardDropdownIndex', 0
      unitList = selectedDepartment.unitList
    else
      @set 'selectedDepartmentName', null
      @set 'selectedUnitName', null
      @set 'selectedWardName', null
      unitList = []
    @set 'unitList', unitList

  unitDropdownValueChanged: ->
    if @selectedUnitDropdownIndex >= 1
      selectedUnit = @unitList[@selectedUnitDropdownIndex-1]
      @set 'selectedUnitName', selectedUnit.name
      @set 'selectedWardName', null
      @set 'selectedWardDropdownIndex', 0
      wardList = selectedUnit.wardList
    else
      wardList = []
    
    @set 'wardList', wardList

  wardDropdownValueChanged: ->
    if @selectedWardDropdownIndex >= 1
      selectedWard = @wardList[@selectedWardDropdownIndex-1]
      @set 'selectedWardName', selectedWard.name

  # Add Custom Location
  # =======================================
  
  addLocation: (e)->
    if e.which is 13
      return unless @location
      @push 'patientStayObject.locations', @location
      @location = ""
      @saveTapped()

  
  
  # =======================================
  
  gotoAddSeatsPage: ->
    @set 'selectedPageIndex', 1

  gotoViewSeatsPage: ->
    @set 'selectedPageIndex', 0

  gotoAddLocationsPage: ->
    @set 'selectedPageIndex', 2

  sortBySeatIndex: (a, b)->
    return b.uid - a.uid
      
}
