module RailsBlank
  module Object
    def blank?
     respond_to?(:empty?) ? empty? : !self
    end
  end

  module String
    def blank?
      /\A[[:space:]]*\z/ === self
    end
  end
end
