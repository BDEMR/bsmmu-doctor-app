
Polymer {

  is: 'dynamic-element-root'

  properties:
    categoryTabSelectedIndex:
      type: Number
      notify: true
      # value: 0
    def:
      type: Object
      value: null
    data:
      type: Object
      value: null
    currentCategory:
      type: Object
      value: null
    currentCategoryData:
      type: Object
      value: null
    isSystemReady:
      type: Boolean
      value: false

  observers: [
    'systemChanged(def, data)'
    'categoryTabSelectedIndexChanged(categoryTabSelectedIndex)'
  ]

  systemChanged: (def, data)->
    @isSystemReady = false
    return unless def and data
    @isSystemReady = true
    @tryRememberingPreviousCategory()

  categoryTabSelected: (e)->
    ## get current category
    currentCategory = @def.childList[@categoryTabSelectedIndex]

    unless 'childMap' of @data
      @data.childMap = {}
      @data.forKey = 'systemRoot'
      @data.forType = 'systemRoot'

    ## make room for category data
    unless currentCategory.key of @data.childMap
      @data.childMap[currentCategory.key] = {
        forType: 'category'
        forKey: currentCategory.key
        childMap: {}
      }
    currentCategoryData = @data.childMap[currentCategory.key]

    ## set
    @set 'currentCategoryData', currentCategoryData
    @set 'currentCategory', currentCategory

  debugPressed: ->
    console.log @data

  attached: ->
    @tryRememberingPreviousCategory()

  tryRememberingPreviousCategory: ->
    if @domHost
      identifier = 'LAST-TAB-INDEX-OF-' + @domHost.nodeName
      if value = sessionStorage.getItem identifier
        @categoryTabSelectedIndex = null
        @categoryTabSelectedIndex = parseInt value
        return
      return
    @categoryTabSelectedIndex = null
    @categoryTabSelectedIndex = 0

  categoryTabSelectedIndexChanged: ->
    return unless @domHost
    return if @categoryTabSelectedIndex is null
    identifier = 'LAST-TAB-INDEX-OF-' + @domHost.nodeName
    sessionStorage.setItem identifier, @categoryTabSelectedIndex

  $loadGenericCategoryElement: (category)->
    unless category.isCustomCategory
      insertionPoint = @$$('.element-insertion-point')
      newElement = document.createElement 'de-category'
      newElement.data = @currentCategoryData
      newElement.def = @currentCategory
      if Polymer.dom(insertionPoint).firstChild
        Polymer.dom(insertionPoint).firstChild.remove()
      Polymer.dom(insertionPoint).appendChild newElement

  $loadCustomCategoryElement: (category)->
    if category.isCustomCategory
      categoryTabSelectedIndex = @categoryTabSelectedIndex
      insertionPoint = @$$('.element-insertion-point')
      @importHref ("elements/#{category.customElementName}/#{category.customElementName}.html"), (e) ->
        newElement = document.createElement category.customElementName
        ## IMPROVE - Could use untangled bindings
        currentCategoryData = @data.childMap[category.key]

        if category.key is 'graph'
          recordingStartTime = @domHost.record.content.opCommon.recordingStartTime
          # recordingEffectiveEndTime = @domHost.record.content.opCommon.recordingStartTime
          recordingEffectiveEndTime = @domHost.record.content.opCommon.recordingEndTime
          newElement.setTimeRange recordingStartTime, recordingEffectiveEndTime

          clockDatetimeStamp = @domHost.clockDatetimeStamp
          newElement.setCurrentTime clockDatetimeStamp

          enforceContinuousBindings = =>
            if categoryTabSelectedIndex is @categoryTabSelectedIndex
              newElement.setCurrentTime @domHost.clockDatetimeStamp
              setTimeout enforceContinuousBindings, 500
          enforceContinuousBindings()

          newElement.startTimeOutOfBoundCallback = (recordingStartTime)=>
            if categoryTabSelectedIndex is @categoryTabSelectedIndex
              @domHost.record.content.opCommon.recordingStartTime = recordingStartTime

          newElement.endTimeOutOfBoundCallback = (recordingEndTime)=>
            if categoryTabSelectedIndex is @categoryTabSelectedIndex
              @domHost.record.content.opCommon.recordingEndTime = recordingEndTime

          unless 'pointList' of currentCategoryData
            currentCategoryData.pointList = []

          newElement.setPointList currentCategoryData.pointList

          newElement.pointListUpdateCallback = (pointList)=>
            if categoryTabSelectedIndex is @categoryTabSelectedIndex
              currentCategoryData.pointList = pointList

          unless 'additionalData' of currentCategoryData
            currentCategoryData.additionalData = {}

          newElement.setAdditionalData currentCategoryData.additionalData

        else if category.key is 'timeline'
          recordingStartTime = @domHost.record.content.opCommon.recordingStartTime
          recordingEffectiveEndTime = @domHost.record.content.opCommon.recordingEndTime
          # console.log (new Date recordingStartTime), new Date recordingEffectiveEndTime
          newElement.setTimeRange recordingStartTime, recordingEffectiveEndTime

          clockDatetimeStamp = @domHost.clockDatetimeStamp
          newElement.setCurrentTime clockDatetimeStamp

          enforceContinuousBindings = =>
            if categoryTabSelectedIndex is @categoryTabSelectedIndex
              newElement.setCurrentTime @domHost.clockDatetimeStamp
              setTimeout enforceContinuousBindings, 500
          enforceContinuousBindings()

          unless 'medicineRowHeaderList' of currentCategoryData
            currentCategoryData.medicineRowHeaderList = []

          newElement.setMedicineRowHeaderList currentCategoryData.medicineRowHeaderList

          unless 'medicineDataGridMap' of currentCategoryData
            currentCategoryData.medicineDataGridMap = {}

          newElement.setMedicineDataGridMap currentCategoryData.medicineDataGridMap

          unless 'measurementRowHeaderList' of currentCategoryData
            currentCategoryData.measurementRowHeaderList = []

          newElement.setMeasurementRowHeaderList currentCategoryData.measurementRowHeaderList

          unless 'measurementDataGridMap' of currentCategoryData
            currentCategoryData.measurementDataGridMap = {}

          newElement.setMeasurementDataGridMap currentCategoryData.measurementDataGridMap

          unless 'additionalData' of currentCategoryData
            currentCategoryData.additionalData = {}

          newElement.setAdditionalData currentCategoryData.additionalData

        else if category.key is 'fluidBalance'

          clockDatetimeStamp = @domHost.clockDatetimeStamp
          newElement.setCurrentTime clockDatetimeStamp

          enforceContinuousBindings = =>
            if categoryTabSelectedIndex is @categoryTabSelectedIndex
              newElement.setCurrentTime @domHost.clockDatetimeStamp
              setTimeout enforceContinuousBindings, 500
          enforceContinuousBindings()

          unless 'fbData' of currentCategoryData
            currentCategoryData.fbData = {}

          newElement.setFbData currentCategoryData.fbData

        ## -
        if Polymer.dom(insertionPoint).firstChild
          Polymer.dom(insertionPoint).firstChild.remove()
        Polymer.dom(insertionPoint).appendChild newElement

  propagateDynamicDataAlterationSignal: (action, path)->
    path.unshift '<root>'
    @domHost.dynamicDataAltered action, path


}
