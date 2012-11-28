module Basecampx
  module Relations

    def mount method, klass
      self.class_eval <<-EOB

        def #{method.to_s}
          @#{method.to_s}
        end

        def #{method.to_s}=#{method.to_s}_obj
          @#{method.to_s} ||= #{klass.to_s.titleize}.new #{method.to_s}_obj
        end

      EOB
    end

    def has_one method, klass
      self.class_eval <<-EOB

        def #{method.to_s}
          @#{method.to_s}
        end

        def #{method.to_s}=#{method.to_s}_obj
          @#{method.to_s} ||= #{klass.to_s.titleize}.new #{method.to_s}_obj
        end

      EOB
    end

    def has_many method, klass
      self.class_eval <<-EOB

        def #{method.to_s}
          @#{method.to_s}
        end

        def #{method.to_s}=#{method.to_s}_obj
          @#{method.to_s} ||= #{klass.to_s.titleize}.parse #{method.to_s}_obj
        end

      EOB
    end

  end
end