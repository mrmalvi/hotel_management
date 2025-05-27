# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'

# Create admin user
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'admin',
  name: 'Admin User'
)

# Create regular user
user = User.create!(
  email: 'user@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'user',
  name: 'Regular User'
)

# Create platforms
platforms = [
  { name: 'Booking.com', subdomain: 'booking' },
  { name: 'Expedia', subdomain: 'expedia' },
  { name: 'Airbnb', subdomain: 'airbnb' }
]

platforms.each do |platform|
  Platform.create!(platform)
end

# Create amenities
amenities = [
  { name: 'WiFi', description: 'Free high-speed internet access' },
  { name: 'Pool', description: 'Swimming pool' },
  { name: 'Gym', description: 'Fitness center' },
  { name: 'Spa', description: 'Spa and wellness center' },
  { name: 'Restaurant', description: 'On-site restaurant' },
  { name: 'Parking', description: 'Free parking' }
]

amenities.each do |amenity|
  Amenity.create!(amenity)
end

# Create room types
room_types = [
  { name: 'Standard', description: 'Standard room with basic amenities' },
  { name: 'Deluxe', description: 'Spacious room with premium amenities' },
  { name: 'Suite', description: 'Luxury suite with separate living area' }
]

room_types.each do |room_type|
  RoomType.create!(room_type)
end

# Create hotels with assets
hotels = [
  {
    name: 'Grand Hotel',
    description: 'Luxury hotel in the heart of the city',
    address: '123 Main St, City',
    phone: '123-456-7890',
    email: 'info@grandhotel.com',
    assets: [
      { image_url: 'https://images.unsplash.com/photo-1566073771259-6a8506099945', position: 1 },
      { image_url: 'https://images.unsplash.com/photo-1582719508461-905c673771fd', position: 2 },
      { image_url: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa', position: 3 }
    ]
  },
  {
    name: 'Seaside Resort',
    description: 'Beachfront resort with ocean views',
    address: '456 Beach Rd, Coast',
    phone: '234-567-8901',
    email: 'info@seasideresort.com',
    assets: [
      { image_url: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4', position: 1 },
      { image_url: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d', position: 2 },
      { image_url: 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7', position: 3 }
    ]
  },
  {
    name: 'Mountain View Lodge',
    description: 'Cozy lodge with mountain views',
    address: '789 Mountain Dr, Hills',
    phone: '345-678-9012',
    email: 'info@mountainviewlodge.com',
    assets: [
      { image_url: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb', position: 1 },
      { image_url: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa', position: 2 },
      { image_url: 'https://images.unsplash.com/photo-1566073771259-6a8506099945', position: 3 }
    ]
  }
]

hotels.each do |hotel_data|
  assets = hotel_data.delete(:assets)
  hotel = Hotel.create!(hotel_data)

  # Create assets for the hotel
  assets.each do |asset_data|
    image_url = asset_data.delete(:image_url)
    asset = hotel.assets.create!(asset_data)
    
    # Download and attach the image
    begin
      image = URI.open(image_url)
      asset.image.attach(io: image, filename: "hotel_#{hotel.id}_#{asset.position}.jpg")
    rescue => e
      puts "Error attaching image for hotel #{hotel.id}: #{e.message}"
    end
  end

  # Create rooms for each hotel
  room_types.each do |room_type|
    3.times do |i|
      room = hotel.rooms.create!(
        room_type: room_type,
        number: "#{room_type[:name][0]}#{i + 1}",
        capacity: rand(2..4),
        price_per_night: rand(100..500),
        description: "#{room_type[:name]} room #{i + 1}"
      )

      # Create assets for the room
      2.times do |j|
        asset = room.assets.create!(position: j + 1)
        begin
          image_url = "https://images.unsplash.com/photo-#{rand(10000000000000000..99999999999999999)}"
          image = URI.open(image_url)
          asset.image.attach(io: image, filename: "room_#{room.id}_#{j + 1}.jpg")
        rescue => e
          puts "Error attaching image for room #{room.id}: #{e.message}"
        end
      end
    end
  end
end
