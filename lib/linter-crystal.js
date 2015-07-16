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
      default: 'build'
    }
  },

  activate: () => {
    // Show the user an error if they do not have the appropriate Crystal
    //  Language package from Atom Package Manager installed.
    if(!atom.packages.getLoadedPackages('language-crystal-actual')) {
      atom.notifications.addError(
        'Crystal Language Package not found.',
        {
          detail: 'Please install the `language-crystal-actual` package in your Settings view.'
        }
      )
    }

    // Show the user an error if they do not have an appropriate linter base
    //  package installed from Atom Package Manager. This will not be an issues
    //  after a base linter package is integrated into Atom, in the comming
    //  months.
    // TODO: Remove when Linter Base is integrated into Atom.
    if(!atom.packages.getLoadedPackages('linter')) {
      atom.notifications.addError(
        'Linter package not found.',
        {
          detail: 'Please install the `linter` package in your Settings view.'
        }
      )
    }
  },

  provideLinter: () => {
    const LinterProvider = require('./provider')
    const provider = new LinterProvider()
    return {
      grammarScopes: ['source.crystal'],
      scope: 'file',
      lint: provider.lint,
      lintOnFly: false
    }
  }
}
