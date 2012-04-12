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
    replaceElement: false
    active:         true

  initialize: (element, options) ->
    @setOptions(options)

    # gather our elements
    @element  = $$(element)[0]
    @undocker = if @options.undockElement? then $$(@options.undockElement)[0]

    # calculate the coordinates of the element to dock
    @elementY =
      @options.dockCoordinate or @element.getCoordinates().top - @options.offset
    # the y value in which to undock the docked element
    @undockY  = if @undocker? then @undocker.getCoordinates()[@options.undockAt]

    # the active state
    @active = @options.active

    # cach the bound method for attaching/detaching
    @scrollEvent = @toDock.bind(this)

    window.addEvent('scroll', @scrollEvent) unless !@active

    return this

  # determines whether to dock or undock the element based on scroll amount
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

    return @docked

  # add the dockedClass to the DockSimple.element
  dockElement: ->
    @element.addClass(@options.dockedClass)
    @docked = true
    return this

  # remove the dockedClass from the DockSimple.element
  undockElement: ->
    @element.removeClass(@options.dockedClass)
    @docked = false
    return this

  # re-attach scroll event if previously detached
  # param: attach - determine calling dockElement() immediately
  activate: (attach) ->
    window.addEvent('scroll', @scrollEvent) unless @active
    @active = true
    if attach then @dockElement()

  # detach the scroll event from window
  # param: detach - determine calling undockElement() immediately
  deactivate: (detach) ->
    window.removeEvent('scroll', @scrollEvent) if @active
    @active = false
    if detach then @undockElement()
