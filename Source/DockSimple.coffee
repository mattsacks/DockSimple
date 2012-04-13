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
    undockAt:       'bottom'
    dockedClass:    'docked'
    forcedClass:    'force-dock'
    dockCoordinate: undefined
    dockOffset:     0
    undockOffset:   0
    replaceElement: false
    active:         true

  initialize: (element, options) ->
    @setOptions(options)

    # gather our elements
    @element  = $$(element)[0]
    @undocker = if @options.undockElement? then $$(@options.undockElement)[0]

    # calculate the coordinates of the element to dock
    @elementY =
      @options.dockCoordinate or @element.getCoordinates().top - @options.dockOffset
    # the y value in which to undock the docked element
    @undockY  = if @undocker?
      @undocker.getCoordinates()[@options.undockAt] - @options.undockOffset

    # the active state
    @active = @options.active

    # a dummy element to replace the element when docked
    if @options.replaceElement
      @dummy = new Element 'div',
        id: 'DockSimple-dummy'
        styles:
          height:  @element.getHeight()
          display: 'none'

      @element.grab(@dummy, 'after')

    # cache the bound method for attaching/detaching
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
    return if @element.hasClass(@options.forcedClass)
    @element.addClass(@options.dockedClass)
    @docked = true
    @dummy.setStyle('display', 'block') if @options.replaceElement
    this.fireEvent('docked', @element)
    return this

  # remove the dockedClass from the DockSimple.element
  undockElement: ->
    return if @element.hasClass(@options.forcedClass)
    @element.removeClass(@options.dockedClass)
    @docked = false
    @dummy.setStyle('display', 'none') if @options.replaceElement
    this.fireEvent('undocked', @element)
    return this

  # re-attach scroll event if previously detached  
  # _params_: **attach** [Boolean] - determine calling dockElement() immediately
  activate: (attach) ->
    window.addEvent('scroll', @scrollEvent) unless @active
    @active = true
    if attach then @dockElement()

  # detach the scroll event from window  
  # _params_: **detach** [Boolean] - determine calling undockElement() immediately
  deactivate: (detach) ->
    window.removeEvent('scroll', @scrollEvent) if @active
    @active = false
    if detach then @undockElement()


# provide a throttle event for functions if not previously defined
unless Function.throttle
  Function.implement
    # prevents calling invoked function repetitively within a given interval  
    # _params_: **interval** [Number]
    throttle: (interval) ->
      timer = null
      return =>
        unless timer
          timer = setTimeout ->
            timer = null
          , interval
          @apply(this)

# provide a debounce event for functions
unless Function.debounce
  Function.implement
    # prevents calling invoked function succinctly until after the given delay  
    # _params_: **delay** [Number]
    debounce: (delay) ->
      timer = null
      return =>
        timer && clearTimeout(timer)
        timer = setTimeout =>
          @apply(this)
        , delay

