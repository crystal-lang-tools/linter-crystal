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
      @showError '[linter-crystal] `linter-plus` package not found, please install it'

  showError: (message = '') ->
    atom.notifications.addError message

  provideLinter: -> {
    grammarScopes: ['source.crystal']
    scope: 'file'
    lint: @lint
    lintOnFly: false
  }

  lint: (TextEditor) ->
    CP = require 'child_process'
    Path = require 'path'
    XRegExp = require('xregexp').XRegExp

    regex = XRegExp('Error in (?<file>.+):(?<line>\\d+): (?<message>.+)')

    return new Promise (Resolve) ->
      FilePath = TextEditor.getPath()
      return unless FilePath # Files that have not be saved
      Data = []
      @cmd = atom.config.get 'linter-crystal.command'
      @cmd = "#{@cmd} --no-build" unless atom.config.get 'linter-crystal.buildOutput'
      @cmd = "#{@cmd} --no-color" unless atom.config.get 'linter-crystal.colorOutput'
      command = "#{@cmd} #{Path.basename(FilePath)}"
      Process = CP.exec(command, {cwd: Path.dirname(FilePath)})
      console.log "linter-crystal command: #{command}" if atom.inDevMode()
      Process.stdout.on 'data', (data) -> Data.push(data.toString())
      Process.on 'close', ->
        Content = []
        for line in Data
          Content.push XRegExp.exec(line, regex)
          console.log "linter-crystal command output: #{line}" if atom.inDevMode()
        ToReturn = []
        Content.forEach (regex) ->
          if regex
            ToReturn.push(
              type: 'error',
              text: regex.message,
              filePath: Path.join(Path.dirname(FilePath), regex.file).normalize()
              range: [
                [regex.line - 1, 0],
                [regex.line - 1, 0]
              ]
            )
        Resolve(ToReturn)
