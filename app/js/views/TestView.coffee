define (require) ->

    require 'backbone'
    
    class TestView extends Backbone.View
        initialize: (options) ->
            @render()

        render: ->
            @$el.html 'Hello World'
            return this