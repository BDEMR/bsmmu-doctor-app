
deBehavior = {

  properties:
    data:
      type: Object
      value: null
    def:
      type: Object
      value: null
    depth:
      type: Number
      value: 0
    shouldRender:
      type: Boolean
      value: false

  $both: (a, b)-> return a and b

  $equals: (left, right)-> left is right

  $inc: (value)-> value + 1

  observers: [
    'systemChanged(def, data)'
  ]

  systemChanged: (def, data)->
    if def and data
      if def.key is data.forKey and def.type is data.forType is @supportedDefType
        @shouldRender = true
        @systemChangedDelegated def, data
        return
    @shouldRender = false

  ## DO NOT DELETE
  # $makeData: (dynamicElement)->
  #   unless dynamicElement.key of @data.childMap
  #     @data.childMap[dynamicElement.key] = {
  #       forType: dynamicElement.type
  #       forKey: dynamicElement.key
  #       childMap: {}
  #     }
  #   return @data.childMap[dynamicElement.key]

  notifyDynamicDataAlteration: (action)->
    try
      @propagateDynamicDataAlterationSignal action, @def.key
    catch ex
      lib.util.delay 100, =>
        @propagateDynamicDataAlterationSignal action, @def.key

  propagateDynamicDataAlterationSignal: (action, path)->
    if typeof path is 'string'
      @domHost.propagateDynamicDataAlterationSignal action, [ path ]
    else
      path.unshift @def.key
      @domHost.propagateDynamicDataAlterationSignal action, path

}

###
  element
###

Polymer {

  is: 'de-card'

  supportedDefType: 'card'

  behaviors: [ deBehavior ]

  systemChangedDelegated: (def, data)-> null

}

###
  element
###

Polymer {

  is: 'de-toggleable-container'

  supportedDefType: 'toggleableContainer'

  behaviors: [ deBehavior ]

  observers: [
    'dataIsCheckedAltered(data.isChecked)'
  ]

  dataIsCheckedAltered: ->
    return unless (@data and @def)
    action = (if @data.isChecked then 'check' else 'uncheck')
    @notifyDynamicDataAlteration action

  systemChangedDelegated: (def, data)-> 
    unless 'isChecked' of data
      if def.isPrechecked
        data.isChecked = true
      else
        data.isChecked = false

}

###
  element
###

Polymer {

  is: 'de-check-list'

  supportedDefType: 'checkList'

  behaviors: [ deBehavior ]

  properties:
    typedCustomValue:
      type: String
      notify: true
      value: ''

  observers: [
    'dataCheckedValueListChanged(data.checkedValueList.*)'
  ]

  dataCheckedValueListChanged: ->
    return unless (@data and @def)
    action = 'change'
    @notifyDynamicDataAlteration action

  $isPossibleValueChecked: (possibleValue, checkedValueList)->
    return possibleValue in checkedValueList

  possibleValueCheckedStatusChanged: (e)->
    value = e.model.possibleValue
    index = @data.checkedValueList.indexOf value
    if index isnt -1
      @splice 'data.checkedValueList', index, 1
    else
      @push 'data.checkedValueList', value

  $isPossibleCustomValueChecked: (customPossibleValue, checkedValueList)->
    return customPossibleValue in checkedValueList

  customPossibleValueCheckedStatusChanged: (e)->
    value = e.model.customPossibleValue
    index = @data.checkedValueList.indexOf value
    if index isnt -1
      @splice 'data.checkedValueList', index, 1
    else
      @push 'data.checkedValueList', value

  addCustomValue: (e)->
    unless @typedCustomValue in @data.customValueList or @typedCustomValue in @def.possibleValueList
      @push 'data.customValueList', @typedCustomValue
      @push 'data.checkedValueList', @typedCustomValue
      @typedCustomValue = ''

  deleteCustomValue: (e)->
    value = e.model.customPossibleValue
    index = @data.checkedValueList.indexOf value
    if index isnt -1
      @splice 'data.checkedValueList', index, 1
    index = @data.customValueList.indexOf value
    if index isnt -1
      @splice 'data.customValueList', index, 1

  systemChangedDelegated: (def, data)-> 
    unless 'checkedValueList' of data
      data.checkedValueList = []
      if 'preselectedValueList' of def
        for value in def.preselectedValueList
          @push 'data.checkedValueList', value
    unless 'customValueList' of data
      data.customValueList = []

}

