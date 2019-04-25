
Polymer {

  is: 'custom-graph'

  $keys: (object)-> Object.keys object

  $of: (object, key)-> object[key]

  $shouldShowButtonOnUI: (pointDefinition, pointDefinitionKey)->
    return pointDefinition[pointDefinitionKey].showButtonOnUI

  $getLabel: (pointDefinition, pointDefinitionKey)->
    return pointDefinitionKey

  $isDefinitionSelected: (pointDefinitionKey, selectedPointDefinitionKey)->
    return pointDefinitionKey is selectedPointDefinitionKey

  $isMoveButton: (pointDefinition, pointDefinitionKey)->
    return ('special' of pointDefinition[pointDefinitionKey] and pointDefinition[pointDefinitionKey].special is 'move')

  $isDeleteButton: (pointDefinition, pointDefinitionKey)->
    return ('special' of pointDefinition[pointDefinitionKey] and pointDefinition[pointDefinitionKey].special is 'delete')

  $isNormalButton: (pointDefinition, pointDefinitionKey)->
    return not ('special' of pointDefinition[pointDefinitionKey])

  toImageUrl: ->
    @$.canvas.toDataURL()

  _clipRawLocalCoords: (x, y)->
    boundLeft = 30 - 1
    boundBottom = 30 - 1
    boundRight = boundLeft + @xIntervalGapWidthPx * @xIntervalLineCount
    boundTop =  boundBottom + @yIntervalGapWidthPx * @yIntervalLineCount
    y = @flip y
    x = if boundLeft < x < boundRight then x - boundLeft else NaN
    y = if boundBottom < y < boundTop then y - boundBottom else NaN
    return [ x, y ]

  _translateToLocalCoords: (x, y)->

    canvas = @$.canvas

    rect = canvas.getBoundingClientRect()

    cw = canvas.width
    ch = canvas.height

    sx = cw / canvas.offsetWidth
    sy = ch / canvas.offsetHeight

    mx = x
    my = y

    mx = mx - rect.left
    my = my - rect.top

    mx = mx
    my = my

    mx = Math.floor (mx * sx)
    my = Math.floor (my * sy)

    return [ mx, my ]

  _unclipAndTranslateToPx: (x, y)->

    boundLeft = 30 - 1
    boundBottom = 30 - 1
    boundRight = boundLeft + @xIntervalGapWidthPx * @xIntervalLineCount
    boundTop =  boundBottom + @yIntervalGapWidthPx * @yIntervalLineCount
    x = x + boundLeft
    y = y + boundBottom
    y = @flip y

    canvas = @$.canvas

    cw = canvas.width
    ch = canvas.height

    sx = cw / canvas.offsetWidth
    sy = ch / canvas.offsetHeight

    x = x / sx
    y = y / sy

    return [ x, y ]

  properties:

    # flags
    shouldRender:
      type: Boolean
      value: false
    isLive:
      type: Boolean
      value: true
    isPrintOnly:
      type: Boolean
      value: false
    isAutoInsertEnabled:
      type: Boolean
      notify: true
      value: false
    isExpressDeleteEnabled:
      type: Boolean
      notify: true
      value: false

    # external
    clockDatetimeStamp: 
      type: Number
      value: 0
    startDatetimeStamp:
      type: Number
      value: 0
    startOffsetDatetimeStamp:
      type: Number
      value: 0
    endDatetimeStamp:
      type: Number
      value: 0
    endOffsetDatetimeStamp:
      type: Number
      value: 0

    # data
    pointList:
      type: Array
      # value: -> []

    # configurable
    patientPositionList:
      type: Array
      value: -> [
        'Supine'
        'Lithotomy'
        'Prone'
        'Beach Chair'
        'Trendelenberg'
        'R Trendelenberg'
        'Rt Lateral'
        'Lt Lateral'
        'Fracture Table'
      ]

    pointDefinitionKeyList: 
      type: Array
      value: -> [
        'Move'
        'Marker'
        'BPS'
        'BPD'
        'BPM'
        'CVP'
        'Pulse'
        'Vapor'
        'Position'
        'Delete'
        'Anaesthesia Start'
        'Anaesthesia End'
        'Surgery Start'
        'Surgery End'
      ]
    pointDefinition:
      type: Object
      value: -> {
        'Move':
          special: 'move'
          shape: 'box'
          fillStyle: "rgba(0,255,0, 0.3)"
          showLines: false
          autoInsert: false
          boxLength: 5
          showButtonOnUI : true
        'Delete':
          special: 'delete'
          shape: 'box'
          fillStyle: "rgba(0,255,0, 0.3)"
          showLines: false
          autoInsert: false
          boxLength: 5
          showButtonOnUI : true
        'Marker':
          shape: 'box'
          fillStyle: "rgba(0,255,0, 0.3)"
          showLines: false
          autoInsert: false
          boxLength: 5
          showButtonOnUI : true
        'Anaesthesia Start':
          shape: 'image'
          fillStyle: "rgb(255,0,0)"
          showLines: false
          autoInsert: false
          imageSource: 'assets/img/graph-a-start.png'
          imageObject: null
          imageYOrigin: 'bottom'
          preventDelete: true
          showButtonOnUI : true
        'Anaesthesia End':
          shape: 'image'
          fillStyle: "rgb(255,0,0)"
          showLines: false
          autoInsert: false
          imageSource: 'assets/img/graph-a-end.png'
          imageObject: null
          imageYOrigin: 'bottom'
          preventDelete: false
          showButtonOnUI : true
        'Surgery Start':
          shape: 'image'
          fillStyle: "rgb(255,0,0)"
          showLines: false
          autoInsert: false
          imageSource: 'assets/img/graph-s-start.png'
          imageObject: null
          imageYOrigin: 'bottom'
          preventDelete: false
          showButtonOnUI : true
        'Surgery End':
          shape: 'image'
          fillStyle: "rgb(255,0,0)"
          showLines: false
          autoInsert: false
          imageSource: 'assets/img/graph-s-end.png'
          imageObject: null
          imageYOrigin: 'bottom'
          preventDelete: false
          showButtonOnUI : true
        'BPS':
          shape: 'image'
          fillStyle: "rgb(255,0,0)"
          showLines: false
          autoInsert: true
          imageSource: 'assets/img/graph-bps.png'
          imageObject: null
          imageYOrigin: 'center'
          showButtonOnUI : true
        'BPD':
          shape: 'image'
          fillStyle: "rgb(255,0,0)"
          showLines: false
          autoInsert: true
          imageSource: 'assets/img/graph-bpd.png'
          imageObject: null
          imageYOrigin: 'center'
          showButtonOnUI : true
        'BPM':
          shape: 'image'
          fillStyle: "rgb(255,0,0)"
          showLines: false
          autoInsert: true
          imageSource: 'assets/img/graph-bpd.png'
          imageObject: null
          imageYOrigin: 'center'
          showButtonOnUI : true
        'CVP':
          shape: 'circle'
          fillStyle: "rgb(0,255,0)"
          showLines: true
          autoInsert: true
          showButtonOnUI : true
        'Pulse':
          shape: 'circle'
          fillStyle: "rgb(0,0,255)"
          showLines: true
          autoInsert: true
          showButtonOnUI : true
        'Vapor':
          shape: 'circle'
          fillStyle: "rgb(255,255,0)"
          showLines: true
          autoInsert: true
          showButtonOnUI : true
        'Position':
          shape: 'Position'
          fillStyle: "#7e2e84"
          showLines: false
          autoInsert: false
          showButtonOnUI : true        
      }

    commonOffsetPx:
      type: Number
      value: 30
    leftOffsetPx:
      type: Number
      value: 30
    bottomOffsetPx: 
      type: Number
      value: 30

    labels:
      type: Object
      value:
        xAxis: 'Time'
        yAxis: 'Magnitude'

    colors:
      type: Object
      value: 
        background: "rgb(255,255,255)"
        axis: 'rgb(0,0,0)'
        text: "rgb(0,0,0)"
        interval: 'rgb(0,127,0)'
        primaryInterval: 'rgb(0,127,0)'
        primaryHardInterval: 'rgb(0,127,0)'
        currentTimeLine: 'rgb(255,0,0)'
        boundingCircle: 'rgb(255, 0, 0)'
        boundingCircleMove: 'rgb(255, 0, 255)'
        boundingCircleDelete: 'rgb(255, 0, 0)'

    xIntervalLineCount:
      type: Number
      value: 3 * 4 * 3
    xPrimaryIntervalLineDivisor: 
      type: Number
      value: 3
    xPrimaryHardIntervalLineDivisor:
      type: Number
      value: 3 * 4
    yIntervalLineCount:
      type: Number
      value: 15
    yPrimaryIntervalLineDivisor:
      type: Number
      value: 3
    yAxisMinValue:
      type: Number
      value: 0
    yAxisMaxValue:
      type: Number
      value: 300
    xAxisTemporalStepSizeInMinutes: # (in minutes)
      type: Number
      value: 5

    # internal const
    widthPx:
      type: Number
      value: 1024 
    heightPx:
      type: Number
      value: 576
    selectedPointDefinitionKey: 
      type: String
      value: 'Move'

    # internal
    patientPositionSelectedIndex: 
      type: Number
      value: 0

    xIntervalLineStart:
      type: Number
      value: 0

    xIntervalGapWidthPx:
      type: Number
      value: null
    yIntervalGapWidthPx:
      type: Number
      value: null

    xIntervalTopLabelList: 
      type: Array
      value: -> []
    yIntervalLabelList:
      type: Array
      value: -> []
    xMousePositionPx:
      type: Number
      value: 0
    yMousePositionPx:
      type: Number
      value: 0

    # fps related
    framesPerSecond:
      type: Number
      value: 0
    lastFramesPerSecond:
      type: Number
      value: 0
    lastDatetimeStamp:
      type: Number
      value: 0

  setPointList: (pointList)->
    @pointList = pointList

  _computeEndOffsetDatetimeStamp: ->
    datetime = new Date @startOffsetDatetimeStamp
    datetime.setHours (3 + datetime.getHours())
    @endOffsetDatetimeStamp = datetime.getTime()

  computeExternalOptions: ->
    unless @startDatetimeStamp
      @startDatetimeStamp = lib.datetime.now()
    unless @startOffsetDatetimeStamp
      @startOffsetDatetimeStamp = @startDatetimeStamp
    unless @endDatetimeStamp
      datetime = new Date @startOffsetDatetimeStamp
      datetime.setHours (3 + datetime.getHours())
      @endDatetimeStamp = datetime.getTime()
    unless @endOffsetDatetimeStamp
      @_computeEndOffsetDatetimeStamp()
    unless @clockDatetimeStamp
      @clockDatetimeStamp = lib.datetime.now()

    diffInMinutes = (@endDatetimeStamp - @startDatetimeStamp) / 60 / 1000
    stepSize = @xAxisTemporalStepSizeInMinutes
    stepCount = diffInMinutes / @xAxisTemporalStepSizeInMinutes
    list = []
    for step in [0..stepCount]
      if step % @xPrimaryIntervalLineDivisor is 0
        date = (new Date @startDatetimeStamp)
        date.setMinutes (date.getMinutes() + step * stepSize)
        list.push lib.datetime.format date, 'mm-dd'
        # list.push lib.datetime.format date, 'mm-dd HH:MM'
      else
        list.push null
    @xIntervalTopLabelList = list

    min = @yAxisMinValue
    max = @yAxisMaxValue
    stepCount = @yIntervalLineCount
    stepSize = ((max - min) / stepCount)
    list = []
    for step in [0..stepCount]
      if max < @yIntervalLineCount
        val = (Math.round ((step * stepSize) * 10))/10
      else
        val = Math.ceil (step * stepSize)
      list.push val
    @yIntervalLabelList = list

  computeInternalOptions: ->
    @xIntervalGapWidthPx = Math.floor ((@widthPx - @commonOffsetPx - @leftOffsetPx) / @xIntervalLineCount)
    @yIntervalGapWidthPx = Math.floor ((@heightPx - @commonOffsetPx - @bottomOffsetPx) / @yIntervalLineCount)

  setTimeRange: (recordingStartTime, recordingEffectiveEndTime)->
    if recordingEffectiveEndTime - recordingStartTime < (3 * 60 * 60 * 1000)
      recordingEffectiveEndTime = recordingStartTime + (3 * 60 * 60 * 1000)
    @startDatetimeStamp = recordingStartTime
    @endDatetimeStamp = recordingEffectiveEndTime
    # if @startOffsetDatetimeStamp < recordingStartTime or @startOffsetDatetimeStamp > recordingEffectiveEndTime
    @startOffsetDatetimeStamp = recordingStartTime
    @_computeEndOffsetDatetimeStamp()

    if @ctx
      @computeExternalOptions()

  setCurrentTime: (clockDatetimeStamp)->
    @clockDatetimeStamp = clockDatetimeStamp

  ready: ->
    @ctx = @$.canvas.getContext '2d'
    @computeExternalOptions()
    @computeInternalOptions()
    @shouldRender = true
    @_loadImagesAndLoop()

  detached: ->
    @shouldRender = false

  _loadImagesAndLoop: ->
    toLoad = 0
    loaded = 0
    for key, type of @pointDefinition
      if type.shape is 'image'
        toLoad += 1
        type.imageObject = new Image()
        type.imageObject.addEventListener 'load', ((e)=>
          loaded += 1
          if loaded is toLoad
            window.requestAnimationFrame => @loop()
        ), false
        type.imageObject.src = type.imageSource
    if toLoad is 0
      window.requestAnimationFrame => @loop()

  flip: (value)-> @heightPx - value

  setPostLoopCallback: (cbfn)->
    @postLoopCallback = cbfn

  loop: ->
    @draw()
    if @postLoopCallback
      @postLoopCallback()
      @postLoopCallback = null

    if @isLive
      if @lastDatetimeStamp is null
        @lastDatetimeStamp = (new Date).getTime()
      else
        now = (new Date).getTime()
        if now - @lastDatetimeStamp > 1000
          @lastFramesPerSecond = @framesPerSecond
          @framesPerSecond = 0
          @lastDatetimeStamp = now
        else
          @framesPerSecond += 1
      window.requestAnimationFrame => @loop()

  draw: ->

    @ctx.font = "14px Roboto"

    # print background
    @ctx.fillStyle = @colors.background
    @ctx.fillRect 0, 0, @widthPx, @heightPx

    # cursor position
    @ctx.font = "12px Roboto"
    if isNaN(@xMousePositionPx) or isNaN(@yMousePositionPx)
      label = "Outside"
    else
      label = @xMousePositionPx + 'x' + @yMousePositionPx

    label += ' FPS: ' + @lastFramesPerSecond

    @ctx.textAlign = "right"
    @ctx.fillStyle = @colors.text
    @ctx.fillText label, (@widthPx - 10), @flip (@heightPx - 20)    
    @ctx.font = "14px Roboto"

    # axis
    @ctx.strokeStyle = @colors.axis
    @ctx.beginPath()
    @ctx.moveTo @leftOffsetPx, @flip @bottomOffsetPx
    @ctx.lineTo (@widthPx - @commonOffsetPx), @flip @bottomOffsetPx
    @ctx.stroke()

    @ctx.strokeStyle = @colors.axis
    @ctx.beginPath()
    @ctx.moveTo @leftOffsetPx, @flip @bottomOffsetPx
    @ctx.lineTo @leftOffsetPx, @commonOffsetPx
    @ctx.stroke()

    # axis labels
    @ctx.textAlign = "center"
    @ctx.fillStyle = @colors.text
    @ctx.fillText @labels.xAxis, (@widthPx/2), (@heightPx - 10)

    @ctx.save()
    @ctx.textAlign = "center"
    @ctx.translate (@widthPx - 10), (@heightPx/2)
    @ctx.rotate (-Math.PI/2)
    @ctx.fillStyle = @colors.text
    @ctx.fillText @labels.yAxis, 0, 0
    @ctx.restore()

    # xInterval and labels
    lim = @yIntervalGapWidthPx * @yIntervalLineCount
    for intervalNumber in [0..@xIntervalLineCount]
      if intervalNumber % @xPrimaryHardIntervalLineDivisor is 0
        @ctx.globalAlpha = 1
        @ctx.strokeStyle = @colors.primaryHardInterval
      else if intervalNumber % @xPrimaryIntervalLineDivisor is 0
        @ctx.globalAlpha = 0.6
        @ctx.strokeStyle = @colors.primaryInterval
      else
        @ctx.globalAlpha = 0.3
        @ctx.strokeStyle = @colors.interval
      @ctx.beginPath()
      @ctx.moveTo @leftOffsetPx + (intervalNumber * @xIntervalGapWidthPx), @flip @bottomOffsetPx
      @ctx.lineTo @leftOffsetPx + (intervalNumber * @xIntervalGapWidthPx), @flip lim + @bottomOffsetPx
      @ctx.stroke()
      @ctx.globalAlpha = 1
      label = @xIntervalTopLabelList[intervalNumber + @xIntervalLineStart]

      if label and intervalNumber isnt @xIntervalLineCount
        @ctx.textAlign = "left"
        @ctx.fillStyle = @colors.text
        centerX = @leftOffsetPx + (intervalNumber * @xIntervalGapWidthPx) + 3
        centerY = @flip lim + @bottomOffsetPx + 3
        # @ctx.fillText label, centerX, centerY

        centerX = @leftOffsetPx + (intervalNumber * @xIntervalGapWidthPx)
        centerY = @flip lim + @bottomOffsetPx
        radius = 2
        @ctx.beginPath()
        @ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false)
        @ctx.strokeStyle = @colors.text
        @ctx.stroke()

    # draw current time's line.
    lim = @yIntervalGapWidthPx * @yIntervalLineCount
    if @startOffsetDatetimeStamp <= @clockDatetimeStamp < @endOffsetDatetimeStamp
      diffMinutes = (@clockDatetimeStamp - @startOffsetDatetimeStamp) / 60 / 1000
      stepSize = 5
      stepNumber = diffMinutes #Math.round (diffMinutes / 5)
      @ctx.strokeStyle = @colors.currentTimeLine
      @ctx.beginPath()
      @ctx.moveTo @leftOffsetPx + (stepNumber * @xIntervalGapWidthPx / 5), @flip @bottomOffsetPx
      @ctx.lineTo @leftOffsetPx + (stepNumber * @xIntervalGapWidthPx / 5), @flip lim + @bottomOffsetPx
      @ctx.stroke()

    # yInterval and labels
    lim = @xIntervalGapWidthPx * @xIntervalLineCount
    for intervalNumber in [0..@yIntervalLineCount]
      if intervalNumber % @yPrimaryIntervalLineDivisor is 0
        @ctx.globalAlpha = 0.6
        @ctx.strokeStyle = @colors.primaryInterval
      else
        @ctx.globalAlpha = 0.3
        @ctx.strokeStyle = @colors.interval
      @ctx.beginPath()
      @ctx.moveTo @bottomOffsetPx, @flip (@bottomOffsetPx + (intervalNumber * @yIntervalGapWidthPx))
      @ctx.lineTo (lim + @bottomOffsetPx), @flip (@bottomOffsetPx + (intervalNumber * @yIntervalGapWidthPx))
      @ctx.stroke()
      @ctx.globalAlpha = 1
      label = @yIntervalLabelList[intervalNumber]

      @ctx.textAlign = "left"
      @ctx.fillStyle = @colors.text
      centerX = (lim + @bottomOffsetPx) + 2
      centerY = @flip (@bottomOffsetPx + (intervalNumber * @yIntervalGapWidthPx)) + 2
      @ctx.fillText label, centerX, centerY

      # Left side vertical denominator
      @ctx.textAlign = "right"
      @ctx.fillStyle = @colors.text
      centerX = (@bottomOffsetPx) - 4
      centerY = @flip (@bottomOffsetPx + (intervalNumber * @yIntervalGapWidthPx)) + 2
      @ctx.fillText label, centerX, centerY


    ## pointList Drawing
    lastPointMap = {}

    for point in (@pointList or [])

      unless @startDatetimeStamp <= (point.datetimeStamp + @startDatetimeStamp) <= @endDatetimeStamp
        console.error 'Point Out Of Bound', point
        # console.log "startDatetimeStamp", @startDatetimeStamp, (@startDatetimeStamp - point)
        # console.log "endDatetimeStamp", @endDatetimeStamp, (@endDatetimeStamp - point)
        continue
      unless @startOffsetDatetimeStamp <= (point.datetimeStamp + @startDatetimeStamp) <= @endOffsetDatetimeStamp
        continue
      x = @_timeToX (point.datetimeStamp - (@startOffsetDatetimeStamp - @startDatetimeStamp))
      y = @_magnitudeToY point.magnitude

      ###
      ## REGION POINT DRAWING - START ==================================
      ###
      unless point.key of lastPointMap
        lastPointMap[point.key] = null
      lastPoint = lastPointMap[point.key]

      [ centerX, centerY ] = @_unclipAndTranslateToPx  x, y 

      type = @pointDefinition[point.key]
      @ctx.fillStyle = type.fillStyle

      if type.shape is 'circle'
        radius = 6
        @ctx.beginPath();
        @ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
        @ctx.fill()

      else if type.shape is 'box'
        width = type.boxLength * 5 + 1
        height = type.boxLength * 4
        x = centerX
        y = centerY
        @ctx.fillRect x, y, width, height

      else if type.shape is 'image'
        centerX__ = centerX - (type.imageObject.width / 2)
        centerY__ = centerY
        if type.imageYOrigin is 'bottom'
          centerY__ -= type.imageObject.height
        if type.imageYOrigin is 'center'
          centerY__ -= ( type.imageObject.height ) / 2
        @ctx.drawImage type.imageObject, centerX__, centerY__

      else if type.shape is 'Position' #change here
        radius = 3
        @ctx.beginPath();
        @ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
        @ctx.fillStyle = type.fillStyle
        @ctx.fill()
        x = centerX + 10
        y = centerY - 6
        @ctx.save()
        @ctx.textAlign = "left"
        @ctx.translate x, y
        @ctx.rotate (-Math.PI/2)
        @ctx.fillStyle = type.fillStyle
        @ctx.fillText point.extraDataObject.text, 0, 0
        @ctx.restore()

      ## Lines
      if type.showLines and lastPoint isnt null
        @ctx.beginPath()
        @ctx.strokeStyle = type.fillStyle
        @ctx.moveTo.apply @ctx, @_unclipAndTranslateToPx (@_timeToX (lastPoint.datetimeStamp - (@startOffsetDatetimeStamp - @startDatetimeStamp))), (@_magnitudeToY lastPoint.magnitude)
        @ctx.lineTo.apply @ctx, @_unclipAndTranslateToPx (@_timeToX (point.datetimeStamp - (@startOffsetDatetimeStamp - @startDatetimeStamp))), (@_magnitudeToY point.magnitude)
        @ctx.stroke()
      lastPointMap[point.key] = point

      ## while moving
      if @selectedPointDefinitionKey is 'Move' and @activelySelectedPoint
        if point.datetimeStamp is @activelySelectedPoint.datetimeStamp and point.magnitude is @activelySelectedPoint.magnitude
          radius = 7
          @ctx.globalAlpha = 1
          @ctx.beginPath()
          @ctx.arc(centerX, (centerY), radius, 0, 2 * Math.PI, false)
          @ctx.strokeStyle = @colors.text
          @ctx.stroke()
          radius = 9
          @ctx.globalAlpha = 1
          @ctx.beginPath()
          @ctx.arc(centerX, (centerY), radius, 0, 2 * Math.PI, false)
          @ctx.strokeStyle = @colors.text
          @ctx.stroke()
          @ctx.globalAlpha = 1

      ## REGION POINT DRAWING - END

    ## cursor circle
    [ centerX, centerY ] = @_unclipAndTranslateToPx @xMousePositionPx, @yMousePositionPx
    if @selectedPointDefinitionKey is 'Move'
      radius = 10
      @ctx.globalAlpha = 0.2
      @ctx.beginPath()
      @ctx.arc(centerX, (centerY + 1), radius, 0, 2 * Math.PI, false)
      @ctx.fillStyle = @colors.boundingCircleMove
      @ctx.fill()
      @ctx.globalAlpha = 1
    else if @selectedPointDefinitionKey is 'Delete'
      radius = 10
      @ctx.globalAlpha = 0.2
      @ctx.beginPath()
      @ctx.arc(centerX, (centerY + 1), radius, 0, 2 * Math.PI, false)
      @ctx.fillStyle = @colors.boundingCircleDelete
      @ctx.fill()
      @ctx.globalAlpha = 1
    else
      radius = 7
      @ctx.globalAlpha = 0.4
      @ctx.beginPath()
      @ctx.arc(centerX, (centerY + 1), radius, 0, 2 * Math.PI, false)
      @ctx.strokeStyle = @colors.boundingCircle
      @ctx.stroke()
      @ctx.globalAlpha = 1

    ## Auto Insert
    if @isAutoInsertEnabled and @autoInsertAnchor
      @ctx.beginPath()
      @ctx.moveTo.apply @ctx, @_unclipAndTranslateToPx (@_timeToX @autoInsertAnchor.datetimeStamp), (@_magnitudeToY @autoInsertAnchor.magnitude)
      @ctx.lineTo.apply @ctx, @_unclipAndTranslateToPx @xMousePositionPx, @yMousePositionPx
      @ctx.stroke()

  pointDefinitionSwitchPressed: (e)->
    @selectedPointDefinitionKey = e.model.pointDefinitionKey

  _updateCoordinates: (e)->
    [ x, y ] = @_translateToLocalCoords e.x, e.y
    [ x, y ] = @_clipRawLocalCoords x, y
    [ @xMousePositionPx, @yMousePositionPx ] = [ x, y ]

  canvasMouseMoved: (e)->
    @_updateCoordinates e
    if @isExpressDeleteEnabled and @selectedPointDefinitionKey is 'Delete'
      point = @_getPointWithinRadius @xMousePositionPx, @yMousePositionPx, 10
      if point
        @_removePoint point

  _magnitudeToY: (yMagnitude)->
    limMagnitude = @yAxisMaxValue - @yAxisMinValue
    limPx = @yIntervalGapWidthPx * @yIntervalLineCount
    ratio = limMagnitude / limPx
    y = yMagnitude / ratio
    return y

  _timeToX: (currentTime)->
    currentTime = currentTime # - @startDatetimeStamp
    currentTime = currentTime / 60 / 1000
    diffInMinutes = 5
    lineNumber = currentTime / diffInMinutes
    x = lineNumber * @xIntervalGapWidthPx  
    return x

  _xToTime: (x)-> 
    lineNumber = Math.round (x / @xIntervalGapWidthPx)
    diffInMinutes = 5
    currentTime = lineNumber * diffInMinutes
    currentTime = (@startOffsetDatetimeStamp - @startDatetimeStamp) + (currentTime * 60 * 1000)
    return currentTime

  _yToMagnitude: (y)->
    limMagnitude = @yAxisMaxValue - @yAxisMinValue
    limPx = @yIntervalGapWidthPx * @yIntervalLineCount
    ratio = limMagnitude / limPx
    yMagnitude = y * ratio
    return yMagnitude

  _pushOrSplicePoint: (object)->
    matchedPoint = null
    for point in @pointList
      if point.key is object.key and point.datetimeStamp is object.datetimeStamp
        matchedPoint = point
        break
    if matchedPoint
      matchedPoint.magnitude = object.magnitude
      @_notifyPointUpdate()
    else
      pointList = lib.util.deepCopy @pointList
      pointList.push object
      pointList.sort (left, right)->
        return -1 if left.datetimeStamp < right.datetimeStamp
        return 1 if left.datetimeStamp > right.datetimeStamp
        return 0
      @pointList = pointList
      @_notifyPointUpdate()

  _addChainOfPoints: (first, last)->
    stepSize = 5 * 60 * 1000
    diff = last.datetimeStamp - first.datetimeStamp
    stepCount = diff / stepSize
    slope = (last.magnitude - first.magnitude) / stepCount
    for stepNumber in [0..stepCount]
      point = lib.util.deepCopy first
      point.datetimeStamp += stepSize * stepNumber
      point.magnitude = point.magnitude + slope * stepNumber
      @_pushOrSplicePoint point

  _addPointFromUserInteraction: (x, y, key, def, extraDataObject = {})->
    if key is 'Position'
      text = @selectedPatientPosition or 'No Position'
      extraDataObject.text = text # ('' + text + '').replace /\s/g, ''
    object = @_preparePointToAdd x, y, key, def, extraDataObject
    if @isAutoInsertEnabled
      if @autoInsertAnchor
        first = @autoInsertAnchor
        last = object
        @_addChainOfPoints first, last
        @autoInsertAnchor = null
      else
        @autoInsertAnchor = object
    else
      @autoInsertAnchor = null
      @_pushOrSplicePoint object

  _getPointWithinRadius: (centerX, centerY, radius)->
    for point in @pointList
      x = @_timeToX point.datetimeStamp
      y = @_magnitudeToY point.magnitude
      isInCircle = Math.sqrt((centerX-x)*(centerX-x) + (centerY-y)*(centerY-y)) < radius
      if isInCircle
        return point
    return null

  _preparePointToAdd: (x, y, key, def, extraDataObject = {})->
    object = {
      datetimeStamp: @_xToTime x
      magnitude: @_yToMagnitude y
      key
      extraDataObject: {}
    }

    for extraKey, extraValue of extraDataObject
      object.extraDataObject[extraKey] = extraValue
    return object

  _removePoint: (pointToRemove)->
    for point, index in @pointList
      if point.key is pointToRemove.key and point.datetimeStamp is pointToRemove.datetimeStamp and point.magnitude is pointToRemove.magnitude
        @pointList.splice index, 1
        @_notifyPointUpdate()
        break

  canvasClicked: (e)->
    return
    @_updateCoordinates e
    unless (not isNaN @xMousePositionPx) and (not isNaN @yMousePositionPx)
      return
    if @selectedPointDefinitionKey is 'Move'
      if @activelySelectedPoint
        @_removePoint @activelySelectedPoint
        object = @_preparePointToAdd @xMousePositionPx, @yMousePositionPx, @activelySelectedPoint.key, def, @activelySelectedPoint.extraDataObject
        @_pushOrSplicePoint object
        @activelySelectedPoint = null
      else
        point = @_getPointWithinRadius @xMousePositionPx, @yMousePositionPx, 10
        if point
          @activelySelectedPoint = point
    else if @selectedPointDefinitionKey is 'Delete'
      point = @_getPointWithinRadius @xMousePositionPx, @yMousePositionPx, 10
      if point
        @_removePoint point
    else
      def = @pointDefinition[@selectedPointDefinitionKey]
      @_addPointFromUserInteraction @xMousePositionPx, @yMousePositionPx, @selectedPointDefinitionKey, def

  leftChevronPressed: (e)->
    maybe = @startOffsetDatetimeStamp - (2 * 60 * 60 * 1000)
    if maybe < @startDatetimeStamp 
      @startDatetimeStamp = maybe
      @startOffsetDatetimeStamp = maybe
      @computeExternalOptions()      
      if @startTimeOutOfBoundCallback
        @startTimeOutOfBoundCallback @startDatetimeStamp
    else
      @startOffsetDatetimeStamp = maybe
      @_computeEndOffsetDatetimeStamp()
    @xIntervalLineStart -= 2 * (3 * 4)
    if @xIntervalLineStart < 0
      @xIntervalLineStart = 0

  rightChevronPressed: (e)->  
    maybe = @startOffsetDatetimeStamp + (2 * 60 * 60 * 1000)
    @startOffsetDatetimeStamp = maybe
    @_computeEndOffsetDatetimeStamp()
    if @endOffsetDatetimeStamp > @endDatetimeStamp
      @endDatetimeStamp = @endOffsetDatetimeStamp
      @computeExternalOptions()
      if @endTimeOutOfBoundCallback
        @endTimeOutOfBoundCallback @endDatetimeStamp
    else
      @_computeEndOffsetDatetimeStamp()
    @xIntervalLineStart += 3 * 4 * 2

  shiftRightThreeHours: ->  
    maybe = @startOffsetDatetimeStamp + (3 * 60 * 60 * 1000)
    @startOffsetDatetimeStamp = maybe
    @_computeEndOffsetDatetimeStamp()
    if @endOffsetDatetimeStamp > @endDatetimeStamp
      @endDatetimeStamp = @endOffsetDatetimeStamp
      @computeExternalOptions()
      if @endTimeOutOfBoundCallback
        @endTimeOutOfBoundCallback @endDatetimeStamp
    else
      @_computeEndOffsetDatetimeStamp()
    @xIntervalLineStart += 3 * 4 * 2

  patientPositionSelected: (e)->
    @selectedPatientPosition = e.detail.item.innerText
    @selectedPatientPosition =  (@selectedPatientPosition).replace /\\n/g, ''
    @selectedPatientPosition = @selectedPatientPosition.replace /^\s+|\s+$/g, ''

  _notifyPointUpdate: ->
    if @pointListUpdateCallback
      @pointListUpdateCallback @pointList

    @domHost.domHost.domHost.addActivityLog "Graph Point", 'add', {patientSerial: @domHost.domHost.record.patientSerial}
  

  setAdditionalData: (additionalData)->
    @additionalData = additionalData

  commentChanged: (e)->
    @additionalData.comments = e.target.value

}



