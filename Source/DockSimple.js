/*
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
*/
var DockSimple;

DockSimple = new Class({
  Implements: [Options, Events],
  options: {
    undockElement: void 0,
    undockAt: 'top',
    dockedClass: 'docked',
    forcedClass: 'force-dock',
    dockCoordinate: void 0,
    offset: 0,
    scrollThrottle: 0
  },
  initialize: function(element, options) {
    this.setOptions(options);
    this.element = $$(element);
    if (this.undockElement == null) {
      this.undockElement = $$(this.options.undockElement)[0];
    }
    this.elementY = this.element.getCoordinates().y - this.options.offset;
    if (this.undockY == null) {
      this.undockY = this.undockElement.getCoordinates()[this.options.undockAt];
    }
    return window.addEvent('scroll', this.dockElement);
  },
  dockElement: function() {
    var scrollY;
    return scrollY = window.getScrollTop();
  }
});
