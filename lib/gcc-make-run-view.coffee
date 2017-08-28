###
# heavily modified from rgbkrk/atom-script - lib/script-options-view.coffee
# https://github.com/rgbkrk/atom-script
# https://atom.io/packages/script
###

{CompositeDisposable} = require 'atom'
{$, View} = require 'atom-space-pen-views'

module.exports =
class RunOptionsView extends View

  @content: ->
    @div class: 'run-options-view', =>
      @div class: 'panel-heading', 'Configure Compile-Run Options'
      @div class: 'panel-body', =>
        @table =>
          @tr =>
            @td => @label 'Compiler Flags:'
            @td => @tag 'atom-text-editor', class: 'editor mini', mini: '', keydown: 'traverseInputFocus', outlet: 'cflags'
          @tr =>
            @td => @label 'Link Libraries:'
            @td => @tag 'atom-text-editor', class: 'editor mini', mini: '', keydown: 'traverseInputFocus', outlet: 'ldlibs'
          @tr =>
            @td => @label 'Run Arguments:'
            @td => @tag 'atom-text-editor', class: 'editor mini', mini: '', keydown: 'traverseInputFocus', outlet: 'args'
        @div class: 'btn-group', =>
          @button class: 'btn btn-primary', click: 'run', keydown: 'traverseButtonFocus', outlet: 'buttonRun', =>
            @span class: 'icon icon-playback-play', 'Run'
          @button class: 'btn', click: 'rebuild', keydown: 'traverseButtonFocus', =>
            @span class: 'icon icon-sync', 'Rebuild'
          @button class: 'btn', click: 'save', keydown: 'traverseButtonFocus', =>
            @span class: 'icon icon-clippy', 'Save'
          @button class: 'btn', click: 'cancel', keydown: 'traverseButtonFocus', outlet: 'buttonCancel', =>
            @span class: 'icon icon-x', 'Cancel'

  initialize: (@main) ->
    # observe shortcut
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'core:cancel': => @hideRunOptions()
      'core:close': => @hideRunOptions()
      'gcc-make-run:compile-run': => @hideRunOptions(true)
      'gcc-make-run:run-options': => @showRunOptions()

    # add modal panel
    @runOptionsPanel = atom.workspace.addModalPanel(item: @, visible: false)

    # hide panel when click outside
    $('atom-workspace').click => @hideRunOptions()
    @.mousedown (e) ->
      target = e.target
      while target != @
        if target.classList.contains('editor')
          target.focus()
          break
        target = target.parentNode
      e.preventDefault()
    @.click (e) -> e.stopPropagation()

  destroy: ->
    @runOptionsPanel?.destroy()
    @subscriptions?.dispose()

  showRunOptions: ->
    return if @runOptionsPanel.isVisible()
    @restoreOptions()
    @runOptionsPanel.show()
    @cflags.focus()

  hideRunOptions: (shouldSave) ->
    return unless @runOptionsPanel.isVisible()
    @runOptionsPanel.hide()
    @saveOptions() if shouldSave

  restoreOptions: ->
    cfgs = ['cflags', 'ldlibs', 'args']
    @[cfg].get(0).getModel().setText(atom.config.get("gcc-make-run.#{cfg}")) for cfg in cfgs

  saveOptions: ->
    cfgs = ['cflags', 'ldlibs', 'args']
    atom.config.set("gcc-make-run.#{cfg}", @[cfg].get(0).getModel().getText()) for cfg in cfgs

  run: ->
    @hideRunOptions(true)
    atom.commands.dispatch @workspaceView(), 'gcc-make-run:compile-run'

  rebuild: ->
    @hideRunOptions(true)
    @main.oneTimeBuild = true
    atom.commands.dispatch @workspaceView(), 'gcc-make-run:compile-run'

  save: ->
    @hideRunOptions(true)
    atom.notifications.addSuccess('Run Options Saved')

  cancel: ->
    @hideRunOptions()

  traverseInputFocus: (e) ->
    switch e.keyCode
      # press tab key should change focus
      when 9
        # stop default propagation
        e.preventDefault()
        # find next/prev input box to focus
        row = @find(e.target).parents('tr:first')[if e.shiftKey then 'prevAll' else 'nextAll']('tr:first')
        if row.length
          row.find('atom-text-editor').focus()
        # focus run or close button if no input box can be found
        else
          if e.shiftKey then @buttonCancel.focus() else @buttonRun.focus()
      # enter key
      when 13 then @buttonRun.click()
    # otherwise ignore
    return true

  traverseButtonFocus: (e) ->
    switch e.keyCode
      when 9
        # press tab on close button should focus the first input box
        if !e.shiftKey && e.target == @buttonCancel.context
          @cflags.focus()
          return false
        # press shift tab on run button should focus the last input box
        else if e.shiftKey && e.target == @buttonRun.context
          @args.focus()
          return false
      # emulate button click when pressing enter key
      when 13 then e.target.click()
    # otherwise ignore
    return true

  workspaceView: ->
    atom.views.getView(atom.workspace)
