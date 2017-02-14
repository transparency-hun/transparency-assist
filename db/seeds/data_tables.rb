data_tables = [['Kormány dokumentumok', 'kormany.hu', ['link', 'title', 'agency']],
               ['Termékszintű adatok KN szerint (2008-2015)', 'ksh.hu', ['item', 'value']],
               ['Termékszintű adatok KN szerint (2015. évtől)', 'ksh.hu',  ['item', 'value']],
               ['NKA által támogatott pályázatok', 'nka.hu', ['tender_name', 'year_of_decision', 'granted_amount', 'dormitory', 'tender_subject', 'specialization', 'seat']],
               ['Területalapú támogatások', 'mvh.gov.hu', ['name', 'address', 'foundation', 'source', 'sum']]]

admins = Admin.all
categories = Category.all

data_tables.each do |data_table|
  changeset_headers = []
  data_table[2].each do |key|
    changeset_headers << {'display' => key, 'crawler_key' => key }
  end

  DataTable.create(
    admin: admins.sample,
    category: categories.sample,
    title: data_table[0],
    source: data_table[1],
    changeset_headers: changeset_headers
  )
end
