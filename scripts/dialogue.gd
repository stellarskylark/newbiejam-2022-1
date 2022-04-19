extends CanvasLayer

export(Resource) var ink_script
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Ink.InkFile = ink_script
	$Ink.LoadStory()
	$Ink.Continue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ink_InkChoices(choices):
	$Choices.clear()
	for choice in choices:
		$Choices.add_item("> " + choice)


func _on_Ink_InkContinued(text, tags):
	var speaker = ""
	if tags and tags[0] == "yellow":
		speaker = "[color=yellow][i]Yellow[/i][/color]\n"
	$Dialogue.bbcode_text = speaker + text


func _on_Dialogue_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			$Ink.Continue()


func _on_Choices_item_selected(index):
	$Ink.ChooseChoiceIndexAndContinue(index)
	$Choices.clear()
