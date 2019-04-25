
Polymer {

  is: 'page-patient-editor'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties:

    EDIT_MODE_ON:
      type: Boolean
      notify: true
      value: false

    user:
      type: Object
      notify: true
      value: null

    isPatientValid: 
      type: Boolean
      notify: true
      value: false

    patient:
      type: Object
      notify: true
      value: null


    sexSelectedIndex:
      type: Number
      value: 0

    genderList:
      type: Array
      value: -> ['Male', 'Female', 'Other']

    divisionIndex:
      type: Number
      value: -1
      notify: true

    districtIndex:
      type: Number
      value: -1
      notify: true

    districtList:
      type: Array
      value: -> []
      notify: true

    divisionList:
      type: Array
      value: -> [
        {
            divisionName: "Barisal"
            districtList: [
                "Barguna",
                "Barisal",
                "Bhola",
                "Jhalokati",
                "Patuakhal",
                "Pirojpur"
            ]
        }
        {
            divisionName: "Chittagong"
            districtList: [
                "Bandarban",
                "Brahmanbaria",
                "Chandpur",
                "Chittagong",
                "Comilla",
                "Cox's Bazar",
                "Feni",
                "Khagrachhari",
                "Lakshmipur",
                "Noakhali",
                "Rangamati"
            ]
        }
        {
            divisionName: "Dhaka"
            districtList: [
                "Dhaka",
                "Faridpur",
                "Gazipur",
                "Gopalganj",
                "Kishoreganj",
                "Madaripur",
                "Manikganj",
                "Munshiganj",
                "Narayanganj",
                "Narsingdi",
                "Rajbari",
                "Shariatpur",
                "Tangail "
            ]
        }
        {
            divisionName: "Khulna"
            districtList: [
                "Bagerhat",
                "Chuadanga",
                "Jessore",
                "Jhenaidah",
                "Khulna",
                "Kushtia",
                "Magura",
                "Meherpur",
                "Narail",
                "Satkhira"
            ]
        }
        {
            divisionName: "Mymensingh"
            districtList: [
                "Jamalpur",
                "Mymensingh",
                "Netrakona",
                "Sherpur"
            ]
        }
        {
            divisionName: "Rajshahi"
            districtList: [
                "Bogra",
                "Joypurhat",
                "Naogaon",
                "Natore",
                "Nawabganj",
                "Pabna",
                "Rajshahi",
                "Sirajganj"
            ]
        }
        {
            divisionName: "Rangpur"
            districtList: [
                "Dinajpur",
                "Gaibandha",
                "Kurigram",
                "Lalmonirhat",
                "Nilphamari",
                "Panchagarh",
                "Rangpur",
                "Thakurgaon"
            ]
        }
        {
            divisionName: "Sylhet"
            districtList: [
                "Habiganj",
                "Moulvibazar",
                "Sunamganj",
                "Sylhet"
            ]
        }
      ]

    organization:
      type: Object
      notify: true
      value: null

    professionList:
      type: Array
      value: -> ['Employed', 'Unemployed', 'Home Maker', 'Student', 'Retired']

    expenditureList:
      type: Array
      value: -> ['bellow 10,000', '10,000-20,000', '20,000-30,000', '30,000-40,000', '40,000-50,000', '50,000 & Above']

    maritalStatusList:
      type: Array
      value: -> ['Married', 'Unmarried', 'Divorced', 'Widowed', 'Widower', 'Separated']

    educationTypeList:
      type: Array
      value: -> ['No formal education', '1-5 years', '5-10 years', '10 to 12 years', '12 to 16', 'More than 16 years']

    profileImage:
      type: String
      value: null
      notify: true

    maximumImageSizeAllowedInBytes:
      type: Number
      value: 1000 * 1000

 

  _compareFn: (left, op, right) ->
    # lib.util.delay 5, ()=>
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


  _returnSerial: (index)->
    index+1

  _isEmpty: (data)-> 
    if data is 0
      return true
    else
      return false


  _loadUser:()->
    userList = app.db.find 'user'
    if userList.length is 1
      @user = userList[0]

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  saveButtonPressed: (e)->
    # params = @domHost.getPageParams()

    # if @patient.serial is null or params['patient'] is 'new'
    #   @patient.serial = @generateSerialForPatient()

    @patient.name = @$makeNameObject @patient.name

    @patient.lastModifiedDatetimeStamp = lib.datetime.now()
    app.db.upsert 'patient-list', @patient, ({serial})=> @patient.serial is serial



    @_callBDEMRPatientDetailsUpdateApi @patient, =>
      @domHost.showToast 'Patient Details Updated!'
      # @domHost.__patientView__oneTimeSearchFilter = @patient.serial
      @arrowBackButtonPressed()

  $findCreator: (creatorSerial)-> 'me'

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--

    return age


  fileInputChanged: (e)->
    reader = new FileReader
    file = e.target.files[0]

    if file.size > @maximumImageSizeAllowedInBytes
      @domHost.showModalDialog 'Please provide a file less than 1mb in size.'
      return

    reader.readAsDataURL file
    reader.onload = =>
      dataUri = reader.result
      @set 'profileImage', dataUri
      @set 'patient.profileImage', dataUri
        


  onDivisionChange: (e)->
    @set 'districtIndex', -1
    districtList = @divisionList[@divisionIndex].districtList
    lib.util.delay 5, ()=>
      @set 'districtList', districtList



  _loadPatient: (patientIdentifier, cbfn)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      @isPatientValid = true
      patient = list[0]
      patient.name = @$getFullName patient.name

      if patient.profileImage
        @set 'profileImage', patient.profileImage
      else
        @set 'profileImage', 'images/avatar.png'

      if ((typeof patient.drugAllergy is 'undefined') or (patient.drugAllergy.list.length is 0))
        patient.drugAllergy =  {value: null, list: []}
        patient.drugAllergy.list.push { type: null }

      @patient = patient
      console.log 'PAT', @patient

    else
      @_notifyInvalidPatient()

    cbfn()

  _notifyInvalidPatient: ->
    @isPatientValid = false
    @domHost.showModalDialog 'Invalid Patient Provided'


  calculateAge: (e)->
    selectedDate = e.detail.value
    selectedDateYear = (new Date selectedDate).getFullYear()
    currentYear = (new Date).getFullYear()
    age = currentYear - selectedDateYear
    @ageInYears = age

  makeDOBFromYears: (e)->
    age = e.target.value
    dateInYear = (new Date).getFullYear()
    dateInYear -= parseInt age
    @set 'patient.dateOfBirth', "#{dateInYear}-01-01" 


  printButtonPressed: (e)->
    window.print()


  addAnotherDrugAllergy: (e)->
    @push "patient.drugAllergy.list", {
      type: ''
    }

  deleteDrugAllergy: (e)->
    index = e.model.index
    @splice "patient.drugAllergy.list", index, 1

  navigatedIn: ->
    @selectedPatientInfoPage = 0
    params = @domHost.getPageParams()

    @organization = @getCurrentOrganization()
    unless @organization
      @domHost.navigateToPage "#/select-organization"
      
    @_loadUser()

    if params['patient'] is 'new'
      @_makePatientSignUp()
      @isPatientValid = true
    else
      @_loadPatient params['patient'], =>
        @set "EDIT_MODE_ON", true


  ## -- update - start

  updatePatientDetails: (e)->
    console.log 'PATIENT', @patient
    unless @patient.name and @patient.dateOfBirth
      @domHost.showToast 'Please Fill Up Required Information'
      return

    @patient.gender = @genderList[@sexSelectedIndex]

    patient = @patient
    patient.name = @_makeNameObject patient.name

    app.db.upsert 'patient-list', patient, ({serial})=> patient.serial is serial

    @_callBDEMRPatientDetailsUpdateApi patient

  _importPatient: (serial, pin, cbfn)->
    @callApi '/bdemr-patient-import-new', {serial: serial, pin: pin, doctorName: @user.name, organizationId: @organization.idOnServer}, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        patientList = response.data

        if patientList.length isnt 1
          return @domHost.showModalDialog 'Unknown error occurred.'


        patient = patientList[0]

        id = (app.db.find 'patient-list', ({serial})-> serial is patient.serial)[0]._id
        if id
          app.db.remove 'patient-list', id

        patient.flags = {
          isImported: false
          isLocalOnly: false
          isOnlineOnly: false
        }
        patient.flags.isImported = true

        @domHost.setCurrentPatientsDetails patient

        _id = app.db.insert 'patient-list', patient
        cbfn _id


  _callBDEMRPatientDetailsUpdateApi: (patient, cbfn) ->
    data =
      patient: patient
      apiKey: @user.apiKey
    @callApi '/bdemr-patient-details-update', data, (err, response)=>
      console.log response
      if response.hasError
        @domHost.showModalDialog response.error.message
      else
        cbfn()



  navigatedOut: ->
    # console.trace 'navigatedOut'
    @patient = null
    @isPatientValid = false
    @set "EDIT_MODE_ON", false


}
