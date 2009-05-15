require 'StatePlaneConverter'
require "test/unit"


class GraphTest < Test::Unit::TestCase


  def test_one

    items = [
             {
               :x => 1308514,
               :y => 246653,
               :latitude => 47.66822519,
               :longitude => -122.18045169
             },
             {
               :x => 1276381,
               :y => 280211,
               :latitude => 47.75859017,
               :longitude => -122.31346096
             },
             {
               :x => 1301704,
               :y => 231975,
               :latitude => 47.62766192,
               :longitude => -122.20702283
             },
             {
               :x => 1269482,
               :y => 286089,
               :latitude => 47.77433425,
               :longitude => -122.34197285
             },
             {
               :x => 1276189,
               :y => 290050,
               :latitude => 47.78554836,
               :longitude => -122.31501155
             },
             {
               :x => 1300858,
               :y => 178924,
               :latitude => 47.48220485,
               :longitude => -122.20661416
             }
    ]

    spc = StatePlaneConverter.new
        
    items.each do |i|
      print "Converting x: #{i[:x]} y: #{i[:y]} => "
      lat, long = spc.to_lat_long(i[:x], i[:y])
      puts " Lat: #{lat} Long: #{long}"
      assert_in_delta(i[:latitude], lat, 0.00000001)
      assert_in_delta(i[:longitude], long, 0.00000001)
    end
    
  end
  
end