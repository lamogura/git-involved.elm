module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    clean: {
      initBuild: {
        src: ['public/']
      },
      finishBuild: {
        src: ['public/elm.js', 'styles']
      }
    },
    //copy
    copy: {
      favicoManifest: {
        files: [
          {nonull: true, src: 'frontend/favicon.ico', dest: 'public/favicon.ico'},
          {nonull: true, src: 'frontend/manifest.json', dest: 'public/manifest.json'},
          {nonull: true, src: 'frontend/index.html', dest: 'public/index.html'}
        ]
      },
    },
    imagemin: {
      img: {
        options: {
          optimizationLevel: 3
        },                 // Another target
        files: [{
          expand: true,                  // Enable dynamic expansion
          cwd: 'frontend/img/',     // Src matches are relative to this path
          src: ['**/*.{png,jpg,gif}'],   // Actual patterns to match
          dest: 'public/img'         // Destination path prefix
        }]
      }
    },
    concat: {
      options: {
      // define a string to put between each file in the concatenated output
        separator: ';'
      },
      js: {
        // the files to concatenate
        src: ['frontend/**/*.js'],
        // the location of the resulting JS file
        dest: 'public/elm.js'
      }
    },
    cssmin: {
      pre: {
        options: {keepSpecialComments: 0},
        files: {
          'public/styles/index.css': 'frontend/styles/index.css'
        }
      },
    },
    uncss_inline: {
      index: {
        options: {
          timeout: 5000,
          ignore: [
            /mdl-card/,
            /issue-card/,
            /mdl-shadow/,
            /rounded/,
            /flex/,
            /my3/,
            /mdl-color--white/,
            /^content$/,
            /^fit$/,
            /py0/,
            /px3/,
            /mt2/,
            /mdl-card__supporting-text/,
            /body/,
            /overflow-hidden/,
            /items-center/,
            /mdl-card__actions/,
            /^m1$/,
            /^center$/,
            /mdl-chip/,
            /^col$/,
            /col-2/,
            /^xs-hide$/,
            /col-10/
          ]
        },
        files: [{
          expand: true,
          cwd: "public/",
          src: "**/*.html",
          dest: "public/"
        }]
      }
    },
    uglify: {
      options: {},
      dist: {
        files: {
          'public/elm.js': ['<%= concat.js.dest %>']
        }
      }
    },
    processhtml: {
      options: {},
      dist: {
        files: {
          'public/index.html': ['public/index.html']
        }
      }
    },
    criticalcss: {
      custom: {
        options: {
          url: "http://localhost:5000",
          width: 1200,
          height: 900,
          outputfile: "public/styles/critical.css",
          filename: "public/styles/index.css",
          buffer: 800*1024,
          ignoreConsole: false
        }
      }
    },
    htmlmin: {
      index: {
        options: {
          collapseBooleanAttributes: true,
          collapseWhitespace: true,
          conservativeCollapse: true,
          decodeEntities: false,
          minifyCSS: true,
          minifyJS: true,
          minifyURLs: false,
          processConditionalComments: true,
          removeAttributeQuotes: true,
          removeComments: true,
          removeOptionalAttributes: true,
          removeOptionalTags: true,
          removeRedundantAttributes: true,
          removeScriptTypeAttributes: true,
          removeStyleLinkTypeAttributes: true,
          removeTagWhitespace: false,
          sortAttributes: true,
          sortClassName: true
        },
        files: {'public/index.html': 'public/index.html'}
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-imagemin');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-processhtml');
  grunt.loadNpmTasks('grunt-uncss-inline');
  grunt.loadNpmTasks('grunt-contrib-htmlmin');
  grunt.registerTask('default', [
    'clean:initBuild',
    'copy',
    'imagemin',
    'concat',
    'cssmin:pre',
    'uglify',
    'processhtml',
    'uncss_inline',
    'htmlmin',
    'clean:finishBuild'
  ]);
};
