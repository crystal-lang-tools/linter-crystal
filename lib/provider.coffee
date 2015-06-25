path = require 'path'
child_process = require 'child_process'

module.exports = class LinterProvider
  regex = /(.+) in (.+):(\d+): (.+)/

  getCommand = ->
    executable = atom.config.get 'linter-crystal.compilerExecPath'
    command = atom.config.get 'linter-crystal.command'
    final = "#{executable} #{command}"
    unless atom.config.get 'linter-crystal.buildArtifacts'
      final = "#{final} --no-build"
    unless atom.config.get 'linter-crystal.colorOutput'
      final = "#{final} --no-color"
    return final

  getCommandWithFile = (file) -> "#{getCommand()} #{file}"

  # This is based on code taken right from the linter-plus rewrite
  #   of `linter-crystal`.
  lint: (TextEditor) ->
    new Promise (Resolve) ->
      file = path.basename TextEditor.getPath()
      cwd = path.dirname TextEditor.getPath()
      data = []
      command = getCommandWithFile file
      console.log "Crystal Linter Command: #{command}" if atom.inDevMode()
      process = child_process.exec command, {cwd: cwd}
      process.stdout.on 'data', (d) -> data.push d.toString()
      process.on 'close', ->
        toReturn = []
        for line in data
          console.log "Crystal Linter Provider: #{line}" if atom.inDevMode()
          if line.match regex
            [type, file, line, message] = line.match(regex)[1..4]
            toReturn.push(
              type: type,
              text: message,
              filePath: path.join(cwd, file).normalize()
              range: [[line - 1, 0], [line - 1, 0]]
            )
        Resolve toReturn
