linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"

class LinterCrystal extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.crystal']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'crystal'

  executablePath: null

  errorStream: 'stdout'

  linterName: 'crystal'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '.+:(?<line>\\d+): (\\[1m)?(?<message>.+)(\\[0m)?'

  constructor: (editor)->
    super(editor)

    atom.config.observe 'linter-crystal.crystalExecutablePath', =>
      @executablePath = atom.config.get 'linter-crystal.crystalExecutablePath'

  lintFile: (filePath, callback) ->
    @cmd = atom.config.get 'linter-crystal.crystalCommandName'

    super(filePath, callback)

  destroy: ->
    atom.config.unobserve 'linter-crystal.crystalExecutablePath'

module.exports = LinterCrystal
