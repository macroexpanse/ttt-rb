class SimpleAiCell < Cell
  attr_reader :position, :row, :column, :left_x, :right_x

  def initialize(args)
    super(args)
    @position = args.fetch(:position)
    @row = position.slice(0)
    @column = position.slice(1)
    @left_x = %w(a1 b2 c3).include?(position)
    @right_x = %w(a3 b2 c1).include?(position)
  end

  def local_hash_attrs
    {:position => position}
  end
end
