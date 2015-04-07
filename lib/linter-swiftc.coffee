{BufferedProcess, BufferedNodeProcess} = require 'atom'
linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
path = require 'path'

class LinterCrystal extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.crystal']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: ''
  crystal: ''

  executablePath: null

  linterName: 'crystal'

  errorStream: 'stderr'

  # A regex pattern used to extract information from the executable's output.
  regex: ':(?<line>\\d+): (?<message>.*)'

  constructor: (editor) ->
    super(editor)

  lintFile: (filePath, callback) ->
     # save cmd to tmp
    tmp = @cmd

    @crystal = atom.config.get 'linter-crystal.crystalCommandName'
    if atom.inDevMode()
      console.log 'crystal-command: ' + @crystal

    @cmd = "#{@crystal} #{@cmd}"

    # build the command with arguments to lint the file
    {command, args} = @getCmdAndArgs(filePath)

    if atom.inDevMode()
      console.log 'is node executable: ' + @isNodeExecutable

    # use BufferedNodeProcess if the linter is node executable
    if @isNodeExecutable
      Process = BufferedNodeProcess
    else
      Process = BufferedProcess

    # options for BufferedProcess, same syntax with child_process.spawn
    options = {cwd: @cwd}

    stdout = (output) =>
      if atom.inDevMode()
        console.log 'stdout', output
      if @errorStream == 'stdout'
        @processMessage(output, callback)

    stderr = (output) =>
      if atom.inDevMode()
        console.warn 'stderr', output
      if @errorStream == 'stderr'
        @processMessage(output, callback)

    new Process({command, args, options, stdout, stderr})

    #restore cmd
    @cmd = tmp;

  createMessage: (match) ->
    # message might be empty, we have to supply a value
    if match and match.type == 'parse' and not match.message
      message = 'error'

    super(match)

module.exports = LinterCrystal
