
staticData = null

cbfnQueue = []

unless app.behaviors.local['root-element']
  app.behaviors.local['root-element'] = {} 
app.behaviors.local['root-element'].dataLoader = 

  loadStaticData: ->
    @requestForLoadingStaticData()

  getStaticData: (name, cbfn)->
    unless name of staticData
      throw new Error 'Unknown static data "' + name + '" requested'

    if staticData[name] isnt null
      lib.util.setImmediate cbfn, staticData[name]
    else
      cbfnQueue.push {
        cbfn: cbfn
        name: name
      }

  afterLoadingStaticData: (collectedData)->
    staticData = collectedData

    for item in cbfnQueue
      lib.util.setImmediate item.cbfn, staticData[item.name]
  
  requestForLoadingStaticData: ->

    staticDataListLocal = [
      # {
      #   name: 'hospitalList'
      #   url: 'static-data/hospital-list.json'
      # }
      {
        name: 'investigationList'
        url: 'static-data/investigation-list.json'
      }
      {
        name: 'symptomsList'
        url: 'static-data/symptoms-list.json'
      }

      {
        name: 'examinationList'
        url: 'static-data/examination-list.json'
      }

      {
        name: 'medicineList'
        url: 'static-data/medicine-list.json'
      }

      {
        name: 'pccMedicineList'
        url: 'static-data/pcc-medicine-list.json'
      }
      # {
      #   name: 'doseGuidelineList'
      #   url: 'static-data/dose-guideline-list.json'
      # }
      # {
      #   name: 'medicineCompositionList'
      #   url: 'static-data/medicine-composition-list.json'
      # }
      {
        name: 'operationList'
        url: 'static-data/operation-list.json'
      }
      {
        name: 'diagnosisList'
        url: 'static-data/diagnosis-list.json'
      }
      {
        name: 'dynamicElementDefinitionPostoperativeAssessment'
        url: 'static-data/de-def-postop-assessment.json'
      }
      {
        name: 'dynamicElementDefinitionOperationAnaesthesia'
        url: 'static-data/de-def-op-anaesthesia.json'
      }
      {
        name: 'dynamicElementDefinitionOperationSurgery'
        url: 'static-data/de-def-op-surgery.json'
      }
      # {
      #   name: 'dynamicElementDefinitionPostoperativeAnalysis'
      #   url: 'static-data/de-def-postop-analysis.json'
      # }
      {
        name: 'dynamicElementDefinitionPreoperativeAssessment'
        url: 'static-data/de-def-doctor-app-history-and-physical-examination.json'
      }
    ]

    staticDataListProduction = [
      {
        name: 'investigationList'
        url: 'https://bdemr.b-cdn.net/investigation-list-8-11-2017.json'
      }
      {
        name: 'symptomsList'
        url: 'https://bdemr.b-cdn.net/symptoms-list-25-10-2017.json'
      }
      {
        name: 'examinationList'
        url: 'https://bdemr.b-cdn.net/examination-list-25-10-2017.json'
      }
      {
        name: 'medicineList'
        url: 'https://bdemr.b-cdn.net/medicine-list-19-10-2017.json'
      }
      {
        name: 'operationList'
        url: 'https://bdemr.b-cdn.net/operation-list-19-10-2017.json'
      }
      {
        name: 'diagnosisList'
        url: 'https://bdemr.b-cdn.net/diagnosis-list-19-10-2017.json'
      }
      {
        name: 'dynamicElementDefinitionPostoperativeAssessment'
        url: 'https://bdemr.b-cdn.net/de-def-postop-assessment-19-10-2017.json'
      }
      {
        name: 'dynamicElementDefinitionOperationAnaesthesia'
        url: 'https://bdemr.b-cdn.net/de-def-op-anaesthesia-19-10-2017.json'
      }
      {
        name: 'dynamicElementDefinitionOperationSurgery'
        url: 'https://bdemr.b-cdn.net/de-def-op-surgery-22-10-2017.json'
      }
      {
        name: 'dynamicElementDefinitionPreoperativeAssessment'
        url: 'https://bdemr.b-cdn.net/de-def-doctor-app-history-and-physical-examination-10-12-2017.json'
      }
      {
        name: 'pccMedicineList'
        url: 'https://bdemr.b-cdn.net/pcc-medicine-list-19-02-2018.json'
      }
    ]

    if (app.mode is 'production') and (app.config.clientPlatform is 'web')
      staticDataList = staticDataListProduction
    else
      staticDataList = staticDataListLocal

    staticData = {}
    for item in staticDataList
      staticData[item.name] = null

    collection1 = new lib.util.Collector staticDataList.length

    it = new lib.util.Iterator staticDataList

    it.forEach (next, index, item)=>
      id = @notifyDownloadAction 'start', item.url
      successFn = lib.network.ensureBaseNetworkDelay => @notifyDownloadAction 'done', item.url, id
      lib.network.request item.url, 'GET', { fromApp: "#{app.config.clientIdentifier}-#{app.config.clientVersion}" }, (errorResponse, response)=>
        if errorResponse
          # alert 'xhr error'
          # console.log errorResponse
          @notifyDownloadAction 'error', item.url, id
          return

        successFn()
        json = JSON.parse response.target.responseText
        collection1.collect item.name, json
      next()

    it.finally -> null

    collection1.finally (collectedData)=> 
      @afterLoadingStaticData collectedData



