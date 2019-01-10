gulp = require('gulp')
path = require('path')
fs = require('fs')
glob = require('glob')
path = require('path')
crypto = require('crypto')
cheerio = require('cheerio')
urllib = require 'url'

# Making production cache ready
gulp.task 'manifest', ->

  # hash function
  sha1 = (data) ->
    crypto.createHash('sha1').update(data).digest 'hex'

  # hashes a file
  hashFile = (pathStr)->
    content = fs.readFileSync(pathStr, 'utf8')
    return sha1 content

  # Walks Directories
  walk = (dir, regExcludes, done) ->
    results = []
    fs.readdir dir, (err, list) ->
      if err
        return done(err)
      pending = list.length
      if !pending
        return done(null, results)
      list.forEach (file) ->
        file = path.join(dir, file)
        excluded = false
        len = regExcludes.length
        i = 0
        while i < len
          if file.match(regExcludes[i])
            excluded = true
          i++
        # Add if not in regExcludes
        if excluded == false
          results.push file
          # Check if its a folder
          fs.stat file, (err, stat) ->
            if stat and stat.isDirectory()
              # If it is, walk again
              walk file, regExcludes, (err, res) ->
                results = results.concat(res)
                if !--pending
                  done null, results
                return
            else
              if !--pending
                done null, results
            return
        else
          if !--pending
            done null, results
        return
      return
    return

  readAnProcessHtmlFile = (pathStr) ->
    console.log "Processing #{pathStr}"

    content = fs.readFileSync pathStr, 'utf8'

    $doc = cheerio.load content, { decodeEntities: true }

    changes = 0

    do ->
      $imports = $doc('link[rel=import]')
      $imports.each (i, elem)->
        depUrl = $doc(elem).attr('href')

        return if (depUrl.indexOf 'http') is 0

        urlObject = urllib.parse depUrl, true
        delete urlObject['search']

        depPath = (path.join (path.dirname pathStr), urlObject.pathname)

        readAnProcessHtmlFile depPath

        hash = hashFile depPath

        urlObject.query['sha1'] = hash

        newDepUrl = urllib.format urlObject
        $doc(elem).attr('href', newDepUrl)

        changes += 1

    do ->
      $imports = $doc('script, img, iron-icon, paper-icon-button') # note: Add other tags here who's src needs to be cache-d
      $imports.each (i, elem)->
        depUrl = $doc(elem).attr('src')

        return if (not depUrl) or (depUrl.indexOf 'http') is 0

        urlObject = urllib.parse depUrl, true
        delete urlObject['search']

        depPath = (path.join (path.dirname pathStr), urlObject.pathname)
        return unless fs.existsSync depPath

        hash = hashFile depPath

        urlObject.query['sha1'] = hash

        newDepUrl = urllib.format urlObject
        console.log "Found      #{newDepUrl}" 

        $doc(elem).attr('src', newDepUrl)
        
        changes += 1

    do ->
      $imports = $doc('link')
      $imports.each (i, elem)->
        return if $doc(elem).attr('rel') is 'import' # note: we already handled those

        depUrl = $doc(elem).attr('href')

        return if (not depUrl) or (depUrl.indexOf 'http') is 0

        urlObject = urllib.parse depUrl, true
        delete urlObject['search']

        depPath = (path.join (path.dirname pathStr), urlObject.pathname)

        hash = hashFile depPath

        urlObject.query['sha1'] = hash

        newDepUrl = urllib.format urlObject
        console.log "Found      #{newDepUrl}" 

        $doc(elem).attr('href', newDepUrl)
        
        changes += 1


    if changes > 0
      console.log "Writing    #{pathStr}"
      newContent = $doc.html()
      fs.writeFileSync pathStr, newContent
    else
      console.log "Skipping   #{pathStr}"



  regExcludes = []

  walk 'build-debug/elements/page-visit-editor/', regExcludes, (err, resultsArray) ->
    throw err if err
    
    for pathStr in resultsArray
      stats = fs.statSync pathStr
      if stats.isFile() and (path.extname pathStr) is '.html'
        readAnProcessHtmlFile pathStr

    console.log 'end of walking'