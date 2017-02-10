# frozen_string_literal: true
ActiveSupport.on_load(:active_model_serializers) do
  # Disable for all serializers (except ArraySerializer)
  ActiveModel::Serializer.root = false

  # Disable for ArraySerializer
  ActiveModel::ArraySerializer.root = false
end

ActiveModelSerializers.config.serializer_lookup_enabled = true
