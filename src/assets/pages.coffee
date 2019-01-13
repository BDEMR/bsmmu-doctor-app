
###
  app.pages
###

app.pages = {}

app.pages.pageList = [
 {
    name: 'dashboard'
    element: 'page-dashboard'
    windowTitlePostfix: 'Dashboard'
    headerTitle: 'Dashboard'
    preload: true
    hrefList: [ 'dashboard' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
    hideAd: true
    accessId: 'none'
  }
  {
    name: 'my-wallet'
    element: 'page-my-wallet'
    windowTitlePostfix: 'my-wallet'
    headerTitle: 'My Wallet'
    preload: true
    hrefList: [ 'wallet' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showPrintButton: false
    accessId: 'none'
  }
  {
    name: 'organization-wallet'
    element: 'page-organization-wallet'
    windowTitlePostfix: 'organization-wallet'
    headerTitle: 'Organization Wallet'
    preload: true
    hrefList: [ 'organization-wallet' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showPrintButton: false
    accessId: 'none'
  }
  {
    name: 'editor'
    element: 'page-editor'
    windowTitlePostfix: 'Editor'
    headerTitle: 'editor'
    preload: true
    hrefList: [ 'editor' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
  }
  {
    name: 'internal'
    element: 'page-internal'
    windowTitlePostfix: 'internal'
    headerTitle: 'Internal'
    preload: true
    hrefList: [ 'internal' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPrintButton: false
    accessId: 'none'
  }
  {
    name: 'send-feedback'
    element: 'page-send-feedback'
    windowTitlePostfix: 'Feedback Section'
    headerTitle: 'Feedback Section'
    preload: true
    hrefList: [ 'send-feedback' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsName: false
    accessId: 'D012'
  }
  {
    name: 'activate'
    element: 'page-activate'
    windowTitlePostfix: 'Activate'
    headerTitle: 'Activate Code'
    preload: true
    hrefList: [ 'activate' ]
    requireAuthentication : false
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }
  {
    name: 'select-organization'
    element: 'page-select-organization'
    windowTitlePostfix: 'Select Organization'
    headerTitle: 'Select Organization'
    preload: true
    hrefList: [ 'select-organization' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }
  {
    name: 'login'
    element: 'page-login'
    windowTitlePostfix: 'Login'
    headerTitle: 'BSMMU Doctor App'
    preload: true
    hrefList: [ 'login' ]
    requireAuthentication : false
    headerType: 'normal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
  }
  {
    name: 'patient-signup'
    element: 'page-patient-signup'
    windowTitlePostfix: 'patient-signup'
    headerTitle: 'Patient Signup'
    preload: true
    hrefList: [ 'patient-signup' ]
    requireAuthentication : false
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
  }
  {
    name: 'patient-manager'
    element: 'page-patient-manager'
    windowTitlePostfix: 'Patient Manager'
    headerTitle: 'Patient Manager'
    preload: true
    hrefList: [ 'patient-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D001'
  }
  {
    name: 'chamber-manager'
    element: 'page-chamber-manager'
    windowTitlePostfix: 'Chamber Manager'
    headerTitle: 'Chamber Manager'
    preload: true
    hrefList: [ '/', 'chamber-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D003' 
  }

  {
    name: 'assistant-manager'
    element: 'page-assistant-manager'
    windowTitlePostfix: 'Assistant Manager'
    headerTitle: 'Assistant Manager'
    preload: true
    hrefList: [ 'assistant-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D005'
  }

  {
    name: 'my-ot-schedule'
    element: 'page-my-ot-schedule'
    windowTitlePostfix: 'My Operation Schedules'
    headerTitle: 'My Operation Schedules'
    preload: true
    hrefList: [ 'my-ot-schedule' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
  }

  {
    name: 'search-record'
    element: 'page-search-record'
    windowTitlePostfix: 'Search Record (Visit)'
    headerTitle: 'Search Record (Visit)'
    preload: true
    hrefList: [ 'search-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsName: false
    accessId: 'D006'
  }
  {
    name: 'booking'
    element: 'page-booking'
    windowTitlePostfix: 'Booking and Services'
    headerTitle: 'Booking and Services'
    preload: true
    hrefList: [ 'booking' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D009'
  }
  {
    name: 'chamber'
    element: 'page-chamber'
    windowTitlePostfix: 'Chamber'
    headerTitle: 'Chamber'
    preload: true
    hrefList: [ 'chamber' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D003'
  }
  {
    name: 'chamber-patients'
    element: 'page-chamber-patients'
    windowTitlePostfix: 'Chamber: Patients'
    headerTitle: 'Chamber: Patients'
    preload: true
    hrefList: [ 'chamber-patients' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showToolbar: false
    accessId: 'D003'
  }
  {
    name: 'print-chamber-patients'
    element: 'page-print-chamber-patients'
    windowTitlePostfix: 'Chamber Patients Print'
    headerTitle: 'Chamber Patients Print'
    preload: true
    hrefList: [ 'print-chamber-patients' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    showPrintButton: true
    showToolbar: true
  }
  {
    name: 'organization-manager'
    element: 'page-organization-manager'
    windowTitlePostfix: 'Organization Manager'
    headerTitle: 'Organization Manager'
    preload: true
    hrefList: [ 'organization-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }
  {
    name: 'organization-records'
    element: 'page-organization-records'
    windowTitlePostfix: 'Organization Records'
    headerTitle: 'Organization Records'
    preload: true
    hrefList: [ 'organization-records' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }
  {
    name: 'organization-medicine-sales-statistics'
    element: 'page-organization-medicine-sales-statistics'
    windowTitlePostfix: 'Medicine Sales Statistics'
    headerTitle: 'Medicine Sales Statistics'
    preload: true
    hrefList: [ 'organization-medicine-sales-statistics' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }
  {
    name: 'organization-editor'
    element: 'page-organization-editor'
    windowTitlePostfix: 'Organization Editor'
    headerTitle: 'Organization Editor'
    preload: true
    hrefList: [ 'organization-editor' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showOrganizationsName: true
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }

  {
    name: 'organization-manage-patient'
    element: 'page-organization-manage-patient'
    windowTitlePostfix: 'Organization Manage Patient'
    headerTitle: 'Organization Manage Patient'
    preload: true
    hrefList: [ 'organization-manage-patient' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }

  {
    name: 'organization-manage-foc'
    element: 'page-organization-manage-foc'
    windowTitlePostfix: 'Free Of Charge Management'
    headerTitle: 'Free Of Charge Management'
    preload: true
    hrefList: [ 'organization-manage-foc' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }

  {
    name: 'organization-manage-users'
    element: 'page-organization-manage-users'
    windowTitlePostfix: 'Organization Manage Users'
    headerTitle: 'Organization Manage Users'
    preload: true
    hrefList: [ 'organization-manage-users' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }

  {
    name: 'organization-rolewise-member-statistics'
    element: 'page-organization-rolewise-member-statistics'
    windowTitlePostfix: 'Organization rolewise member statistics'
    headerTitle: 'Organization rolewise member statistics'
    preload: true
    hrefList: [ 'organization-rolewise-member-statistics' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }

  {
    name: 'reports-manager'
    element: 'page-reports-manager'
    windowTitlePostfix: 'Patient Reports'
    headerTitle: 'Patient Reports'
    preload: true
    hrefList: [ 'reports-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D002'
  }

  {
    name: 'review-report'
    element: 'page-review-report'
    windowTitlePostfix: 'Review Report'
    headerTitle: 'Review Report'
    preload: true
    hrefList: [ 'review-report' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: false
    showPatientsDetails: false
    hideAd: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D002'
  }

  {
    name: 'pending-report'
    element: 'page-pending-report'
    windowTitlePostfix: 'Pending Report'
    headerTitle: 'Pending Report'
    preload: true
    hrefList: [ 'pending-report' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: false
    showPatientsDetails: false
    hideAd: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D002'
  }
  {
    name: 'patient-editor'
    element: 'page-patient-editor'
    windowTitlePostfix: 'Patient Profile'
    headerTitle: 'Patient Profile'
    preload: true
    hrefList: [ 'patient-editor' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D001'
    # showPrintButton: true
  }

  {
    name: 'ndr-editor'
    element: 'page-ndr-editor'
    windowTitlePostfix: 'NDR'
    headerTitle: 'NDR Form'
    preload: true
    hrefList: [ 'ndr' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D001'
    showPrintButton: false
  }

  {
    name: 'preconception-record'
    element: 'page-preconception-record'
    windowTitlePostfix: 'Preconception Record'
    headerTitle: 'PCC Record'
    preload: true
    hrefList: [ 'preconception-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
    showPrintButton: false
    hideAd: false
  }
  {
    name: 'patient-viewer'
    element: 'page-patient-viewer'
    windowTitlePostfix: 'Patient'
    headerTitle: 'Patient'
    preload: true
    hrefList: [ 'patient-viewer' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: true
    showToolbar: true
    hideHeaderTitle: true
    accessId: 'D014'
  }

  {
    name: 'medicine-dispension'
    element: 'page-medicine-dispension'
    windowTitlePostfix: 'Medicine Dispension'
    headerTitle: 'Medicine Dispension'
    preload: true
    hrefList: [ 'medicine-dispension' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'D004'
  }

  {
    name: 'print-record'
    element: 'page-print-record'
    windowTitlePostfix: 'Print Record'
    headerTitle: 'Print Record'
    preload: true
    hrefList: [ 'print-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'print-diagnosis'
    element: 'page-print-diagnosis'
    windowTitlePostfix: 'Print Diagnosis'
    headerTitle: 'Print Diagnosis'
    preload: true
    hrefList: [ 'print-diagnosis' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'print-full-visit'
    element: 'page-print-full-visit'
    windowTitlePostfix: 'Print Full Visit'
    headerTitle: 'Print Full Visit'
    preload: true
    hrefList: [ 'page-print-full-visit' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'print-anaesmon-record'
    element: 'page-print-anaesmon-record'
    windowTitlePostfix: 'Print Record'
    headerTitle: 'Print Record'
    preload: true
    hrefList: [ 'print-anaesmon-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'print-test-adviced'
    element: 'page-print-test-adviced'
    windowTitlePostfix: 'Print Test Adviced'
    headerTitle: 'Print Test Adviced'
    preload: true
    hrefList: [ 'print-test-adviced' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'print-test-result-from-clinic-app'
    element: 'page-print-test-result-from-clinic-app'
    windowTitlePostfix: 'Print Test Result'
    headerTitle: 'Print Test Result'
    preload: true
    hrefList: [ 'print-test-result' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }


  {
    name: 'page-print-current-medicine'
    element: 'page-print-current-medicine'
    windowTitlePostfix: 'Print Current Medicine'
    headerTitle: 'Print Current Medicine'
    preload: true
    hrefList: [ 'print-current-medicine' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'organization-manage-patient-stay'
    element: 'page-organization-manage-patient-stay'
    windowTitlePostfix: 'Organization Manage Patient Stay'
    headerTitle: 'Organization Manage Patient Stay'
    preload: true
    hrefList: [ 'organization-manage-patient-stay' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showOrganizationsName: true
    hideHeaderTitle: false
    accessId: 'D010'
  }
  {
    name: 'organization-manage-waitlist'
    element: 'page-organization-manage-waitlist'
    windowTitlePostfix: 'Organization Manage Waitlist'
    headerTitle: 'Organization Manage Waitlist'
    preload: true
    hrefList: [ 'organization-manage-waitlist' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    hideHeaderTitle: false
    accessId: 'D010'
  }
  {
    name: 'page-print-old-medicine'
    element: 'page-print-old-medicine'
    windowTitlePostfix: 'Print Old Medicine'
    headerTitle: 'Print Old Medicine'
    preload: true
    hrefList: [ 'print-old-medicine' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'none'
  }


  {
    name: 'page-print-both-medicine'
    element: 'page-print-both-medicine'
    windowTitlePostfix: 'Print Both Medicine'
    headerTitle: 'Print Both Medicine'
    preload: true
    hrefList: [ 'print-both-medicine' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-print-vital-bp'
    element: 'page-print-vital-bp'
    windowTitlePostfix: 'Print Vital Blood Pressure'
    headerTitle: 'Print Vital Blood Pressure'
    preload: true
    hrefList: [ 'print-vital-bp' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-print-vital-pr'
    element: 'page-print-vital-pr'
    windowTitlePostfix: 'Print Vital Pulse Rate'
    headerTitle: 'Print Vital Pulse Rate'
    preload: true
    hrefList: [ 'print-vital-pr' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-print-vital-bmi'
    element: 'page-print-vital-bmi'
    windowTitlePostfix: 'Print Vital BMI'
    headerTitle: 'Print Vital BMI'
    preload: true
    hrefList: [ 'print-vital-bmi' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-print-vital-rr'
    element: 'page-print-vital-rr'
    windowTitlePostfix: 'Print Vital RR'
    headerTitle: 'Print Vital RR'
    preload: true
    hrefList: [ 'print-vital-rr' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-print-vital-spo2'
    element: 'page-print-vital-spo2'
    windowTitlePostfix: 'Print Vital spo2'
    headerTitle: 'Print Vital spo2'
    preload: true
    hrefList: [ 'print-vital-spo2' ]
    requireAuthentication : true
    showPatientsDetails: false
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-print-vital-temp'
    element: 'page-print-vital-temp'
    windowTitlePostfix: 'Print Vital Temperature'
    headerTitle: 'Print Vital Temperature'
    preload: true
    hrefList: [ 'print-vital-temp' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-print-test-blood-sugar'
    element: 'page-print-test-blood-sugar'
    windowTitlePostfix: 'Print Blood Sugar'
    headerTitle: 'Print Blood Sugar'
    preload: true
    hrefList: [ 'print-blood-sugar' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-print-test-other-test'
    element: 'page-print-test-other-test'
    windowTitlePostfix: 'Print Other Test'
    headerTitle: 'Print Other Test'
    preload: true
    hrefList: [ 'print-other-test' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'print-history-and-physical-record'
    element: 'page-print-history-and-physical-record'
    windowTitlePostfix: 'Print History and Physical'
    headerTitle: 'Print History and Physical'
    preload: true
    hrefList: [ 'print-history-and-physical-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'record-history-and-physical'
    element: 'page-record-history-and-physical'
    windowTitlePostfix: 'History and Physical'
    headerTitle: 'History and Physical'
    preload: true
    hrefList: [ 'record-history-and-physical' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: true
    showPrintButton: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'visit-editor'
    element: 'page-visit-editor'
    windowTitlePostfix: 'Visit'
    headerTitle: 'Visit'
    preload: true
    hrefList: [ 'visit-editor' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showPatientsDetails: true
    hideAd: false
    showPrintButton: false
    showToolbar: true
    hideHeaderTitle: true
    accessId: 'D014'
  }


  {
    name: 'visit-preview'
    element: 'page-visit-preview'
    windowTitlePostfix: 'Visit Preview'
    headerTitle: 'Visit Preview'
    preload: true
    hrefList: [ 'visit-preview' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: true
    hideAd: false
    showPrintButton: true
    showToolbar: false
    hideHeaderTitle: true
    accessId: 'D014'
  }

  {
    name: 'discharge-note'
    element: 'page-discharge-note'
    windowTitlePostfix: 'Discharge Summary'
    headerTitle: 'Discharge Summary'
    preload: true
    hrefList: [ 'discharge-note' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D014'
  }

  {
    name: 'test-other'
    element: 'page-test-other-editor'
    windowTitlePostfix: 'Other Test'
    headerTitle: 'Other Test'
    preload: true
    hrefList: [ 'other-test' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'test-blood-sugar'
    element: 'page-test-blood-sugar-editor'
    windowTitlePostfix: 'Blood Sugar'
    headerTitle: 'Blood Sugar'
    preload: true
    hrefList: [ 'test-blood-sugar' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'settings'
    element: 'page-settings'
    windowTitlePostfix: 'Settings'
    headerTitle: 'Settings'
    preload: true
    hrefList: [ 'settings' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showSaveButton: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'next-visit'
    element: 'page-visit-next-visit-editor'
    windowTitlePostfix: 'Next Visit'
    headerTitle: 'Next Visit'
    preload: true
    hrefList: [ 'next-visit' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'patient-vitals-editor'
    element: 'page-patient-vitals-editor'
    windowTitlePostfix: 'Vitals'
    headerTitle: 'Vitals'
    preload: true
    hrefList: [ 'patient-vitals-editor' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'page-attachement-preview'
    element: 'page-attachement-preview'
    windowTitlePostfix: 'Test Results'
    headerTitle: 'Test Results'
    preload: true
    hrefList: [ 'attachement-preview' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: true
    hideAd: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'notification-panel'
    element: 'page-notification-panel'
    windowTitlePostfix: 'Notfication Panel'
    headerTitle: 'Notfication Panel'
    preload: true
    hrefList: [ 'notification-panel' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    hideHeaderTitle: false
    accessId: 'D011'
  }

  {
    name: 'visit-invoice'
    element: 'page-visit-invoice'
    windowTitlePostfix: 'Visit Invoice'
    headerTitle: 'Invoice'
    preload: true
    hrefList: [ 'visit-invoice' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'invoice-manager'
    element: 'page-invoice-manager'
    windowTitlePostfix: 'Invoice Manager'
    headerTitle: 'Invoice Manager'
    preload: true
    hrefList: [ 'invoice-manager' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showSaveButton: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'D007'
  }

  {
    name: 'print-invoice'
    element: 'page-print-invoice'
    windowTitlePostfix: 'print Invoice'
    headerTitle: 'Invoice'
    preload: true
    hrefList: [ 'print-invoice' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'foc-admin-panel'
    element: 'page-foc-admin-panel'
    windowTitlePostfix: 'Free Of Charge Admin Panel'
    headerTitle: 'Free Of Charge Admin Panel'
    preload: true
    hrefList: [ 'foc-admin-panel' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showSaveButton: false
    showOrganizationsName: true
    showToolbar: false
    hideHeaderTitle: false
    accessId: 'D010'
  }  

  {
    name: 'welcome'
    element: 'page-welcome'
    windowTitlePostfix: 'Welcome'
    headerTitle: 'Welcome'
    preload: true
    hrefList: [ 'welcome' ]
    requireAuthentication : false
    headerType: 'normal'
    leftMenuEnabled: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'none'
  }
  {
    name: 'welcome-internal'
    element: 'page-welcome-internal'
    windowTitlePostfix: 'Welcome'
    headerTitle: 'Welcome'
    preload: true
    hrefList: [ 'welcome-internal' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showPatientsDetails: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'dev-tools'
    element: 'dev-tools'
    windowTitlePostfix: 'Dev Tools'
    headerTitle: 'Dev Tools'
    preload: true
    hrefList: [ 'dev-tools' ]
    requireAuthentication : false
    headerType: 'normal'
    showPatientsDetails: false
    leftMenuEnabled: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'print-preview'
    element: 'page-print-preview'
    windowTitlePostfix: 'Print Preview'
    headerTitle: 'Print Preview'
    preload: true
    hrefList: [ 'print-preview' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    hideAd: false
    hideHeaderTitle: false
    accessId: 'none'
    showToolbar: false
  }

  {
    name: 'preview-preconception-record'
    element: 'page-preview-preconception-record'
    windowTitlePostfix: 'Preview Preconception Record'
    headerTitle: 'Preview Preconception Record'
    preload: true
    hrefList: [ 'preview-preconception-record' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    hideAd: false
    hideHeaderTitle: false
    accessId: 'none'

  }

  {
    name: 'temp-pcc-record-list'
    element: 'page-temp-pcc-record-list'
    windowTitlePostfix: 'Untrackable pcc record list'
    headerTitle: 'Untrackable pcc record list'
    preload: true
    hrefList: [ 'temp-pcc-record-list' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    hideAd: false
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'preview-ndr'
    element: 'page-preview-ndr'
    windowTitlePostfix: 'Preview NDR Record'
    headerTitle: 'Preview NDR Record'
    preload: true
    hrefList: [ 'preview-ndr' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPatientsDetails: false
    hideAd: false
    hideHeaderTitle: false
    accessId: 'none'

  }

  

  {
    name: 'print-symptoms'
    element: 'page-print-symptoms'
    windowTitlePostfix: 'Print Symptoms'
    headerTitle: 'Print Symptoms'
    preload: true
    hrefList: [ 'print-symptoms' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showPrintButton: true
    showPatientsDetails: false
    hideAd: true
    hideHeaderTitle: false
    accessId: 'none'
  }

  {
    name: 'pcc-reports'
    element: 'page-pcc-reports'
    windowTitlePostfix: 'PCC Reports'
    headerTitle: 'Preconception Reports'
    preload: true
    hrefList: [ 'pcc-reports' ]
    requireAuthentication : true
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
  },

  {
    name: 'ndr-record-list'
    element: 'page-ndr-record-list'
    windowTitlePostfix: 'View NDR Records'
    headerTitle: 'View NDR Records'
    preload: true
    hrefList: [ 'ndr-record-list' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
  }

  {
    name: 'nwdr-reports'
    element: 'page-nwdr-reports'
    windowTitlePostfix: 'NWDR Reports'
    headerTitle: 'NWDR Reports'
    preload: true
    hrefList: [ 'nwdr-reports' ]
    requireAuthentication : false
    headerType: 'normal'
    leftMenuEnabled: true
    showPatientsDetails: false
    showToolbar: false
    hideHeaderTitle: false
  }

  {
    name: 'test-results'
    element: 'page-test-results-editor'
    windowTitlePostfix: 'Test Results'
    headerTitle: 'Test Results'
    preload: true
    hrefList: [ 'test-results' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showToolbar: false
    showSaveButton: true
    showPatientsDetails: false
    accessId: 'none'
    hideHeaderTitle: false
  }

  {
    name: 'single-test-result-print'
    element: 'page-single-test-result-print'
    windowTitlePostfix: 'Test Result Print'
    headerTitle: 'Test Result Print'
    preload: true
    hrefList: [ 'single-test-result-print' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showToolbar: false
    showPatientsDetails: false
    showPrintButton: true
    accessId: 'none'
    hideHeaderTitle: false
  }

  {
    name: 'quick-patient-medical-info-preview'
    element: 'page-quick-patient-medical-info-preview'
    windowTitlePostfix: 'Patient Quick Info'
    headerTitle: 'Patient Quick Info'
    preload: true
    hrefList: [ 'patient-quick-info' ]
    requireAuthentication : true
    headerType: 'modal'
    leftMenuEnabled: false
    showSaveButton: false
    showToolbar: false
    showPatientsDetails: false
    showPrintButton: true
    accessId: 'none'
    hideHeaderTitle: false
  }

]

app.pages.error404 = {
  name: '404'
  element: 'page-error-404'
  windowTitlePostfix: 'Not Found'
  headerTitle: '404 Not Found'
  preload: true
  href: [ '/404' ]
  requireAuthentication : false
  headerType: 'normal'
  leftMenuEnabled: true
}
