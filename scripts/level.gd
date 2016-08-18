extends Spatial

var pfb_road;

var trigger_obj;
var trigger_pos;
var next_pos;

func _ready():
	pfb_road = load("res://prefabs/lvl_road.tscn");
	
	next_pos = Vector3();
	
	for i in range(5):
		generate_world();
	
	trigger_obj = get_node("../pikachu");
	trigger_pos = Vector3(0,0,-10.0);
	
	set_fixed_process(true);

func _fixed_process(delta):
	if trigger_obj == null:
		return;
	
	var pos = trigger_obj.get_translation();
	if pos.z > trigger_pos.z:
		return;
	
	generate_world();
	trigger_pos.z -= 10.0;

func generate_world():
	if get_child_count() >= 5:
		remove_child(get_child(0));
	
	var inst = pfb_road.instance();
	inst.set_translation(next_pos);
	add_child(inst, true);
	
	next_pos -= Vector3(0, 0, 10.0);
