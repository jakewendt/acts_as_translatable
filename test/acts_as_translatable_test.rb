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

#	test "should create page with translations" do
#		assert_difference('Page.count',3) {
#			page = create_page(:title => 'original',
#				:translations_attributes => [
#					{:title => 'translated title 1',:locale => 'sp'},
#					{:title => 'translated title 2',:locale => 'fr'}
#				]
#			)
#		}
#	end

#	test "should require unique locales for translations using translations_attributes" do
#		assert_difference('Page.count',0) {
#			page = create_page(:title => 'original',:body=> 'testing',
#				:translations_attributes => [
#					{:title => 'translated title 1', :locale => 'sp'},
#					{:title => 'translated title 2', :locale => 'sp'}
#				]
#			)
##			assert page.errors.on('translations.locale')
#puts page.inspect
#puts page.translations.inspect
#		}
#	end

#	test "should require locales for translations using translations_attributes" do
#		assert_difference('Page.count',0) {
#			page = create_page(:title => 'original',:body=> 'testing',
#				:translations_attributes => [
#					{:title => 'translated title 1'},
#					{:title => 'translated title 2'}
#				]
#			)
#			assert page.errors.on('translations.locale')
#		}
#	end

	test "should destroy all translations on destroy" do
	end

	test "should get translation of translatable" do
#		page = create_page(:title => 'original',
#			:translations_attributes => [
#				{:title => 'translated title 1',:locale => 'sp'},
#				{:title => 'translated title 2',:locale => 'fr'}
#			]
#		)
		page = create_page(:title => 'original')
		page.translations << create_page(
			:title => 'translated title 1',:locale => 'sp')
		page.translations << create_page(
			:title => 'translated title 2',:locale => 'fr')
		translation = page.translate('sp')
		assert_equal translation.locale, 'sp'
	end

	test "should return self if translation locale doesn't exist" do
#		page = create_page(:title => 'original',
#			:translations_attributes => [
#				{:title => 'translated title 1',:locale => 'sp'},
#				{:title => 'translated title 2',:locale => 'fr'}
#			]
#		)
		page = create_page(:title => 'original')
		page.translations << create_page(
			:title => 'translated title 1',:locale => 'sp')
		page.translations << create_page(
			:title => 'translated title 2',:locale => 'fr')
		translation = page.translate('ru')
		assert_equal translation.locale, nil
	end

protected

	def create_page(options={})
		page = Page.new(options)
		page.save
		page
	end

end
