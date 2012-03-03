# encoding: utf-8

module Veritas
  class Relation

    # A relation backed by an adapter
    class Gateway < Relation

      DECORATED_CLASS = superclass

      # remove methods so they can be proxied
      undef_method *DECORATED_CLASS.public_instance_methods(false).map(&:to_s) - %w[ materialize ]
      undef_method :project, :remove, :extend, :rename, :restrict, :sort_by, :reverse, :drop, :take

      # The adapter the gateway will use to fetch results
      #
      # @return [Adapter::DataObjects]
      #
      # @api private
      attr_reader :adapter
      protected :adapter unless RUBY_VERSION == '2.0.0'

      # The relation the gateway will use to generate SQL
      #
      # @return [Relation]
      #
      # @api private
      attr_reader :relation
      protected :relation unless RUBY_VERSION == '2.0.0'

      # Initialize a Gateway
      #
      # @param [Adapter::DataObjects] adapter
      #
      # @param [Relation] relation
      #
      # @return [undefined]
      #
      # @api private
      def initialize(adapter, relation)
        @adapter  = adapter
        @relation = relation
      end

      # Iterate over each row in the results
      #
      # @example
      #   gateway = Gateway.new(adapter, relation)
      #   gateway.each { |tuple| ... }
      #
      # @yield [tuple]
      #
      # @yieldparam [Tuple] tuple
      #   each tuple in the results
      #
      # @return [self]
      #
      # @api public
      def each
        return to_enum unless block_given?
        tuples.each { |tuple| yield tuple }
        self
      end

      # Return a relation that is the join of two relations
      #
      # @example natural join
      #   join = relation.join(other)
      #
      # @example theta-join using a block
      #   join = relation.join(other) { |r| r.a.gte(r.b) }
      #
      # @param [Relation] other
      #   the other relation to join
      #
      # @yield [relation]
      #   optional block to restrict the tuples with
      #
      # @yieldparam [Relation] relation
      #   the context to evaluate the restriction with
      #
      # @yieldreturn [Function, #call]
      #   predicate to restrict the tuples with
      #
      # @return [Gateway]
      #   return a gateway if the adapters are equal
      # @return [Algebra::Join]
      #   return a normal join when the adapters are not equal
      # @return [Algebra::Restriction]
      #   return a normal restriction when the adapters are not equal
      #   for a theta-join
      #
      # @api public
      def join(other)
        if block_given?
          super
        else
          binary_operation(__method__, other, Algebra::Join)
        end
      end

      # Return a relation that is the cartesian product of two relations
      #
      # @example
      #   product = gateway.product(other)
      #
      # @param [Relation] other
      #   the other relation to find the product with
      #
      # @return [Gateway]
      #   return a gateway if the adapters are equal
      # @return [Algebra::Product]
      #   return a normal product when the adapters are not equal
      #
      # @api public
      def product(other)
        binary_operation(__method__, other, Algebra::Product)
      end

      # Return the union between relations
      #
      # @example
      #   union = gateway.union(other)
      #
      # @param [Relation] other
      #   the other relation to find the union with
      #
      # @return [Gateway]
      #   return a gateway if the adapters are equal
      # @return [Algebra::Union]
      #   return a normal union when the adapters are not equal
      #
      # @api public
      def union(other)
        binary_operation(__method__, other, Algebra::Union)
      end

      # Return the intersection between relations
      #
      # @example
      #   intersect = gateway.intersect(other)
      #
      # @param [Relation] other
      #   the other relation to find the intersect with
      #
      # @return [Gateway]
      #   return a gateway if the adapters are equal
      # @return [Algebra::Intersection]
      #   return a normal intersection when the adapters are not equal
      #
      # @api public
      def intersect(other)
        binary_operation(__method__, other, Algebra::Intersection)
      end

      # Return the diferrence between relations
      #
      # @example
      #   difference = gateway.difference(other)
      #
      # @param [Relation] other
      #   the other relation to find the difference with
      #
      # @return [Gateway]
      #   return a gateway if the adapters are equal
      # @return [Algebra::Difference]
      #   return a normal dfference when the adapters are not equal
      #
      # @api public
      def difference(other)
        binary_operation(__method__, other, Algebra::Difference)
      end

      # Return a summarized relation
      #
      # @example with no arguments
      #   summarization = gateway.summarize do |context|
      #     context.add(:count, context[:id].count)
      #   end
      #
      # @example with a relation
      #   summarization = gateway.summarize(relation) do |context|
      #     context.add(:count, context[:id].count)
      #   end
      #
      # @example with a header
      #   summarization = gateway.summarize([ :name ]) do |context|
      #     context.add(:count, context[:id].count)
      #   end
      #
      # @example with another gateway
      #   summarization = gateway.summarize(other_gateway) do |context|
      #     context.add(:count, context[:id].count)
      #   end
      #
      # @param [Gateway, Relation, Header, #to_ary] summarize_with
      #
      # @yield [function]
      #   Evaluate a summarization function
      #
      # @yieldparam [Evaluator::Context] context
      #   the context to evaluate the function within
      #
      # @return [Gateway]
      #   return a gateway if the adapters are equal, or there is no adapter
      # @return [Algebra::Summarization]
      #   return a normal summarization when the adapters are not equal
      #
      # @api public
      def summarize(summarize_with = TABLE_DEE, &block)
        if summarize_merge?(summarize_with)
          summarize_merge(summarize_with, &block)
        else
          summarize_split(summarize_with, &block)
        end
      end

      # Test if the method is supported on this object
      #
      # @param [Symbol] method
      #
      # @return [Boolean]
      #
      # @api private
      def respond_to?(method, *)
        super || forwardable?(method)
      end

    private

      # Proxy the message to the relation
      #
      # @param [Symbol] method
      #
      # @param [Array] *args
      #
      # @return [self]
      #   return self for all command methods
      # @return [Object]
      #   return response from all query methods
      #
      # @api private
      def method_missing(method, *args, &block)
        forwardable?(method) ? forward(method, *args, &block) : super
      end

      # Test if the method can be forwarded to the relation
      #
      # @param [Symbol] method
      #
      # @return [Boolean]
      #
      # @api private
      def forwardable?(method)
        relation.respond_to?(method)
      end

      # Forward the message to the relation
      #
      # @param [Array] *args
      #
      # @return [self]
      #   return self for all command methods
      # @return [Object]
      #   return response from all query methods
      #
      # @api private
      def forward(*args, &block)
        relation = self.relation
        response = relation.public_send(*args, &block)
        if response.equal?(relation)
          self
        elsif response.kind_of?(DECORATED_CLASS)
          self.class.new(adapter, response)
        else
          response
        end
      end

      # Return a list of tuples to iterate over
      #
      # @return [#each]
      #
      # @api private
      def tuples
        relation = self.relation
        if materialized?
          relation
        else
          DECORATED_CLASS.new(header, adapter.read(relation))
        end
      end

      # Return a binary relation
      #
      # @param [Relation] other
      #
      # @return [Gateway]
      #   return a gateway if the adapters are equal
      # @return [Relation]
      #   return a binary relation when the adapters are not equal
      #
      # @api private
      def binary_operation(method, other, factory)
        if same_adapter?(other)
          forward(method, other.relation)
        else
          factory.new(self, other)
        end
      end

      # Test if the other object uses the same adapter
      #
      # @param [Gateway, Relation] other
      #
      # @return [Boolean]
      #
      # @api private
      def same_adapter?(other)
        other.respond_to?(:adapter) && adapter.eql?(other.adapter)
      end

      # Test if the summarize_with object can be merged into the summarization
      #
      # @param [Gateway, Relation, Header] summarize_with
      #
      # @return [Boolean]
      #
      # @api private
      def summarize_merge?(summarize_with)
        !summarize_with.respond_to?(:header) ||
        summarize_with.equal?(TABLE_DEE)     ||
        same_adapter?(summarize_with)
      end

      # Merge the summarize_with into the summarization
      #
      # @param [Gateway, Relation, Header] summarize_with
      #
      # @return [Gateway]
      #
      # @api private
      def summarize_merge(summarize_with, &block)
        summarize_with = summarize_with.relation if summarize_with.respond_to?(:relation)
        forward(:summarize, summarize_with, &block)
      end

      # Split the summarize_with into a separate relation, wrapped in a summarization
      #
      # @param [Gateway, Relation, Header] summarize_with
      #
      # @return [Algebra::Summarization]
      #
      # @api private
      def summarize_split(summarize_with, &block)
        # evaluate the gateway, then summarize with the provided relation
        context = Evaluator::Context.new(header - summarize_with.header, &block)
        Algebra::Summarization.new(self, summarize_with, context.functions)
      end

    end # class Gateway
  end # class Relation
end # module Veritas
