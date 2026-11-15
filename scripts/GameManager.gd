extends Node2D

const SPIKE_TEXTURE = preload("res://sprites/spike.svg")
const FINISH_TEXTURE = preload("res://sprites/flag.png")

var spikes = []

@export var spike_positions: Array[Vector2i]
@export var finish_location: Vector2i
@export var next_level: PackedScene

var finish_collider: CollisionShape2D = null
var finish_line: Sprite2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var spike_positions = [
	#	Vector2i(16, -2),
	#	Vector2i(39, -1)
	#]
	
	for spike_pos: Vector2i in spike_positions:
		var spike: Sprite2D = Sprite2D.new()
		spike.texture = SPIKE_TEXTURE
		spike.position = $TileMapLayer.to_global($TileMapLayer.map_to_local(spike_pos))
		
		var spike_collider: CollisionShape2D = CollisionShape2D.new()
		
		var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
		rectangle_shape.size = Vector2(50, 50)
		spike_collider.shape = rectangle_shape
		
		spike_collider.name = StringName("CollisionShape2D")
		spike.add_child(spike_collider)
		
		spikes.push_back(spike)
		add_child(spike)
		
	finish_line = Sprite2D.new()
	finish_line.texture = FINISH_TEXTURE
	finish_line.position = $TileMapLayer.to_global($TileMapLayer.map_to_local(finish_location))
	finish_line.scale = Vector2(4, 4)
	
	finish_collider = CollisionShape2D.new()
	
	var finish_shape: RectangleShape2D = RectangleShape2D.new()
	finish_shape.size = Vector2(50, 50)
	finish_collider.shape = finish_shape
	
	finish_collider.name = StringName("CollisionShape2D")
	finish_line.add_child(finish_collider)
	
	add_child(finish_line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player: Shape2D = $Player/CollisionShape2D.shape
	for spike: Sprite2D in spikes:
		var collider: CollisionShape2D = spike.get_node("CollisionShape2D")
		if(player.collide($Player.global_transform, collider.shape, spike.global_transform)):
			$Player.reset()
			
	if finish_collider and player.collide($Player.global_transform, finish_collider.shape, finish_line.global_transform):
		get_tree().change_scene_to_packed(next_level)
