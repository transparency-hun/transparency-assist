# frozen_string_literal: true
ActiveAdmin.register DataTable do
  permit_params :title, :description, :category_id, :official, :confirmed,
                :recent, :highlighted, :data_sheet, :source, tag_ids: []

  index do
    selectable_column
    column :category
    column :tags do |data_table|
      data_table.tags.pluck(:name).join(', ')
    end
    column :title
    column :last_fetched_at do |data_table|
      date = [data_table.last_fetched_at, data_table.created_at].compact.max
      l date, format: :long
    end
    column :url do |data_table|
      link_to('download', data_table.data_sheet.url)
    end
    column :official
    column :confirmed
    actions
  end

  filter :category
  filter :title
  filter :official
  filter :confirmed
  filter :tags

  form do |f|
    f.inputs 'Data table Details' do
      f.input :title
      f.input :description
      f.input :source
      f.input :category
      f.input :tags
      f.input :official
      f.input :confirmed
      f.input :recent
      f.input :highlighted
      f.input :data_sheet
    end
    f.actions
  end

  show do
    attributes_table do
      row :category
      row :title
      row :description
      row :source
      row :uploader_email
      row :created_at do
        l data_table.created_at, format: :long
      end
      row :last_fetched_at do
        l data_table.last_fetched_at, format: :long if data_table.last_fetched_at.present?
      end
      row :official
      row :confirmed
      row :recent
      row :highlighted

      rows :tags do
        data_table.tags.pluck(:name).join(', ')
      end

      row :url do
        link_to('download', data_table.data_sheet.url)
      end
    end

    if data_table.official?
      panel DataSource.model_name.human.pluralize do
        data_sources = data_table.data_sources.order(created_at: :desc)
        collection = Kaminari.paginate_array(data_sources).page(params[:page]).per(20)
        paginated_collection(collection, download_links: false) do
          table_for(collection, sortable: false) do
            column DataSource.human_attribute_name(:created_at) do |data_source|
              l data_source.created_at, format: :long
            end

            column :confirmed

            column 'Data Size' do |data_source|
              data_source.changeset.size
            end

            column '' do |data_source|
              capture do
                concat link_to 'View', admin_data_source_url(data_source)
                concat ' | '
                concat link_to 'Download XLS', download_admin_data_source_url(data_source, format: :xls)
              end
            end
          end
        end
      end
    end
  end
end
