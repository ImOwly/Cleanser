extends RigidBody2D
var lifetime = .7
@onready var tile_map = get_tree().get_root().get_node("World").get_node("TileMap")
var colors = [Color(0.0, 255.0, 255.0, 1.0), 
			Color("06c3dd", 1.0), 
			Color("24909f", 1.0),
			Color("5e23dc", 1.0)]

func _ready():
	randomize()
	modulate = colors[randi() % colors.size()]
	await get_tree().create_timer(lifetime).timeout
	#print(position)
	
	queue_free()
func _physics_process(delta):
	if(tile_map == null):
		print("it null")
	var tilePos = tile_map.local_to_map(position)
	var data = tile_map.get_cell_tile_data(0, tilePos)
	var current_Atlas_Id = tile_map.get_cell_atlas_coords(0, tilePos)
	if(data):
		match current_Atlas_Id:
			Vector2i(0,1):
				var atlasCord : Vector2i = Vector2i(0, 0)
				tile_map.set_cell(0, tilePos, 0, atlasCord)
			Vector2i(5,4):
				var atlasCord : Vector2i = Vector2i(5, 0)
				tile_map.set_cell(0, tilePos, 0, atlasCord)
			Vector2i(4,1):
				var atlasCord : Vector2i = Vector2i(4, 0)
				tile_map.set_cell(0, tilePos, 0, atlasCord)
			Vector2i(2,1):
				var atlasCord : Vector2i = Vector2i(2, 0)
				tile_map.set_cell(0, tilePos, 0, atlasCord)
			Vector2i(3,1):
				var atlasCord : Vector2i = Vector2i(3, 0)
				tile_map.set_cell(0, tilePos, 0, atlasCord)
			Vector2i(1,1):
				var atlasCord : Vector2i = Vector2i(1, 0)
				tile_map.set_cell(0, tilePos, 0, atlasCord)
			Vector2i(8,4):
				var atlasCord : Vector2i = Vector2i(8, 0)
				tile_map.set_cell(0, tilePos, 0, atlasCord)

	pass
