class MeasurementGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)
  # argument :measurement_type, :type => :string, :default => "generic", :desc => "The measurement type eg. <-type->Measurement. Expects camelcased eg. 'HeartRate' "
  check_class_collision suffix: "Measurement"
  # These end up in options hash
  # class_option :view_engine, :type => :string, :aliases => "-t", :desc => "Template engine for the views. Available options are 'erb' and 'haml'.", :default => "erb"
  class_option :numeric, :type => :boolean, :default => true, :aliases => "-n"
  class_option :ews, :type => :boolean, :default => false, :aliases => "-e"


  def generate_measurement
    template "model.rb", "app/models/measurements/#{file_name}.rb"
    migration_template "migration.rb", "db/migrate/create_#{file_name}"
    insert_into_file "app/models/observation.rb", "'#{name.underscore}',", after: "@@measurement_types = ["
  end

  def configure_for_ews 
    if options[:ews]
      prepend_to_file "config/ews_boundaries.yml" do
        "#{name}:\n#{
        if options[:numeric]
          ['min2','min1','min0','max0','max1','max2']
        else
          [0,1,2,3].map(&:to_s)
        end.map{|i| "  #{i}: ~"}.join("\n")
        }\n\n"
      end
    end
  end

  private
  def file_name
    "#{name.underscore}_measurement"
  end

  def self.next_migration_number(path)
    @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
  end
end
