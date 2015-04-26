module.exports =
  configDefaults:
    # Should the lint only lint in the actual file path (this fixes problems
    #   with relative requirements)
    cyrstalUseActualFilePath: true
    crystalCommandName: 'crystal build --no-build'

  activate: ->
    if atom.inDevMode()
      console.log 'activate linter-crystal'
