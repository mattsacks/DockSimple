###
---

name: DockSimple
script: DockSimple.js
description: A MooTools class for docking elements at a certain scroll threshold.

requires:
  - Core/Class.Extras 
  - Core/Element.Event
  - Core/Element.Dimensions  

provides: [DockSimple]

authors:
  - Matt Sacks

...
###

DockSimple = new Class
  Implements: [Options, Events]

  options:
    undockElement:  undefined
    undockAt:       'top'
    dockedClass:    'docked'
    forcedClass:    'force-dock'
    dockCoordinate: undefined
    offset:         0
    scrollThrottle: 0

  initialize: (element, options) ->
    @setOptions(options)

    # starting out undocked FIXME
    @docked = false

    # gather our elements
    @element  = $$(element)[0]
    @undocker = if @options.undockElement? then $$(@options.undockElement)[0]

    # calculate the coordinates of the element to dock
    @elementY =
      @options.dockCoordinate or @element.getCoordinates().top - @options.offset
    # the y value in which to undock the docked element
    @undockY  = if @undocker? then @undocker.getCoordinates()[@options.undockAt]

    window.addEvent('scroll', @toDock.bind(this))

    return this

  toDock: ->
    scrollY = window.getScrollTop()

    # if scrolled past the element to dock and it hasnt docked yet
    if scrollY >= @elementY and !@docked
      # if undockElement is specified and haven't scrolled to it yet
      if @undockY? and scrollY <= @undockY
        @dockElement()
      # if undockElement wasn't specified
      else if !@undockY?
        @dockElement()

    else if @docked
      # undock the element from the undocked element
      if @undockY? and scrollY >= @undockY
        @undockElement()

      # undock the element from its original position
      else if scrollY <= @elementY
        @undockElement()

  # add the dockedClass to the DockSimple.element
  dockElement: ->
    @element.addClass(@options.dockedClass)
    @docked = true

  # remove the dockedClass from the DockSimple.element
  undockElement: ->
    @element.removeClass(@options.dockedClass)
    @docked = false
