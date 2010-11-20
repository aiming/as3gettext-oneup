require 'helper'

class TestAs3gettext < Test::Unit::TestCase
  context "-g option" do
    setup do
      # delete generated files
      @file_list = ["test/works/_.as", "test/works/com/rails2u/gettext/GetText.as"]
      @file_list.each do |f|
        File.delete(f) if File.exist?(f)
      end
      [
        "test/works/com/rails2u/gettext/",
        "test/works/com/rails2u/",
        "test/works/com/",
      ].each do |d|
        Dir.delete(d) if File.exist?(d)
      end
    end
    should "generate as3lib" do
      # not exists?
      @file_list.each do |f|
        assert !File.exist?(f)
      end
      # generate
      As3gettext::Command.new.run %W(-g test/works)
      # generated?
      @file_list.each do |f|
        assert File.exist?(f)
      end
    end
  end
end
