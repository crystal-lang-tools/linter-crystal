'use babel';

export default {
  config: {
    compilerExecPath: {
      title: 'Compiler Executable Path',
      description: 'The path (with excutable) to be run by the IDE in the background. By default the IDE will use the compiler in your path.',
      type: 'string',
      default: 'crystal'
    },
    buildArtifacts: {
      title: 'Output Build Artifacts',
      description: 'When true the compiler will create build artifacts when run by the linter.',
      type: 'boolean',
      default: false
    },
    colorOutput: {
      title: 'Compiler passing Color Output',
      description: 'When false the compiler will not pass ASCII color characters to the linter when run by the linter.',
      type: 'boolean',
      default: false
    },
    command: {
      title: 'Compiler Command',
      description: 'The command passed to the commpiler during linting.',
      type: 'string',
      default: 'compile'
    }
  },

  activate: () => {},

  provideLinter: () => {
    const helpers = require('atom-linter')
    return {
      grammarScopes: ['source.crystal'],
      scope: 'file',
      lintOnFly: false,
      lint: (activeEditor) => new Promise((resolve) => {
        const command = atom.config.get('linter-crystal.compilerExecPath')
        const args = []
        args.push(atom.config.get('linter-crystal.command'))
        if(!atom.config.get('linter-crystal.buildArtifacts')) {
          args.push('--no-codegen')
        }
        if(!atom.config.get('linter-crystal.colorOutput')) {
          args.push('--no-color')
        }
        args.push('-f', 'json')
        args.push(activeEditor.getPath())
        resolve(helpers.exec(command, args).then(output => {
          if (!output) return []
          const result = []
          for (issue of JSON.parse(output)) {
            result.push({
              type: "Error",
              text: issue.message,
              filePath: issue.file,
              range: [
                [issue.line - 1, issue.column - 1],
                [issue.line - 1, issue.column + issue.size - 1]
              ]
            })
          }
          return result
        }))
      })
    }
  }
}
