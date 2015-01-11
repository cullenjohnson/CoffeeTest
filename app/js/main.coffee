require.config
  paths:
    jquery: "lib/jquery-1.11.2.min"
    underscore: "lib/underscore-min"
    backbone: "lib/backbone-min"

require ["application"], (app) ->
  console.log("Requiring app")
  app.initialize()