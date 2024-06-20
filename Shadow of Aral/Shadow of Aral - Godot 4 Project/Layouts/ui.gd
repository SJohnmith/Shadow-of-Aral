extends CanvasLayer

@onready var bullet_label: Label = $Label

func update_bullet_text():
     bullet_label.text = "Ammo: " + str(Globals.bullets)
