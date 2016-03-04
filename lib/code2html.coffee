Code2htmlView = require './code2html-view'
{CompositeDisposable} = require 'atom'

module.exports = Code2html =
  code2htmlView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @code2htmlView = new Code2htmlView(state.code2htmlViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @code2htmlView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'code2html:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @code2htmlView.destroy()

  serialize: ->
    code2htmlViewState: @code2htmlView.serialize()

  toggle: ->
    console.log 'Code2html was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      selectedText = selectedText.replace(/&/g,'&amp;').replace(/"/g,'&quot;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/\t/g,'    ');
      selectedText = '<pre><code>'+selectedText+'</code></pre>';
      atom.clipboard.write(selectedText, "code");
