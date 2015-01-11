define (require) ->
    require 'backbone'

    TestView = require 'views/TestView'

    class AppRouter extends Backbone.Router

        initialize: ->
            console.log 'router'

            @listenTo this, 'route', (route) ->
                console.log "route #{route}"

        routes:
            '': 'indexRoute'

        indexRoute: () ->
            console.log 'route';
            view = new TestView el: 'body'
