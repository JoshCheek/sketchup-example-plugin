require 'sketchup'
require 'extensions'

unless file_loaded?(__FILE__)
  file_loaded(__FILE__)

  ex = SketchupExtension.new('Eden', 'eden/select_same/main')
  ex.description = 'Eden\'s extension to select the same objects'
  ex.version     = '1.0.0'
  ex.copyright   = 'whatever'
  ex.creator     = 'Josh Cheek'
  Sketchup.register_extension(ex, true)
end
