require 'active_record'

module ActiveRecord # :nodoc:
  class Base
    # Stores the default scope for the class
    class_inheritable_accessor :default_scoping, :instance_writer => false
    self.default_scoping = []

    class << self
      # Sets the default options for the model. The format of the
      # <tt>method_scoping</tt> argument is the same as in with_scope.
      #
      #   class Person < ActiveRecord::Base
      #     default_scope :find => { :order => 'last_name, first_name' }
      #   end
      def default_scope(options = {})
        self.default_scoping << { :find => options, :create => (options.is_a?(Hash) && options.has_key?(:conditions)) ? options[:conditions] : {} }
      end

      def scoped_methods #:nodoc:
        Thread.current[:"#{self}_scoped_methods"] ||= self.default_scoping.dup
      end
    end
  end
end
