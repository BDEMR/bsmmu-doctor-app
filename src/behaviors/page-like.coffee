
app.behaviors.pageLike = [
  {

    ready: ->
      # @debugInfo 'ready'
      @domHost.pageReady @

    locateParentNode: (el, nodeName)->
      while el.nodeName isnt nodeName
        el = el.parentNode
      return el

    # region: wallet - START =============================================

    # $gte: (a, b)-> a >= b

    addBalanceTapped: (e)->
      amount = e.target.getAttribute('data-amount') or '100';
      this.domHost.showModalInput "Enter amount in BDT", amount, (answer)=>
        if answer
          amount = parseInt answer
          if amount < 10
            this.domHost.showModalDialog "Insert an amount of 10 or more."
            return
          this._addFunds(amount)
          
    _addFunds: (amount)->
      query = {
        apiKey: (app.db.find 'user')[0].apiKey
        amountToAdd:amount
        currency: 'BDT'
        notes: 'Funding for "My Tests"'
      }
      this.domHost.callApi '/bdemr-wallet-add-funds', query, (err, response)=>
        if (not err) and (not response.hasError)
          window.location = response.data.redirectionUrl.replace('//', 'https://')
      
    _showWalletFundingDialog: ->
      params = this.domHost.getPageParams()
      if 'funding' of params
        if params.funding is 'successful'
          this.domHost.showModalDialog "Thank you for your payment."
        else
          this.domHost.showModalDialog "Something went wrong with your payment. Please try again."

    _loadWallet: ->
      # this._showWalletFundingDialog()
      query = {
        apiKey: (app.db.find 'user')[0].apiKey
      }
      this.domHost.callApi '/bdemr-wallet-get-balance-and-transaction-details', query, (err, response)=>
        console.log(response)
        if (not err) and (not response.hasError)
          this.walletBalance = response.data.balance
        else
          this.walletBalance = -1;
        this.domHost.set('walletBalance',this.walletBalance)

    _loadPatientWallet: (id)->
      # this._showWalletFundingDialog()
      query = {
        apiKey: (app.db.find 'user')[0].apiKey
        userIdOverride: id
      }
      this.domHost.callApi '/bdemr-wallet-get-balance-and-transaction-details', query, (err, response)=>
        console.log(response)
        if (not err) and (not response.hasError)
          this.patientWalletBalance = response.data.balance
        else
          this.patientWalletBalance = -1;
        this.domHost.set('patientWalletBalance',this.patientWalletBalance)

    _loadPatientOrganizationWallet: (organizationId, patientId, cbfn)->   
      query = {
        apiKey: (app.db.find 'user')[0].apiKey
        organizationId
        searchString: ''
      }
      this.domHost.callApi '/bdemr-organization-list-patient', query, (err, response)=>
        unless response.data
          return cbfn null
        for patient in response.data.matchingPatientList
          if patient.patientId is patientId
            cbfn patient
            return
        cbfn null

    # _chargeUser: (amount, purpose, cbfn)->
    #   query = {
    #     apiKey: (app.db.find 'user')[0].apiKey
    #     amountInBdt: amount
    #     notes: purpose
    #   }
    #   this.domHost.callApi '/bdemr-wallet-charge-user', query, (err, response)=>
    #     if (err)
    #       return cbfn err
    #     if response.hasError
    #       return cbfn response.error
    #     return cbfn()

    _chargePatient: (patientId, amount, purpose, cbfn)->
      query = {
        apiKey: (app.db.find 'user')[0].apiKey
        amountInBdt: amount
        notes: purpose
        userIdOverride: patientId
      }
      if (!this.domHost.shouldChargePatientInsteadOfOrganization)
        query.organization2IdOverride = this.domHost.getCurrentOrganization().idOnServer
      this.domHost.callApi '/bdemr-wallet-charge-user', query, (err, response)=>
        if (err)
          return cbfn err
        if response.hasError
          return cbfn response.error
        if ((typeof response.data) == 'object') && ('remainingOrganizationFocCount' of response.data)
          this.domHost.remainingOrganizationFocCount = response.data.remainingOrganizationFocCount
        return cbfn()

    # region: end - START =============================================

    # navigatedIn: ->
    #   @debugInfo 'navigatedIn'

    # navigatedOut: ->
    #   @debugInfo 'navigatedOut'


  }
  , app.behaviors.debug
]