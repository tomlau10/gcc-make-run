###
# a remake of kriscross07/atom-gpp-compiler with extended features
# https://github.com/kriscross07/atom-gpp-compiler
# https://atom.io/packages/gpp-compiler
###

GccMakeRunView = require './gcc-make-run-view'
{CompositeDisposable} = require 'atom'

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
    console.log 'compile()'
    # TODO:

  make: (srcPath) ->
    console.log 'make()'
    # TODO:

  run: (info) ->
    console.log 'run()'
    # TODO:
