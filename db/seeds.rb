# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Pet.destroy_all
Application.destroy_all
Shelter.destroy_all


@shelter_1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)

@pet_1 = @shelter_1.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
@pet_2 = @shelter_1.pets.create!(image:"", name: "Zaney", description: "dog", approximate_age: 4, sex: "female")
@pet_3 = @shelter_1.pets.create!(image:"", name: "Iggy", description: "dog", approximate_age: 8, sex: "female")
@pet_4 = @shelter_1.pets.create!(image:"", name: "Mia", description: "dog", approximate_age: 4, sex: "female")
@pet_5 = @shelter_1.pets.create!(image:"", name: "Josh", description: "dog", approximate_age: 1, sex: "male")

@application_1 = Application.create!({ first_name: "John", last_name: "Jacob", street_address: "123 Baker Street", city: "Philadelphia", state: "PA", zip: 19100, description: "Large yard", status: "Pending"})
@application_2 = Application.create!({ first_name: "Mary", last_name: "Hairy", street_address: "456 Coder Lane", city: "Philadelphia", state: "PA", zip: 19089, description: "Trained service dog", status: "Pending"})
@application_3 = Application.create!({ first_name: "Fin", last_name: "Girder", street_address: "789 New Market Street", city: "Philadelphia", state: "PA", zip: 19145, description: "Wroks from home", status: "Pending"})

@application_1.pets << @pet_1
@application_1.pets << @pet_3
@application_1.pets << @pet_5
@application_2.pets << @pet_2
@application_2.pets << @pet_3
@application_2.pets << @pet_4
@application_3.pets << @pet_2
@application_3.pets << @pet_4
@application_3.pets << @pet_5

  @shelter_2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Longmont", state: "CO", zip: 80012)
  @pet_6 = @shelter_2.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
  @pet_7 = @shelter_2.pets.create!(image:"", name: "Zimba", description: "cat", approximate_age: 5, sex: "male")
  @pet_8 = @shelter_2.pets.create!(image:"", name: "Blop", description: "cat", approximate_age: 10, sex: "female")
  @pet_9 = @shelter_2.pets.create!(image:"", name: "Slinky", description: "cat", approximate_age: 0, sex: "male")
  @pet_10 = @shelter_2.pets.create!(image:"", name: "Jinx", description: "cat", approximate_age: 3, sex: "female")

  @application_4 = Application.create!({ first_name: "Will", last_name: "Martin", street_address: "123 Baker Street", city: "Philadelphia", state: "PA", zip: 19100, description: "Large yard", status: "Pending"})
  @application_5= Application.create!({ first_name: "Eliza", last_name: "Thorneberry", street_address: "456 Coder Lane", city: "Philadelphia", state: "PA", zip: 19089, description: "Trained service dog", status: "Pending"})
  @application_6= Application.create!({ first_name: "Debra", last_name: "Gritt", street_address: "789 New Market Street", city: "Philadelphia", state: "PA", zip: 19145, description: "Wroks from home", status: "Pending"})

  @application_4.pets << @pet_6
  @application_4.pets << @pet_8
  @application_4.pets << @pet_10
  @application_5.pets << @pet_7
  @application_5.pets << @pet_8
  @application_5.pets << @pet_9
  @application_6.pets << @pet_7
  @application_6.pets << @pet_9
  @application_6.pets << @pet_10

  @shelter_3 = Shelter.create!(name: "Shell Shelter", address: "102 Shelter Dr.", city: "Commerce City", state: "CO", zip: 80022)
  @pet_11 = @shelter_2.pets.create!(image:"", name: "Luke", description: "cat", approximate_age: 3, sex: "male")
  @pet_12 = @shelter_2.pets.create!(image:"", name: "Daisy", description: "dog", approximate_age: 3, sex: "female")
  @pet_13 = @shelter_2.pets.create!(image:"", name: "Shadow", description: "cat", approximate_age: 3, sex: "male")
  @pet_14 = @shelter_2.pets.create!(image:"", name: "Jam", description: "cat", approximate_age: 3, sex: "female")
  @pet_15 = @shelter_2.pets.create!(image:"", name: "Smith", description: "dog", approximate_age: 3, sex: "male")
