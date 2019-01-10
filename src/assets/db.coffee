
app.db = new lib.DatabaseEngine {
  name: 'bdemr-doctor-app-db'
  storageEngine: lib.localStorage
  serializationEngine: lib.json
  config:
    commitDelay: 0
}

app.db.initializeDatabase { removeExisting: false }


###
  unregsitered-patient-details
###
app.db.defineCollection {
  name: 'unregsitered-patient-details'
}



###
  settings
    isSyncEnabled
###
app.db.defineCollection {
  name: 'settings'
}

app.db.defineCollection {
  name: 'settings--deleted'
}



###
  --serial-generator
    patient-seed Number
    anaesmon-record-seed Number
    progress-note-seed Number
###
app.db.defineCollection {
  name: '--serial-generator'
}



###
  --persistent-session
    shouldRememberUser Boolean
###
app.db.defineCollection {
  name: '--persistent-session'
}


###
  user
    serial
    name
    email
    phone
    apiKey
    sessionSerial
    usedTokenList
    accountExpiresOnDate
###

###
  anaesmon-record
    idOnServer
    source = local \ online
    lastSyncedDatetimeStamp
    lastLocallyChangedDatetimeStamp
    createdDatetimeStamp
    createdByUserSerial
    serial
    doctorsPrivateNote: ''
    patientSerial
    recordType: 'anaesmon-record'
    content Object
###

app.db.defineCollection {
  name: 'anaesmon-record'
}

app.db.defineCollection {
  name: 'anaesmon-record--deleted'
}

app.db.defineCollection {
  name: 'progress-note-record'
}

app.db.defineCollection {
  name: 'progress-note-record--deleted'
}




app.db.defineCollection {
  name: 'user'
}

###
  patient-list
    idOnServer
    source = local | online
    lastSyncedDatetimeStamp
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    createdByUserSerial
    serial
    name
    email
    phone
    address
        line1
        line2
        postalCode
        cityOrTown
        stateOrProvince
        country
    dob
    nIdOrSsn
    doctorsPrivateNote
###
app.db.defineCollection {
  name: 'patient-list'
}

app.db.defineCollection {
  name: 'patient-list--deleted'
}

###
  idOnServer
  name
  address
  effectiveRegion
  isCurrentUserAMember
  isCurrentUserAnAdmin
  isClaimed
###

app.db.defineCollection {
  name: 'organization'
}



###
  visited-patient-log
    serial
    createdByUserSerial
    patientSerial
    patientName
    visitedDateTimeStamp
    lastModifiedDatetimeStamp
###

app.db.defineCollection {
  name: 'visited-patient-log'
}

app.db.defineCollection {
  name: 'visited-patient-log--deleted'
}



###
  history-and-physical-record
###
app.db.defineCollection {
  name: 'history-and-physical-record'
}

app.db.defineCollection {
  name: 'history-and-physical-record--deleted'
}

###
  diagnosis-record
###
app.db.defineCollection {
  name: 'diagnosis-record'
}

app.db.defineCollection {
  name: 'diagnosis-record--deleted'
}

###
  operation-record
###
app.db.defineCollection {
  name: 'operation-record'
}

app.db.defineCollection {
  name: 'operation-record--deleted'
}



###
  doctor-visit
    idOnServer
    source = local \ online
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    patientSerial
    doctorName
    hospitalName
    doctorSpeciality
    prescriptionSerial
    doctorNoteSerial
    nextVisitSerial
    advisedTestSerial
    testResults
      serial
      resultType
      resultName

    
###

app.db.defineCollection {
  name: 'doctor-visit'
}


app.db.defineCollection {
  name: 'doctor-visit--deleted'
}


###
  visit-prescription
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    visitSerial
    patientSerial
    
###

app.db.defineCollection {
  name: 'visit-prescription'
}

app.db.defineCollection {
  name: 'visit-prescription--deleted'
}

###
  visit-note
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    visitSerial
    patientSerial
    data
        message
    
###

app.db.defineCollection {
  name: 'visit-note'
}

app.db.defineCollection {
  name: 'visit-note--deleted'
}


###
  visit-patient-stay
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    visitSerial
    patientSerial
      data:
        typeNameOfTheInstitution
        typeOutPatientDischargedAdvised
        typeOutPatientAdmissionAdvised
        typeEmergencyDischargedAdvised
        typeEmergencyAdmissionAdvised
        admissionToHospitalName
        admissionToDepartment
        admissionToDateOfAdmissionDateTimeStamp
        admissionToLocationDateOfAdmissionDateTimeStamp
        admissionToNameOfWard
        admissionToNameOfBed
        dischargeDatetimeStamp
        dischargeReason
        dischargeReasonGotBetter
        dischargeReasonRequireCare
        dischargeReasonCurrentCareNotPossible
        dischargeReasonNotRequiredStayHospital
        dischargeReasonDeath
        dischargeToHome
        dischargeToRehabilitation
        dischargeToMortualry
        dischargeToCustom
    
