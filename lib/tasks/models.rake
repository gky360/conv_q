namespace :models do

  MODELS = ["history", "report", "tag", "tag_topic", "topic", "user"]

  MODELS.each do |model_name|
    model_plr = model_name.pluralize
    namespace model_name.to_sym do

      desc "dump #{model_plr} into a fixture file"
      task :dump_fixture => :environment do
        dump_fixture(model_name)
      end

      desc "delete all #{model_plr} from the table"
      task :drop => :environment do
        drop(model_name)
      end

    end
  end

  desc "dump all models into a fixture file"
  task :dump_fixture => :environment do
    MODELS.each do |model_name|
      dump_fixture(model_name)
    end
  end

  desc "delete all models from the table"
  task :drop => :environment do
    MODELS.each do |model_name|
      drop(model_name)
    end
  end


  private

  def dump_fixture(model_name)
    model_plr = model_name.pluralize
    model_obj = Object.const_get(model_name.camelize.to_sym)
    model_h = {}
    model_obj.find_each do |model_instance|
      fixture_name = "#{model_name}_#{model_instance.id}"
      model_h[fixture_name] = model_instance.attributes
      model_h[fixture_name].each do |key, val|
        if key === "created_at" || key === "updated_at"
          model_h[fixture_name].delete(key)
        else
          model_h[fixture_name][key] = val.to_s
        end
      end
    end

    File.open("#{Rails.root}/spec/fixtures/#{model_plr}.yml", "w") do |f|
      f.write model_h.to_yaml
    end
  end

  def drop(model_name)
    model_plr = model_name.pluralize
    model_obj = Object.const_get(model_name.camelize.to_sym)
    model_obj.delete_all
    model_obj.connection.execute("TRUNCATE TABLE `#{model_plr}`")
  end

end
