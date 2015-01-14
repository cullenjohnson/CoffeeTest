require.config
    paths:
        jquery: "lib/jquery-1.11.2.min"
        underscore: "lib/underscore-min"
        backbone: "lib/backbone-min"
        localstorage: 'lib/backbone.localStorage-min'
        Mustache: "lib/mustache"
        moment: 'lib/moment.min'

require ["application"], (app) ->
    $.fx.off = false
    app.initialize()