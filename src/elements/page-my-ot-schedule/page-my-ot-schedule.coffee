
Polymer {
  
  is: 'page-my-ot-schedule'

  behaviors: [ 
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
    app.behaviors.commonComputes
    app.behaviors.dbUsing
  ]

  properties:

    otManagementList:
      type: Array
      value: ()-> []

    filteredOtManagementList:
      type: Array
      value: ()-> []

    matchingOtManagementList:
      type: Array
      value: ()-> []

    user:
      type: Object
      notify: true
      value: null

    organization:
      type: Object
      notify: true
      value: null
      

  navigatedIn: ->
    @_loadUser()
    @organization = @getCurrentOrganization()
    @loadOtManagementList()

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  loadOtManagementList: ()->
    userId = @user.idOnServer
    @otManagementList = app.db.find 'ot-management'
    console.log @otManagementList
    @filteredOtManagementList = @otManagementList.filter (item)-> (item.data.anaesthesist.id is userId) or (item.data.assistantSurgeon1.id is userId) or (item.data.assistantSurgeon2.id is userId) or (item.data.assistantSurgeon3.id is userId) or (item.data.surgeon.id is userId) 
    @filteredOtManagementList.sort (a, b)-> b.data.operationDate - a.data.operationDate
    console.log 'Yes Id Matched', @filteredOtManagementList

  ### Search System ###

  filterByDateClicked: (e)->
    startDate = new Date e.detail.startDate
    startDate.setHours(0,0,0,0)
    endDate = new Date e.detail.endDate
    endDate.setHours(23,59,59,999)
    @set 'dateCreatedFrom', (startDate.getTime())
    @set 'dateCreatedTo', (endDate.getTime())

  filterByDateClearButtonClicked: ->
    @dateCreatedFrom = 0
    @dateCreatedTo = 0
  
  searchButtonClicked: ()->
    searchParameters = {
      dateCreatedFrom: @dateCreatedFrom?=""
      dateCreatedTo: @dateCreatedTo?=""
      searchString: @searchString.toLowerCase()
    }    

    matchingOtManagementList = @filteredOtManagementList.filter (item)=>
      return (if searchParameters.dateCreatedFrom and searchParameters.dateCreatedTo then searchParameters.dateCreatedFrom <= item.data.operationDate <= searchParameters.dateCreatedTo else true) and (if searchParameters.searchString then item.data.nameOfTheInstitution.toLowerCase().indexOf(searchParameters.searchString.toLowerCase()) > -1 else true)

    console.log {matchingOtManagementList}
    @set 'matchingOtManagementList', matchingOtManagementList

  resetButtonClicked: (e)->
    window.location.reload()      
}
