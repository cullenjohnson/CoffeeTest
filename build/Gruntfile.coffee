module.exports = (grunt) ->
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')

        stylus: 
          build: 
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
            compileWithMapsDir:
                options:
                    sourceMap: true
                    flatten: false
                files: [{
                    expand: true
                    cwd: '../app/'
                    src: ['**/*.coffee', '!**/Gruntfile.coffee']
                    dest: 'out/'
                    ext: '.js'
                }]

        autoprefixer:
            build:
                expand: true,
                cwd: 'out',
                src: [ '**/*.css' ]
                dest: 'out',
                ext: '.css'

    # Load the plugins
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-stylus');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-autoprefixer');

    # Run tasks
    grunt.registerTask('default', ['clean', 'copy', 'stylus', 'coffee', 'autoprefixer']);
