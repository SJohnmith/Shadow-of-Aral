extends Character_Body

# Load Character Texture
func _ready():
     $BackArm.texture = character_texture
     
func _process(_delta):
     # Set rotation of the arms to player (target) position
#     front_arm.look_at(get_owner().player.position)
     
     # Arms Point in the Direction of Movement
     if $"..".current_state == "idle":
          pass
#          front_arm.look_at(get_owner().player.position)

     # Arms Point in the Direction of Player
     elif $"..".current_state =="attack":
#          print(get_owner().player)
          if is_instance_valid(get_owner().player):
               front_arm.look_at(get_owner().player.position)
          else:
               front_arm.look_at(Vector2.ZERO)
     
