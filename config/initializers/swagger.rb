# frozen_string_literal: true

GrapeSwaggerRails.options.app_name = 'quarantinehelper'
GrapeSwaggerRails.options.url = '/api/docs'
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
GrapeSwaggerRails.options.doc_expansion = 'list'
GrapeSwaggerRails.options.hide_url_input = true
