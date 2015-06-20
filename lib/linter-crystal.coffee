child_process = require 'child_process'
path = require 'path'

module.exports = LinterCrystal =
  config:
    buildArtifacts:
      type: 'boolean'
      default: false
    colorOutput:
      type: 'boolean'
      default: false
    command:
      type: 'string'
      default: 'crystal build'

  activate: ->
    unless atom.packages.getLoadedPackages 'linter-plus'
      atom.notifications.addError message '[linter-crystal] `linter-plus` package not found, please install it'

  provideLinter: -> {
    grammarScopes: ['source.crystal']
    scope: 'file'
    lint: @lint
    lintOnFly: false
  }

  lint: (TextEditor) ->
    regex = /.+ in (.+):(\d+): (.+)/
    return new Promise (Resolve) ->
      if TextEditor.getPath()
        file = path.basename TextEditor.getPath()
        cwd = path.dirname TextEditor.getPath()
        data = []
        command = atom.config.get 'linter-crystal.command'
        command = "#{command} --no-build" unless atom.config.get 'linter-crystal.buildOutput'
        command = "#{command} --no-color" unless atom.config.get 'linter-crystal.colorOutput'
        command = "#{command} #{file}"
        console.log "linter-crystal command: #{command}" if atom.inDevMode()
        process = child_process.exec command, {cwd: cwd}
        process.stdout.on 'data', (d) -> data.push d.toString()
        process.on 'close', ->
          toReturn = []
          for line in data
            console.log "linter-crystal command output: #{line}" if atom.inDevMode()
            if line.match regex
              match = line.match(regex)[1..3]
              file = match[0]
              line = match[1]
              message = match[2]
              toReturn.push(
                type: 'error',
                text: message,
                filePath: path.join(cwd, file).normalize()
                range: [[line - 1, 0], [line - 1, 0]]
              )
          Resolve(toReturn)
