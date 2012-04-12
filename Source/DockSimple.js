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
    scrollThrottle: 0,
    replaceElement: false,
    active: true
  },
  initialize: function(element, options) {
    this.setOptions(options);
    this.element = $$(element)[0];
    this.undocker = this.options.undockElement != null ? $$(this.options.undockElement)[0] : void 0;
    this.elementY = this.options.dockCoordinate || this.element.getCoordinates().top - this.options.offset;
    this.undockY = this.undocker != null ? this.undocker.getCoordinates()[this.options.undockAt] : void 0;
    this.active = this.options.active;
    this.scrollEvent = this.toDock.bind(this);
    if (!!this.active) window.addEvent('scroll', this.scrollEvent);
    return this;
  },
  toDock: function() {
    var scrollY;
    scrollY = window.getScrollTop();
    if (scrollY >= this.elementY && !this.docked) {
      if ((this.undockY != null) && scrollY <= this.undockY) {
        this.dockElement();
      } else if (!(this.undockY != null)) {
        this.dockElement();
      }
    } else if (this.docked) {
      if ((this.undockY != null) && scrollY >= this.undockY) {
        this.undockElement();
      } else if (scrollY <= this.elementY) {
        this.undockElement();
      }
    }
    return this.docked;
  },
  dockElement: function() {
    this.element.addClass(this.options.dockedClass);
    this.docked = true;
    return this;
  },
  undockElement: function() {
    this.element.removeClass(this.options.dockedClass);
    this.docked = false;
    return this;
  },
  activate: function(attach) {
    if (!this.active) window.addEvent('scroll', this.scrollEvent);
    this.active = true;
    if (attach) return this.dockElement();
  },
  deactivate: function(detach) {
    if (this.active) window.removeEvent('scroll', this.scrollEvent);
    this.active = false;
    if (detach) return this.undockElement();
  }
});
