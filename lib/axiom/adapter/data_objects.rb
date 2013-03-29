# encoding: utf-8

require 'axiom'
require 'axiom-sql-generator'
require 'data_objects'

module Axiom
  module Adapter

    # An adapter wrapping a DataObjects connection
    class DataObjects
      include Adamantium

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
        return to_enum(__method__, relation) unless block_given?
        connection = ::DataObjects::Connection.new(@uri)
        Statement.new(connection, relation).each { |row| yield row }
        self
      ensure
        connection.close if connection
      end

    end # class DataObjects
  end # module Adapter
end # module Axiom

require 'axiom/adapter/data_objects/version'

require 'axiom/adapter/data_objects/statement'
