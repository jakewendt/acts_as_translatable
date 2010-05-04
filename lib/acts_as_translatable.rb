# ActsAsTranslatable
module Acts #:nodoc:
	module Translatable #:nodoc:
		def self.included(base)
			base.extend(InitialClassMethods)
		end

		module InitialClassMethods
			def acts_as_translatable(options = {})
#				configuration = { }
#				configuration.update(options) if options.is_a?(Hash)

				include Acts::Translatable::InstanceMethods
				extend  Acts::Translatable::ClassMethods

				belongs_to :translatable, 
					:class_name => self.class_name

				has_many :translations, 
					:class_name  => self.class_name,
					:foreign_key => 'translatable_id'

#				ANAF creates a lot of headaches and impossible validations
#				accepts_nested_attributes_for :translations

#				attr_accessor :require_locale

				if self.accessible_attributes
					attr_accessible :locale
					attr_accessible :translatable_id
					attr_accessible :translations_attributes
				end

				validates_presence_of :locale, :if => :translatable
				validates_presence_of :locale, :if => :translatable_id
#				validates_presence_of :locale, :if => :require_locale

				#
				#	When using 
				#		accepts_nested_attributes_for :translations
				#	and
				#		Page.new(..... :translations_attributes => [])
				#	this doesn't stop creation with invalid translation?
				#	But will return false with valid? call on translation post save?
				#
				#	This appears to be due to the fact that translatable_id
				#	isn't set until AFTER validation.  A translation doesn't know
				#	that it is a translation until after it is saved and
				#	becomes a translation.  Initially, it is translatable.
				#
				#	I added a :require_locale method to use as a flag.
				#
				#	There is also no guarantee that they are unique
				#	as none of them have been saved yet.
				#
				#	Perhaps I should disallow the :ANAF functionality?
				#

				validates_uniqueness_of :locale, 
					:scope => :translatable_id

#				before_validation :translations_require_locale

			end
		end

		module ClassMethods
		end 

		module InstanceMethods
#			def translations_require_locale
#				self.translations.each do |t|
#					t.require_locale = true
#				end
#			end

			def translate(locale)
				self.translations.find(:first, 
					:conditions => {:locale => locale}) || self
			end
		end 
	end
end
