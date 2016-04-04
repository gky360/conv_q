namespace :models do

  MODELS = ["history", "report", "tag", "tag_topic", "topic", "user"]

  MODELS.each do |model|
    model_plr = model.pluralize
    namespace model.to_sym do

      desc "dump #{model_plr} into a fixture file"
      task :dump_fixture => :environment do
        model_obj = Object.const_get(model.camelize.to_sym)
        model_h = {}
        model_obj.find_each do |model_instance|
          fixture_name = "#{model}_#{model_instance.id}"
          model_h[fixture_name] = model_instance.attributes
          model_h[fixture_name].each do |key, val|
            if key === "created_at" || key === "updated_at"
              model_h[fixture_name][key] = Time.parse(val.to_s)
            else
              model_h[fixture_name][key] = val.to_s
            end
          end
        end

        File.open("#{Rails.root}/spec/fixtures/#{model_plr}.yml", "w") do |f|
          f.write model_h.to_yaml
        end
      end

      desc "delete all #{model_plr} from the table"
      task :drop => :environment do
        model_obj = Object.const_get(model.camelize.to_sym)
        model_obj.delete_all
        model_obj.connection.execute("TRUNCATE TABLE `#{model_plr}`")
      end

    end
  end


end
