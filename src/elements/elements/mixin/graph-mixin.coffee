

window.__SOURAV_MIXIN_graphMixin = {

  _generatePointList_temperature: ->
    pointList = []

    for item, index in @matchingVitalTemperatureList
      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.temperature
        key: 'CVP'
        extraDataObject: {}
      }
      pointList.push point

    return pointList

  _generatePointList_oxygenSaturation: ->
    pointList = []

    for item, index in @matchingVitalSpO2List
      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.spO2Percentage
        key: 'CVP'
        extraDataObject: {}
      }
      pointList.push point

    return pointList

  _generatePointList_respiratoryRate: ->
    pointList = []

    for item, index in @matchingVitalRespiratoryRateList
      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.respiratoryRate
        key: 'CVP'
        extraDataObject: {}
      }
      pointList.push point

    return pointList

  _generatePointList_bmi: ->
    pointList = []

    # return console.log @bmiList

    for item, index in @matchingVitalBMIList
      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.height
        key: 'Vapor'
        extraDataObject: {}
      }
      pointList.push point

      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.weight
        key: 'CVP'
        extraDataObject: {}
      }
      pointList.push point

      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.calculatedBMI
        key: 'Pulse'
        extraDataObject: {}
      }
      pointList.push point

    return pointList

  _generatePointList_heartRate: ->
    pointList = []

    # console.log @matchingVitalPulseRateList

    for item, index in @matchingVitalPulseRateList
      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.bpm
        key: 'Pulse'
        extraDataObject: {}
      }
      pointList.push point

    return pointList

  _generatePointList_bloodPressure: ->
    pointList = []

    for item, index in @matchingVitalBloodPressureList
      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.diastolic
        key: 'BPD'
        extraDataObject: {}
      }
      pointList.push point

      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.systolic
        key: 'BPS'
        extraDataObject: {}
      }
      pointList.push point

    return pointList

  _generatePointList_bloodSugar: ->
    pointList = []

    for item, index in @matchingTestBloodSugarList

      switch item.data.type
        when 'after-meal'
          magnitude = item.data.value
          key = "Vapor"
        when 'before-meal'
          magnitude = item.data.value
          key = "CVP"
        when 'random'
          magnitude = item.data.value
          key = "Pulse"

      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt magnitude
        key: key
        extraDataObject: {}
      }
      pointList.push point

      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.systolic
        key: 'BPS'
        extraDataObject: {}
      }
      pointList.push point

    return pointList
  
  _generatePointList_otherTest: ->
    pointList = []

    console.log @matchingOtherTestList

    for item, index in @matchingOtherTestList
      point = {
        originalCreatedDatetimeStamp: item.createdDatetimeStamp
        datetimeStamp: (2 + index * 5) * 1000 * 60
        magnitude: parseInt item.data.result
        key: 'Pulse'
        extraDataObject: {}
      }
      pointList.push point

    return pointList

  showGraphPressed: (e)->
    # 5 = Test Results
    # 3 = Vitals
    return unless @selectedSubViewIndex is 5 or @selectedSubViewIndex is 3
    
    if @selectedSubViewIndex is 5
      if @selectedTestPage is 0
        pointList = @_generatePointList_bloodSugar()
      else if @selectedTestPage is 1
        pointList = @_generatePointList_otherTest()

      parentEl = @$$('.element-insertion-point2')
      for child in (Array.from parentEl.childNodes)
        parentEl.removeChild child

    else if @selectedSubViewIndex is 3
      if @selectedVitalPage is 0
        pointList = @_generatePointList_bloodPressure()
      else if @selectedVitalPage is 1
        pointList = @_generatePointList_heartRate()
      else if @selectedVitalPage is 2
        pointList = @_generatePointList_bmi()
      else if @selectedVitalPage is 3
        pointList = @_generatePointList_respiratoryRate()
      else if @selectedVitalPage is 4
        pointList = @_generatePointList_oxygenSaturation()
      else if @selectedVitalPage is 5
        pointList = @_generatePointList_temperature()
      
      parentEl = @$$('.element-insertion-point')
      for child in (Array.from parentEl.childNodes)
        parentEl.removeChild child        

    maxMagnitude = 1
    start = (new Date).getTime()
    end = (new Date).getTime() + (24 * 60 * 60 * 1000)    
    for point in pointList
      if point.magnitude > maxMagnitude
        maxMagnitude = point.magnitude  
      if point.originalCreatedDatetimeStamp < start
        start = point.originalCreatedDatetimeStamp
      if point.originalCreatedDatetimeStamp > end
        end = point.originalCreatedDatetimeStamp
    
    ## Comment out to get per page
    # for point in pointList
    #   point.datetimeStamp = point.originalCreatedDatetimeStamp - start

    el = document.createElement 'custom-graph'

    el.setTimeRange start, end

    el.setCurrentTime start
     
    el.yAxisMaxValue = Math.ceil (maxMagnitude + 0* (10 * maxMagnitude / 100))

    el.setPointList pointList

    el.computeExternalOptions()

    parentEl.appendChild el

    # el.scrollIntoView()


}

