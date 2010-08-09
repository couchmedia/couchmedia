require 'yaml'

require 'rubygems'
require 'magic'

class SyncHandler
  attr_reader :sync_plugins

  def initialize(plugins_dir)
    # load all plugins
    @sync_plugins = load_plugins(plugins_dir)
  end
  def load_plugins(plugins_dir)
    plugins = {}
    Dir.glob("#{plugins_dir}/*/plugin.yml") do |filename|
      unless File.directory?("#{filename}")
        plugin_manifest = YAML::load_file("/#{filename}")
        
        if(plugin_manifest["mimetypes"] and plugin_manifest["filename"] and plugin_manifest["classname"] and plugin_manifest["name"])
          plugin_absolute_filename = File.dirname(filename)+"/"+plugin_manifest["filename"]

          plugin_manifest["mimetypes"].each do |mimetype|
            if (!plugins[mimetype])
              plugins[mimetype] = []
            end
            plugins[mimetype] << { :name => plugin_manifest["name"], :classname => plugin_manifest["classname"], :filename => plugin_absolute_filename }
          end
            
          begin
            require plugin_absolute_filename
          rescue Exception => e 
            puts "[SyncHandler] plugin #{plugin_manifest['name']} at #{plugin_absolute_filename} failed to load: #{e.message}"
          end
        end
      end
    end

    return plugins
  end

  def syncDocToFile(document, file)
    mimetype = Magic.guess_file_mime_type(file)
    available_plugins = @sync_plugins[mimetype]
    success = false

    available_plugins.each do |plugin|
      begin
        success = Kernel.const_get(plugin[:classname]).syncDocToFile(document, file)
        break if success
      rescue Exception => e 
        puts "[SyncHandler] plugin #{plugin['name']} failed to sync the corresponding document to #{file}: #{e.message}"
      end
    end

    puts "[SyncHandler] no plugin was able to sync #{file}, giving up" if !success and available_plugins.size > 0
    puts "[SyncHandler] no plguins to sync #{file}, giving up" if !success and available_plugins.size == 0

    return success
  end
  def syncFileToDocs(file, documents)
    mimetype = Magic.guess_file_mime_type(file)
    available_plugins = @sync_plugins[mimetype]
    new_docs = nil

    available_plugins.each do |plugin|
      begin
        new_docs = Kernel.const_get(plugin[:classname]).syncFileToDocs(file, documents)
        break if new_docs
      rescue Exception => e 
        puts "[SyncHandler] plugin #{plugin['name']} failed to sync #{file} to its documents: #{e.message}"
      end
    end

    puts "[SyncHandler] no plugin was able to sync #{file}, giving up" if !new_docs and available_plugins.size > 0
    puts "[SyncHandler] no plguins to sync #{file}, giving up" if !new_docs and available_plugins.size == 0

    return new_docs
  end
end
