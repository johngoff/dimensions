/* DO NOT MODIFY. This file was compiled Sun, 16 Oct 2011 02:01:19 GMT from
 * /Users/becker/trash/dimensions/app/coffeescripts/filter.coffee
 */

(function() {
  var Filter;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Filter = (function() {
    function Filter() {
      this.removeTag = __bind(this.removeTag, this);
      this.addTag = __bind(this.addTag, this);
      this.hasTag = __bind(this.hasTag, this);
      this.removeGroup = __bind(this.removeGroup, this);
      this.hasGroup = __bind(this.hasGroup, this);
      this.addGroup = __bind(this.addGroup, this);
      this.onSearchChange = __bind(this.onSearchChange, this);
      this.getQuery = __bind(this.getQuery, this);
      this.bind = __bind(this.bind, this);      this.startDate = Date.now().add(-12).hours().toISOString();
      this.search = null;
      this.tags = [];
      this.groups = [];
      console.log('gotcha');
    }
    Filter.prototype.bind = function() {
      $('#date-filter').change(this.onDateChange);
      return $('#search').change(this.onSearchChange);
    };
    Filter.prototype.getQuery = function() {
      var query;
      query = {};
      if (this.search && this.search.trim()) {
        query.search = this.search;
      }
      if (this.tags.length > 0) {
        query.tag = this.tags.join(',');
      }
      if (this.groups.length > 0) {
        query.owner = this.groups.join(',');
      }
      query.start_date = this.startDate;
      return query;
    };
    Filter.prototype.durationToMinutes = function(s) {
      var duration, matches, multiplier;
      matches = s.match(/(\d+)(\w+)/);
      duration = matches[1];
      multiplier = 1;
      switch (matches[2]) {
        case 'wk':
          multiplier = 7 * 24 * 60;
          break;
        case 'd':
          multiplier = 24 * 60;
          break;
        case 'hr':
          multiplier = 60;
      }
      return multiplier * duration;
    };
    Filter.prototype.onDateChange = function(e) {
      var duration, minutes;
      duration = $('#date-filter').val();
      minutes = this.durationToMinutes(duration);
      console.log(minutes);
      this.startDate = Date.now().addMinutes(-minutes).toISOString();
      console.log("duration changed: ", duration, this.startDate);
      return window.stream.loadItems();
    };
    Filter.prototype.onSearchChange = function(e) {
      this.search = e.target.value;
      console.log(this.search);
      return window.stream.loadItems();
    };
    Filter.prototype.addGroup = function(t) {
      this.groups.push(t);
      return window.stream.loadItems();
    };
    Filter.prototype.hasGroup = function(t) {
      var found;
      found = false;
      $.each(this.groups, function(i, t1) {
        if (t1 === t) {
          return found = true;
        }
      });
      return found;
    };
    Filter.prototype.removeGroup = function(t) {
      var temp;
      temp = [];
      $.each(this.groups, function(i, t1) {
        if (t1 !== t) {
          return temp.push(t1);
        }
      });
      this.groups = temp;
      return window.stream.loadItems();
    };
    Filter.prototype.hasTag = function(t) {
      var found;
      found = false;
      $.each(this.tags, function(i, t1) {
        if (t1 === t) {
          return found = true;
        }
      });
      return found;
    };
    Filter.prototype.addTag = function(t) {
      this.tags.push(t);
      return window.stream.loadItems();
    };
    Filter.prototype.removeTag = function(t) {
      var temp;
      temp = [];
      $.each(this.tags, function(i, t1) {
        if (t1 !== t) {
          return temp.push(t1);
        }
      });
      this.tags = temp;
      return window.stream.loadItems();
    };
    return Filter;
  })();
  jQuery(function() {
    window.filter = new Filter();
    return window.filter.bind();
  });
}).call(this);