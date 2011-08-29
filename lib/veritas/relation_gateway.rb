# encoding: utf-8

module Veritas

  # A relation backed by an adapter
  class RelationGateway
    include Enumerable

    # Initialize a RelationGateway
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
    #   gateway = RelationGateway.new(adapter, relation)
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
      return super if materialized?
      each_tuple { |tuple| yield tuple }
      self
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
      @relation.respond_to?(method)
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
      response = @relation.public_send(*args, &block)
      if response.equal?(@relation)
        self
      else
        response
      end
    end

    # Yield each tuple in the result
    #
    # @yield [tuple]
    #
    # @yieldparam [Tuple] tuple
    #   each tuple in the results
    #
    # @return [undefined]
    #
    # @api private
    def each_tuple
      Relation.new(@relation.header, @adapter.read(@relation)).each do |tuple|
        yield tuple
      end
    end

  end # class RelationGateway
end # module Veritas
