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
    undockSide:     'top'
    dockedClass:    'docked'
    forcedClass:    'force-dock'
    dockCoordinate: undefined
    dockOffset:     0
    undockOffset:   0
    replaceElement: false
    dummyHide:      false
    multiReplace:   false
    active:         true

  initialize: (element, options) ->
    @setOptions(options)

    # gather our elements
    @element = element.findElementIndex()
    @elementHeight = @element.getHeight()
    @undocker = if @options.undockElement? then @attachUndocker(@options.undockElement)

    # calculate the coordinates of the element to dock
    @elementY =
      @options.dockCoordinate or @element.getCoordinates().top - @options.dockOffset

    # the active state
    @active = @options.active

    # a dummy element to replace the element when docked
    if @options.replaceElement
      @dummy = new Element 'div',
        id: 'DockSimple-dummy'
        styles:
          height:  @elementHeight
          display: 'none'

      @options.dummyHide = true
      @element.grab(@dummy, 'after')

    # cache the bound method for attaching/detaching
    @scrollEvent = @toDock.bind(this)

    window.addEvent('scroll', @scrollEvent) unless !@active

    return this

  # add an undocking element to calculations in which to undock
  attachUndocker: (undocker) ->
    return unless undocker?
    @undocker = undocker.findElementIndex()

    # the y value in which to undock the docked element
    @undockY =
      # if we want to undock the element when it's bottom touches the
      # undockSide of the undocker
      if @options.undockSide is 'bottom' and @undocker?
        @undocker.getCoordinates()[@options.undockAt] -
        (@elementHeight + @options.undockOffset)

      else if @undocker?
        @undocker.getCoordinates()[@options.undockAt] - @options.undockOffset

    return @undocker

  # determines whether to dock or undock the element based on scroll amount
  toDock: ->
    scrollY = window.scrollY

    # if scrolled past the element to dock and it hasnt docked yet
    if scrollY >= @elementY and !@docked
      # if undockElement is specified and haven't scrolled to it yet
      if @undockY? and scrollY <= @undockY
        @dockElement()
      # if undockElement wasn't specified
      else unless @undockY?
        @dockElement()

    else if @docked
      # undock the element from the undocked element
      if @undockY? and scrollY >= @undockY
        @undockElement('end')

      # undock the element from its original position
      else if scrollY <= @elementY
        @undockElement('start')

    return @docked

  # add the dockedClass to the DockSimple.element
  dockElement: ->
    return if @element.hasClass(@options.forcedClass)
    @element.addClass(@options.dockedClass)
    @docked = true
    @dummy.setStyle('display', 'block') if @options.replaceElement
    this.fireEvent('docked', [@element, @elementY])
    return this

  # remove the dockedClass from the DockSimple.element  
  # _params_: **dir** [String] - either 'start' or 'end', detected from the
  # undocking direction
  undockElement: (dir) ->
    return if @element.hasClass(@options.forcedClass)
    @element.removeClass(@options.dockedClass)
    @docked = false

    if @options.replaceElement and @options.dummyHide
      # always undock the dummy element if there's multiple instances
      if @options.multiReplace
        @dummy.setStyle('display', 'none')
      # undock the dummy element when scrolling up the page
      else if dir is 'start' and @options.multiDock
        @dummy.setStyle('display', 'none')
      # undock the dummy element when scrolling down the
      # page for a single instance of DockSimple
      else unless dir is 'end' and @options.multiDock
        @dummy.setStyle('display', 'none')

    # pass the undocked coordinate from the scrolled direction
    if dir is 'start'
      this.fireEvent('undocked', [@element, @elementY])
    else if dir is 'end'
      this.fireEvent('undocked', [@element, @undockY])
    else
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


# ## class-level methods
DockSimple.extend
  # create multiple instances of DockSimple to dock multiple elements
  multiDock: (selector, options) ->
    elements = $$(selector).length
    if elements > 0
      dockers = []
      options.multiDock = true

      for i in [0...elements]
        # don't create a dummy element for each selection unless directed to
        if i is 1 and !options.multiReplace and options.replaceElement
          options.replaceElement = false
          options.dummyHide      = false

        undockSelector = selector + '[' + (i + 1) + ']'
        Object.merge(options, undockElement: undockSelector)
        dockers.push new DockSimple(selector + '[' + i + ']', options)
    else
      dockers = new DockSimple(selector, options)

    return dockers

# ## required modification to the String type
String.implement
  # find an element based on a given index
  # example: '.foo[2].findElementIndex()' will return the second .foo element
  findElementIndex: ->
    index = @match(/\[(\d+)\]$/)
    if index and index[1]
      return $$(''+@match(/(.*)\[\d+\]$/)[1])[index[1]]
    else
      return $$(''+this)[0]


# ## provided methods for performance improvements / customzation

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

