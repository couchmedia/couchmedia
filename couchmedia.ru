$: << "."
$: << "lib"

require 'couchmedia'

CouchMedia.modules.each_value do |mod|
  require mod[:filepath]
  map "/#{mod[:namespace]}" do
    klass = Kernel.const_get(mod[:classname])
    if mod[:needs_init]
      run klass.new
    else
      run klass
    end
  end
end
