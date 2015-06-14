require 'pathname'

module Fixtures
  FIXTURES_ROOT = Pathname.new(File.expand_path('../../fixtures', __FILE__))

  def read_fixture(name)
    fixture_path(name).read
  end

  def fixture_path(name)
    FIXTURES_ROOT.join(name)
  end
end
