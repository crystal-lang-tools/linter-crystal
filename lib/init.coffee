module.exports =
  config:
    liveLinting:
      type: 'boolean'
      default: false
    buildArtifacts:
      type: 'boolean'
      default: false
    colorOutput:
      type: 'boolean'
      default: false
    command:
      type: 'string'
      default: 'crystal build'


  activate: ->
    if atom.inDevMode()
      console.log 'activate linter-crystal'
