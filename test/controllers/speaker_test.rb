require "test_helper"

class SpeakerTest < ActiveSupport::TestCase
  test "should not save speaker without name" do
    speaker = Speaker.new
    speaker.email = "test@gmail.com"
    assert_not speaker.save, "Saved the speaker without a name"
  end
  test "should not save speaker without email" do
    speaker = Speaker.new
    speaker.name = "Test, "
    assert_not speaker.save
end
