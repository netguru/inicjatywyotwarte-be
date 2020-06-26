# frozen_string_literal: true

ActiveAdmin.register Resource, as: 'approved_resources' do
  actions :all, except: %i[create new destroy]

  permit_params :name,
                :description,
                :draft_description,
                :target_url,
                :facebook_url,
                :ios_url,
                :android_url,
                :location,
                :organizer,
                :contact,
                :how_to_help,
                :category,
                :thumbnail,
                tag_ids: []

  controller do
    after_action :regenerate_resources_json, only: %i[create update disapprove]

    def regenerate_resources_json
      UploadResourcesToStorageWorker.perform_async
      UploadLocationsToStorageWorker.perform_async
    end

    def scoped_collection
      end_of_association_chain.approved.distinct.includes([thumbnail_attachment: :blob])
    end
  end

  index download_links: false do
    id_column
    column :name
    column :description
    column :tags do |resource|
      content_tag(:span, resource.tags.pluck(:name).join(', '))
    end
    column :category
    column :location
    column :thumbnail do |resource|
      resource.thumbnail.attached? ? image_tag(url_for(resource.thumbnail), size: '100x100') : content_tag(:span, 'No thumbnail yet')
    end
    column :created_at
    actions defaults: true do |resource|
      link_to 'Disapprove', disapprove_admin_approved_resource_path(resource), method: :put if can?(:disapprove, Resource)
    end
  end

  show do
    attributes_table do
      row :name
      row :description
      row :draft_description
      row :category
      row :target_url
      row :location
      row :organizer
      row :contact
      row :how_to_help
      row :ios_url
      row :android_url
      row :facebook_url
      row :thumbnail do |resource|
        image_tag(url_for(resource.thumbnail), size: '100x100') if resource.thumbnail.attached?
      end
      panel 'Upvotes' do
        paginated_collection(resource.upvotes.order(created_at: :desc).page(params[:page]).per(15), download_links: false) do
          table_for collection do
            column :id
            column :ip_address
            column :created_at
            column('Actions') do |upvote|
              span link_to 'Delete', destroy_comment_admin_approved_resource_path(upvote_id: upvote.id), method: :delete
            end
          end
        end
      end
      active_admin_comments
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
      f.input :draft_description, hint: 'This description won\'t be be visible. Use \'description\' input above'
      f.input :category, as: :select, collection: StaticData::CATEGORIES
      f.input :tags,
              as: :select,
              input_html: { class: 'tag_select_input' },
              multiple: true,
              collection: ActsAsTaggableOn::Tag.select(:id, :name).all,
              hint: 'Hold ctrl to select multiple tags.'
      f.input :target_url
      f.input :location
      f.input :organizer
      f.input :contact
      f.input :how_to_help, label: 'How to help and get help?'
      f.input :ios_url
      f.input :android_url
      f.input :facebook_url
      f.input :thumbnail,
              as: :file,
              hint: if f.object.thumbnail.attached?
                      image_tag(url_for(f.object.thumbnail), size: '100x100')
                    else
                      content_tag(:span, 'No thumbnail yet')
                    end
    end
    f.actions
  end

  action_item :disapprove, only: :show do
    link_to 'Disapprove', disapprove_admin_approved_resource_path(resource), method: :put if can?(:disapprove, Resource)
  end

  action_item :destroy_resource_thumbnail, only: %i[show edit new] do
    if resource.thumbnail.attached?
      link_to 'Delete thumbnail', destroy_resource_thumbnail_admin_approved_resource_path(resource.thumbnail.id),
              method: :delete,
              data: { confirm: 'Are you sure?' }
    end
  end

  member_action :disapprove, method: :put do
    if resource.disapprove!
      redirect_to admin_approved_resources_path, notice: 'Disapproved!'
    else
      flash[:error] = resource.errors.full_messages.join(', ')
      redirect_to admin_approved_resources_path
    end
  end

  member_action :destroy_comment, method: :delete do
    Upvote.find(params[:upvote_id]).destroy!
    redirect_to admin_approved_resource_path(resource), notice: 'Upvote removed!'
  end

  member_action :destroy_resource_thumbnail, method: :delete do
    @thumbnail = ActiveStorage::Attachment.find(params[:id])
    @thumbnail.purge_later
    redirect_back(fallback_location: edit_admin_approved_resource_path)
  end

  filter :name
  filter :description
  filter :category, as: :select, collection: StaticData::CATEGORIES
  filter :location
  filter :created_at
  filter :target_url
  filter :facebook_url
  filter :ios_url
  filter :android_url
  filter :tags, label: 'Tags',
                as: :select, input_html: { multiple: true },
                collection: proc { ActsAsTaggableOn::Tag.distinct.pluck(:name) }
end
