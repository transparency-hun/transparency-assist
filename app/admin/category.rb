# frozen_string_literal: true
ActiveAdmin.register Category do
  permit_params :name

  index do
    selectable_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs 'Category Details' do
      f.input :name
    end
    f.actions
  end
end
