{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

module.exports =
class ReleaseNotesStatusBar extends View
  @content: ->
    @span type: 'button', class: 'release-notes-status icon icon-squirrel inline-block'

  initialize: (@statusBar, previousVersion) ->
    @subscriptions = new CompositeDisposable()

    @on 'click', -> atom.workspace.open('atom://release-notes')
    @subscriptions.add atom.commands.add 'atom-workspace', 'window:update-available', (event) => @attach(event)

    @subscriptions.add atom.tooltips.add(@element, title: 'Click to view the release notes')
    @attach() if previousVersion? and previousVersion isnt atom.getVersion()

  attach: (event) ->
    if Array.isArray(event?.detail)
      [version] = event.detail
      if version isnt ("v#{atom.getVersion()}")
        @addClass 'release-notes-status-available'

    @statusBar.addRightTile(item: this, priority: -100)

  detached: ->
    @subscriptions?.dispose()
