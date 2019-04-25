
Polymer {

  is: 'page-internal'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:

    user:
      type: Object
      notify: true
      value: null

    searchParameters:
      type: Object
      notify: true
      value: -> {
        searchString: ''
        offset: 0
        limit: 10
        role: ''
        fromDate: '2017-12-01', 
        toDate:  '2017-12-31'
      }

    userList:
      type: Array
      value: -> []

  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _sampleApi: (data)->
    data = { 
      apiKey: @user.apiKey
      organizationId: organizationIdentifier
    }
    @callApi '/bdemr-organization-patient-stay-get-object', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        departmentList = response.data.patientStayObject.departmentList
        seatList = response.data.patientStayObject.seatList
        @set 'departmentList', @_modifyList departmentList, seatList

        console.log 'departmentList', @departmentList

  $stringify: (object)-> 
    newObject = {}
    for key, value of object
      unless key in ['profileImageData', 'nidScanCopyImageFrontImageData', 'nidScanCopyImageBackImageData']
        newObject[key] = value
    json = JSON.stringify(newObject, null, 2)
    return json
        
  navigatedIn: ->     
    @_loadUser()
    lib.util.delay 300, => this.searchTapped(null)
    
  navigatedOut: ->
    null

  _searchUsers: (cbfn)->
    data = { 
      apiKey: @user.apiKey
    }
    Object.assign(data, this.searchParameters)
    @callApi '/internal-search-users', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn(response.data.userList)

  _getImageData: (imageId, cbfn)->
    data = { 
      apiKey: @user.apiKey
      imageId
    }
    @callApi '/get-image-data-raw', data, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn(response.data.imageData)

  _getUserImages: (user, cbfn)->
    data = {}
    promiseList = []

    if user.profileImage and user.profileImage.length > 2
      promise = new Promise (accept, reject)=>
        this._getImageData user.profileImage, (profileImageData)=>
          data.profileImageData = profileImageData
          accept()
      promiseList.push promise
    
    if user.nidScanCopyImageFront and user.nidScanCopyImageFront.length > 2
      promise = new Promise (accept, reject)=>
        this._getImageData user.nidScanCopyImageFront, (nidScanCopyImageFrontImageData)=>
          data.nidScanCopyImageFrontImageData = nidScanCopyImageFrontImageData
          accept()
      promiseList.push promise

    if user.nidScanCopyImageBack and user.nidScanCopyImageBack.length > 2
      promise = new Promise (accept, reject)=>
        this._getImageData user.nidScanCopyImageBack, (nidScanCopyImageBackImageData)=>
          data.nidScanCopyImageBackImageData = nidScanCopyImageBackImageData
          accept()
      promiseList.push promise
    
    Promise.all(promiseList).then =>
      cbfn(data)

  searchTapped: (e = null)->
    this._searchUsers (userList)=>
      this.userList = []
      
      promiseList = userList.map (user)=>
        return new Promise (accept, reject)=>
          this._getUserImages user, (data)=>
            Object.assign(user, data)
            accept()
      Promise.all(promiseList)
      .then ()=>
        this.userList = userList
        # console.log('userList', userList)

}
