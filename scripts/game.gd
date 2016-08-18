extends Node

var candies;
var panel_gameover;
var sample_player;
var player;

func _init():
	randomize();

func _ready():
	OS.set_target_fps(30.0);
	
	candies = 0;
	panel_gameover = get_node("gui/panel_gameover");
	panel_gameover.hide();
	panel_gameover.get_node("btnRestart").connect("pressed", self, "restart_game");
	panel_gameover.get_node("btnQuit").connect("pressed", self, "quit_game");
	
	sample_player = get_node("music");
	sample_player.play();
	
	player = get_node("env/pikachu");

func add_candy():
	candies += 1;
	
	get_node("gui/lblScore").set_text(str(candies));

func game_over():
	sample_player.stop();
	panel_gameover.get_node("AnimationPlayer").play("fade_in");

func restart_game():
	get_tree().reload_current_scene();

func quit_game():
	get_tree().quit();
