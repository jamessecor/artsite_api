require 'csv'
namespace :import_data do

  task :delete_artworks => :environment do
    Artwork.find_each do |artwork|
      msg = "deleted #{artwork.title}, id=#{artwork.id}."
      artwork.image.purge if artwork.image.persisted?
      puts msg if artwork.destroy
    end
  end

  task :import_artworks => :environment do
    csv_text = File.read('./db/data/artworks.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Artwork.create!(
        id: row["imgID"] == "" ? nil : row["imgID"],
        medium: row["media"] == "" ? nil : row["media"],
        price: row["price"] == "" ? nil : row["price"],
        sale_price: row["salePrice"] == "" ? nil : row["salePrice"],
        year: row["yearCreated"] == "" ? nil : row["yearCreated"],
        title: row["title"] == "" ? nil : row["title"],
        grouping: row["grouping"] == "" ? nil : row["grouping"],
        buyer_id: row["buyerId"] == "" ? nil : row["buyerId"],
        sale_date: row["saleDate"] == "" ? nil : row["saleDate"],
        tax_paid: row["taxStatus"].present?
      )
      puts "Imported #{row["title"]} successfully"
    end
  end

  task :import_artwork_images => :environment do
    csv_text = File.read('./db/data/artworks.csv')
    csv = CSV.parse(csv_text, :headers => true)
    errors = []
    Artwork.transaction do
      csv.each do |row|
        if row["filename"].present? && row["filename"] != ""
          artwork = Artwork.find_by(id: row["imgID"], title: row["title"])
          image_path = Rails.root.join "db", "data", "artwork_images", "#{row["filename"]}"
          if File.exists? image_path
            image_file = File.open(image_path)
            puts artwork.title
            artwork.image.attach(io: image_file, filename: "#{row["filename"]}")
            puts "Added image [#{row["filename"]}] to #{artwork.title}."
          else
            puts "No image found."
            errors << artwork.title
          end
        else
          puts "No image for #{row["title"]}."
        end
      end
    end
    puts errors.to_s
  end

  task :import_contacts => :environment do
    csv_text = File.read('./db/data/contacts.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      contact = Contact.find_or_create_by(id: row["c_id"])
      contact.update(
        firstname: row["c_name"],
        lastname: row["c_lastname"],
        email: row["c_email"],
        message: row["c_note"]
      )
    end
  end

  task :import_expenses => :environment do
    csv_text = File.read('./db/data/expenses.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      # "expenseId","expenseDesc","cost","expenseDate","expenseFilename"
      expense = Expense.find_or_create_by(id: row["expenseId"])
      expense.update(
        description: row["expenseDesc"],
        cost: row["cost"],
        incurred_at: row["expenseDate"]
      )

    end
  end

  task :import_expense_pdfs => :environment do
    csv_text = File.read('./db/data/expense.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      if row["expenseFilename"].present? && row["expenseFilename"] != ""
        expense = Expense.find_by(id: row["expenseId"])
        image_path = Rails.root.join "db", "data", "img", "#{row["expenseFilename"]}"
        image_file = File.open(image_path)
        expense.image.attach(io: image_file, filename: "#{row["expenseFilename"]}")
        puts "Added pdf [#{row["expenseFilename"]}] to #{expense.description}."
      else
        puts "No pdf for expense id:#{row["expenseId"]}."
      end
    end
  end
end