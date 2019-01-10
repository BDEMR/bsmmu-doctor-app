
Polymer {

  is: 'de-array'

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
    elementMap:
      type: Object
      value: ->
        return {
          'card': { elementName: 'de-card', canHaveChildren: 'yes' }
          'label': { elementName: 'de-label', canHaveChildren: 'no' }
          'container': { elementName: 'de-container', canHaveChildren: 'yes' }
          'checkbox': { elementName: 'de-checkbox', canHaveChildren: 'no' }
          'toggleableContainer': { elementName: 'de-toggleable-container', canHaveChildren: 'yes' }
          'checkList': { elementName: 'de-check-list', canHaveChildren: 'no' }
          'radioList': { elementName: 'de-radio-list', canHaveChildren: 'no' }
          'singleSelectDropdown': { elementName: 'de-single-select-dropdown', canHaveChildren: 'no' }
          'input': { elementName: 'de-input', canHaveChildren: 'no' }
          'incrementalCounter': { elementName: 'de-incremental-counter', canHaveChildren: 'no' }
          'autocomplete': { elementName: 'de-autocomplete', canHaveChildren: 'no' }
        }
    shouldRender:
      type: Boolean
      value: false

  $both: (a, b)-> return a and b

  $equals: (left, right)-> left is right

  $inc: (value)-> value + 1

  observers: [
    'systemChanged(def, data)'
    'shouldRenderChanged(shouldRender, elementMap)'
  ]

  shouldRenderChanged: (shouldRender, elementMap)->
    return unless shouldRender

    insertionPoint = @$$('.element-insertion-point')
    while Polymer.dom(insertionPoint).firstChild
      Polymer.dom(insertionPoint).firstChild.remove()

    for dynamicElement in @def.childList
      de = @elementMap[dynamicElement.type]

      newElement = document.createElement de.elementName
      newElement.data = @$makeData(dynamicElement, de.canHaveChildren)
      newElement.def = dynamicElement
      newElement.depth = @$inc(@depth)
      Polymer.dom(insertionPoint).appendChild newElement

  systemChanged: (def, data)->
    if def and data
      if def.key is data.forKey and def.type is data.forType
        @shouldRender = true
        return
    @shouldRender = false

  $makeData: (dynamicElement, canHaveChildren = 'yes')->
    unless 'childMap' of @data
      @data.childMap = {}
    unless dynamicElement.key of @data.childMap
      object = {
        forType: dynamicElement.type
        forKey: dynamicElement.key
      }
      object.childMap = {} if canHaveChildren is 'yes'
      @data.childMap[dynamicElement.key] = object
    return @data.childMap[dynamicElement.key]

  propagateDynamicDataAlterationSignal: (action, path)->
    path.unshift '<array>'
    @domHost.propagateDynamicDataAlterationSignal action, path

}
