RSpec.describe Superbot::CLI::Cloud::VersionCommand do
  before { @k = superbot_cloud "version" }

  describe "stdout" do
    it do
      expect(@k.out).to include "#{Superbot::Cloud::VERSION}\r\n"
    end
  end
end
