extends CanvasLayer

export(Resource) var ink_script
export(int) var print_speed = 20

var target_text = ""
var index = 0
var time_since_last = 0.0
var voice = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ink.InkFile = ink_script
	$Ink.LoadStory()
	$Ink.Continue()
	
	# set up FMOD
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	
	# load banks
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Master.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Master.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/audio/Banks/Desktop/Dialogue.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)

	# register listener
	Fmod.add_listener(0, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Dialogue.bbcode_text.length() == target_text.length():
		return
	if time_since_last > 1.0 / print_speed:
		index += 1
		$Dialogue.bbcode_text = target_text.left(index)
		time_since_last = 0.0
		Fmod.play_one_shot("event:/Voices/%s" % voice, self)
	time_since_last += delta


func _on_Ink_InkChoices(choices):
	$Choices.clear()
	for choice in choices:
		$Choices.add_item("> " + choice)


func _on_Ink_InkContinued(text, tags):
	var speaker = ""
	if tags and tags[0] == "yellow":
		voice = "Narrator" # TODO: Make Yellow voice and update tthis value
		speaker = "[color=yellow][i]Yellow[/i][/color]\n"
	else:
		voice = "Narrator"
		speaker = "\n"
	index = speaker.length()
	target_text = speaker + text
	print(target_text)
	time_since_last = 0.0


func _on_Dialogue_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			if $Dialogue.bbcode_text.length() < target_text.length():
				$Dialogue.bbcode_text = target_text
				return
			$Ink.Continue()


func _on_Choices_item_selected(index):
	$Ink.ChooseChoiceIndexAndContinue(index)
	$Choices.clear()
