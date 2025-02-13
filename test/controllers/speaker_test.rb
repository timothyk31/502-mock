require "test_helper"

class SpeakerTest < ActiveSupport::TestCase
  test "should not save speaker without name" do
    speaker = Speaker.new
    speaker.email = "test@gmail.com"
    assert_not speaker.save, "Saved the speaker without a name"
  end
  test "should not save speaker without email" do
    speaker = Speaker.new
    speaker.name = "Test, Test"
    assert_not speaker.save, "Saved the speaker without an email"
  end
  test "should not save speaker with invalid email" do
    speaker = Speaker.new
    speaker.name = "Test, Test"
    speaker.email = "invalid_email!com"
    assert_not speaker.save, "Saved the speaker with an invalid email"
  end
  test "should save speaker with valid name and email" do
    speaker = Speaker.new
    speaker.name = "Andy, Test"
    speaker.email = "andycorrales7@gmail.com"
    assert speaker.save, "Did not save the speaker with a valid name and email"
end
