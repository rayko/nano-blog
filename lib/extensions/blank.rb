module Extensions
  module Blank

    def blank?
      return true if NilClass === self
      return chars.empty? if respond_to?(:chars)
      return empty? if respond_to?(:empty?)
      return nil? if respond_to?(:nil?)

      false
    end


  end
end
