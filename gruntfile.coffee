module.exports = (grunt) ->

  coffeePath = 'src/coffee/**/*.coffee'

  grunt.initConfig

    livereload :
      options:
        base: 'src'
      files: [coffeePath]

    watch:
      client:
        files: [coffeePath]
        tasks: ['coffeelint', 'coffee']
        reload: true

    coffee:
      compile:
        options:
          bare: true
          sourceMap: true
        files:
          'src/Application.js': coffeePath

    coffeelint:
      options:
        'max_line_length':'level': 'ignore'
        'no_backticks':'level': 'ignore'
      files: coffeePath

    grunt.registerTask 'default', (env) ->
      grunt.task.run ['coffeelint', 'coffee', 'watch']

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-livereload')

