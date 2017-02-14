# frozen_string_literal: true
require 'diff_checker'
require 'xls_generator'

class ChangeSet < OpenStruct
  extend ActiveModel::Naming
end

# frozen_string_literal: true
ActiveAdmin.register DataSource do
  actions :index, :show, :edit, :update, :destroy

  permit_params :confirmed

  member_action :download, method: :get do
    respond_to do |format|
      format.csv { send_data resource.to_csv }
      format.xls do
        send_data XlsGenerator.new(resource.to_array).to_xls.string,
                  filename: "#{resource.data_table.title.parameterize}.xls",
                  type: 'application/vnd.ms-excel'
      end
    end
  end

  member_action :diff, method: :get do
    @data_source = resource
    @previous_data_source = resource.previous_data_source
    if @previous_data_source.present?
      @page_title = "#{resource.data_table.title}: " \
                    "Changes from #{l @previous_data_source.created_at, format: :long} " \
                    "to #{l @data_source.created_at, format: :long}"

      @diffs = DiffChecker.new(@previous_data_source.changeset, @data_source.changeset).diff
    else
      @page_title = "#{resource.data_table.title}: " \
                    "Changes to #{l @data_source.created_at, format: :long}"
    end

    render 'admin/data_sources/diff'
  end

  action_item only: :show do
    link_to 'Show changes', diff_admin_data_source_url(data_source)
  end

  action_item only: :show do
    link_to 'Download XLS', download_admin_data_source_url(data_source, format: :xls)
  end

  index do
    selectable_column
    column :created_at
    column :confirmed
    column :title
    column 'data size' do |data_source|
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

  show title: proc { |ds| "#{ds.data_table.title} - #{l ds.created_at, format: :long}" } do
    panel "#{data_source.confirmed? ? 'CONFIRMED' : 'UNCONFIRMED'} Data" do
      changeset = data_source.changeset.map { |hsh| ChangeSet.new(hsh) }
      paginated_collection(Kaminari.paginate_array(changeset).page(params[:page]).per(20), download_links: false) do
        table_for(collection, sortable: false) do
          data_source.changeset_headers.each do |header_info|
            column header_info['display'] do |hsh|
              if header_info['crawler_key'] == 'link'
                link_to header_info['display'], hsh[header_info['crawler_key']]
              else
                hsh[header_info['crawler_key']]
              end
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs 'Data Source Details' do
      f.input :confirmed
    end
    f.actions
  end
end
