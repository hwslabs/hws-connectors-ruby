module Hws::Connectors::Exception
  attr_reader :reason

  class Error < StandardError
    def initialize(err = nil)
      case err.class.name
      when 'Hash'
        @reason = err['reason']
        super(err['message'])
      else
        super(err)
      end
    end
  end

  class UnAuthorized < Error
    def initialize(msg = 'Invalid credentials')
      super(msg)
    end
  end

  class LowBalance < Error
    def initialize(msg = 'Your account balance is low')
      super(msg)
    end
  end

  class RatelimitExceeded < Error
    def initialize(msg = 'You have exceeded the number of attempts')
      super(msg)
    end
  end
end
