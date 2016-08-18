extends KinematicBody

const MOVE_SPEED = 4.0;
const MAX_SPEED = 15.0;
const GRAVITY_ACCEL = -9.8;
const MAX_SLOPE_ANGLE = 30;

var target_x = 0.0;
var vel = Vector3();
var cur_speed = 0.0;
var particle = null;
var animation = null;
var sfx = null;
var dying = false;
var touch_dragging;

func _ready():
	particle = get_node("particle");
	animation = get_node("pikachu/AnimationPlayer");
	sfx = get_node("sfx");
	
	target_x = get_translation().x;
	cur_speed = MOVE_SPEED;
	dying = false;
	touch_dragging = false;
	
	set_fixed_process(true);
	set_process_input(true);

func _fixed_process(delta):
	var pos = get_translation();
	var diff = target_x-pos.x;
	vel.x = diff*5;
	vel.y += GRAVITY_ACCEL*delta;
	vel.z = -cur_speed;
	
	cur_speed = clamp(cur_speed+0.2*delta, MOVE_SPEED, MAX_SPEED);
	
	if dying:
		vel.x *= 0.0;
		vel.z *= 0.0;
	
	var motion = move(vel*delta);
	
	var on_floor = false;
	var original_vel = vel;
	var floor_velocity = Vector3();
	var attempts = 4;
	
	while(is_colliding() and attempts):
		var n = get_collision_normal();
		var collider = get_collider();
		
		if collider extends StaticBody && collider in get_tree().get_nodes_in_group("obstacle"):
			dying = true;
			pika_hit();
			get_node("/root/game").game_over();
		
		if (rad2deg(acos(n.dot(Vector3(0, 1, 0)))) < MAX_SLOPE_ANGLE):
				# If angle to the "up" vectors is < angle tolerance,
				# char is on floor
				floor_velocity = get_collider_velocity()
				on_floor = true
			
		motion = n.slide(motion)
		vel = n.slide(vel)
		if (original_vel.dot(vel) > 0):
			# Do not allow to slide towads the opposite direction we were coming from
			motion=move(motion)
			if (motion.length() < 0.001):
				break
		attempts -= 1
	
	if Input.is_key_pressed(KEY_UP) && on_floor && !dying:
		vel.y = 4.0;
	
	if dying:
		set_animation("dying");
	elif vel.length() > 0.1:
		set_animation("walk", clamp(cur_speed/MOVE_SPEED, 0.0, 1.8));
	else:
		set_animation("idle");
	
	if on_floor && !particle.is_emitting() && !dying:
		particle.set_emitting(true);
	if (!on_floor || dying) && particle.is_emitting():
		particle.set_emitting(false);

func _input(ie):
	if ie.type == InputEvent.KEY && ie.pressed:
		if ie.scancode == KEY_LEFT:
			target_x = clamp(target_x-1, -1.0, 1.0);
		if ie.scancode == KEY_RIGHT:
			target_x = clamp(target_x+1, -1.0, 1.0);
	
	if ie.type == InputEvent.SCREEN_TOUCH:
		if ie.pressed && !touch_dragging:
			touch_dragging = true;
		if !ie.pressed && touch_dragging:
			touch_dragging = false;
	
	if ie.type == InputEvent.SCREEN_DRAG:
		if touch_dragging:
			if ie.relative_x < -10:
				target_x = clamp(target_x-1, -1.0, 1.0);
				touch_dragging = false;
			if ie.relative_x > 10:
				target_x = clamp(target_x+1, -1.0, 1.0);
				touch_dragging = false;

func set_animation(ani, speed = 1.0, force = false):
	if animation.get_current_animation() != ani || force:
		animation.play(ani);
	if animation.get_speed() != speed || force:
		animation.set_speed(speed);

func candy_collected():
	sfx.play("sound_coin");

func pika_hit():
	sfx.play("sound_hit");
