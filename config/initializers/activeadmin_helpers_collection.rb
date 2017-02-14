# frozen_string_literal: true
module ActiveAdmin
  module Helpers
    module Collection
      alias old_collection_size collection_size

      def collection_size(c = collection)
        return c.count if c.is_a?(Array)

        old_collection_size(c)
      end
    end
  end
end
