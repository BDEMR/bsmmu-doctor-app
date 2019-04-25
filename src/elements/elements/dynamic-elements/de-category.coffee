
Polymer {

  is: 'de-category'

  properties:
    data:
      type: Object
      value: null
    def:
      type: Object
      value: null

  $makeData: (collection)->
    unless collection.key of @data.childMap
      @data.childMap[collection.key] = {
        forType: 'collection'
        forKey: collection.key
        childMap: {}
      }
    return @data.childMap[collection.key]

  propagateDynamicDataAlterationSignal: (action, path)->
    path.unshift @def.key
    @domHost.propagateDynamicDataAlterationSignal action, path

}
