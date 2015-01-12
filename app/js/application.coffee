define (require) ->
    require 'backbone'

    AppRouter = require './AppRouter'

    initialize: ->
        # I'm not sure if making a global App object is very requirejs-kosher, but I'm not sure what else to do...
        window.App = {}

        window.App.router = new AppRouter

        Backbone.history.start()