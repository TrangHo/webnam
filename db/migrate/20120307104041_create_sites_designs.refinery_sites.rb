# This migration comes from refinery_sites (originally 4)
class CreateSitesDesigns < ActiveRecord::Migration

  def up
    create_table :refinery_sites_designs do |t|
      t.integer :site_id
      t.string :scss_model
      t.string :background_color
      t.string :font_family
      t.string :font_color

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-sites"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/sites/designs"})
    end

    drop_table :refinery_sites_designs

  end

end
