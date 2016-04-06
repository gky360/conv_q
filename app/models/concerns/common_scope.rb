module CommonScope
  extend ActiveSupport::Concern

  included do
    # order random
    scope :rand, -> { order("RAND()") }

    # [fields_text] fields you want, splitted by commas
    #   if not present, this scope returns all fields included in permitted_fields
    # [permitted_fields] array of syms of fields you permit clients to access
    #   if not present, this scope returns all fields of the model
    scope :fields_with_permit, -> (fields_text, permitted_fields) {
      fields_text ||= ""
      permitted_fields ||= []
      fields = fields_text.split(",")
          .map{ |field_text| field_text.strip.to_sym }
          .select{ |field| permitted_fields.include?(field) }
      if fields.empty?
        return select(permitted_fields)
      end
      return select(fields)
    }

    # [fields_text] fields you want to use to sort records, splitted by commas
    #   example
    #     "updated_at"  -> updated_at: :asc
    #     "-updated_at" -> updated_at: :desc
    # [permitted_fields] array of syms of fields you permit clients to access
    scope :sort_with_permit, -> (fields_text, permitted_fields) {
      fields_text ||= ""
      permitted_fields ||= []
      order_h = {}
      fields_text.split(",").each do |field_text|
        field_match = field_text.strip.match(/\A(\-?)(\w+)\Z/)
        next if field_match.nil?
        attr_key = field_match[2].to_sym
        next unless permitted_fields.include?(attr_key)
        if field_match[1] === "-"
          order_h[attr_key] = :desc
        else
          order_h[attr_key] = :asc
        end
      end
      return order(order_h)
    }
  end

end
