class TrueClass
  def humanize
    "Yes"
  end
end

class FalseClass
  def humanize
    "No"
  end
end

class Numeric
	def humanize
		self
	end
end

class NilClass
	def humanize
		self
	end
end