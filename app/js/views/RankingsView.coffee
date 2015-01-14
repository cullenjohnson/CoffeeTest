define (require) ->
    require 'backbone'
    require 'moment'
    Mustache = require 'Mustache'

    class RankingsView extends Backbone.View
        initialize: (options) ->
            App.quizSessions.sort()
            @build()

        build: ->
            template = $('#main_template').html()
            bodyTemplate = $('#rankings_body_template').html()
            footerHtml = $('#restart_link').html()

            data = 
                header: 'Rankings'
                body: Mustache.to_html(bodyTemplate, App.quizSessions.getTemplateJSON())
                footer: footerHtml

            @$el.html Mustache.to_html(template, data)