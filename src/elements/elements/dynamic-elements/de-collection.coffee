
Polymer {

  is: 'de-collection'

  properties:
    data:
      type: Object
      value: null
    def:
      type: Object
      value: null
    hasData:
      type: Boolean
      value: false
    isOpened:
      type: Boolean
      value: false
    groupTabSelectedIndex:
      type: Number
      notify: true
      value: null
    currentGroup:
      type: Object
      value: null
    currentGroupData:
      type: Object
      value: null

  $both: (a, b)-> return a and b

  $getDataClass: (value)-> if value then 'hasData' else 'doesNotHaveData'

  observers: [
    'systemChanged(def, data)'
    'isOpenedChanged(isOpened)'
  ]

  systemChanged: (def, data)->
    return unless def and data

    unless 'isDefaultGroupDismissed' of data
      @set 'data.isDefaultGroupDismissed', false

    if Object.keys(data.childMap).length is 0
      @hasData = false
      @isOpened = false
    else
      @hasData = true
    ## HACK START
    # In order to trigger value changing when switching categories
    @groupTabSelectedIndex = null
    # HACK END
    @groupTabSelectedIndex = 0

  isOpenedChanged: (isOpened)->
    list = (@getAttribute 'class')
    if isOpened
      list += ' opened'
      Polymer.dom(@).setAttribute 'class', list
    else if (list.indexOf ' opened') isnt -1
      list = list.replace ' opened', ''
      Polymer.dom(@).setAttribute 'class', list

  collectionCreatePressed: (e)->
    @hasData = true
    @isOpened = true
    ## HACK START
    # In order to trigger value changing when switching categories
    @groupTabSelectedIndex = null
    # HACK END
    @groupTabSelectedIndex = 0

    if 'defaultGroup' of @def and not @data.isDefaultGroupDismissed
      @groupTabSelected()

  collectionErasePressed: (e)->
    @domHost.domHost.domHost.domHost.showModalPrompt 'Are you sure you want to delete this entire collection?', (answer)=>
      if answer
        @isOpened = false
        @hasData = false
        # console.log window.bdemrElement.patient.serial
        # console.log @data.forKey
        @domHost.domHost.domHost.domHost.addActivityLog @data.forKey, 'removed', {patientSerial: window.bdemrElement.patient.serial}
        @data.childMap = {}
        @currentGroup = null
        @currentGroupData = null
        @groupTabSelectedIndex = null

  collectionCollapsePressed: (e)->
    @isOpened = false

  collectionExpandPressed: (e)->
    @isOpened = true
    if 'defaultGroup' of @def and not @data.isDefaultGroupDismissed
      @groupTabSelected()

  $hasActiveDefaultGroup: (p1, p2)->
    'defaultGroup' of p1 and not p2

  dismissDefaultsPressed: (e)->
    @set 'data.isDefaultGroupDismissed', true

  groupTabSelected: (e)->
    return if @groupTabSelectedIndex is null

    if @groupTabSelectedIndex is 0 and 'defaultGroup' of @def and not @data.isDefaultGroupDismissed

      ## get current group
      currentGroup = @def.defaultGroup

    else

      ## get current group
      currentGroup = @def.childList[@groupTabSelectedIndex] 

    ## make room for group data
    unless currentGroup.key of @data.childMap
      @data.childMap[currentGroup.key] = {
        forType: 'group'
        forKey: currentGroup.key
        childMap: {}
      }
    currentGroupData = @data.childMap[currentGroup.key]

    ## set
    @set 'currentGroupData', currentGroupData
    @set 'currentGroup', currentGroup

  propagateDynamicDataAlterationSignal: (action, path)->
    path.unshift @currentGroup.key
    path.unshift @def.key
    @domHost.propagateDynamicDataAlterationSignal action, path

}
