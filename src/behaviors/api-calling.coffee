desanitize = (object) ->
  if typeof object == 'string'
    return he.decode(object)
  if typeof object == 'object' and object != null
    if Array.isArray(object)
      i = 0
      while i < object.length
        object[i] = desanitize(object[i])
        i++
    else
      keys = Object.keys(object)
      i = 0
      while i < keys.length
        object[keys[i]] = desanitize(object[keys[i]])
        i++
  
  return object

app.behaviors.apiCalling = 

  showMessageLocal: (args...)->
    if @showModalDialog
      @showModalDialog.apply @, args
    else
      @domHost.showModalDialog.apply @domHost, args

  callApi: (args...)->
    if args.length is 3
      [ api, data, cbfn ] = args
      options = 
        automaticallyHandleNetworkErrors: false
    else if args.length is 4
      [ api, data, options, cbfn ] = args
    else
      throw new Error "Developer Error: Missing arguments in callApi"

    { automaticallyHandleNetworkErrors } = options

    if navigator.onLine or (window.location.href.indexOf('localhost:') isnt -1)
      lib.network.callBdemrPostApi api, data, (err, response)=>
        if err and automaticallyHandleNetworkErrors
          errorMessage = "Could not contact server. Please make sure you have an active internet connection and try again."
          el = document.querySelector 'root-element'
          el.showModalDialog errorMessage
        else
          if not err and response.hasError and response.error.name is "API_KEY_AUTH_FAILED"
            # errorMessage = 'You have been automatically logged out. Taking you to the login page.'
            # @showMessageLocal errorMessage
            context = if @logoutPressed then @ else @domHost
            try
              unless context.routeData and (context.routeData.page.indexOf("login") > -1)
                context.logoutPressed null
            catch err
              context.logoutPressed null
            return
          cbfn err, desanitize(response)
    else
      errorMessage = 'You are not Connected to the Internet. Please Try Again.'
      @showMessageLocal errorMessage

  ## region - pcc signup - start
  
  ## region - pcc signup - end

  


