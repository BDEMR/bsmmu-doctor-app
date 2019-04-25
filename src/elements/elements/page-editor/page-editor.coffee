
Polymer {

  is: 'page-editor'

  behaviors: [ 
    app.behaviors.commonComputes
    app.behaviors.dbUsing
    app.behaviors.translating
    app.behaviors.pageLike
    app.behaviors.apiCalling
  ]

  properties: {}

  arrowBackButtonPressed: (e)->
    @domHost.navigateToPreviousPage()

  presentEditor: ->
    editor.hide()
    editor.show()
    editor.setContent(editor.toEdit)
    editor.setBackButtonCallbackFn (@editorBackButtonPressed.bind @)

  navigatedIn: ->
    # params = @domHost.getPageParams()
    # if params['patient']
    #   @_loadPatient params['patient']
    # else
    #   @_notifyInvalidPatient()
    # resetLayout 
    if editor.isInitialized
      @presentEditor()
    else
      lib.util.delay 100, =>
        editor.init()
        editor.isInitialized = true
        @presentEditor()

  editorBackButtonPressed: (content)->
    content = editor.getContent()
    el = @domHost.querySelector 'app-drawer-layout'
    el.resetLayout()
    editor.toEdit = content
    @domHost.navigateToPreviousPage()

  navigatedOut: ->
    

}
