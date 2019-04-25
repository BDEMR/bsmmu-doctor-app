Polymer {
  is: 'custom-vital-search'

  properties:
    startDate:
      type: String
      value: ''
      reflectToAttribute: true
    endDate:
      type: String
      value: ''
      reflectToAttribute: true
    filterDateRange:
      type: String
      value: ''

  filterButtonClicked: (e, detail)->
    @filterDateRange = "#{lib.datetime.format @startDate, 'mmm d, yyyy'} - #{lib.datetime.format @endDate, 'mmm d, yyyy'}"
    @fire 'date-select', {startDate: @startDate, endDate: @endDate}

  clearIconClicked: ()->
    @filterDateRange = ''
    @startDate = ''
    @endDate = ''
    @fire 'clear', {}
  
  showFilterModalButtonClicked: (e)->
    @.$.filterModal.toggle()
    #reset data
    @startDate = ''
    @endDate = ''

}