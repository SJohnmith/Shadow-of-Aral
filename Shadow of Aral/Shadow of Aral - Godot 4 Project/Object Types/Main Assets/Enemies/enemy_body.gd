extends Character_Body

# Load Character Texture
func _ready():
     $BackArm.texture = character_texture
     
func _process(_delta):
     # Set rotation of the arms to player (target) position
     front_arm.look_at(get_owner().player.position)
     
