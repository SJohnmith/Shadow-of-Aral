extends Character_Body

#func _ready():
#     print(get_owner().player)

func _process(_delta):
     # Set rotation of the arms to player (target) position
     front_arm.look_at(get_owner().player.position)
