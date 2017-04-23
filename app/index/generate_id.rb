module GenerateID
  # Generate the ID
  def generate_id(doc_data, index_name, item_type)
    datasource = get_dataspec_for_project_source(index_name, item_type)
    id = get_secondary_id(datasource, doc_data, get_primary_id(datasource, doc_data))
    return add_doc_type(index_name, item_type, id)
  end

  # Add the document type/index to the ID
  def add_doc_type(index_name, item_type, id)
    "#{id}_#{index_name}_#{item_type.underscore}"
  end

  # Return the primary ID
  def get_primary_id(datasource, doc_data)
    clean_id(doc_data[datasource.id_field])
  end

  # Get the secondary ID fields
  def get_secondary_id(datasource, doc_data, id)
    return datasource.secondary_id.inject(id) do |id, field|
      id += clean_id(doc_data[field])
    end
  end

  # Removes non-urlsafe chars from ID
  def clean_id(str)
    if str
      return str.to_s.gsub("/", "").gsub(" ", "").gsub(",", "").gsub(":", "").gsub(";", "").gsub("'", "").gsub(".", "")
    end
  end
end