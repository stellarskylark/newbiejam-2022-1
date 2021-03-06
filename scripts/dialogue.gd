extends CanvasLayer

signal finished

export(Resource) var ink_script
export(int) var print_speed = 20
export(StreamTexture) var orange_icon
export(StreamTexture) var blue_icon
export(StreamTexture) var green_icon
export(StreamTexture) var player_icon

var orange_voice
var green_voice
var blue_voice
var narrator_voice

var target_text = ""
var index = 0
var time_since_last = 0.0
var voice

var begun = false
var done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# register voices
	orange_voice = Fmod.create_event_instance("event:/Voices/Orange")
	green_voice = Fmod.create_event_instance("event:/Voices/Green")
	blue_voice = Fmod.create_event_instance("event:/Voices/Blue")
	narrator_voice = Fmod.create_event_instance("event:/Voices/Narrator")
	
	# Register Ink story
	$Ink.InkFile = ink_script
	$Ink.LoadStory()
	
	
	$Choices.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not begun:
		return
	if Input.is_action_just_pressed("advance_dialogue"):
		if $DialogueBox/HSplitContainer/DialogueText.bbcode_text != target_text:
			$DialogueBox/HSplitContainer/DialogueText.bbcode_text = target_text
			Fmod.stop_event(voice, Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		else:
			$Ink.Continue()	
			if done:
				cleanup()
			
	if $DialogueBox/HSplitContainer/DialogueText.bbcode_text == target_text:
		if Fmod.get_event_playback_state(voice) == 0:
			Fmod.stop_event(voice, Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		return
	if time_since_last > 1.0 / print_speed:
		index += 1
		$DialogueBox/HSplitContainer/DialogueText.bbcode_text = target_text.left(index)
		time_since_last = 0.0
	time_since_last += delta


func _on_Ink_InkChoices(choices):
	$Choices.clear()
	for choice in choices:
		$Choices.add_item("> " + choice)


func _on_Ink_InkContinued(text, tags):
	var speaker = ""
	if "kill" in tags:
		var upgrade = File.new()
		upgrade.open("user://upgrade", File.WRITE)
		upgrade.store_line("1")
		upgrade.close()
		get_tree().quit()
	if tags and tags[0] == "orange":
		voice = orange_voice
		speaker = "[color=#FF8C00][i]Orange[/i][/color]\n"
		$DialogueBox.add_stylebox_override("panel", load("res://assets/themes/orange_box_style.tres"))
		$DialogueBox/HSplitContainer/SpeakerIcon.texture = orange_icon
	elif tags and tags[0] == "green":
		voice = green_voice
		speaker = "[color=green][i]Green[/i][/color]\n"
		$DialogueBox.add_stylebox_override("panel", load("res://assets/themes/green_box_style.tres"))
		$DialogueBox/HSplitContainer/SpeakerIcon.texture = green_icon
	elif tags and tags[0] == "blue":
		voice = blue_voice
		speaker = "[color=blue][i]Blue[/i][/color]\n"
		$DialogueBox.add_stylebox_override("panel", load("res://assets/themes/blue_box_style.tres"))
		$DialogueBox/HSplitContainer/SpeakerIcon.texture = blue_icon
	elif tags and tags[0] == "player":
		voice = narrator_voice
		speaker = "[i]You[/i]\n"
		$DialogueBox.add_stylebox_override("panel", load("res://assets/themes/standard_box_style.tres"))
		$DialogueBox/HSplitContainer/SpeakerIcon.texture = player_icon
	else:
		voice = narrator_voice
		speaker = "\n"
		$DialogueBox.add_stylebox_override("panel", load("res://assets/themes/standard_box_style.tres"))
		$DialogueBox/HSplitContainer/SpeakerIcon.texture = null
	index = speaker.length()
	target_text = speaker + text
	time_since_last = 0.0
	Fmod.start_event(voice)


func cleanup():
	Fmod.stop_event(orange_voice, Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	Fmod.stop_event(blue_voice, Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	Fmod.stop_event(green_voice, Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	Fmod.stop_event(narrator_voice, Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	
	Fmod.release_event(orange_voice)
	Fmod.release_event(blue_voice)
	Fmod.release_event(green_voice)
	Fmod.release_event(narrator_voice)
	
	emit_signal("finished")


func _on_Ink_InkEnded():
	done = true


func _on_Choices_item_activated(index):
	$Ink.ChooseChoiceIndex(index)
	$Choices.clear()


func _on_TransitionTimer_timeout():
	$Ink.Continue()
	begun = true
