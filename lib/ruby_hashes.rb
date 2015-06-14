require 'ruby_hashes/version'
require 'parser/current'
require 'active_support/core_ext/hash'

module RubyHashes

  class Converter
    def initialize(source, options={})
      @source = source
      @options = options.reverse_merge({
        filename: "(main)",
      })
    end

    def to_new_style
      buffer = Parser::Source::Buffer.new(@options[:filename])
      parser = Parser::CurrentRuby.new
      buffer.source = @source
      ast = parser.parse(buffer)
      rewriter = NewStyleHashRewriter.new(buffer)
      rewriter.rewrite(ast)
    end
  end

  class NewStyleHashRewriter < ::Parser::Rewriter
    def initialize(buffer, *args, &block)
      @source_buffer = buffer
      super(*args, &block)
    end

    def rewrite(ast)
      @source_rewriter = ::Parser::Source::Rewriter.new(@source_buffer)
      process(ast)
      @source_rewriter.process
    end

    def on_hash(node)
      debug "on_hash [%d...%d]\n  %p" % [
        node.loc.expression.begin_pos,
        node.loc.expression.end_pos,
        node.loc.expression.source,
      ]

      @convert = simple_old_style_hash?(node)
      super
      debug "end on_hash"
    end

    def on_pair(node)
      debug "on_pair [%d...%d]\n  node: %p\n  @convert: %p" % [
        node.loc.expression.begin_pos,
        node.loc.expression.end_pos,
        node.loc.expression.source,
        @convert,
      ]

      if @convert
        key_node, value_node = node.children

        op_range = node.loc.operator

        key = key_node.loc.expression.source.sub(/^:/, '')
        key << ":"

        # :key=>value
        #     ^ key end_pos
        #     ^ op begin_pos
        #       ^ op end_pos
        #       ^ value begin_pos
        #
        # :key=> value
        #     ^ key end_pos
        #     ^ op begin_pos
        #       ^ op end_pos
        #        ^ value begin_pos
        #
        # :key => value
        #     ^ key end_pos
        #      ^ op begin_pos
        #        ^ op end_pos
        #         ^ value begin_pos
        #
        # key:value
        #    ^ key end_pos
        #    ^ op begin_pos
        #     ^ op end_pos
        #     ^ value begin_pos
        #
        # key: value
        #    ^ key end_pos
        #    ^ op begin_pos
        #     ^ op end_pos
        #      ^ value begin_pos

        if (value_node.loc.expression.begin_pos - node.loc.operator.size) == key_node.loc.expression.end_pos
          key << " "
          debug "  appending one space"
        elsif (node.loc.operator.begin_pos - key_node.loc.expression.end_pos) > 0
          op_range = ::Parser::Source::Range.new(@source_buffer, node.loc.operator.begin_pos - 1, node.loc.operator.end_pos)
          debug "  removing one space"
        end

        replace(key_node.loc.expression, key)
        remove(op_range)
      end

      super

      debug "end on_pair"
    end

    private

    def simple_old_style_hash?(node)
      node.children.all? do |pair_node|
        key_node = pair_node.children.first
        key_node.type == :sym &&
          (key_node.loc.begin.nil? ||
           key_node.loc.begin.is?(':'))
      end
    end

    def debug(*args, &block)
      if ENV['DEBUG']
        puts(*args, &block)
      end
    end
  end

end
