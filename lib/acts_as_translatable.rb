# ActsAsTranslatable
module Acts #:nodoc:
	module Translatable #:nodoc:
		def self.included(base)
			base.extend(InitialClassMethods)
		end

		module InitialClassMethods
			def acts_as_translatable(options = {})
				configuration = { }
				configuration.update(options) if options.is_a?(Hash)

				include Acts::Translatable::InstanceMethods
				extend  Acts::Translatable::ClassMethods
			end
		end

		module ClassMethods
		end 

		module InstanceMethods
		end 
	end
end
