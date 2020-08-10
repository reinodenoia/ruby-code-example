class Example
  def initialize(hash)
    @hash = hash
    @hash.each do |attr, _value|
      define_singleton_method("#{attr}=") { |val| @hash[attr] = val }
      define_singleton_method(attr) { @hash[attr] }
    end
  end

  class << self
    def method_missing(m, *opts)
      return @hash[m.to_s] if @hash.key?(m.to_s)
      return @hash[m.to_sym] if @hash.key?(m.to_sym)
      nil
    end
  end
end

class Hash
  def method_missing(m, *opts)
    return self[m.to_s] if key?(m.to_s)
    return self[m.to_sym] if key?(m.to_sym)
    nil
  end
end

ex = Example.new({ z: { x: 'x', y: 'y' }, other: 'value'})

ex.z
# => {:x=>"x", :y=>"y"}
ex.z.x
# => "x"
ex.z = 'w'
ex.z
# => "w"
ex.other
# => "value"