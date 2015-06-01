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
    console.log 'activate linter-crystal' if atom.inDevMode()
    unless atom.packages.getLoadedPackages 'linter-plus'
      @showError '[linter-crystal] `linter-plus` package not found, please install it'

  showError: (message = '') ->
    atom.notifications.addError message

  provideLinter: ->
    {
      scopes: ['source.crystal']
      scope: 'file'
      lint: @lint
      lintOnFly: false
    }

  lint: (TextEditor, TextBuffer) ->
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
      Process = CP.exec("#{@cmd} #{Path.basename(FilePath)}",
        {cwd: Path.dirname(FilePath)})
      Process.stdout.on 'data', (data) -> Data.push(data.toString())
      Process.on 'close', ->
        Content = []
        for line in Data
          Content.push XRegExp.exec(line, regex)
          console.log line# if atom.inDevMode()
        ToReturn = []
        Content.forEach (regex) ->
          if regex
            if Path.basename(FilePath) == Path.normalize(regex.file)
              ToReturn.push(
                Type: 'Error',
                Message: regex.message,
                File: FilePath
                Position: [[regex.line, 0], [regex.line, TextBuffer.lineLengthForRow(regex.line)]]
              )
            else
              ToReturn.push(
                Type: 'Error',
                Message: regex.message,
                File: Path.normalize(regex.file)
                Position: [[regex.line, 0], [regex.line, 0]]
              )
        Resolve(ToReturn)
