module.exports = (grunt) ->
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')

        stylus: 
            compileStylusFiles: 
                options:
                    compress: false
                
                files: [{
                    expand: true,
                    cwd: '../app',
                    src: [ '**/*.styl', '!build/**/*.styl'],
                    dest: 'out',
                    ext: '.css'
                }] 
    
        clean: 
            out:
                src: [ 'out' ]

        copy:
            out:
                cwd: '../app'
                src: ['**', '!**/*.coffee', '!**/*.styl'],
                dest: 'out',
                expand: true

        coffee:
            compileCoffeeScripts:
                options:
                    sourceMap: false
                    flatten: false
                files: [{
                    expand: true
                    cwd: '../app/'
                    src: ['**/*.coffee', '!**/Gruntfile.coffee']
                    dest: 'out/'
                    ext: '.js'
                }]

        autoprefixer:
            prefixOutputCSS:
                expand: true,
                cwd: 'out',
                src: [ '**/*.css' ]
                dest: 'out',
                ext: '.css'

        watch:
            watchForChanges:
                files: ['../app/**/*.coffee', '../app/**/*.styl', '../app/**/*.html']
                tasks: ['default']
                options:
                    spawn: true

        'http-server':
            'dev':

                # the server root directory
                root: 'out'

                port: 8282
                # port: function() { return 8282; }

                host: "127.0.0.1"

                showDir : true
                autoIndex: true

                # server default file extension
                ext: "html"

                # run in parallel with other tasks
                runInBackground: true


    # Load the plugins
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-stylus'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-autoprefixer'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-http-server'

    grunt.registerTask('default', ['clean', 'copy', 'stylus', 'coffee', 'autoprefixer'])

    grunt.registerTask('server', ['http-server', 'watch'])

