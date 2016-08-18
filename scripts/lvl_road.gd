extends Spatial

var pfb_candy;
var pfb_stone;

func _ready():
	pfb_candy = load("res://prefabs/candy.tscn");
	pfb_stone = load("res://prefabs/stone.tscn");
	
	generate_candy();
	generate_barricade();

func generate_candy():
	if rand_range(0, 10) < 5:
		return;
	
	var start_pos = Vector3(0, 0.2, 0);
	if rand_range(0, 10) > 5:
		start_pos.x -= 1;
	elif rand_range(0, 10) > 5:
		start_pos.x += 1;
	
	for i in range(rand_range(1,6)):
		var inst = pfb_candy.instance();
		inst.set_translation(start_pos);
		add_child(inst);
		start_pos.z -= 2;

func generate_barricade():
	if rand_range(0, 10) < 5:
		return;
	
	var pos = Vector3();
	if rand_range(0, 10) > 5:
		pos.x -= 1;
	elif rand_range(0, 10) > 5:
		pos.x += 1;
	pos.z += rand_range(-4, 4);
	
	var inst = pfb_stone.instance();
	inst.add_to_group("obstacle");
	inst.set_translation(pos);
	inst.set_scale(Vector3(1,1,1)*rand_range(0.7, 0.9));
	inst.set_rotation(Vector3(0, deg2rad(rand_range(0, 360)), 0));
	add_child(inst);
