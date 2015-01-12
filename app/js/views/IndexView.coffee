define (require) ->

    require 'backbone'
    Mustache = require 'Mustache'

    class IndexView extends Backbone.View
        ###
        DATA HANDLING/INITIALIZATION FUNCTIONS
        ###
        initialize: (options) ->
            @build();

        ###
        RENDER/BUILD FUNCTIONS
        ###
        build: ->
            template = $('#main_template').html()
            bodyHtml = $('#welcome_body').html()
            footerHtml = $('#rankings_link').html()
            data =
                header: 'Welcome to Coffee Test!'
                body: bodyHtml
                footer: footerHtml

            @$el.html Mustache.to_html template, data
