module.exports =
  configDefaults:
    crystalCommandName: 'crystal'

  activate: ->
    if atom.inDevMode()
      console.log 'activate linter-crystal'
