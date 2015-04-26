module.exports =
  configDefaults:
    # Should the lint only lint in the actual file path (this fixes problems
    #   with relative requirements)
    cyrstalUseActualFilePath: true
    crystalCommand: 'crystal build --no-build'

  activate: ->
    if atom.inDevMode()
      console.log 'activate linter-crystal'
