class ActionController::Metal
  def self.controller_name
    # @controller_name ||= self.name.demodulize.sub(/Controller$/, '').underscore
    @controller_name ||= self.name.sub(/Controller$/, '').underscore
  end
end

