###
# heavily modified from rgbkrk/atom-script - lib/script-options-view.coffee
# https://github.com/rgbkrk/atom-script
# https://atom.io/packages/script
###

{CompositeDisposable} = require 'atom'
{View} = require 'atom-space-pen-views'

module.exports =
class RunOptionsView extends View

  @content: ->
    @div =>
      @div class: 'overlay from-top panel run-options-view', outlet: 'runOptionsView', =>
        @div class: 'panel-heading', 'Configure Compile-Run Options'
        @table =>
          @tr =>
            @td => @label 'Compiler Flags:'
            @td =>
              @input
                keydown: 'traverseFocus'
                type: 'text'
                class: 'editor mini native-key-bindings'
                outlet: 'cflags'
          @tr =>
            @td => @label 'Link Libraries:'
            @td =>
              @input
                keydown: 'traverseFocus'
                type: 'text'
                class: 'editor mini native-key-bindings'
                outlet: 'ldlibs'
          @tr =>
            @td => @label 'Run Arguments:'
            @td =>
              @input
                keydown: 'traverseFocus'
                type: 'text'
                class: 'editor mini native-key-bindings'
                outlet: 'args'
        @div class: 'block buttons', =>
          css = 'btn inline-block-tight'
          @button class: "btn #{css} run", outlet: 'buttonRun', click: 'run', =>
            @span class: 'icon icon-triangle-right', 'Run'
          @button class: "btn #{css} rebuild", outlet: 'buttonReBuild', click: 'rebuild', =>
            @span class: 'icon icon-sync', 'Re-Build'
          @button class: "btn #{css} save", outlet: 'buttonSave', click: 'save', =>
            @span class: 'icon icon-clippy', 'Save'
          @button class: "btn #{css} cancel", outlet: 'buttonCancel', click: 'cancel', =>
            @span class: 'icon icon-x', 'Cancel'

  initialize: (@controller) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel': => @toggleRunOptions('hide')
      'core:close': => @toggleRunOptions('hide')
      'gcc-make-run:run-options': => @toggleRunOptions()
    atom.workspace.addTopPanel(item: this)
    atom.config.onDidChange(=> @restoreOptions())
    @restoreOptions()
    @toggleRunOptions 'hide'

  destroy: ->
    @subscriptions?.dispose()

  toggleRunOptions: (command) ->
    switch command
      when 'show'
        @runOptionsView.show()
        @cflags.focus()
      when 'hide'
        @runOptionsView.hide()
        @restoreOptions()
      else
        @runOptionsView.toggle()
        @cflags.focus() if @runOptionsView.is(':visible')

  restoreOptions: ->
    cfgs = ['cflags', 'ldlibs', 'args']
    @[cfg].val(atom.config.get("gcc-make-run.#{cfg}")) for cfg in cfgs

  saveOptions: ->
    cfgs = ['cflags', 'ldlibs', 'args']
    atom.config.set("gcc-make-run.#{cfg}", @[cfg].val()) for cfg in cfgs

  run: ->
    @saveOptions()
    @toggleRunOptions('hide')
    atom.commands.dispatch @workspaceView(), 'gcc-make-run:compile-run'

  rebuild: ->
    @saveOptions()
    @toggleRunOptions('hide')
    @controller.onceRebuild = true
    atom.commands.dispatch @workspaceView(), 'gcc-make-run:compile-run'

  save: ->
    @saveOptions()
    @toggleRunOptions('hide')
    atom.notifications.addSuccess('Run Options Saved')

  cancel: ->
    @toggleRunOptions('hide')

  traverseFocus: (e) ->
    return true if e.keyCode != 9

    row = @find(e.target).parents('tr:first').nextAll('tr:first')
    if row.length then row.find('input').focus() else @buttonRun.focus()

  workspaceView: ->
    atom.views.getView(atom.workspace)
