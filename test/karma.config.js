module.exports = function(config) {
  config.set({

    // base path, that will be used to resolve files and exclude
    basePath: '../',
    frameworks: ['jasmine'],

    // list of files / patterns to load in the browser
    files: [
      { pattern: '_public/js/vendor.js', watched: true },
      { pattern: '_public/js/app.js', watched: true },
      { pattern: 'bower_components/angular-mocks/angular-mocks.js', watched: false },
      { pattern: 'test/midway/**/*.js', watched: true },
      { pattern: 'test/unit/**/*.js', watched: true }
    ],

    // list of files to exclude
    exclude: [

    ],

    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress'],

    port: 9876,
    colors: true,

    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,

    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,

    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false,

    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera (has to be installed with `npm install karma-opera-launcher`)
    // - Safari (only Mac; has to be installed with `npm install karma-safari-launcher`)
    // - PhantomJS
    // - IE (only Windows; has to be installed with `npm install karma-ie-launcher`)
    browsers: ['Chrome'],

    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 60000

  });
};
