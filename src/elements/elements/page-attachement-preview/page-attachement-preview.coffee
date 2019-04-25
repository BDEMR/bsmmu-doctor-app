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

  is: 'page-attachement-preview'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.pageLike
    app.behaviors.translating
    app.behaviors.apiCalling
  ]

  properties:

    isVisitValid: 
      type: Boolean
      notify: false
      value: false

    isPrescriptionValid:
      type: Boolean
      notify: false
      value: false

    isNoteValid:
      type: Boolean
      notify: false
      value: false

    isNextVisitValid:
      type: Boolean
      notify: false
      value: false

    isTestResultsValid:
      type: Boolean
      notify: true
      value: false

    isPatientValid:
      type: Boolean
      notify: false
      value: false      

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

    prescription:
      type: Object
      notify: true
      value: null

    doctorNote:
      type: Object
      notify: true
      value: null

    nextVisit:
      type: Object
      notify: true
      value: null

    testAdvised:
      type: Object
      notify: true
      value: null

    matchingPrescribedMedicineList:
      type: Array
      notify: true
      value: []

    doctorInstitutionList:
      type: Array
      notify: true
      value: []

    doctorSpecialityList:
      type: Array
      notify: true
      value: []

    doctorInstitutionSelectedIndex:
      type: Number
      notify: true
      value: 0

    doctorSpecialitySelectedIndex:
      type: Number
      notify: true
      value: 0

    settings:
      type: Object
      notify: true


    testResultsAttachmentSerialList:
      type: Array
      notify: true
      value: []


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


  

  _getSettings: ->
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()
    if list.length
      return list[0]


  _loadUser:()->
    userList = app.db.find 'user'
    # console.log userList
    if userList.length is 1
      @user = userList[0]

      # if userList[0].employmentDetailsList is not '[]'

      for employmentDetails in userList[0].employmentDetailsList
        @push 'doctorInstitutionList', employmentDetails.institutionName

      # if userList[0].specializationList is not '[]'

      for specializationDetails in userList[0].specializationList
        @push 'doctorSpecialityList', specializationDetails.specializationTitle




  _loadPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      @patient = list[0]
    else
      @_notifyInvalidPatient()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()


  _loadTestResultsAttachments: (testIdentifier)->
    
    list = app.db.find 'patient-test-results', ({serial})-> serial is testIdentifier
 
    if list.length is 1
      @isTestResultsValid = true
      console.log testIdentifier
      @_loadAttachmentList testIdentifier

      return true
    else
      @_notifyInvalidTest()
      return false

  _notifyInvalidTest: ()->
    isTestResultsValid = false
    @domHost.showModalDialog 'Invalid Test Results!'



  navigatedIn: ->

    @_loadUser()
    
    params = @domHost.getPageParams()

    @_loadTestResultsAttachments params['test-result']




  navigatedOut: ->
    @visit = {}
    @patient = {}
    @isVisitValid = false
    @isPatientValid = false
    @isTestResultsValid = false
    @doctorInstitutionList = []
    @doctorSpecialityList = []

  _formatDateTime: (dateTime)->
    # console.log dateTime
    lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')


  # Gallary [START]
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

  _loadAttachmentList: (testResultIdentifier)->
    # console.log patientIdentifier

    # unless 'attachmentList' of @record.content.attachment
    #   @record.content.attachment.attachmentList = []
    
    localAttachmentList = app.db.find 'patient-gallery--local-attachment', ({testResultsSerial})-> testResultsSerial is testResultIdentifier
    onlineAttachmentList = app.db.find 'patient-gallery--online-attachment', ({testResultsSerial})-> testResultsSerial is testResultIdentifier
    # console.log onlineAttachmentList

    uploadedFileList = []

    lib.util.iterate onlineAttachmentList, (next, index, item)=>
      @callApi 'bdemr/get-uploaded-file', {attachmentId: item.data.attachmentId}, (err, response)=>
        if response.hasError
          @domHost.showModalDialog response.error.message
        else
          uploadedFileList.push response.data
          next()
    .finally =>
      attachmentList = [].concat localAttachmentList, uploadedFileList
      @set 'attachmentList', attachmentList


    console.log @attachmentList
    

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
      serial: @generateSerialForAttachment()
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

  # === Gallary [END] ===


}
