define (require) ->

    require 'backbone'
    Mustache = require 'Mustache'

    class QuizView extends Backbone.View
        ###
        DATA HANDLING/INITIALIZATION FUNCTIONS
        ###
        initialize: (options) ->
            @options = options || {}
            @build()

        ###
        RENDER/BUILD FUNCTIONS
        ###
        build: ->
            template = $('#main_template').html()
            bodyHtml = ''
            footerHtml = ''
            data =
                header: ''
                body: bodyHtml
                footer: footerHtml

            @$el.html Mustache.to_html template, data
