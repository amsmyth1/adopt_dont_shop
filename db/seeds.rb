# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Pet.destroy_all
Shelter.destroy_all

@shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)

@pet1 = @shelter1.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
@pet2 = @shelter1.pets.create!(image:"", name: "Zaney", description: "dog", approximate_age: 4, sex: "female")
@pet3 = @shelter1.pets.create!(image:"", name: "Iggy", description: "dog", approximate_age: 8, sex: "female")
@pet4 = @shelter1.pets.create!(image:"", name: "Mia", description: "dog", approximate_age: 4, sex: "female")
@pet5 = @shelter1.pets.create!(image:"", name: "Josh", description: "dog", approximate_age: 1, sex: "male")
@application_1 = Application.create!(first_name: "John", last_name: "Smith", street_address: "123 Baker Street", city: "Harrison", state: "MD", zip: 19013, description: "Large yard", status: "Pending")


@shelter2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Longmont", state: "CO", zip: 80012)
@pet6 = @shelter2.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
@pet7 = @shelter2.pets.create!(image:"", name: "Zimba", description: "cat", approximate_age: 5, sex: "male")
@pet8 = @shelter2.pets.create!(image:"", name: "Blop", description: "cat", approximate_age: 10, sex: "female")
@pet9 = @shelter2.pets.create!(image:"", name: "Slinky", description: "cat", approximate_age: 0, sex: "male")
@pet10 = @shelter2.pets.create!(image:"", name: "Jinx", description: "cat", approximate_age: 3, sex: "female")

@shelter3 = Shelter.create!(name: "Shell Shelter", address: "102 Shelter Dr.", city: "Commerce City", state: "CO", zip: 80022)
@pet11 = @shelter2.pets.create!(image:"", name: "Luke", description: "cat", approximate_age: 3, sex: "male")
@pet12 = @shelter2.pets.create!(image:"", name: "Daisy", description: "dog", approximate_age: 3, sex: "female")
@pet13 = @shelter2.pets.create!(image:"", name: "Shadow", description: "cat", approximate_age: 3, sex: "male")
@pet14 = @shelter2.pets.create!(image:"", name: "Jam", description: "cat", approximate_age: 3, sex: "female")
@pet15 = @shelter2.pets.create!(image:"", name: "Smith", description: "dog", approximate_age: 3, sex: "male")
