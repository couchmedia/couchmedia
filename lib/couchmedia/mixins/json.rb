require 'json'

module JSON
  def self.load_file path
    File.open(path, 'r') do |file|
      JSON.load(file)
    end  
  end
end
