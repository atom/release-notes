{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

module.exports =
class ReleaseNotesStatusBar extends View
  @content: ->
    # 'blank' top level span due to issue #58
    @span =>
      @span type: 'button', class: 'release-notes-status icon icon-squirrel inline-block', outlet: 'statusIcon'

  initialize: (@statusBar, previousVersion) ->
    if previousVersion? and previousVersion is atom.getVersion()
      @statusIcon.addClass 'release-notes-status-available'

    @subscriptions = new CompositeDisposable()

    @on 'click', -> atom.workspace.open('atom://release-notes')
    @subscriptions.add atom.commands.add 'atom-workspace', 'window:update-available', => @attach()

    @subscriptions.add atom.tooltips.add(@element, title: 'Click to view the release notes')
    @attach() if previousVersion? and previousVersion isnt atom.getVersion()

  attach: ->
    @statusBar.addRightTile(item: this, priority: -100)

  detached: ->
    @subscriptions?.dispose()
