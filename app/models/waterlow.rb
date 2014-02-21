class Waterlow < ActiveRecord::Base
	belongs_to :patient

	serialize :special_risks, Array 

	before_save :set_scores

	validates_presence_of :height, :weight, :patient_id
	validates_inclusion_of :appetite, :in => [true, false], :if => :has_not_lost_weight?

	def score
		#return score
		0
	end

	def weight_lost
		patient.waterlows[-2].weight - weight
	end

	private

	def set_scores
		set_bmi(height, weight)
		set_skin_type_score(skin_type)
		set_nutrition_score(weight, appetite)
		#Set scores of various aspects
	end

	def set_bmi(height, weight)
		height = height/100 if height > 5
		set_bmi_score(self.bmi = weight/(height*height))
	end

	def set_bmi_score(bmi)
		self.bmi_score = if bmi < 20
			3
		elsif bmi < 25
			0
		elsif bmi < 30
			1
		else # BMI is greater than or equal to 30
			2
		end 
	end

	def set_skin_type_score(skin_type)
		self.skin_type_score = case skin_type.try(&:downcase)
		when "healthy"
			0
		when "tissue paper", "dry", "oedematous", "clammy, pyrexia"
			1
		when "discoloured grade 1"
			2
		when "broken/spots grade 2", "broken/spots grade 3", "broken/spots grade 4"
			3
		else
			nil
		end
	end

	def has_lost_weight?
		patient.waterlows.presence ? weight_lost >= 0.5 : nil
	end

	def has_not_lost_weight?
		!has_lost_weight?
	end

	def set_nutrition_score(weight, appetite)
		self.nutrition_score = if has_lost_weight? 
			case weight_lost
			when 0.5..5
				1
			when 5..10
				2
			when 10..15
				3
			when proc { |w| w > 15 }
				4
			end
		elsif has_lost_weight? == nil # Weight loss is unsure 
			2
		else
			if appetite
				0
			else
				1
			end
		end
	end
end