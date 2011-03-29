$: << "."
$: << "lib"

require 'couchmedia'

CouchMedia.modules.each_value do |mod|
  require mod[:filepath]
  map "/#{mod[:namespace]}" do
    run Kernel.const_get(mod[:classname])
  end
end
