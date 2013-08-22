exports.config =
  conventions:
    assets: /^app\/assets\//
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  files:
    javascripts:
      joinTo:
        'js/vendor.js': /^bower_components/
        'js/app.js': /^app\/scripts/
      order:
        before: [
          'bower_components/lodash/lodash.js'
          'bower_components/jquery/jquery.js'
          'bower_components/angular/angular.js'
        ]

    stylesheets:
      joinTo:
        'css/app.css': /^app\/styles/
