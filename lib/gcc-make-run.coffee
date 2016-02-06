GccMakeRunView = require './gcc-make-run-view'
{CompositeDisposable} = require 'atom'

module.exports = GccMakeRun =
  gccMakeRunView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @gccMakeRunView = new GccMakeRunView(state.gccMakeRunViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @gccMakeRunView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'gcc-make-run:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @gccMakeRunView.destroy()

  serialize: ->
    gccMakeRunViewState: @gccMakeRunView.serialize()

  toggle: ->
    console.log 'GccMakeRun was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
