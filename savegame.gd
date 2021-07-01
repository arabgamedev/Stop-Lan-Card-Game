extends Node
#var savegame = File.new() 
var settings_file:File=File.new()
var settings_path="user://stop_settings.sav"
#var save_path = "user://game.sav"


var settings0:Dictionary={
	"first_time":true,
	"nickname":"player",
}
var settings:Dictionary

func _ready():
	if not settings_file.file_exists(settings_path):
		settings=settings0.duplicate(true)
		save_settings()
	else:
		# if exist load data to settings dict
		load_settings()

func load_settings():
	settings_file.open(settings_path, File.READ) 
	settings = parse_json(settings_file.get_as_text())
	settings_file.close()
	

func save_settings():
	settings_file.open(settings_path, File.WRITE) 
	settings_file.store_string(to_json(settings))
	settings_file.close()
