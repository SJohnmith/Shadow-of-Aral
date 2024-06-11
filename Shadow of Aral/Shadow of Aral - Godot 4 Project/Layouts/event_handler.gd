# Global Event
extends Node2D

# List of Objects to Reference
var bullet_scene: PackedScene = preload("res://Object Types/Main Assets/Bullet/bullet.tscn")

func _ready():
     EventBus.glob_signal.connect(_on_player_open_fire)
     
# Player Fires Spawn Bullets
func _on_player_open_fire(muzzle_pos, muzzle_drctn):
     var bullet_instance = bullet_scene.instantiate() as Area2D
     $Projectiles.add_child(bullet_instance)
     bullet_instance.position = muzzle_pos
     bullet_instance.rotation = muzzle_drctn.angle()
     bullet_instance.direction = muzzle_drctn
     
     # For Testing Purposes
     $UI.update_bullet_text()
