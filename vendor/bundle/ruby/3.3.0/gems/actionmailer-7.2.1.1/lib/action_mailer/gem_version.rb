# frozen_string_literal: true

module ActionMailer
  # Returns the currently loaded version of Action Mailer as a +Gem::Version+.
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 7
    MINOR = 2
    TINY  = 1
    PRE   = "1"

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
  end
end
