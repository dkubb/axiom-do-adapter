# encoding: utf-8

require 'veritas'
require 'veritas-sql-generator'
require 'data_objects'

module Veritas
  module Adapter

    # An adapter wrapping a DataObjects connection
    class DataObjects

      # Initialize a DataObjects adapter
      #
      # @param [String] uri
      #
      # @return [undefined]
      #
      # @api private
      def initialize(uri)
        @uri = uri
      end

      # Read the results from the SQL representation of the relation
      #
      # @example
      #   adapter.read(relation) { |row| ... }
      #
      # @param [Relation] relation
      #
      # @yield [row]
      #
      # @yieldparam [Array] row
      #   each row in the results
      #
      # @return [self]
      #
      # @api public
      def read(relation)
        connection = ::DataObjects::Connection.new(@uri)
        Statement.new(connection, relation, SQL::Generator::Relation).each { |row| yield row }
        self
      ensure
        connection.close if connection
      end

    end # class DataObjects
  end # module Adapter
end # module Veritas

require 'veritas/adapter/data_objects/version'

require 'veritas/adapter/data_objects/statement'
