$(function(){
  $namespace("Dimensions").Renderer = function(){};
  $namespace("Dimensions").Renderer.prototype ={
    render: function(){
      if($(this.element).length){
        $(this.element).empty();
        if(this.data.results.length > 0){
          $.tmpl(this.template,{items:this.data.results}).appendTo(this.element);
          clearMap();

          $.each(this.data.results, function(i, r) {
            var breakingNews, displayMarker, latitude, longitude, _ref, _ref2;
            //longitude = 47.5 + Math.random() / 4.0;
            //latitude = -122.0 - Math.random() * 0.5;
            if(r.variables){
              lat_long = eval('('+r.variables.replace(/=>/g,":")+')');
              latitude = lat_long[0];
              longitude = lat_long[1];
              breakingNews = (_ref = Math.random() < .2) != null ? _ref : {
                1: 0
              };
              displayMarker = (_ref2 = Math.random() < .4) != null ? _ref2 : {
                1: 0
              };
              if (displayMarker > 0) {
                if (breakingNews < 1) {
                  return addMarker(longitude, latitude);
                } else {
                  return addBreakingNewsMarker(longitude, latitude);
                }
              }
            }
          });

        }else{
          $("#stream").append('<div class="no-results"><h1>Sorry, I find nothing :-(</h1>' + '<p>Searched for: ' + window.filter.getQueryAsHtml() + '</p></div>');
                              //$.each(this.data.results,function(i,r){
                              //console.log("latitude for each topic");
                              //});
        }
        FB.XFBML.parse();//reload facebook events 
      }else{
        //console.log(this.element+"  does not exist!");
      }
      this.unbind("loadItems");
    },
    onLoadComplete: function(response){
      this.data = response;
      this.render(this.element);
    },
    bind: function(name, fn){
      Dimensions.Renderer.method(name, fn);
    },
    unbind:function(name){
      Dimensions.Renderer.method(name,null);
    }
  }
});
