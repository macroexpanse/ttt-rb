class Cell
  attr_reader :id, :value, :win

  def initialize(args)
    @id = args.fetch(:id)
    @value = args.fetch(:value)
  end

  def fill(value)
    @value = value
  end

  def is_winner
    @win = true
  end

  def to_hash
    hash = { :id => self.id, :value => self.value }.merge(local_hash_attrs)
    hash[:win] = true if win == true
    hash
  end

  def local_hash_attrs
    {}
  end

end

