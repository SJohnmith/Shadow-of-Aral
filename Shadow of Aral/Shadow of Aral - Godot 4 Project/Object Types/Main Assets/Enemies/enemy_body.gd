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
          front_arm.look_at(get_owner().player.position)
     
