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
        open do |connection|
          statement(connection, relation).each { |row| yield row }
        end
        self
      end

    private

      # Handles opening and closing a connection
      #
      # @yield [connection]
      #
      # @yieldparam [::DataObjects::Connection] connection
      #   the database connection
      #
      # @return [undefined]
      #
      # @api private
      def open
        connection = ::DataObjects::Connection.new(@uri)
        yield connection
      ensure
        connection.close if connection
      end

      # Initialize a Statement for the connection and relation
      #
      # @param [Array] *args
      #   the connection and relation
      #
      # @return [Statement]
      #
      # @api private
      def statement(*args)
        Statement.new(*args << SQL::Generator::Relation)
      end

    end # class DataObjects
  end # module Adapter
end # module Veritas

require 'veritas/adapter/data_objects/version'

require 'veritas/adapter/data_objects/statement'