###
  element
###

Polymer {

  is: 'de-input'

  supportedDefType: 'input'

  behaviors: [ deBehavior ]

  properties: 
    localSelectedUnitIndex: 
      type: Number

  observers: [
    'dataValueChanged(data.value)'
    'updateValueIfUnitIsAltered(localSelectedUnitIndex)'
  ]

  dataValueChanged: ->
    return unless (@data and @def)
    action = 'change'
    @notifyDynamicDataAlteration action

  systemChangedDelegated: (def, data)-> 
    unless 'value' of data
      if def.prefilledValue
        @set 'data.value', def.prefilledValue
      else
        if def.valueType is 'text'
          @set 'data.value', ''
        if def.valueType is 'multilineText'
          @set 'data.value', ''
        if def.valueType is 'date'
          @set 'data.value', lib.datetime.mkDate lib.datetime.now()
        if def.valueType is 'number'
          @set 'data.value', 0

    if 'unitDetails' of def
      unless 'selectedUnitIndex' of data
        @set 'data.selectedUnitIndex', def.unitDetails.baseUnit
      @set 'localSelectedUnitIndex', @data.selectedUnitIndex

    unless 'labelType' of def
      def.labelType = 'float'

    if 'rangeDetails' of def
      unless 'rangeDetails' of data
        @set 'data.rangeDetails', {}
        @set 'data.rangeDetails.minValue', def.rangeDetails.minValue
        @set 'data.rangeDetails.maxValue', def.rangeDetails.maxValue
        steps = Math.pow 10, def.rangeDetails.decimalPrecisionDigits
        @set 'data.rangeDetails.steps', steps

    ## DO NOT DELETE
    # lib.util.delay 60, =>
    #   if def.labelType is 'alwaysFloat'
    #     el = Polymer.dom (@$$ '.main-input')
    #     el.setAttribute 'always-float-label', 'always-float-label'
    #   else if def.labelType is 'hidden'
    #     el = Polymer.dom (@$$ '.main-input')
    #     el.setAttribute 'no-label-float', 'no-label-float'
    #     el.setAttribute 'label', ''
    #   else if def.labelType is 'placeholder'
    #     el = Polymer.dom (@$$ '.main-input')
    #     el.setAttribute 'no-label-float', 'no-label-float'

    if 'injection' of def
      if def.injection.ref
        { ref } = def.injection
        value = ''
        if ref is 'patient-name'
          value = window.bdemrElement.patient.name
        else if ref is 'patient-age'
          value = new Date window.bdemrElement.patient.dob
          value = (new Date).getTime() - value.getTime()
          value = Math.floor (value / 1000 / 60 / 60 / 24 / 365)
        else if ref is 'patient-dob'
          value = window.bdemrElement.patient.dob
        else if ref is 'patient-address'
          value = window.bdemrElement.patient.address.line1
        @set 'data.value', value
      else
        { from } = def.injection
        str = from.replace '<root>', window.bdmerRecordContentTypeName
        str = str.replace /\/\/\<array\>/g, ''
        item = window.bdemrElement.safeExtractItem str
        if item
          @set 'data.value', item.value
    try
      data.value = data.value.replace '@VALUE@', ''
    catch e
      'pass'
    
  updateValueIfUnitIsAltered: ->
    oldIndex = @data.selectedUnitIndex
    newIndex = @localSelectedUnitIndex
    return if oldIndex is newIndex

    value = @data.value

    formula = @def.unitDetails.unitList[oldIndex].reverseFormula.replace '@VALUE@', value
    value = eval formula

    formula = @def.unitDetails.unitList[newIndex].formula.replace '@VALUE@', value
    value = eval formula

    if 'rangeDetails' of @data
      formula = @def.unitDetails.unitList[newIndex].formula.replace '@VALUE@', @def.rangeDetails.minValue
      @set 'data.rangeDetails.minValue', (eval formula)
      formula = @def.unitDetails.unitList[newIndex].formula.replace '@VALUE@', @def.rangeDetails.maxValue
      @set 'data.rangeDetails.maxValue', (eval formula)

    @set 'data.selectedUnitIndex', @localSelectedUnitIndex
    @set 'data.value', value

}

