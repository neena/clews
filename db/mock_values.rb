def pulse_value
  @pulse_dir ||= [-1, 1].sample
  @pulse_value = value_from_range(EWSConfig["Pulse"]["min2"]..EWSConfig["Pulse"]["max2"], @pulse_value, @pulse_dir)
end

def oxygen_sat_value
  @oxygen_sat_dir ||= oxygen_supp_value ? 1 : -1
  @oxygen_sat_value = value_from_range(EWSConfig["OxygenSat"]["min2"]..EWSConfig["OxygenSat"]["min0"], @oxygen_sat_value, @oxygen_sat_dir)
end

def oxygen_supp_value
  @oxygen_supp_value = value_from_array([true, false], @oxygen_supp_value)
end

def temperature_value
  @temperature_dir ||= [-1, 1].sample
  @temperature_value = value_from_range(EWSConfig["Temperature"]["min2"]..EWSConfig["Temperature"]["max1"], @temperature_value, @temperature_dir)
end

def concious_value
  @concious_value = value_from_array(["A", "V", "P", "U"], @concious_value)
end

def respiration_rate_value
  @respiration_rate_dir ||= [-1, 1].sample
  @respiration_rate_value = value_from_range(EWSConfig["RespirationRate"]["min2"]..EWSConfig["RespirationRate"]["max2"], @respiration_rate_value, @respiration_rate_dir)
end

def sys_bp_value
  @sys_bp_dir ||= -1 * @pulse_dir
  @sys_bp_value = value_from_range(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"], @sys_bp_value, @sys_bp_dir)
end

def dia_bp_value
  @dia_bp_dir ||= -1 * @pulse_dir
  @dia_bp_value = value_from_range(EWSConfig["SysBp"]["min2"]..EWSConfig["SysBp"]["max2"], @dia_bp_value, @dia_bp_dir)
end

def value_from_range(range, current = nil, direction = nil)
  new = rand(range)
  if current && direction
    (current + (new * direction)) / 2
  else
    new
  end
end

def value_from_array(array, current)

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
