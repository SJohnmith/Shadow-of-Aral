extends Camera2D

@onready var camera := $"."

const VIEW_ZONE: int = 60
var target: Vector2
var zoom_min: Vector2 = Vector2(0.5, 0.5)
var zoom_max: Vector2 = Vector2(1, 1)
var zoom_speed: Vector2 = Vector2(0.05, 0.05)

func _input(event: InputEvent) -> void:
     # Shift the Camera Towards Mouse
     if event is InputEventMouseMotion:
          target = event.position - get_viewport().size*0.5
          if target.length() < VIEW_ZONE:
               self.position = Vector2(0, 0)
          else:
               self.position = target.normalized() * (target.length() - VIEW_ZONE)*0.5
               
     # Zooming In and Out the Camera
     if event is InputEventMouseButton:
          if event.is_pressed():
               if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
                    if camera.zoom > zoom_min:
                         camera.zoom -= zoom_speed
               if event.button_index == MOUSE_BUTTON_WHEEL_UP:
                    if camera.zoom < zoom_max:
                         camera.zoom += zoom_speed
