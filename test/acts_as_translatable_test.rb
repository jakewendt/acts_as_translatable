require File.dirname(__FILE__) + '/test_helper'

class ActsAsTranslatableTest < ActiveSupport::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	test "should create page" do
		assert_difference('Page.count',1) do
			page = create_page
		end
	end

	test "should create page and not require locale" do
		assert_difference('Page.count',1) do
			create_page(:locale => nil)
		end
	end

	test "should create page and not require translatable" do
		assert_difference('Page.count',1) do
			create_page(:translatable_id => nil)
		end
	end

	test "should require locale for translation" do
		translatable = create_page
		assert_difference('Page.count',0) do
			page = create_page(:translatable_id => translatable.id)
			assert page.errors.on(:locale)
		end
	end

	test "should require unique locale for translation" do
		translatable = create_page
		create_page(:translatable_id => translatable.id, 
			:locale => 'sp')
		assert_difference('Page.count',0) do
			page = create_page(:translatable_id => translatable.id, 
				:locale => 'sp')
			assert page.errors.on(:locale)
		end
	end

	test "should have many translations" do
		page = create_page
		assert_equal 0, page.translations.count
		assert_difference("Page.find(#{page.id}).translations.count",3) {
		assert_difference('Page.count',3) {
			p = create_page(:translatable_id => page.id, :locale => 'sp')
			assert_equal p.translatable, page
			p = create_page(:translatable_id => page.id, :locale => 'fr')
			assert_equal p.translatable, page
			p = create_page(:translatable_id => page.id, :locale => 'de')
			assert_equal p.translatable, page
		} }
	end

	test "should create page with translation" do
		assert_difference('Page.count',3) {
			page = create_page(:title => 'original',
				:translations_attributes => [
					{:title => 'translated title 1'},
					{:title => 'translated title 2'}
				]
#	These translations are invalid as they have no locale
#	but apparently the error doesn't get raised on creation.
#	A check afterward shows that they do fail validation.
#		WTF
			)
puts page.errors.inspect
puts page.inspect
puts page.translations.inspect
t = page.translations.first
puts t.valid?
puts t.errors.inspect
		}
	end

	test "should destroy all translations on destroy" do
	end

protected

	def create_page(options={})
		page = Page.new(options)
		page.save
		page
	end

end
