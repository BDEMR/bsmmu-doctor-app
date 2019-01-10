dataURItoBlob = (dataURI) ->
  byteString = atob(dataURI.split(',')[1])
  mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
  ab = new ArrayBuffer(byteString.length)
  ia = new Uint8Array(ab)
  i = 0
  while i < byteString.length
    ia[i] = byteString.charCodeAt(i)
    i++
  blob = new Blob([ ab ], type: mimeString)
  blob

Polymer {
  is: "page-test-other-editor"
  
  behaviors: [
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
  ]
  
  properties:
    selectedTestViewIndex:
      type: Number
      notify: true
      value: 0

    user:
      type: Object
      notify: true
      value: {}

    patient:
      type: Object
      notify: true
      value: {}

    isPatientValid:
      type: Boolean
      notify: false
      value: true 

    isThatNewTest:
      type: Boolean
      notify: false
      value: true

    otherTest:
      type: Object
      notify: true
      value: {}


    currentDate:
      type: String
      value: ()->
        return lib.datetime.mkDate new Date


    ## Attachment - start -

    attachmentList:
      type: Array
      notify: false
      value: -> []

    newAttachment:
      type: Object
      notify: false
      value: null

    localDataUriDb:
      type: Object
      value: null

    maximumImageSizeAllowedInBytes: 
      type: Number
      value: 10 * 1000 * 1000

    maximumLocalDataUriDbSizeInChars: 
      type: Number
      value: 2 * 1000 * 1000

    localDataUsedPercentage:
      type: Number
      value: 0

    currentDateFilterStartDate:
      type: Number

    currentDateFilterEndDate:
      type: Number

    isDownloading:
      type: Boolean
      value: false
    
    isUploading:
      type: Boolean
      value: false


    ## Attachment - end -



  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  _makeOtherTest: ->
    @otherTest =
      serial: null
      createdByUserSerial: @user.serial
      patientSerial: @patient.serial
      createdDatetimeStamp: null
      lastModifiedDatetimeStamp: 0
      lastSyncedDatetimeStamp: 0
      data:
        date: lib.datetime.mkDate()
        name: null
        institution: null
        result: null
        unit: null
        attachmentSerialList: []

  _loadOtherTest: (testIdentifier)->
    list = app.db.find 'patient-test-other', ({serial})-> serial is testIdentifier
 
    if list.length is 1
      @isTestValid = true
      @otherTest = list[0]

      @_loadAttachmentList @otherTest.serial
      console.log 'otherTest', @otherTest
      return true
    else
      @_notifyInvalidTest()
      return false

  updateOtherTestPressed: (e)->
    # TODO - Validation message
    unless @otherTest.data.name and @otherTest.data.result and @otherTest.data.unit
      @domHost.showToast 'Please Enter All The Data.'
    if @otherTest.data.name and @otherTest.data.result and @otherTest.data.unit
      @_saveOtherTest @otherTest
      @domHost.showToast 'Updated Successfully!'
      @_makeOtherTest()
      @arrowBackButtonPressed()
    

  cancelButtonClicked: (e)->
    @_makeOtherTest()
    @arrowBackButtonPressed()

  arrowBackButtonPressed: (e)->
    window.history.back()

  _notifyInvalidTest:() ->
    @isTestValid = false
    @domHost.showModalDialog 'Invalid Test Provided!'

  _saveOtherTest: (data)->
    data.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'patient-test-other', data, ({serial})=> data.serial is serial


  

  addOtherTestButtonClicked: ->

    # TODO - Validation message
    unless @otherTest.data.name and @otherTest.data.result and @otherTest.data.unit and @otherTest.data.institution
      @domHost.showToast 'Please Enter All The Data'
      return

    # this._chargePatient @patient.idOnServer, 5, 'Payment BDEMR Doctor Generic', (err)=>
    #   if (err)
    #     @domHost.showModalDialog("Unable to charge the patient. #{err.message}")
    #     return

  
    #   else
        
    @otherTest.createdDatetimeStamp = lib.datetime.now()
    @otherTest.serial = @generateSerialForVitals 'OT'
    @otherTest.createdByUserSerial = @user.serial
    @otherTest.patientSerial = @patient.serial
    @_saveOtherTest @otherTest
    
    console.log @otherTest
    @_makeOtherTest()
    @domHost.showToast 'Added Successfully'
    @arrowBackButtonPressed()




  ## Attachement [START]
  # ================================

  _updateSpaceCalculation: ->
    if @localDataUriDb
      taken = @localDataUriDb.computeTotalSpaceTaken()
      used = 1 - ((@maximumLocalDataUriDbSizeInChars - taken) / @maximumLocalDataUriDbSizeInChars)
      @localDataUsedPercentage = Math.floor ((used) * 100)

  _openLocalDataUriDb: ->

    localDataUriDb = new lib.DatabaseEngine {
      name: 'local-data-uri-db'
      storageEngine: lib.localStorage
      serializationEngine: lib.json
      config:
        commitDelay: 0
    }

    localDataUriDb.initializeDatabase { removeExisting: false }

    localDataUriDb.defineCollection {
      name: 'local-attachment'
    }

    @localDataUriDb = localDataUriDb

    sessionDataUriDb = new lib.DatabaseEngine {
      name: 'session-data-uri-db'
      storageEngine: lib.tabStorage
      serializationEngine: lib.json
      config:
        commitDelay: 0
    }

    sessionDataUriDb.initializeDatabase { removeExisting: false }

    sessionDataUriDb.defineCollection {
      name: 'local-attachment'
    }

    @sessionDataUriDb = sessionDataUriDb

  
  
  _makeBlankAttachment: ->
    @set 'newAttachment', {
      title: ''
      description: ''
      dataUri: ''
      originalName: null 
      originalType: null
      sizeInBytes: 0
      sizeInChars: 0
      isImage: false
      isLoaded: false
      progress: 0
    }

  _loadAttachmentList: (testIdentifier)->

    localAttachmentList = app.db.find 'patient-gallery--local-attachment', ({testSerial})-> testSerial is testIdentifier
    @set 'attachmentList', localAttachmentList

    onlineAttachmentList = app.db.find 'patient-gallery--online-attachment', ({testSerial})-> testSerial is testIdentifier
    if onlineAttachmentList.length
      @set 'isDownloading', true

    lib.util.iterate onlineAttachmentList, (next, index, item)=>
      @callApi 'bdemr/get-uploaded-file', {attachmentId: item.data.attachmentId}, (err, response)=>
        if response.hasError
          @domHost.showModalDialog response.error.message
        else
          @push 'attachmentList', response.data
          next()
    .finally =>
      @set 'isDownloading', false
    

  _saveAttachment: (attachment)->
    app.db.upsert 'patient-gallery--local-attachment', attachment, ({serial})=> attachment.serial is serial
  

    

  $toMega: (value)-> (Math.ceil ((value / 1000 / 1000) * 100)) / 100

  $getImageSrc: (attachment)->
    if attachment.mainStorage is 'local'
      list = @localDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial
      if list.length > 0
        return list[0].dataUri
      else
        return 'assets/not-found.png'
    else if attachment.mainStorage is 'server'
      return attachment.dataURI
    else if attachment.mainStorage is 'session'
      list = @sessionDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial
      if list.length > 0
        return list[0].dataUri
      else
        return 'assets/not-found.png'


  fileInputChanged: (e)->
    reader = new FileReader
    file = e.target.files[0]

    if file.size > @maximumImageSizeAllowedInBytes
      @domHost.showModalDialog "Please provide a file less than #{Math.floor(@maximumImageSizeAllowedInBytes / 1000 / 1000)}mb in size."
      return

    reader.readAsDataURL file

    reader.onprogress = (e)=>
      @set 'newAttachment.progress', ((e.loaded / e.total) * 100)

    reader.onload = =>
      dataUri = reader.result
      @set 'newAttachment.isImage', file.type.indexOf('image/') > -1

      @set 'newAttachment.sizeInBytes', file.size
      @set 'newAttachment.title', file.name
      @set 'newAttachment.dataUri', dataUri
      @set 'newAttachment.originalType',  file.type
      @set 'newAttachment.originalName', file.name
      @set 'newAttachment.sizeInChars', dataUri.length
      
      @set 'newAttachment.isLoaded', true

  _prepareAtachment: ->
    { 
      title
      description
      dataUri
      isImage
      originalName
      originalType
      sizeInBytes
      sizeInChars
    } = @newAttachment

    attachment = {
      serial: @generateSerialForAttachmentBlob()
      attSyncSerial: @generateSerialForAttachmentSync()
      lastModifiedDatetimeStamp: lib.datetime.now()
      mainStorage: null # could be 'server' or 'local' or 'session'
      title
      description
      # dataUri
      isImage
      originalName
      originalType
      sizeInBytes
      sizeInChars
    }

    return attachment


  uploadPressed: (e)->
    attachment = @_prepareAtachment()
    attachment.mainStorage = 'server'
    attachment.apiKey = (app.db.find 'user')[0].apiKey
    attachment.dataURI = @newAttachment.dataUri
    @set 'isUploading', true
    @callApi 'bdemr/file-uploader', attachment, (err, response)=>
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        attachment._id = response.data.attachmentId
        @push 'attachmentList', attachment
        console.log @otherTest
        @push 'otherTest.data.attachmentSerialList', attachment.serial
 
        # following syncable object signature
        onlineAttachment = 
          serial: attachment.attSyncSerial
          createdDatetimeStamp: 0
          lastModifiedDatetimeStamp: attachment.lastModifiedDatetimeStamp
          lastSyncedDatetimeStamp: 0
          patientSerial: @patient.serial
          testSerial: @otherTest.serial
          data:
            attachmentId: response.data.attachmentId

        # Saving the attachment ref
        app.db.upsert 'patient-gallery--online-attachment', onlineAttachment, ({serial})=> serial is attachment.serial
        @set 'isUploading', false
        @domHost._syncOnlyPatientGallery ()=>
          @_makeBlankAttachment()


  saveLocallyPressed: (e)->
    attachment = @_prepareAtachment()
    attachment.mainStorage = 'local' 

    uploadData = {
      attachmentSerial: attachment.serial
      dataUri: @newAttachment.dataUri
    }

    currentSize = @localDataUriDb.computeTotalSpaceTaken()
    maxSize = @maximumLocalDataUriDbSizeInChars
    sizeLeft = maxSize - currentSize
    sizeNeededForThisAttachment = (JSON.stringify uploadData).length

    if sizeLeft < sizeNeededForThisAttachment
      extraNeeded = sizeNeededForThisAttachment - sizeLeft
      message = "Sorry. Can not save image. Your browser needs #{@$toMega(extraNeeded)}MB additional storage."
      @domHost.showModalDialog message
    else
      @localDataUriDb.insert 'local-attachment', uploadData
      @push 'attachmentList', attachment
      @_saveAttachment attachment
      @_makeBlankAttachment()
      @_updateSpaceCalculation()
  
  keepUntilBrowserClosedPressed: (e)->
    attachment = @_prepareAtachment()
    attachment.mainStorage = 'session' 

    uploadData = {
      attachmentSerial: attachment.serial
      dataUri: @newAttachment.dataUri
    }

    currentSize = @sessionDataUriDb.computeTotalSpaceTaken()
    maxSize = 50 * 1000 * 1000
    sizeLeft = maxSize - currentSize
    
    sizeNeededForThisAttachment = (JSON.stringify uploadData).length

    if sizeLeft < sizeNeededForThisAttachment
      extraNeeded = sizeNeededForThisAttachment - sizeLeft
      message = "Sorry. Can not save image. Your browser needs #{@$toMega(extraNeeded)}MB additional storage."
      @domHost.showModalDialog message
    else
      try
        @sessionDataUriDb.insert 'local-attachment', uploadData  
        @push 'attachmentList', attachment
        @_makeBlankAttachment()
      catch e
        message = "Sorry. Can not save image. Your browser do not have enough memory."
        @domHost.showModalDialog message

  deletePressed: (e)->
    { attachmentIndex, attachment } = e.model
    if attachment.mainStorage is 'local'
      attachmentData = (@localDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial)
      if attachmentData.length > 0
        @localDataUriDb.remove 'local-attachment', attachmentData[0]._id
      app.db.remove 'patient-gallery--local-attachment', attachment._id
      @splice 'attachmentList', attachmentIndex, 1
      @_updateSpaceCalculation()
    else if attachment.mainStorage is 'session'
      attachmentData = (@sessionDataUriDb.find 'local-attachment', ({attachmentSerial})-> attachmentSerial is attachment.serial)
      if attachmentData.length > 0
        @sessionDataUriDb.remove 'local-attachment', attachmentData[0]._id
      app.db.remove 'patient-gallery--local-attachment', attachment._id
      @splice 'attachmentList', attachmentIndex, 1
    else
      @callApi 'bdemr/delete-uploaded-file', {attachmentId: attachment._id}, (err, response)=>
        if response.hasError
          @domHost.showModalDialog response.error.message
        else
          attachmentData = (app.db.find 'patient-gallery--online-attachment', ({serial})-> serial is attachment.attSyncSerial)
          if attachmentData.length > 0
            app.db.remove 'patient-gallery--online-attachment', attachmentData[0]._id
            @splice 'attachmentList', attachmentIndex, 1
            app.db.insert 'patient-gallery--online-attachment--deleted', { serial: attachmentData[0].serial }


  downloadPressed: (e)->
    attachment = e.model.attachment
    src = @$getImageSrc attachment

    if (src.indexOf 'data:') is 0
      blob = dataURItoBlob src
      objectURL = window.URL.createObjectURL blob, { type: attachment.originalType }
    else
      objectURL = src

    identifier = attachment.originalName
    a = window.document.createElement 'a'
    a.href = objectURL
    a.target = '_blank'
    a.download = identifier
    document.body.appendChild a
    a.click()
    document.body.removeChild a

  # === Attachment [END] ===



  # psedo lifecycle callback
  navigatedIn: ()->
    currentOrganization = @getCurrentOrganization()
    unless currentOrganization
      @domHost.navigateToPage "#/select-organization"
      
    params = @domHost.getPageParams()

    @_loadUser()
    @_loadPatient(params['patient'])

    unless params['test']
      @_notifyInvalidTest()
      return

    if params['test'] is 'new'
      @isThatNewTest = true
      @_makeOtherTest()

    else
      @isThatNewTest  = false
      @_loadOtherTest params['test']

    @_openLocalDataUriDb()
    @_makeBlankAttachment()
    
    @_updateSpaceCalculation()

  navigatedOut: ->
    @user = {}
    @patient = {}
    @isTestValid = false
    @isPatientValid = false


    
  

}