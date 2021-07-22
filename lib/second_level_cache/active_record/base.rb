# -*- encoding : utf-8 -*-
module SecondLevelCache
  module ActiveRecord
    module Base
      extend ActiveSupport::Concern

      included do
        after_destroy :expire_second_level_cache
        after_update :update_second_level_cache
        after_create :write_second_level_cache

        class << self
          alias_method_chain :update_counters, :cache
        end
      end


      module ClassMethods
        def update_counters_with_cache(id, counters)
          update_counters_without_cache(id, counters).tap do
            Array(id).each{|i| expire_second_level_cache(i)}
          end
        end
      end
    end
  end
end
