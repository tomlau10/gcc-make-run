###
# a remake of kriscross07/atom-gpp-compiler with extended features
# https://github.com/kriscross07/atom-gpp-compiler
# https://atom.io/packages/gpp-compiler
###

GccMakeRunView = require './gcc-make-run-view'
{CompositeDisposable} = require 'atom'
{parse} = require 'path'
{exec} = require 'child_process'

module.exports = GccMakeRun =
  config:
    'C':
      title: 'gcc Compiler'
      type: 'string'
      default: 'gcc'
      order: 1
      description: 'Compiler for C, in full path or command name (make sure it is in your $PATH)'
    'C++':
      title: 'g++ Compiler'
      type: 'string'
      default: 'g++'
      order: 2
      description: 'Compiler for C++, in full path or command name (make sure it is in your $PATH)'
    'make':
      title: 'make Utility'
      type: 'string'
      default: 'make'
      order: 3
      description: 'The make utility used for compilation, in full path or command name (make sure it is in your $PATH)'
    'uncondBuild':
      title: 'Unconditional Build'
      type: 'boolean'
      default: false
      order: 4
      description: 'Compile even if executable is up to date'
    'cflags':
      title: 'Compiler Flags'
      type: 'string'
      default: ''
      order: 5
      description: 'Flags for compiler, eg: -Wall'
    'ldlibs':
      title: 'Link Libraries'
      type: 'string'
      default: ''
      order: 6
      description: 'Libraries for linking, eg: -lm'
    'args':
      title: 'Run Arguments'
      type: 'string'
      default: ''
      order: 7
      description: 'Arguments for executing, eg: 1 "2 3"'

  gccMakeRunView: null

  activate: (state) ->
    @gccMakeRunView = new GccMakeRunView(@)
    atom.commands.add 'atom-workspace', 'gcc-make-run:compile-run': => @compile()
    atom.commands.add '.tree-view .file > .name', 'gcc-make-run:make-run': (e) => @make(e.target.getAttribute('data-path'))

  deactivate: ->
    @gccMakeRunView.cancel()

  serialize: ->
    gccMakeRunViewState: @gccMakeRunView.serialize()

  compile: () ->
    # get editor
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    # save file
    try
      editor.save() if editor.isModified()
    catch error
      atom.notifications.addError('Temporary files must be saved first')
      return

    # get grammar
    grammar = editor.getGrammar().name
    switch grammar
      when 'C', 'C++' then
        # do nothing
      when 'Makefile'
        @make(editor.getPath())
        return
      else
        atom.notifications.addError('Only C, C++ and Makefile are supported')
        return

    # get config
    info = parse(editor.getPath())
    info.useMake = false;
    info.exe = "#{info.name}.exe"
    compiler = atom.config.get("gcc-make-run.#{grammar}")
    cflags = atom.config.get('gcc-make-run.cflags')
    ldlibs = atom.config.get('gcc-make-run.ldlibs')

    # compile
    cmd = "\"#{compiler}\" #{cflags} \"#{info.base}\" -o \"#{info.name}\" #{ldlibs}"
    atom.notifications.addInfo(cmd)
    exec(cmd , { cwd: info.dir }, @onBuildFinished.bind(@, info))

  make: (srcPath) ->
    # get config
    info = parse(srcPath)
    info.useMake = true;
    mk = atom.config.get('gcc-make-run.make')

    # make
    cmd = "\"#{mk}\" -f \"#{info.base}\""
    atom.notifications.addInfo('Start Building...')
    exec(cmd, { cwd: info.dir }, @onBuildFinished.bind(@, info))

  onBuildFinished: (info, error, stdout, stderr) ->
    # notifications about compilation status
    atom.notifications[if error then 'addError' else 'addWarning'](stderr.replace(/\n/g, '<br>'), { dismissable: true }) if stderr
    atom.notifications.addInfo(stdout.replace(/\n/g, '<br>')) if stdout

    # continue only if no error
    return if error
    atom.notifications.addSuccess('Build Success')
    @run(info)

  run: (info) ->
    # get config
    mk = atom.config.get('gcc-make-run.make')
    args = atom.config.get('gcc-make-run.args')

    # build the run cmd
    if info.useMake
      # TODO: use make run
      console.log 'make run'
    else
      info.cmd = "start \"#{info.exe}\" cmd /c \"\"#{info.exe}\" #{args} && pause || pause\""

      # run the cmd
      console.log info.cmd
      exec(info.cmd, { cwd: info.dir, env: info.env }, @onRunFinished.bind(@))

  onRunFinished: (error, stdout, stderr) ->
    # debug use
    if error
      console.log 'error:'
      console.log error
    if stdout
      console.log 'stdout:'
      console.log stdout
    if stderr
      console.log 'stderr:'
      console.log stderr