###
  element
###

Polymer {

  is: 'de-label'

  supportedDefType: 'label'

  behaviors: [ deBehavior ]

  properties:
    updateHackInteger:
      type: Number
      value: 0
    cache:
      type: String
      value: null

  refreshButtonTapped: ->
    @updateHackInteger += 1

  $_getLabel: (label)->
    return label

  systemChangedDelegated: (def, data)-> 
    unless 'label' of data
      ## HACK START
      # no def.type='label' should contain a 'label' field.
      # this needs to be fixed in the .json file
      if def.label
        def.defaultLabel = def.label
        if def.defaultLabel is '@VALUE@'
          def.defaultLabel = ''
        delete def['label']
      ## HACK END
      data.label = def.defaultLabel
      if data.label is '@VALUE@'
        data.label = ''
      data.label = data.label.replace '@VALUE@', ''
    if def.isRefreshable
      @cache = data.label
      window.setTimeout (=> @refreshLoop()), 1000

  refreshLoop: ->
    return unless @def and @data and @def.isRefreshable

    if @data.label isnt @cache
      @cache = @data.label
      @refreshButtonTapped null

    window.setTimeout (=> @refreshLoop()), 1000

}

###
  element
###

Polymer {

  is: 'de-container'

  supportedDefType: 'container'

  behaviors: [ deBehavior ]

  systemChangedDelegated: (def, data)-> 
    unless 'label' of data
      ## HACK START
      # no def.type='label' should contain a 'label' field.
      # this needs to be fixed in the .json file
      if def.label
        def.defaultLabel = def.label
        delete def['label']
      ## HACK END
      data.label = def.defaultLabel

}

###
  element
###

Polymer {

  is: 'de-single-select-dropdown'

  supportedDefType: 'singleSelectDropdown'

  behaviors: [ deBehavior ]

  observers: [
    'dataSelectedIndexChanged(data.selectedIndex)'
  ]

  dataSelectedIndexChanged: ->
    return unless (@data and @def)
    action = 'change'
    @notifyDynamicDataAlteration action

  systemChangedDelegated: (def, data)-> 
    unless 'selectedIndex' of data
      if 'preselctedIndex' of def
        data.selectedIndex = def.preselctedIndex
      else
        data.selectedIndex = null

}

###
  element
###

Polymer {

  is: 'de-incremental-counter'

  supportedDefType: 'incrementalCounter'

  behaviors: [ deBehavior ]

  properties:
    virtualItemList:
      type: Array
      value: null

  observers: [
    'dataCountChanged(data.count)'
  ]

  dataCountChanged: ->
    return unless (@data and @def)
    action = 'change'
    @notifyDynamicDataAlteration action

  $getUnit: (count)->
    if 'unit' of @def
      if count is 1 then @def.unit.singular else @def.unit.plural
    else
      if count is 1 then 'unit' else 'units'

  $lt: (a, b)-> a < b

  systemChangedDelegated: (def, data)->
    unless 'count' of data
      data.count = 0
    unless 'seed' of data
      data.seed = 0
    unless 'limit' of def
      def.limit = 999
    unless 'virtualChildMap' of data
      data.virtualChildMap = {}

    virtualItemList = []
    for key, item of data.virtualChildMap
      key = parseInt (key.replace 'item', '')
      virtualDef = @generateVirtualContainer @def, key
      virtualData = item
      virtualItemList.push {
        def: virtualDef
        data: virtualData
      }
    @set 'virtualItemList', virtualItemList

  generateVirtualContainer: (def, serial)->
    virtualContainer = 
      type: 'deletable-container'
      defaultLabel: (try def.unit.singular catch ex then 'unit') + ' #' + (serial + 1)
      key: 'item' + serial
      childList: def.childListForEachContainer
    return virtualContainer

  addIconPressed: (e)->
    @set 'data.count', (@data.count + 1)
    serial = @data.seed
    @set 'data.seed', (@data.seed + 1)
    virtualDef = @generateVirtualContainer @def, serial
    virtualData = {
      forType: 'deletable-container'
      forKey: virtualDef.key
      childMap: {}
    }
    @push 'virtualItemList', {
      def: virtualDef
      data: virtualData
    }
    @data.virtualChildMap[virtualDef.key] = virtualData

  deleteIconPressed: (e)->
    virtualItem = e.model.virtualItem
    
    index = @virtualItemList.indexOf virtualItem
    if index > -1
      @splice 'virtualItemList', index, 1

      @set 'data.count', (@data.count - 1)

      virtualDef = virtualItem.def
      virtualData = virtualItem.data
      delete @data.virtualChildMap[virtualDef.key]
  
}

