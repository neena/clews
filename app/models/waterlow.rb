class Waterlow < ActiveRecord::Base
	belongs_to :patient

	serialize :special_risks, Array 

	before_save :set_scores

	def score
		#return score
		0
	end

	def set_scores
		set_bmi(height, weight)
		#Set scores of various aspects
	end

	def set_bmi(height, weight)
		bmi = weight/(height*height)
		self.bmi = bmi
		self.bmi_score = if bmi < 20
			3
		elsif bmi < 25
			0
		elsif bmi < 30
			1
		else
			2
		end 
	end

end