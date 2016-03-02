module CanCan
  module ModelAdapters
    class ActiveRecord3Adapter < AbstractAdapter
      include ActiveRecordAdapter
      def self.for_class?(model_class)
        model_class <= ActiveRecord::Base
      end

      private

      def build_relation_with_unions(model_class,rules)
        rules.map do |rule|
          model_class.where(conditions_for_rule(rule)).joins(joins_for_rule(rule))
        end.inject(empty_relation(model_class)) do |result, element|
          result.union(element)
        end
      end

      def build_relation(*where_conditions)
        @model_class.where(*where_conditions).includes(joins)
      end

      # used with inject to return emtpy relation instead of a nil value
      def empty_relation(model_class)
        model_class.where("1=1")
      end

    end
  end
end
