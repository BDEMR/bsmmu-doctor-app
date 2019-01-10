
app.behaviors.commonComputes = 

  $equals: (left, right)-> left is right

  $if: (value, thenValue, elseValue)-> if value then thenValue else elseValue

  $iff: (value)-> value

  $sum: (a,b)-> a + b

  $and: (a,b)-> a and b

  $truncate: (string, maxCount)->
    return string if string.length <= maxCount
    return (string.substr 0, (maxCount - 3)) + '...'

  $mkDate: (date)-> lib.datetime.mkDate date

  $formatDate: (date)->
    return '' unless date
    formatObj = { 
      timeZone: 'Asia/Dhaka' 
      day: 'numeric'
      month: 'short'
      year: 'numeric'
    }
    return new Date(date).toLocaleString('en-GB', formatObj)

  $formatDateTime: (dateTime)->
    return '' unless dateTime
    formatObj = { 
      timeZone: 'Asia/Dhaka' 
      day: 'numeric'
      month: 'short'
      year: 'numeric'
      hour: '2-digit'
      minute: '2-digit'
    }
    # lib.datetime.format((new Date dateTime), 'mmm d, yyyy h:MMTT')
    return new Date(dateTime).toLocaleString('en-IN', formatObj)  

  $compareFn: (left, op, right)->
    if (op=='<')
      return left < right
    if (op=='>')
      return left > right
    if (op=='==')
      return left == right
    if (op=='>=')
      return left >= right
    if (op=='<=')
      return left <= right

  $mkDateTime: (ms)->
    if typeof ms is 'undefined'
      return lib.datetime.now()
    else
      return lib.datetime.format((new Date ms), 'mmm d, yyyy h:MMTT')

  $mkTime: (ms)-> lib.datetime.format((new Date ms), 'HH-MM-ss')

  $in: (item, list...)->
    item in list

  $returnSerial: (index)->
    index+1

  $isEmptyArray: (data)->
    if data is 0
      return true
    else
      return false

  $getFullName:(data)->

    if typeof data is "object"
      honorifics = ''
      first = ''
      last = ''
      middle = ''

      if data.honorifics  
        honorifics = data.honorifics + ". "
      if data.first
        first = data.first
      if data.middle
        middle = " " + data.middle
      if data.last
        last = " " + data.last
        
      return honorifics + first + middle + last

    else return data


  $makeNameObject: (fullName)->

    if typeof fullName is 'string'

      fullName = fullName.trim()

      partArray = fullName.split('.')

      namePart = partArray.pop()

      if partArray.length is 0 
        honorifics = ''
      else
        honorifics = partArray.join('.').trim()

      partArray = (namePart.trim()).split(' ')

      nameObject = {}

      if (partArray.length <= 1)
        first = partArray[0]
      else
        first = partArray.shift()
        last = partArray.pop()
        middle = partArray.join(' ')

        if ((middle is '') or (typeof middle is 'undefined'))
          middle = null
        
        if ((last is '') or (typeof last is 'undefined'))
          last = null

      if honorifics is ''
        honorifics = null

      nameObject.honorifics = honorifics
      nameObject.first = first
      nameObject.middle = middle
      nameObject.last = last
      return nameObject
    else
      return fullName


  $getProfileImage: (data)->
    if data
      return data
    else
      return 'images/avatar.png'


  $getAuthorizedOrganizationList: ()->

    list = app.db.find 'settings', ({serial})=> @user.serial is serial

    serialList = []

    if list
      if list.length > 0
        authorizedOrganiztionList = list[0].authorizedOrganiztionList

        for item in authorizedOrganiztionList
          if item.isChecked
            serialList.push item.idOnServer
 
    return serialList
  
  
  
  
  _getClassForFlaggedAsError: (data)->
    if data is true
      return 'danger'
    else return ''

      
