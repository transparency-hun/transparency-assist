def attachment_path(file)
  File.open(Rails.root.join('db', 'seeds', 'attachments', "#{file}"))
end

def preview_seed
  preview = Array.new(rand(15..30), ['Nagy Gábor', '1991', 'Szeptember', '25'])
  preview.unshift(['Név', 'Év', 'Hónap', 'Nap'])
end

admins = Admin.all
categories = Category.all

rand(10..30).times do |index|
  DataTable.create(
    admin: admins.sample,
    category: categories.sample,
    title: 'Táblázat ' + index.to_s,
    data_sheet: attachment_path('data_table01.csv'),
    preview: preview_seed,
    source: 'KSH'
  )
end
