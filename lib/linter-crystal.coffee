linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
path = require 'path'

class LinterCrystal extends Linter
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
    @lintLiveListen = atom.config.observe 'linter-crystal.liveLinting', =>
      @lintLive = atom.config.get 'linter-crystal.liveLinting'
    @colorListen = atom.config.observe 'linter-crystal.colorOutput', =>
      @colorBuild = atom.config.get 'linter-crystal.colorOutput'
    @buildOutputListen = atom.config.observe 'linter-crystal.buildArtifacts', =>
      @buildOutput = atom.config.get 'linter-crystal.buildArtifacts'

  lintFile: (filePath, callback) ->
    @cmd = atom.config.get 'linter-crystal.command'
    {command, args} = @getCmdAndArgs(filePath)
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
    @lintLiveListen.dispose()
    @colorListen.dipose()
    @buildOutputListen.dispose()

module.exports = LinterCrystal
