class String
  def underscore
    self.gsub(/(.)([A-Z])/,'\1_\2').downcase
  end
end
