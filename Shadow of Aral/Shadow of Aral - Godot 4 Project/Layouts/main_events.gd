# Global Event
extends Node2D

# List of Objects to Reference
var bullet_scene: PackedScene = preload("res://Object Types/Main Assets/Bullet/bullet.tscn")
var player_scene: PackedScene = preload("res://Object Types/Main Assets/Player/player.tscn")

var player_exists: bool = true # Need to somehow update this

# Connect
func _ready():
     EventBus.wpn_shoot_bullets.connect(_on_player_open_fire)
     EventBus.ui_update.connect(_update_ui_elements)
 
func _process(_delta):
     # DEBUG: For this purpose use Space Bar to Trigger Player Respawn
     if Input.is_key_pressed(KEY_SPACE):
          respawn_player()
     
# Player Fires Spawn Bullets
func _on_player_open_fire(muzzle_pos, muzzle_drctn):
     var bullet_instance = bullet_scene.instantiate() as Area2D
     $Projectiles.add_child(bullet_instance)
     bullet_instance.position = muzzle_pos
     bullet_instance.rotation = muzzle_drctn.angle()
     bullet_instance.direction = muzzle_drctn

# Update UI Elements
func _update_ui_elements():
     # This is Good for Testing
     $UI.update_bullet_text()

# Respawn Player
func respawn_player():
     # DEBUG: This is player dependent
#     if player_exists:
#          print("Player Alive")
     if !player_exists:
#          print("Player can Respawn")
          player_exists = true
          
          var spwn_player = player_scene.instantiate()
          $".".add_child(spwn_player)
          spwn_player.position = $SpawnPoint.position
