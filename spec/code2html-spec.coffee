Code2html = require '../lib/code2html'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Code2html", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('code2html')

  describe "when the code2html:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.code2html')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'code2html:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.code2html')).toExist()

        code2htmlElement = workspaceElement.querySelector('.code2html')
        expect(code2htmlElement).toExist()

        code2htmlPanel = atom.workspace.panelForItem(code2htmlElement)
        expect(code2htmlPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'code2html:toggle'
        expect(code2htmlPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.code2html')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'code2html:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        code2htmlElement = workspaceElement.querySelector('.code2html')
        expect(code2htmlElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'code2html:toggle'
        expect(code2htmlElement).not.toBeVisible()
