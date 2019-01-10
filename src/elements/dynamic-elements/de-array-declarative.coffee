
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

}
