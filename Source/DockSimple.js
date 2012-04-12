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
    this.docked = false;
    this.element = $$(element)[0];
    this.undocker = this.options.undockElement != null ? $$(this.options.undockElement)[0] : void 0;
    this.elementY = this.options.dockCoordinate || this.element.getCoordinates().top - this.options.offset;
    this.undockY = this.undocker != null ? this.undocker.getCoordinates()[this.options.undockAt] : void 0;
    window.addEvent('scroll', this.toDock.bind(this));
    return this;
  },
  toDock: function() {
    var scrollY;
    scrollY = window.getScrollTop();
    if (scrollY >= this.elementY && !this.docked) {
      if ((this.undockY != null) && scrollY <= this.undockY) {
        return this.dockElement();
      } else if (!(this.undockY != null)) {
        return this.dockElement();
      }
    } else if (this.docked) {
      if ((this.undockY != null) && scrollY >= this.undockY) {
        return this.undockElement();
      } else if (scrollY <= this.elementY) {
        return this.undockElement();
      }
    }
  },
  dockElement: function() {
    this.element.addClass(this.options.dockedClass);
    return this.docked = true;
  },
  undockElement: function() {
    this.element.removeClass(this.options.dockedClass);
    return this.docked = false;
  }
});
