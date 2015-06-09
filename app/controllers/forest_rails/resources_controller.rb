module ForestRails
  class ResourcesController < ApplicationController

    before_filter :find_resource
    before_filter :define_serializers

    def index
      render json: @resource.limit(20), each_serializer: @serializer
    end

    def show
      render json: @resource.find(params[:id]), serializer: @serializer
    end

    private

    def find_resource
      @resource_plural_name = params[:resource]
      @resource_singular_name = @resource_plural_name.singularize
      @resource_class_name = @resource_singular_name.classify

      begin
        @resource = @resource_class_name.constantize
      rescue
      end

      if @resource.nil? || !@resource.ancestors.include?(ActiveRecord::Base)
        render json: {status: 404}, status: :not_found
      end
    end

    def define_serializers
      @serializer = SerializerFactory.new.serializer_for(@resource)
    end

  end
end
