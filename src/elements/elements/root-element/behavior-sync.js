if (!app.behaviors.local['root-element']) {
  app.behaviors.local['root-element'] = {};
}
app.behaviors.local['root-element'].newSync = {

  _getLastSyncedDatetimeStamp() { return parseInt(window.localStorage.getItem('lastSyncedDatetimeStamp')) || 0; },

  _updateLastSyncedDatetimeStamp() { return window.localStorage.setItem('lastSyncedDatetimeStamp', lib.datetime.now()); },

  _getModifiedDataFromDB(collectionNameList, lastSyncedDatetimeStamp) {
    return collectionNameList.reduce((list, clientCollectionName) => {
      const docList = app.db.find(clientCollectionName, ({ lastModifiedDatetimeStamp }) => lastModifiedDatetimeStamp > lastSyncedDatetimeStamp);
      const docListWithClientCollectionName = docList.map(doc => {
        doc.clientCollectionName = clientCollectionName;
        return doc;
      });
      return list.concat(docListWithClientCollectionName);
    }, [])
  },


  _newSync(cbfn) {

    const collectionNameMap = {
      'bdemr--doctor-favorite-medications': 'favorite-medicine-list',
      'favorite-advised-test': 'favorite-advised-test',
      'user-favorite-symptom': 'user-favorite-symptom',
      'user-favorite-note': 'user-favorite-note',
      'user-favorite-examination': 'user-favorite-examination',
      'user-added-institution-list': 'user-added-institution-list',
      'visited-patient-log': 'visited-patient-log',
      'user-custom-symptoms': 'custom-symptoms-list',
      'user-custom-examination': 'custom-examination-list',
      'bdemr--doctor-visit': 'doctor-visit',
      'bdemr--visit-prescription': 'visit-prescription',
      'bdemr--patient-medications': 'patient-medications',
      'bdemr--doctor-notes': 'visit-note',
      'bdemr--visit-next-visit': 'visit-next-visit',
      'bdemr--visit-advised-test': 'visit-advised-test',
      'bdemr--visit-examination': 'visit-examination',
      'bdemr--visit-identified-symptoms': 'visit-identified-symptoms',
      'custom-investigation-list': 'custom-investigation-list',
      'bdemr--anaesmon-record': 'anaesmon-record',
      'bdemr--patient-test-results': 'patient-test-results',
      'bdemr--patient-stay': 'visit-patient-stay',
      'history-and-physical-record': 'history-and-physical-record',
      'diagnosis-record': 'diagnosis-record',
      'bdemr--vital-blood-pressure': 'patient-vitals-blood-pressure',
      'bdemr--vital-bmi': 'patient-vitals-bmi',
      'bdemr--vital-pulse-rate': 'patient-vitals-pulse-rate',
      'bdemr--vital-respiratory-rate': 'patient-vitals-respiratory-rate',
      'bdemr--vital-temperature': 'patient-vitals-temperature',
      'bdemr--vital-spo2': 'patient-vitals-spo2',
      'bdemr--test-blood-sugar': 'patient-test-blood-sugar',
      'bdemr--other-test': 'patient-test-other',
      'bdemr--comment-patient': 'comment-patient',
      'bdemr--comment-doctor': 'comment-doctor',
      'bdemr--patient-gallery--online-attachment': 'patient-gallery--online-attachment',
      'bdemr--user-activity-log': 'activity',
      'bdemr--visit-invoice': 'visit-invoice',
      'bdemr--visit-diagnosis': 'visit-diagnosis',
      'bdemr--clinic-operation-list': 'ot-management',
      'bdemr--pcc-records': 'pcc-records',
      'bdemr--ndr-records': 'ndr-records'
    };

    const deleteCollectionNameMap = {
      'bdemr--doctor-favorite-medications--deleted': 'favorite-medicine-list--deleted',
      'favorite-advised-test--deleted': 'favorite-advised-test--deleted',
      'user-favorite-symptom--deleted': 'user-favorite-symptom--deleted',
      'user-favorite-note--deleted': 'user-favorite-note--deleted',
      'user-favorite-examination--deleted': 'user-favorite-examination--deleted',
      'user-added-institution-list--deleted': 'user-added-institution-list--deleted',
      'visited-patient-log--deleted': 'visited-patient-log--deleted',
      'user-custom-symptoms--deleted': 'custom-symptoms-list--deleted',
      'user-custom-examination--deleted': 'custom-examination-list--deleted',
      'bdemr--doctor-visit--deleted': 'doctor-visit--deleted',
      'bdemr--visit-prescription--deleted': 'visit-prescription--deleted',
      'bdemr--patient-medications--deleted': 'patient-medications--deleted',
      'bdemr--doctor-notes--deleted': 'visit-note--deleted',
      'bdemr--next-visit--deleted': 'visit-next-visit--deleted',
      'bdemr--visit-advised-test--deleted': 'visit-advised-test--deleted',
      'bdemr--visit-examination--deleted': 'visit-examination--deleted',
      'bdemr--visit-identified-symptoms--deleted': 'visit-identified-symptoms--deleted',
      'custom-investigation-list--deleted': 'custom-investigation-list--deleted',
      'bdemr--anaesmon-record--deleted': 'anaesmon-record--deleted',
      'bdemr--patient-test-results--deleted': 'patient-test-results--deleted',
      'bdemr--patient-stay--deleted': 'visit-patient-stay--deleted',
      'history-and-physical-record--deleted': 'history-and-physical-record--deleted',
      'diagnosis-record--deleted': 'diagnosis-record--deleted',
      'bdemr--vital-blood-pressure--deleted': 'patient-vitals-blood-pressure--deleted',
      'bdemr--vital-bmi--deleted': 'patient-vitals-bmi--deleted',
      'bdemr--vital-pulse-rate--deleted': 'patient-vitals-pulse-rate--deleted',
      'bdemr--respiratory-pulse-rate--deleted': 'patient-vitals-respiratory-rate--deleted',
      'bdemr--vital-temperature--deleted': 'patient-vitals-temperature--deleted',
      'bdemr--test-blood-sugar--deleted': 'patient-test-blood-sugar--deleted',
      'bdemr--vital-spo2--deleted': 'patient-vitals-spo2--deleted',
      'bdemr--other-test--deleted': 'patient-test-other--deleted',
      'bdemr--comment-patient--deleted': 'comment-patient--deleted',
      'bdemr--comment-doctor--deleted': 'comment-doctor--deleted',
      'bdemr--patient-gallery--online-attachment--deleted': 'patient-gallery--online-attachment--deleted',
      'bdemr--user-activity-log--deleted': 'activity--deleted',
      'bdemr--visit-invoice--deleted': 'visit-invoice--deleted',
      'bdemr--visit-diagnosis--deleted': 'visit-diagnosis--deleted',
      'bdemr--clinic-operation-list--deleted': 'ot-management--deleted',
      'bdemr--pcc-records--deleted': 'pcc-records--deleted',
      'bdemr--ndr-records--deleted': 'ndr-records--deleted'
    }

    const lastSyncedDatetimeStamp = this._getLastSyncedDatetimeStamp();
    const organizationId = this.getCurrentOrganization().idOnServer;
    const patientList = app.db.find('patient-list');
    const knownPatientSerialList = patientList.map((patient) => patient.serial);
    const { apiKey } = this.getCurrentUser();

    const collectionNameList = Object.keys(collectionNameMap).map(serverCollectionName => collectionNameMap[serverCollectionName]);
    const deletedCollectionNameList = Object.keys(deleteCollectionNameMap).map(serverCollectionName => deleteCollectionNameMap[serverCollectionName]);

    const clientToServerDocList = this._getModifiedDataFromDB(collectionNameList, lastSyncedDatetimeStamp);
    const removedDocList = this._getModifiedDataFromDB(deletedCollectionNameList, lastSyncedDatetimeStamp);

    const data = {
      apiKey,
      organizationId,
      knownPatientSerialList,
      lastSyncedDatetimeStamp,
      clientToServerDocList,
      removedDocList,
      client: 'doctor'
    };


    this.callApi('/bdemr--sync', data, (err, response) => {

      if (err) {
        return cbfn(err)
      }
      else if (response.hasError) {
        return cbfn(response.error.message);
      } else {

        let { serverToClientItems, serverToClientDeletedItems } = response.data;
        // let serverToClientItems = response.data;

        if (serverToClientItems.length) {
          app.db.__allowCommit = false;
          for (let index = 0; index < serverToClientItems.length; index++) {
            var item = serverToClientItems[index];
            const collectionName = collectionNameMap[item.collection];
            if (!collectionName) continue;
            delete item.collection;
            if (index === (serverToClientItems.length - 1)) {
              app.db.__allowCommit = true;
            }
            if (collectionName) {
              app.db.upsert(collectionName, item, ({ serial }) => item.serial === serial);
            }
          }
          app.db.__allowCommit = true;
        }

        // Deleted Docs from Server
        if (serverToClientDeletedItems.length) {
          serverToClientDeletedItems.forEach((item) => {
            const deletedCollectionName = deleteCollectionNameMap[item.collection];
            if (!deletedCollectionName) return;
            const collectionName = deletedCollectionName.split('--')[0]
            let docList = app.db.find(collectionName, ({ serial }) => serial == item.serial);
            console.log(docList)
            if (docList.length) app.db.remove(collectionName, docList[0]._id);
          })
        }

        this._updateLastSyncedDatetimeStamp();

        return cbfn();
      }
    });
  }
};
