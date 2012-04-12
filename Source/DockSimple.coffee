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

    # gather our elements
    @element        = $$(element)
    @undockElement ?= $$(@options.undockElement)[0]

    # calculate the coordinates of the element to dock
    @elementY    = @element.getCoordinates().y - @options.offset
    # the y value in which to undock the docked element
    @undockY    ?= @undockElement.getCoordinates()[@options.undockAt]

    window.addEvent('scroll', @dockElement)

  dockElement: ->
    scrollY = window.getScrollTop()
