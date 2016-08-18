extends Area

func _ready():
	connect("body_enter", self, "on_body_enter");

func on_body_enter(body):
	if body extends preload("res://scripts/pikachu.gd"):
		get_node("/root/game").add_candy();
		body.candy_collected();
	
	queue_free();
