linter-crystal
=========================

This linter plugin for [Linter](https://github.com/AtomLinter/Linter) provides an interface to Crystal's builtin syntax analysis. It will be used with files that have the `Crystal` syntax.

If you do not have a valid `Crystal` syntax, you should install the one I've created by running `apm install language-crystal-actual` in your Shell, or by searching for the `language-crystal-actual` in your editor.

As well, you must have the Crystal compiler installed on this system for this to work, to learn how to install this please visit the [Crystal Language Documentation](http://crystal-lang.org/docs/installation/README.html).

## Installation
Linter package must be installed in order to use this plugin. If Linter is not installed, please follow the instructions [here](https://github.com/AtomLinter/Linter).

### Plugin installation
```
$ apm install linter-crystal
```

## Settings
Using the Settings for the Package you may change the state of any of these properties to change how files are linted:
- `Build Artifacts` when disabled passes the `--no-build` option to the compiler to prevent it from outputing anything.
- `Color Output` when disabled passes the `--no-color` option to the compiler to prevent it from coloring and bolding the console outputs. This option only exists in Crystal version >= 0.7
- `Command` allows you to set the command Linter runs when your file is linted.
- `Live Linting` when enabled lints the current state of the current file in a temporary directory, this breaks relative requirements, but this mode is useful if writing a script. When disabled the file is linted in the directory it's saved in at save and opening, keeping in tact relative requirements.

## Contributing
If you would like to contribute enhancements or fixes, please do the following:

1. Fork the plugin repository.
1. Hack on a separate topic branch created from the latest `master`.
1. Commit and push the topic branch.
1. Make a pull request.
1. welcome to the club

Please note that modifications should follow these coding guidelines:

- Indent is 2 spaces.
- Code should pass coffeelint linter.
- Vertical whitespace helps readability, don’t be afraid to use it.

Thank you for helping out!
