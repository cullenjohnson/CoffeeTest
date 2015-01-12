require.config
    paths:
        jquery: "lib/jquery-1.11.2.min"
        underscore: "lib/underscore-min"
        backbone: "lib/backbone-min"
        Mustache: "lib/mustache"

require ["application"], (app) ->
  app.initialize()