extends CanvasLayer

export(Resource) var ink_script
export(int) var print_speed = 20

var orange_voice
var green_voice
var blue_voice
var narrator_voice

var target_text = ""
var index = 0
var time_since_last = 0.0
var voice

# Called when the node enters the scene tree for the first time.
func _ready():
	# set up FMOD
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	
	# load banks
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Master.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Master.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Voices.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)

	# register listener
	Fmod.add_listener(0, self)
	
	# register voices
	orange_voice = Fmod.create_event_instance("event:/Voices/Orange")
	green_voice = Fmod.create_event_instance("event:/Voices/Green")
	blue_voice = Fmod.create_event_instance("event:/Voices/Blue")
	narrator_voice = Fmod.create_event_instance("event:/Voices/Narrator")
	
	# Register Ink story
	$Ink.InkFile = ink_script
	$Ink.LoadStory()
	$Ink.Continue()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Dialogue.bbcode_text.length() == target_text.length():
		if Fmod.get_event_playback_state(voice) == 0:
			Fmod.stop_event(voice, Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		return
	if time_since_last > 1.0 / print_speed:
		index += 1
		$Dialogue.bbcode_text = target_text.left(index)
		time_since_last = 0.0
	time_since_last += delta


func _on_Ink_InkChoices(choices):
	$Choices.clear()
	for choice in choices:
		$Choices.add_item("> " + choice)


func _on_Ink_InkContinued(text, tags):
	var speaker = ""
	if tags and tags[0] == "orange":
		voice = orange_voice
		speaker = "[color=#FF8C00][i]Orange[/i][/color]\n"
	elif tags and tags[0] == "green":
		voice = green_voice
		speaker = "[color=green][i]Green[/i][/color]\n"
	elif tags and tags[0] == "blue":
		voice = blue_voice
		speaker = "[color=blue][i]Blue[/i][/color]\n"
	else:
		voice = narrator_voice
		speaker = "\n"
	index = speaker.length()
	target_text = speaker + text
	print(target_text)
	time_since_last = 0.0
	Fmod.start_event(voice)


func _on_Dialogue_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			if $Dialogue.bbcode_text.length() < target_text.length():
				$Dialogue.bbcode_text = target_text
				return
			Fmod.stop_event(voice, Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
			$Ink.Continue()


func _on_Choices_item_selected(index):
	$Ink.ChooseChoiceIndexAndContinue(index)
	$Choices.clear()
