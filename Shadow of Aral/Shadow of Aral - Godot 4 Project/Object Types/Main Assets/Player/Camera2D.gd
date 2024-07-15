extends Camera2D

const VIEW_ZONE: int = 60
var target: Vector2

func _input(event: InputEvent) -> void:
     if event is InputEventMouseMotion:
          target = event.position - get_viewport().size*0.5
          if target.length() < VIEW_ZONE:
               self.position = Vector2(0, 0)
          else:
               self.position = target.normalized() * (target.length() - VIEW_ZONE)*0.5