###

app.db.defineCollection {
  name: 'visit-patient-stay'
}

app.db.defineCollection {
  name: 'visit-patient-stay--deleted'
}


###
  visit-next-visit
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    visitSerial
    patientSerial
    data:
      date
      status
    
###

app.db.defineCollection {
  name: 'visit-next-visit'
}

app.db.defineCollection {
  name: 'visit-next-visit--deleted'
}



###
  custom-investigation-list
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    data:
      categoryName
      investigationName
    
###

app.db.defineCollection {
  name: 'custom-investigation-list'
}

app.db.defineCollection {
  name: 'custom-investigation-list--deleted'
}



###
  visit-advised-test
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    visitSerial
    patientSerial
    data
      testAdvisedList: [
        {
          testName
          suggestedInstitutionName
          userAddedInstitutionSelectedIndex
        }
      ]
    
###

app.db.defineCollection {
  name: 'visit-advised-test'
}

app.db.defineCollection {
  name: 'visit-advised-test--deleted'
}

###
  favorite-advised-test
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    testName
    
###

app.db.defineCollection {
  name: 'favorite-advised-test'
}

app.db.defineCollection {
  name: 'favorite-advised-test--deleted'
}

###
  user-favorite-symptom
###

app.db.defineCollection {
  name: 'user-favorite-symptom'
}

app.db.defineCollection {
  name: 'user-favorite-symptom--deleted'
}

###
  user-favorite-note
###

app.db.defineCollection {
  name: 'user-favorite-note'
}

app.db.defineCollection {
  name: 'user-favorite-note--deleted'
}

###
  user-favorite-examination
###

app.db.defineCollection {
  name: 'user-favorite-examination'
}

app.db.defineCollection {
  name: 'user-favorite-examination--deleted'
}


###
  user-added-institution-list
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    data
      institutionName

    
###

app.db.defineCollection {
  name: 'user-added-institution-list'
}

app.db.defineCollection {
  name: 'user-added-institution-list--deleted'
}



###
patient-medications
  serial
  createdDatetimeStamp
  lastModifiedDatetimeStamp
  lastSyncedDatetimeStamp
  createdByUserSerial
  patientSerial
  prescriptionSerial
  data:
    genericName
    brandName
    manufacturer
    dose
    from
    startDateTimeStamp
    endDateTimeType
    endDateTimeStamp
    route
    direction
    quantityPerPrescription
    numberOfRefill
    comments
    intakeDateTimeStampList
    nextDoseDateTimeStamp
    intervalInHours
    statusInHours
    status = continue/stopped

###

###
  patient-test-results
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    advisedDoctorSerial
    patientSerial
    advisedTestSerial
    investigationSerial
    investigationName
    attachmentSerialList
    data =
      testList = {
        datePerform
        testName
        testResult
        testUnit
        testUnitList = []
        unitSelectedIndex
        checkedTestIndex
        reportedDoctorSerial
        reportedDoctorName
        reportedDoctorSpeciality
        reportedDoctorSelectedIndex
        referenceRange
      }

    
###
app.db.defineCollection {
  name: 'patient-test-results'
}

app.db.defineCollection {
  name: 'patient-test-results--deleted'
}


app.db.defineCollection {
  name: 'patient-medications'
}

app.db.defineCollection {
  name: 'patient-medications--deleted'
}



###
favorite-medicine-list
  serial
  createdDatetimeStamp
  lastModifiedDatetimeStamp
  lastSyncedDatetimeStamp
  createdByUserSerial
  data:
    genericName
    brandName
    manufacturer
    dose
    from
    startDateTimeStamp
    endDateTimeType
    endDateTimeStamp
    route
    direction
    quantityPerPrescription
    numberOfRefill
    comments
    intakeDateTimeStampList
    nextDoseDateTimeStamp
    intervalInHours
    status = continue/stopped
###
app.db.defineCollection {
  name: 'favorite-medicine-list'
}

app.db.defineCollection {
  name: 'favorite-medicine-list--deleted'
}



###
  patient-vitals-blood-pressure'
    serial
    createdByUserSerial
    patientSerial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    data:
      systolic
      diastolic
      random
      unit
      flags =
        flagAsError: false
