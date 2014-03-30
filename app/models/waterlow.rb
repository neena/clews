class Waterlow < ActiveRecord::Base
	belongs_to :patient

	serialize :special_risks, Hash # in form 'risk' => score

	before_save :set_score
	before_validation :strip_whitespace

	validates_presence_of :patient_id
	validates_inclusion_of :appetite, :in => [true, false], :if => :has_not_lost_weight?

	# scorers (could move whole logic to front end but yolo)
	SKIN_TYPE_SCORER = {"healthy" => 0,
											"tissue paper" => 1,
											"dry" => 1,
											"oedematous" => 1,
											"clammy/pyrexia" => 1,
											"discoloured- grade 1 pressure ulcer" => 2,
											"broken/spot- grade 2-4 pressure ulcer" => 3}

	MOBILITY_SCORER = {"fully mobile" => 0,
										"restless/fidgety" => 1,
										"apathetic" => 2,
										"restricted" => 3,
										"bedbound/traction" => 4,
										"chairbound (eg. wheelchair)" => 5}

	CONTINENCE_SCORER = {"complete/catheterised" => 0,
											"urinary incontinent" => 1,
											"faecal incontinent" => 2,
											"urinary and faecal incontinent" => 3}

	SPECIAL_RISKS_SCORER = {"terminal cachexia" => 8, ## Tissue malnutrition
													"multiple organ failure" => 8,
													"single organ failure (resp., renal, cardiac)" => 5,
													"peripheral vascular disease" => 5,
													"anaemia (hb < 8)" => 2,
													"smoking" => 1, 
													"diabetes, ms, cva (4)" => 4, ## Neurological defecit
													"diabetes, ms, cva (5)" => 5,
													"diabetes, ms, cva (6)" => 6,
													"motor/sensory (4)" => 4,
													"motor/sensory (5)" => 5,
													"motor/sensory (6)" => 6,
													"paraplegia (4)" => 4,
													"paraplegia (5)" => 5,
													"paraplegia (6)" => 6,
													"orthopaedic, spinal" => 5, ## Major surgery trauma
													"on table more than 2 hours" => 5,
													"on table more than 6 hours" => 8,
													"long-term, high dose steroids, cytotoxics, high-dose anti-inflammatory" => 4 } ## Medication

	def weight_lost
		patient.waterlows[patient.waterlows.last == self ? -2 : -1 ].weight - self.weight # This weird line prevents errors during build/create/save
	end

	private

	def strip_whitespace
		changes.keys.each do |name|
			if send(name).is_a? String
				send("#{name}=", send(name).strip.downcase)
			elsif name == "special_risks"
				special_risks.keys.each do |risk|
					special_risks[risk.strip.downcase] = special_risks[risk]
					special_risks.delete(risk)
				end
			end
		end
	end

	def set_score
		self.score = [bmi_score,
									skin_type_score,
									get_nutrition_score,
									sex_score(patient.sex),
									age_score(patient.age),
									continence_score,
									mobility_score].compact.sum
		#Set scores of various aspects
	end

	def set_bmi
		self.height = height/100 if height > 5
		self.bmi = weight/(height*height)
	end

	def bmi_score
		set_bmi if weight_changed? || height_changed?
		if bmi < 20
			3
		elsif bmi < 25
			0
		elsif bmi < 30
			1
		else # BMI is greater than or equal to 30
			2
		end 
	end

	def skin_type_score
		SKIN_TYPE_SCORER[skin_type]
	end

	def get_nutrition_score
		if weight_changed? || appetite_changed?
			set_nutrition_score(self.weight, self.appetite)
		else
			self.nutrition_score
		end
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

	def sex_score(sex)
		case sex.try(&:downcase)
		when "m"
			1
		when "f"
			2
		end
	end

	def age_score(age)
		case age
		when 14..49
			1
		when 50..64
			2
		when 65..74
			3
		when 75..80
			4
		when proc {|age| age >= 81}
			5
		end
	end

	def continence_score
		case continence
		when "complete", "catheterised"
			0
		when "urine incontinence"
			1
		when "faecal incontinence"
			2
		when "urinary and faecal incontinence"
			3
		end
	end

	def mobility_score
		MOBILITY_SCORER[mobility]
	end
	def special_risks_score
		special_risks.inject(0) do |total_score, (risk, score)|
			total_score + score
		end
	end

	def has_lost_weight?
		if (patient.waterlows.length > 0 && patient.waterlows.last != self) || patient.waterlows.length > 1 
			weight_lost >= 0.5 
		else
			nil
		end
	end

	def has_not_lost_weight?
		!has_lost_weight?
	end
end