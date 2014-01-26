VARIANCE_RATE = 0.05

def pulse_value
  @pulse_dir = random_direction
  @pulse_value = value_from_range(EWSConfig["Pulse"]["min2"]..EWSConfig["Pulse"]["max2"], @pulse_value, @pulse_dir)
end

def oxygen_sat_value
  @oxygen_sat_dir = oxygen_supp_value ? VARIANCE_RATE : -VARIANCE_RATE
  @oxygen_sat_value = value_from_range(EWSConfig["OxygenSat"]["min2"]..100, @oxygen_sat_value, @oxygen_sat_dir)
end

def oxygen_supp_value
  @oxygen_supp_value = value_from_array([true, false], @oxygen_supp_value)
end

def temperature_value
  @temperature_dir = random_direction
  @temperature_value = value_from_range(EWSConfig["Temperature"]["min2"]..EWSConfig["Temperature"]["max1"], @temperature_value, @temperature_dir)
end

def concious_value
  @concious_value = value_from_array(["A", "V", "P", "U"], @concious_value)
end

def respiration_rate_value
  @respiration_rate_dir = random_direction
  @respiration_rate_value = value_from_range(EWSConfig["RespirationRate"]["min2"]..EWSConfig["RespirationRate"]["max2"], @respiration_rate_value, @respiration_rate_dir)
end

def sys_bp_value
  @sys_bp_dir = -(VARIANCE_RATE*0.1) * @pulse_dir
  @sys_bp_value = value_from_range(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"], @sys_bp_value, @sys_bp_dir)
end

def dia_bp_value
  @dia_bp_dir = -(VARIANCE_RATE*0.1) * @pulse_dir
  @dia_bp_value = value_from_range(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"], @dia_bp_value, @dia_bp_dir)
end

def value_from_range(range, current = nil, direction = nil)
  new_value = rand(range)

  if current && direction
    new_value = (current + (current * direction)).floor
  end

  if outside_range?(range, new_value)
    new_value = range.begin if new_value < range.begin
    new_value = range.end   if new_value > range.end
  end

  new_value
end

def outside_range?(range, value)
  !range.include?(value)
end

def value_from_array(array, current)
  if rand(100) > 85
    array.sample
  else
    current
  end
end

def random_direction
  [-(VARIANCE_RATE*0.1), (VARIANCE_RATE*0.1)].sample
end

def reset_values
  @pulse_value = nil
  @pulse_dir = nil

  @oxygen_supp_value = nil

  @oxygen_sat_value = nil
  @oxygen_sat_dir = nil

  @temperature_value = nil
  @temperature_dir = nil

  @concious_value = nil

  @respiration_rate_value = nil
  @respiration_rate_dir = nil

  @sys_bp_value = nil
  @sys_bp_dir = nil

  @dia_bp_value = nil
  @dia_bp_dir = nil
end

def default_values
  @pulse_value = 80 #EWSConfig["Pulse"]["max0"]
  @pulse_dir = 1

  @oxygen_supp_value = false

  @oxygen_sat_value = 100 #EWSConfig["OxygenSat"]["min0"]
  @oxygen_sat_dir = 1

  @temperature_value = 37 #EWSConfig["Temperature"]["min0"]
  @temperature_dir = 1

  @concious_value = EWSConfig["Concious"]["0"]

  @respiration_rate_value = 18 #EWSConfig["RespirationRate"]["min0"]
  @respiration_rate_dir = -1

  @sys_bp_value = 120 #EWSConfig["SysBp"]["min0"]
  @sys_bp_dir = 1

  @dia_bp_value = 80 #(EWSConfig["SysBp"]["min0"] * 0.80).floor
  @dia_bp_dir = 1
end
