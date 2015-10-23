class Module
  def constant(name, value)
    unless const_defined?(name)
      const_set(name, value)
      module_eval(<<-EVAL, __FILE__, __LINE__)
        def self.#{name.to_s.downcase}
      #{name.to_s}
        end
      EVAL
    end
  end
end