###
  element
###

Polymer {

  is: 'de-radio-list'

  supportedDefType: 'radioList'

  behaviors: [ deBehavior ]

  properties:
    typedCustomValue:
      type: String
      notify: true
      value: ''

  observers: [
    'dataSelectedValueChanged(data.selectedValue)'
  ]

  dataSelectedValueChanged: ->
    return unless (@data and @def)
    return unless @data.selectedValue
    action = 'change'
    @notifyDynamicDataAlteration action

  $isPossibleValueChecked: (possibleValue, selectedValue)->
    return possibleValue is selectedValue

  possibleValueCheckedStatusChanged: (e)->
    value = e.model.possibleValue
    @set 'data.selectedValue', value

  $isPossibleCustomValueChecked: (customPossibleValue, selectedValue)->
    return customPossibleValue is selectedValue

  customPossibleValueCheckedStatusChanged: (e)->
    value = e.model.customPossibleValue
    @set 'data.selectedValue', value

  addCustomValue: (e)->
    unless @typedCustomValue in @data.customValueList or @typedCustomValue in @def.possibleValueList
      @push 'data.customValueList', @typedCustomValue
      @set 'data.selectedValue', @typedCustomValue
      @typedCustomValue = ''

  deleteCustomValue: (e)->
    value = e.model.customPossibleValue
    @set 'data.selectedValue', ''
    index = @data.customValueList.indexOf value
    if index isnt -1
      @splice 'data.customValueList', index, 1

  systemChangedDelegated: (def, data)-> 
    unless 'selectedValue' of data
      @set 'data.selectedValue',  ''
      if 'preselectedValue' of def
        @data.selectedValue = @def.preselectedValue
    unless 'customValueList' of data
      data.customValueList = []

}

###
  element
###

Polymer {

  is: 'de-checkbox'

  supportedDefType: 'checkbox'

  behaviors: [ deBehavior ]

  observers: [
    'dataIsCheckedChanged(data.isChecked)'
  ]

  dataIsCheckedChanged: ->
    return unless (@data and @def)
    action = (if @data.isChecked then 'check' else 'uncheck')
    @notifyDynamicDataAlteration action

  systemChangedDelegated: (def, data)-> 
    unless 'isChecked' of data
      if def.isPrechecked
        data.isChecked = true
      else
        data.isChecked = false

}

###
  element
###

