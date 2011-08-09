# encoding: utf-8

module Veritas
  module Adapter
    class DataObjects

      # Executes generated SQL statements
      class Statement
        include Enumerable, Immutable

        # Initialize a statement
        #
        # @param [::DataObjects::Connection] connection
        #   the database connection
        # @param [Relation] relation
        #   the relation to generate the SQL from
        # @param [SQL::Generator::Relation] generator
        #   the object to generate the SQL with
        #
        # @return [undefined]
        #
        # @api private
        def initialize(connection, relation, generator)
          @connection = connection
          @relation   = relation
          @generator  = generator
        end

        # Iterate over each row in the results
        #
        # @example
        #   statement = Statement.new(connection, relation, generator)
        #   statement.each { |row| ... }
        #
        # @yield [row]
        #
        # @yieldparam [Array] row
        #   each row in the results
        #
        # @return [self]
        #
        # @api public
        def each
          return to_enum unless block_given?
          each_row(command.execute_reader) { |row| yield row }
          self
        end

        # Return the SQL query
        #
        # @return [String]
        #
        # @api public
        def to_s
          @generator.visit(@relation).to_sql.freeze
        end

      private

        # Yield each row in the result
        #
        # @param [::DataObjects::Reader] reader
        #
        # @yield [row]
        #
        # @yieldparam [Array] row
        #   each row in the results
        #
        # @return [undefined]
        #
        # @api private
        def each_row(reader)
          while reader.next!
            yield reader.values
          end
        ensure
          reader.close
        end

        # Return the command for the SQL query and column types
        #
        # @return [::DataObjects::Command]
        #
        # @api private
        def command
          command = @connection.create_command(to_s)
          command.set_types(column_types)
          command
        end

        # Return the list of types for each column
        #
        # @return [Array<Class>]
        #
        # @api private
        def column_types
          @relation.header.map { |attribute| attribute.class.primitive }
        end

        memoize :to_s, :command

      end # class Statement
    end # class DataObjects
  end # module Adapter
end # module Veritas
