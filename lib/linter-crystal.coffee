linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
path = require 'path'

module.exports = class LinterCrystal extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.crystal']
  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: ''
  errorStream: 'stdout'
  linterName: 'crystal'
  # Is the linter linting in the actual file's path.
  # This fixes isses with relative requirements.
  @lintLive: false
  @colorBuild: false
  @buildOutput: false
  # A regex pattern used to extract information from the executable's output.
  regex: '.+:(?<line>\\d+): (?<message>.+)'

  constructor: (@editor)->
    super(@editor)
    @listen =
      atom.config.observe 'linter-crystal.liveLinting', (value) =>
        @lintLive = value
    atom.config.observe 'linter-crystal.colorOutput', (value) =>
      @colorBuild = value
    atom.config.observe 'linter-crystal.buildArtifacts', (value) =>
      @buildOutput = value

  lintFile: (filePath, callback) ->
    @cmd = atom.config.get 'linter-crystal.command'
    unless @colorBuild
      @cmd = "#{@cmd} --no-color"
    unless @buildOutput
      @cmd = "#{@cmd} --no-build"
    if @lintLive
      super(filePath, callback)
    else
      super((path.basename do @editor.getPath), callback)
    if atom.inDevMode()
      console.log "linter-crystal running command: #{@cmd}"

  destroy: ->
    @listen.dispose()
