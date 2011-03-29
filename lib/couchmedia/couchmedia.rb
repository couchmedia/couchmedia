require 'couchmedia/mixins'
require 'pathname'

class CouchMedia
  CONFIG_FILE = 'config.json'
  MODULE_ROOT = 'modules'
  
  class << self
    def conf file = nil
      load unless @conf
      @conf
    end
      
    def modules
      load unless @modules
      @modules
    end

    def load
      @conf = JSON.load_file(CONFIG_FILE)
      @modules = Hash.new
      @conf['modules'].each_pair do |mod, mod_conf|
        path = Pathname.new(mod)
        path = File.join(MODULE_ROOT, mod) unless path.absolute?
        manifest = JSON.load_file(File.join(path, 'manifest.json'))
        @conf['modules'][mod] = manifest['config'].merge(mod_conf)

        @modules[manifest['rack']['namespace']] = {
          namespace: manifest['rack']['namespace'],
          classname: manifest['rack']['application'],
          filepath: "#{File.join(path, manifest['rack']['application'].underscore)}.rb",
          needs_init: (manifest['rack']['needs_init'] ? true : false )
        }
      end      
    end
  end
end

