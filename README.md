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
By changing the Crystal Command config option you may change what the linter runs when your file is linted.

As well, your file is only linted when first opened and when saved, you may change this option in the settings as well so that your file is linted whenever you make an edit. (Warning: Changing this setting will cause your file to be linted in a temporary directory and mess with relative requirements.)

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
