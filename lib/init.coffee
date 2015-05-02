module.exports =
  configDefaults:
    liveLinting: false
    buildArtifacts: false
    colorOutput: false
    crystalCommand: 'crystal build'


  activate: ->
    if atom.inDevMode()
      console.log 'activate linter-crystal'
