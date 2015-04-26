linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
path = require 'path'

class LinterCrystal extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.crystal']
  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'crystal build --no-build'
  errorStream: 'stdout'
  linterName: 'crystal'
  # Is the linter linting in the actual file's path.
  # This fixes isses with relative requirements.
  @pathLint: true
  # If the linter is being allowed to run or not.
  # This allows us to only lint when the file is run opened and when saved.
  @enabled: false

  # A regex pattern used to extract information from the executable's output.
  regex:
    '.+:(?<line>\\d+): (\\[1m)?(?<message>.+)(\\[0m)?'

  constructor: (@editor)->
    super(@editor)
    @pathLintListen =
      atom.config.observe 'linter-crystal.cyrstalUseActualFilePath', =>
        @pathLint = atom.config.get 'linter-crystal.cyrstalUseActualFilePath'
    if @pathLint
      @enabled = true

  lintFile: (filePath, callback) ->
    @cmd = atom.config.get 'linter-crystal.crystalCommandName'
    if @pathLint
      if @enabled
        origin_file = path.basename do @editor.getPath
        super(origin_file, callback)
    else
      super(filePath, callback)

  destroy: ->
    @pathLintListen.dispose()

module.exports = LinterCrystal
