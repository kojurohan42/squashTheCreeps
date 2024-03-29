extends Node

export (PackedScene) var mob_scene


func _ready():
	$UserInterface/Retry.hide()
	randomize()


func _on_MobTimer_timeout():
	var mob = mob_scene.instance()

	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()
	var player_position = $Player.transform.origin
	mob.initialize(mob_spawn_location.translation, player_position)

	add_child(mob)
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
	

func _on_Player_hit():
	$MobTimer.stop() # Replace with function body.
	$UserInterface/Retry.show()
