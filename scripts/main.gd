extends Node2D

export(Array, String, FILE, "*.tscn") var levels
export(Array, String, FILE, "*.ink") var dialogue_files

var level_instance
var current_level = 0
var current_dialogue = 0
var music_instance
var music_intensity = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	# set up FMOD
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	
	# load banks
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Master.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Master.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Voices.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Music.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/audio/Banks/Desktop/SFX.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)

	# register listener
	Fmod.add_listener(0, self)
	
	music_instance = Fmod.create_event_instance("event:/Music/Act 1")
	Fmod.start_event(music_instance)
	
	next_level()
	


func next_level():
	if level_instance:
		level_instance.queue_free()
		
	level_instance = load(levels[current_level]).instance()
	level_instance.connect("finished", self, "next_level")
	
	if levels[current_level] == "res://scenes/Dialogue.tscn":
		level_instance.ink_script = load(dialogue_files[current_dialogue])
		current_dialogue += 1
		Fmod.set_event_parameter_by_name(music_instance, "Dialogue", 1)
	else:
		music_intensity += 1
		Fmod.set_event_parameter_by_name(music_instance, "Dialogue", 0)
		Fmod.set_event_parameter_by_name(music_instance, "Intensity", music_intensity)
		
	add_child(level_instance)
	
	current_level += 1