Polymer {

  is: 'de-autocomplete'

  supportedDefType: 'autocomplete'

  behaviors: [ deBehavior ]

  properties:
    sourceDataList:
      type: Array
      notify: true
      value: []
    virtualItemList:
      type: Array
    selectedStringObjectList:
      type: Array
      notify: true

  sourceDataPluginMap:
    'operationNameList': (cbfn)->
      root = document.querySelector 'root-element'
      root.getStaticData 'operationList', (list)=>
        sourceDataList = ({text: item.name, alt: item.shortcut} for item in list)
        cbfn sourceDataList
    'medicineNameList': (cbfn)->
      root = document.querySelector 'root-element'
      root.getStaticData 'medicineList', (list)=>
        brandNameDataList = ({text: item.brandName, alt: ''} for item in list)
        pharmaNameDataList = ({text: item.pharmaName, alt: ''} for item in list)
        sourceDataList = [].concat brandNameDataList, pharmaNameDataList
        cbfn sourceDataList
    'hospitalNameList': (cbfn)->
      root = document.querySelector 'root-element'
      root.getStaticData 'hospitalList', (list)=>
        sourceDataList = ({text: item.name, alt: ''} for item in list)
        cbfn sourceDataList
    'diagnosisNameList': (cbfn)->
      root = document.querySelector 'root-element'
      root.getStaticData 'diagnosisList', (list)=>
        sourceDataList = ({text: item.name, alt: ''} for item in list)
        cbfn sourceDataList

  observers: [
    'dataVirtualItemListChanged(virtualItemList.*)'
  ]

  dataVirtualItemListChanged: ->
    return unless (@data and @def)
    action = 'change'
    @notifyDynamicDataAlteration action

  systemChangedDelegated: (def, data)->
    
    unless 'selectionType' of def
      console.log def
      throw new Error 'missing selectionType'

    if 'sourceDataPlugin' of def
      name = def.sourceDataPlugin.name
      if name of @sourceDataPluginMap
        fn = @sourceDataPluginMap[name]
        fn (sourceDataList)=>
          @sourceDataList = sourceDataList
      else
        throw 'unknown sourceDataPlugin'
    else if 'sourceDataList' of def
      @sourceDataList = def.sourceDataList
    else
      throw new Error 'missing sourceDataList or sourceDataPlugin'

    unless 'virtualChildMap' of data
      data.virtualChildMap = {}

    virtualItemList = []
    
    for key, item of data.virtualChildMap
      serial = (key.replace 'item_', '')
      parts = (serial.split '_')
      parts.pop()
      label = parts.join '_'
      virtualDef = @generateVirtualContainer @def, serial, label
      virtualData = item
      virtualItemList.push {
        def: virtualDef
        data: virtualData
      }

    @set 'virtualItemList', virtualItemList

    if virtualItemList.length is 0
      if 'injection' of def
        if def.injection.ref
          'custom stuff'
        else
          { from } = def.injection
          str = from.replace '<root>', window.bdmerRecordContentTypeName
          str = str.replace /\/\/\<array\>/g, ''
          item = window.bdemrElement.safeExtractItem str
          if item
            for key, value of item.virtualChildMap
              key = key.split '_'
              serial = key.pop()
              key.shift()
              text = key.join '_'
              selectedStringObject = { text, serial }
              @_postAutocompleteSelected selectedStringObject

  generateVirtualContainer: (def, serial, label)->
    virtualContainer = 
      type: 'deletable-container'
      defaultLabel: label
      key: 'item_' + serial
      childList: def.childListForEachContainer
    return virtualContainer

  _postAutocompleteSelected: (selectedStringObject)->
    serial = selectedStringObject.text + '_' + selectedStringObject.serial
    virtualDef = @generateVirtualContainer @def, serial, selectedStringObject.text

    virtualData = {
      forType: 'deletable-container'
      forKey: virtualDef.key
      childMap: {}
    }

    @push 'virtualItemList', {
      def: virtualDef
      data: virtualData
    }
    @data.virtualChildMap[virtualDef.key] = virtualData

  autocompleteSelected: (e) ->
    selectedStringObject = e.detail.selectedStringObject
    @_postAutocompleteSelected selectedStringObject

  # deleteLabelIconPressed: (e)->
  #   { selectedStringObjectIndex } = e.model
  #   { selectedStringObjectList }
  

  deleteIconPressed: (e)->
    virtualItem = e.model.virtualItem
    
    index = @virtualItemList.indexOf virtualItem
    if index > -1
      @splice 'virtualItemList', index, 1

      virtualDef = virtualItem.def
      virtualData = virtualItem.data
      delete @data.virtualChildMap[virtualDef.key]

}


