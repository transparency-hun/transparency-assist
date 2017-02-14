# frozen_string_literal: true
ActiveAdmin.register Tag do
  permit_params :name

  index do
    selectable_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs 'Tag Details' do
      f.input :name
    end
    f.actions
  end
end
