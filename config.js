exports.config = {
  conventions: {
    assets: /^app\/assets\//
  },
  modules: {
    definition: false,
    wrapper: false
  },
  paths: {
    "public": '_public'
  },
  files: {
    javascripts: {
      joinTo: {
        'js/vendor.js': /^bower_components/,
        'js/app.js': /^app\/scripts/
      },
      order: {
        before: [
          'bower_components/lodash/lodash.js',
          'bower_components/jquery/jquery.js',
          'bower_components/angular-bootstrap/ui-bootstrap.js',
          'bower_components/angular/angular.js',
          'bower_components/d3/d3.js',
          'app/scripts/barChart.js',
          'app/scripts/directives.coffee']
      }
    },
    stylesheets: {
      joinTo: {
        'css/app.css': /^app\/styles/
      }
    }
  }
};
