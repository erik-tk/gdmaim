@tool
extends Panel

@export var code_edit : CodeEdit

var _search_results : Array[Vector2i]
var _cur_search_result : int = 0


func _ready() -> void:
	if _should_use_editor_icons():
		_update_icons()
		theme_changed.connect(_update_icons)


func is_search_focused() -> bool:
	return $VBoxContainer/Search.has_focus()


func open() -> void:
	if code_edit.get_selected_text():
		$VBoxContainer/Search.text = code_edit.get_selected_text()
	_update_search()
	
	show()
	$VBoxContainer/Search.grab_focus()


func close() -> void:
	hide()
	code_edit.grab_focus()
	code_edit.set_search_text("")
	code_edit.queue_redraw()


func _update_search(new_text : String = "") -> void:
	var updated_text : String = $VBoxContainer/Search.text
	
	var flags : int = (
		TextEdit.SEARCH_MATCH_CASE * int($VBoxContainer/MatchCase.button_pressed) +
		TextEdit.SEARCH_WHOLE_WORDS * int($VBoxContainer/WholeWords.button_pressed))
	
	code_edit.set_search_text(updated_text)
	code_edit.set_search_flags(flags)
	code_edit.queue_redraw()
	
	_search_results.clear()
	_cur_search_result = 0
	var result : Vector2i = code_edit.search(updated_text, flags, 0, 0)
	while result.x != -1:
		_search_results.append(result)
		if result.y + 1 == code_edit.get_line_count():
			break
		result = code_edit.search(updated_text, flags, result.y + 1, 0)
		if _search_results.has(result):
			break
	
	_update_matches()


func _update_matches() -> void:
	$VBoxContainer/Matches.modulate = Color.WHITE
	if !$VBoxContainer/Search.text:
		$VBoxContainer/Matches.text = ""
	elif !_search_results:
		$VBoxContainer/Matches.text = "No match"
		$VBoxContainer/Matches.modulate = Color.SALMON
	else:
		_cur_search_result = posmod(_cur_search_result, _search_results.size())
		$VBoxContainer/Matches.text = str(_cur_search_result + 1) + " of " + str(_search_results.size()) + " matches"
		code_edit.set_caret_line(_search_results[_cur_search_result].y)
		code_edit.set_caret_column(_search_results[_cur_search_result].x)


func _on_search_text_submitted(new_text : String) -> void:
	_cur_search_result += 1
	_update_matches()


func _on_previous_pressed() -> void:
	_cur_search_result -= 1
	_update_matches()


func _on_next_pressed() -> void:
	_cur_search_result += 1
	_update_matches()


func _should_use_editor_icons() -> bool:
	# Only in the editor, and not while editing code_search.tscn itself
	# (otherwise the icons get baked into the scene file on save).
	return Engine.is_editor_hint() and get_tree().edited_scene_root != self


func _update_icons() -> void:
	var theme : Theme = EditorInterface.get_editor_theme()
	$VBoxContainer/Previous.icon = theme.get_icon("MoveUp", "EditorIcons")
	$VBoxContainer/Next.icon = theme.get_icon("MoveDown", "EditorIcons")
	$VBoxContainer/Close.icon = theme.get_icon("Close", "EditorIcons")
	$VBoxContainer/Previous.text = ""
	$VBoxContainer/Next.text = ""
	$VBoxContainer/Close.text = ""
