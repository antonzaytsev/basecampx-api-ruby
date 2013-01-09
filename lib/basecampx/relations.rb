module Basecampx
  module Relations

    def mount method, klass
      m = method.to_s.gsub(/\s+/, '')
      self.class_eval <<-EOB

        def #{m}
          @#{m}
        end

        def #{m}=#{m}_obj
          @#{m} ||= #{klass.to_s.titleize}.new #{m}_obj
        end

      EOB
    end

    def has_one method, klass
      m = method.to_s.gsub(/\s+/, '')
      self.class_eval <<-EOB

        def #{m}
          @#{m}
        end

        def #{m}=#{m}_obj
          @#{m} ||= #{klass.to_s.titleize}.new #{m}_obj
        end

      EOB
    end

    def has_many method, klass
      m = method.to_s.gsub(/\s+/, '')
      self.class_eval <<-EOB

        def #{m}
          @#{m} || []
        end

        def #{m}=#{m}_obj
          @#{m} ||= #{klass.to_s.titleize}.parse #{m}_obj
        end

      EOB
    end

    def belongs_to name, *args
      options = args.extract_options!
      name = name.to_s.gsub(/\s+/, '')

      if args[0]
        klass = args[0].to_s
      else
        klass = name.to_s.singularize
      end

      klass = klass.titleize

      self.class_eval <<-EOB

        def #{name}_id
          @#{name} && @#{name}.id
        end

        def #{name}_id=id
          @#{name}_id = id
        end

        def #{name}
          if @#{name}_id && @#{name} && @#{name}.id && @#{name}_id != @#{name}.id
            @#{name} = #{klass}.find @#{name}_id
          elsif !@#{name}_id && @#{name} && @#{name}.id
            @#{name}_id = @#{name}.id
          end
          @#{name}
        end

        def #{name}=#{name}_obj
          obj = #{klass}.new #{name}_obj
          @#{name} ||= obj
        end

      EOB
    end

  end
end