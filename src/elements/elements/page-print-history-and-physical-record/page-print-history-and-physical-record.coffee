
Polymer {

  is: 'page-print-history-and-physical-record'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
  ]

  properties:
    record:
      type: Object
      notify: true
      value: null

    patient:
      type: Object
      notify: true
      value: null

    recordDatabaseCollectionName:
      type: String
      value: null

    recordPartName:
      type: String
      value: null

    recordPartData:
      type: Object
      value: null

    recordPartDef:
      type: Object
      value: null

    recordPartTitle:
      type: String
      value: null

    recordPartHtmlContent:
      type: String
      value: null

    shouldRender:
      type: Boolean
      value: false

    delayRendering:
      type: Boolean
      value: false

    settings:
      type: Object
      notify: true

  _computeAge: (dateString)->
    today = new Date()
    birthDate = new Date dateString
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()

    if m < 0 || (m == 0 && today.getDate() < birthDate.getDate())
      age--
    
    return age

  printButtonPressed: (e)->
    window.print()

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  _getRecord: (recordIdentifier, desiredRecordType)->
    list = app.db.find desiredRecordType, ({serial})-> serial is recordIdentifier
    if list.length is 1
      return list[0]
    else
      return null

  _getPatient: (patientIdentifier)->
    list = app.db.find 'patient-list', ({serial})-> serial is patientIdentifier
    if list.length is 1
      return list[0]
    else
      return null

  navigatedIn: ->

    params = @domHost.getPageParams()

    unless params['record']
      @domHost.showModalDialog 'Missing Record!'
      return

    @set 'recordPartName', 'history-and-physical-record'

    @recordDatabaseCollectionName = 'history-and-physical-record'

    @record = @_getRecord params['record'], @recordDatabaseCollectionName

    unless @record
      @domHost.showModalDialog 'Invalid Record Identifier'
      return

    unless 'patientSerial' of @record
      @domHost.showModalDialog 'Missing Patient from Record'
      return

    @patient = @_getPatient @record.patientSerial

    unless @patient
      @domHost.showModalDialog 'Invalid Patient Identifier'
      return

    @settings = @_getSettings()

    @recordPartData = @record

    @recordPartTitle = 'History and Physical Record'

    @domHost.getStaticData 'dynamicElementDefinitionPreoperativeAssessment', (def)=>
      
      @recordPartDef = def

      @recordPartHtmlContent = @generateHtmlContent @recordPartDef, @recordPartData

      # console.log @recordPartHtmlContent

      unless @delayRendering
        
        @shouldRender = true


  navigatedOut: ->

    @shouldRender = false

  ## SETTINGS ======================================================================================

  _makeSettings: ->
    settings = 
      serial: 'only'
      isSyncEnabled: false
      printDecoration: 
        leftSideLine1: 'My Institution'
        leftSideLine2: 'My Institution Address'
        leftSideLine3: 'My Institution Contact'
        rightSideLine1: 'My Name'
        rightSideLine2: 'My Degrees'
        rightSideLine3: 'My Contact'
        footerLine: 'A simple message on the bottom'
        logoDataUri: null
      billingTargetEmailAddress: ''
      nsqipTargetEmailAddress: ''
      monetaryUnit: 'BDT'

  _getSettings: ->
    list = app.db.find 'settings', ({serial})=> serial is @generateSerialForSettings()
    return list[0] if list.length

  ## NOTE - PRINT ======================================================================================
  # The code below is unavoidably messy looking due to the various requirements in the data 
  # definition. If the namespace is not polluted then we will not have any serious consequences
  # when it comes to performance.

  generateHtmlContent: (def, data)->
    html = @handle_type def, data.data
    html = @filterHtmlContent html
    return html

  filterHtmlContent: (html)->
    html = html.replace /@VALUE@/g, ''
    return html

  printOutStyleSheet: ->
    """
    <style>
      
      .default-category {
        /* font-size: 20px; 
        font-weight: bold; */
        text-align: center; 
      }
      .default-collection {
        /* font-size: 16px; 
        font-weight: bold; */
      }
      .default-group {
        /* text-decoration: overline; */
      }
      .default-card {
        /* text-decoration: underline; */
      }
      span {
        font-size: 14px;
      }
      .unprocessed {
        color: red;
      }
    </style>
    """

  handle_children: (def, data)->
    html = ''
    # console.log data
    if 'childMap' of data and 'childList' of def and def.childList isnt null
      for child, childIndex in def.childList
        if child.key of data.childMap
          childHtml = @handle_type child, data.childMap[child.key]
          if childHtml and not (childHtml in [ ';', ':;', ': ;' ])
            childHtml = @sanitizeOutput childHtml
            html += childHtml
    else
      console.log 'end-case'
    return html

  handle_type: (def, data)->
    # console.log def.key, @listPrintDirectives def
    def.print = {} unless 'print' of def
    if def.type is 'systemRoot'
      @flattenStyle def
      return @type_systemRoot def, data
    else if def.type is 'category'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 18 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_category def, data
    else if def.type is 'collection'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 16 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_collection def, data
    else if def.type is 'group'
      def.print.passThrough = true unless 'passThrough' of def.print
      def.print.fontSize = 14 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_group def, data
    else if def.type is 'card'
      def.print.boldLabel = true unless 'boldLabel' of def.print
      def.print.fontSize = 14 unless 'fontSize' of def.print
      @flattenStyle def
      return @type_card def, data
    else if def.type is 'checkbox'
      @flattenStyle def
      return @type_checkbox def, data
    else if def.type is 'toggleableContainer'
      @flattenStyle def
      return @type_toggleableContainer def, data
    else if def.type is 'label'
      @flattenStyle def
      return @type_label def, data
    else if def.type is 'autocomplete'
      if 'selectionType' of def and def.selectionType is 'label'
        def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_autocomplete def, data
    else if def.type is 'container'
      @flattenStyle def
      return @type_container def, data
    else if def.type is 'checkList'
      def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_checkList def, data
    else if def.type is 'radioList'
      def.print.separatorString = ", " unless 'separatorString' of def.print
      @flattenStyle def
      return @type_radioList def, data
    else if def.type is 'input'
      @flattenStyle def
      return @type_input def, data
    else if def.type is 'singleSelectDropdown'
      @flattenStyle def
      return @type_singleSelectDropdown def, data
    else if def.type is 'incrementalCounter'
      @flattenStyle def
      return @type_incrementalCounter def, data
    else
      return '<span class="unprocessed">UNPROCESSED ' + def.type + ' - ' + def.key + '</span>'


  flattenStyle: (def)->
    if 'passThrough' of def.print
      unless 'hideLabel' of def.print
        def.print.hideLabel = true
      unless 'noColonAfterThis' of def.print
        def.print.noColonAfterThis = true
      unless 'noSemicolonAfterThis' of def.print
        def.print.noSemicolonAfterThis = false
      # delete def.print['passThrough']
    if 'newLineBeforeThis' of def.print
      if typeof def.print.newLineBeforeThis is 'boolean'
        def.print.newLineBeforeThis = (if def.print.newLineBeforeThis is true then 1 else 0)
      else
        def.print.newLineBeforeThis = parseInt def.print.newLineBeforeThis
    if 'newLineAfterThis' of def.print
      if typeof def.print.newLineAfterThis is 'boolean'
        def.print.newLineAfterThis = (if def.print.newLineAfterThis is true then 1 else 0)
      else
        def.print.newLineAfterThis = parseInt def.print.newLineAfterThis
    if 'newLineAfterThisAndChildren' of def.print
      if typeof def.print.newLineAfterThisAndChildren is 'boolean'
        def.print.newLineAfterThisAndChildren = (if def.print.newLineAfterThisAndChildren is true then 1 else 0)
      else
        def.print.newLineAfterThisAndChildren = parseInt def.print.newLineAfterThisAndChildren
    if 'newLineAfterEachValue' of def.print
      if typeof def.print.newLineAfterEachValue is 'boolean'
        def.print.newLineAfterEachValue = (if def.print.newLineAfterEachValue is true then 1 else 0)
      else
        def.print.newLineAfterEachValue = parseInt def.print.newLineAfterEachValue

  sanitizeOutput: (content)->
    for i in [0..2]
      content = content.replace /\;;/g, ';'
      content = content.replace /\;;/g, ';'
      content = content.replace /\; ;/g, ';'
      content = content.replace /\: ;/g, ';'
      content = content.replace /\: :/g, ':'
      content = content.replace /\, ;/g, ';'
      content = content.replace /\; ,/g, ';'
      content = content.replace /\,;/g, ';'

      content = content.replace /<\/span style=""><\/span>/g, ''
      content = content.replace /<\/span>;<\/span>/g, '<\/span><\/span>'
      content = content.replace /<\/span>; <\/span>/g, '<\/span><\/span>'
      content = content.replace /<\/span> ,<\/span>/g, '<\/span><\/span>'

    return content


  ###
    REGION - VARIOUS TYPES
  ###

  _computeElementStyle: (def)->
    style = ''
    if def.print.fontSize
      style += "font-size: #{def.print.fontSize}px;"
    if def.print.hide
      style += "display: none;"
    return style

  _computeTitleOrLabelStyle: (def)->
    style = ''
    if def.print.boldLabel
      style += "font-weight: bold;"
    return style

  type_systemRoot: (def, data)->
    content = (@handle_children def, data)
    return @printOutStyleSheet() + content

  type_category: (def, data)->
    content = @handle_children def, data
    return '' if content.length is 0
    style = @_computeTitleOrLabelStyle def
    title = """<span style="#{style}">#{def.label}</span>"""
    style = @_computeElementStyle def
    html = """<div class="default-category" style="#{style}">#{title}</div>#{content}"""
    return html

  type_collection: (def, data)->
    return '' if (Object.keys data.childMap).length is 0
    if def.defaultGroup and not data.isDefaultGroupDismissed
      content = @handle_type def.defaultGroup, data.childMap[def.defaultGroup.key]
    else
      content = @handle_children def, data
    style = @_computeTitleOrLabelStyle def
    title = """<br><span style="#{style}">#{def.label}</span><br>"""
    style = @_computeElementStyle def
    html = """<span class="default-collection" style="#{style}">#{title}</span>: #{content}<br>"""
    return html

  type_group: (def, data)->
    content = @handle_children def, data
    style = @_computeTitleOrLabelStyle def
    title = """<span style="#{style}">#{def.label}</span>"""
    if def.print.passThrough
      html = """#{content};"""
    else
      style = @_computeElementStyle def
      html = """<span class="default-group" style="#{style}">#{title}</span>: #{content}; """
    return html

  _makePrintableContent: (label, content, value, def, data)->
    return '' if content.length is 0 and value.length is 0 and def.type isnt 'label'
    print = def.print

    # console.log label, print

    labelHtml = ''
    contentHtml = ''
    valueHtml = ''

    return '' if print.hide

    if label.length > 0
      unless print.hideLabel
        style = ''
        if print.boldLabel
          style += 'font-weight: bold;'
        if print.fontSize
          style += "font-size:#{print.fontSize}px;"
        labelHtml = """<span style="#{style}">#{label}</span>"""

    if value.length > 0
      unless print.hideValue
        style = ''
        if print.boldValue
          style += 'font-weight: bold;'
        if print.fontSize
          style += "font-size:#{print.fontSize}px;"
        valueHtml = """<span style="#{style}">#{value}</span>"""    

    if content.length > 0
      unless print.hideChildren
        style = ''
        if print.boldChildren
          style += 'font-weight: bold;'
        contentHtml = """<span style="#{style}">#{content}</span>"""

    if (labelHtml + contentHtml + valueHtml).length is 0
      return ''

    if 'newLineBeforeThis' of print
      for i in [0...print.newLineBeforeThis]
        labelHtml = '<br>' + labelHtml

    if 'newLineAfterThis' of print
      for i in [0...print.newLineAfterThis]
        labelHtml = labelHtml + '<br>'

    colon = (if ('noColonAfterThis' of print and print.noColonAfterThis) or labelHtml.length is 0 then '' else ': ')
    semicolon = (if 'noSemicolonAfterThis' of print and print.noSemicolonAfterThis then '' else '; ')
    html = labelHtml + colon + contentHtml + valueHtml + semicolon

    if 'newLineAfterThisAndChildren' of print
      for i in [0...print.newLineAfterThisAndChildren]
        html = html + '<br>'

    return html


  type_card: (def, data)->
    content = (@handle_children def, data)
    label = def.label
    value = null
    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data
    
  type_checkbox: (def, data)->
    content = null
    label = null

    if data.isChecked
      value = def.label
    else
      value = ''

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_label: (def, data)->
    content = null
    label = data.label or def.label or def.defaultLabel
    value = null
    
    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_toggleableContainer: (def, data)->
    return '' unless data.isChecked

    content = @handle_children def, data
    label = def.label
    value = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_container: (def, data)->
    content = @handle_children def, data
    label = data.label or def.defaultLabel
    value = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_checkList: (def, data)->
    print = def.print

    stringList = []
    for item in data.checkedValueList
      stringList.push item

    separatorString = print.separatorString
    if 'newLineAfterEachValue' of print
      for i in [0...print.newLineAfterEachValue]
        separatorString += '<br>'

    value = stringList.join separatorString 

    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_radioList: (def, data)->
    value = data.selectedValue
    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_singleSelectDropdown: (def, data)->
    value = def.possibleValueList[data.selectedIndex]
    label = null
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_input: (def, data)->
    content = data.value

    if def.unitDetails
      unit = def.unitDetails.unitList[data.selectedUnitIndex]
      # content += ' ' + unit.name

    value = content
    label = def.label
    content = null

    return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_autocomplete: (def, data)->
    print = def.print

    if def.selectionType is 'label'

      stringList = []
      for key, value of data.virtualChildMap
        title = key.split '_'
        title.pop()
        title.shift()
        title = title.join '_'
        stringList.push title

      separatorString = print.separatorString
      if 'newLineAfterEachValue' of print
        for i in [0...print.newLineAfterEachValue]
          separatorString += '<br>'

      value = stringList.join separatorString 

      label = def.label
      content = null

      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

    else
      content = ''
      for key, value of data.virtualChildMap
        title = key.split '_'
        title.pop()
        title.shift()
        title = title.join '_'

        virtualContainer = 
          type: 'container'
          defaultLabel: title
          key: key
          childList: def.childListForEachContainer

        childContent = (@handle_type virtualContainer, value) + ', '
        content += childContent

      value = null
      label = def.label

      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  type_incrementalCounter: (def, data)->
    content = ''
    for key, value of data.virtualChildMap
      title = key.replace 'item', ''
      serial = parseInt title

      virtualContainer = 
        type: 'container'
        defaultLabel: (try def.unit.singular catch ex then 'unit') + ' #' + (serial + 1)
        key: key
        childList: def.childListForEachContainer

      content += (@handle_type virtualContainer, value) + ';'

      value = null
      label = def.label
      return @_makePrintableContent (label or ''), (content or ''), (value or ''), def, data

  ###
    REGION - PRINT RELATED CHECKS
  ###

  should_boldLabel: (def)->
    'print' of def and 'boldLabel' of def.print and def.print.boldLabel

  should_passThrough: (def)->
    'print' of def and 'passThrough' of def.print and def.print.passThrough

  should_newLineBeforeThis: (def)->
    'print' of def and 'newLineBeforeThis' of def.print and def.print.newLineBeforeThis

  inject_passThrough_special_card: (def, data)->
    if def.key is def.label and def.key in [ "Details", 'Default' ]
      def.print = {} unless def.print
      def.print.passThrough = true

  inject_passThrough_special_group: (def, data)->
    if def.key is def.label and def.key in [ "List", 'Default' ]
      def.print = {} unless def.print
      def.print.passThrough = true

  __debug_print: (def, handledDirectiveList)->
    all = if 'print' of def then Object.keys(def.print) else []
    left = lib.array.minus all, handledDirectiveList
    if left.length > 0
      console.log 'UNHANDLED print directives', def, left


}