###
app.db.defineCollection {
  name: 'patient-vitals-blood-pressure'
}

app.db.defineCollection {
  name: 'patient-vitals-blood-pressure--deleted'
}



###
  patient-vitals-pulse-rate
    serial
    createdByUserSerial
    patientSerial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    data:
      bpm
      flags =
        flagAsError: false
###
app.db.defineCollection {
  name: 'patient-vitals-pulse-rate'
}

app.db.defineCollection {
  name: 'patient-vitals-pulse-rate--deleted'
}



###
  patient-vitals-respiratory-rate
    serial
    createdByUserSerial
    patientSerial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    data:
      respiratoryRate
      unit
      flags =
        flagAsError: false
###
app.db.defineCollection {
  name: 'patient-vitals-respiratory-rate'
}

app.db.defineCollection {
  name: 'patient-vitals-respiratory-rate--deleted'
}



###
  patient-vitals-spo2
    serial
    createdByUserSerial
    patientSerial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    data:
      spO2Percentage
      unit
      flags =
        flagAsError: false
###
app.db.defineCollection {
  name: 'patient-vitals-spo2'
}

app.db.defineCollection {
  name: 'patient-vitals-spo2--deleted'
}

###
  patient-vitals-temperature
    serial
    createdByUserSerial
    patientSerial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    data:
      temparature
      unit
      flags =
        flagAsError: false
###
app.db.defineCollection {
  name: 'patient-vitals-temperature'
}

app.db.defineCollection {
  name: 'patient-vitals-temperature--deleted'
}



###
  patient-vitals-bmi
    serial
    createdByUserSerial
    patientSerial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    data:
      height
      weight
      heightInFt
      heightInInch
      heightUnit
      weightUnit
      calculatedBMI
###
app.db.defineCollection {
  name: 'patient-vitals-bmi'
}

app.db.defineCollection {
  name: 'patient-vitals-bmi--deleted'
}



###
  patient-test-blood-sugar
    serial
    createdByUserSerial
    patientSerial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    data:
      beforeMeal
      afterMeal
      random
      unit
###
app.db.defineCollection {
  name: 'patient-test-blood-sugar'
}

app.db.defineCollection {
  name: 'patient-test-blood-sugar--deleted'
}

###
  patient-test-other
    serial
    createdByUserSerial
    patientSerial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    data:
      date
      name
      result
      institution
      unit
###
app.db.defineCollection {
  name: 'patient-test-other'
}

app.db.defineCollection {
  name: 'patient-test-other--deleted'
}


###
  comment-patient
    serial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    patientSerial
    data:
      message

###
app.db.defineCollection {
  name: 'comment-patient'
}


app.db.defineCollection {
  name: 'comment-patient--deleted'
}


###
  comment-doctor
    serial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    lastSyncedDatetimeStamp
    doctorSerial
    patientSerial
    doctorSpeciality
    doctorName
    data:
      message

###
app.db.defineCollection {
  name: 'comment-doctor'
}


app.db.defineCollection {
  name: 'comment-doctor--deleted'
}



app.db.defineCollection {
  name: 'patient-gallery--local-attachment'
}

app.db.defineCollection {
  name: 'patient-gallery--online-attachment'
}

app.db.defineCollection {
  name: 'patient-gallery--online-attachment--deleted'
}


###
  patient-test-results
    serial
    lastModifiedDatetimeStamp
    createdDatetimeStamp
    lastSyncedDatetimeStamp
    createdByUserSerial
    patientSerial
    advisedTestSerial
    investigationSerial
    data
      testList [
        {
          datePerform
          testName
          institutionName
          testResult
          testUnit
          testedBy
        }
      ]

    
###
app.db.defineCollection {
  name: 'patient-test-results'
}

app.db.defineCollection {
  name: 'patient-test-results--deleted'
}

###
  category
  message
###

app.db.defineCollection {
  name: 'in-app-notification'
}


###
  local-patient-pin-code-list
    patientSerial
    pin
###
app.db.defineCollection {
  name: 'local-patient-pin-code-list'
}



###
  serial
  doctorSerial
  lastModifiedDatetimeStamp
  subject
  action
  args
###

app.db.defineCollection {
  name: 'activity'
}

app.db.defineCollection {
  name: 'activity--deleted'
}


###
  serial
  doctorSerial
  lastModifiedDatetimeStamp
  data:
    nameOfInstitution 
    nameOfPatient:
    billingPersonsName
    serviceRenderedSelectedIndex
    customServiceRendered
    sourceOfPatientSelectedIndex
    customSourceOfPatient
    datePerformed
    dateDue
    timeFrom
    timeTo
    isCleared
    paymentStatus
    feeBilledAmount
    isThereAnyPaymentMade
    feePaidAmount
    feePaidOn
    feePaidBySelectedIndex
    comments
