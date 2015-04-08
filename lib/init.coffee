module.exports =
  configDefaults:
    crystalExecutablePath: null
    crystalCommandName: 'crystal'

  activate: ->
    if atom.inDevMode()
      console.log 'activate linter-crystal'
