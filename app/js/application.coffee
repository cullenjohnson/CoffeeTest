define (require) ->
    require 'backbone'

    AppRouter = require './AppRouter'

    initialize: ->
        router = new AppRouter

        Backbone.history.start()