###

app.db.defineCollection {
  name: 'visit-invoice'
}

app.db.defineCollection {
  name: 'visit-invoice--deleted'
}

###
  Separate Diagnosis List from History Physical
    serial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    createdByUserSerial
    patientSerial
    doctorName
    doctorSpeciality
    diagnosis
###

app.db.defineCollection {
  name: 'visit-diagnosis'
}

app.db.defineCollection {
  name: 'visit-diagnosis--deleted'
}


app.db.defineCollection {
  name: 'visit-current-diagnosis'
}

app.db.defineCollection {
  name: 'visit-current-diagnosis--deleted'
}


###
visit-identified-symptoms
serial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    createdByUserSerial
    patientSerial
    doctorName
    doctorSpeciality
    data
      symptomsList
###
app.db.defineCollection {
  name: 'visit-identified-symptoms'
}

app.db.defineCollection {
  name: 'visit-identified-symptoms--deleted'
}

###
visit-examination
serial
    createdDatetimeStamp
    lastModifiedDatetimeStamp
    createdByUserSerial
    patientSerial
    doctorName
    doctorSpeciality
    data
      examinationList
###
app.db.defineCollection {
  name: 'visit-examination'
}

app.db.defineCollection {
  name: 'visit-examination--deleted'
}


###
custom-symptoms-list
  serial
  createdDatetimeStamp
  lastModifiedDatetimeStamp
  createdByUserSerial
  data
    name
###

app.db.defineCollection {
  name: 'custom-symptoms-list'
}

app.db.defineCollection {
  name: 'custom-symptoms-list--deleted'
}

###
custom-examination-list
  serial
  createdDatetimeStamp
  lastModifiedDatetimeStamp
  createdByUserSerial
  data
    name
    examinationValueList
###

app.db.defineCollection {
  name: 'custom-examination-list'
}

app.db.defineCollection {
  name: 'custom-examination-list--deleted'
}




app.db.defineCollection {
  name: 'offline-patient-pin'
}

### 
in-patient-medicine-dispense-log
  serial
  createdDatetimeStamp
  lastModifiedDatetimeStamp
  createdByUserSerial
  organizationId
  patientSerial
  medicineSerial

###

app.db.defineCollection {
  name: 'in-patient-medicine-dispense-log'
}

app.db.defineCollection {
  name: 'in-patient-medicine-dispense-log--deleted'
}

### 
pcc-record
  serial: null
  lastModifiedDatetimeStamp: 0
  createdDatetimeStamp: 0
  lastSyncedDatetimeStamp: 0
  createdByUserSerial
  patientSerial
  centerInfo:
    centerIdOnServer
    centerSerial
    centerName
    patientId
  medicalInfo

###

app.db.defineCollection {
  name: 'pcc-records'
}

app.db.defineCollection {
  name: 'pcc-records--deleted'
}

app.db.defineCollection {
  name: 'existing-patient-log-for-pending-pcc-records'
}


### 
ndr-record
  serial: null
  lastModifiedDatetimeStamp: 0
  createdDatetimeStamp: 0
  lastSyncedDatetimeStamp: 0
  createdByUserSerial
  patientSerial
  data:

###

app.db.defineCollection {
  name: 'ndr-records'
}

app.db.defineCollection {
  name: 'ndr-records--deleted'
}

### 
patient-insulin-list
  serial: null
  lastModifiedDatetimeStamp: 0
  createdDatetimeStamp: 0
  lastSyncedDatetimeStamp: 0
  createdByUserSerial
  patientSerial
  data:

###

app.db.defineCollection {
  name: 'patient-insulin-list'
}

app.db.defineCollection {
  name: 'patient-insulin-list--deleted'
}

app.db.defineCollection {
  name: 'conflicted-patient-list'
}

app.db.defineCollection {
  name: 'organization-record-authorization'
}


app.db.defineCollection {
  name: 'previous-operation'
}

app.db.defineCollection {
  name: 'previous-operation--deleted'
}


app.db.defineCollection {
  name: 'current-operation'
}

app.db.defineCollection {
  name: 'current-operation--deleted'
}

app.db.defineCollection {
  name: 'user-added-reported-doctor-list'
}

app.db.defineCollection {
  name: 'user-added-reported-doctor-list--deleted'
}

app.db.defineCollection {
  name: 'ot-management'
}

app.db.defineCollection {
  name: 'ot-management--deleted'
}


