class_name ProjectGlobalAddonsDialog
extends AcceptDialog


@onready var _tree: Tree = $Tree

var _project: Projects.Item
var _version: String = ""
var _is_mono: bool = false
var _updating_checks := false


func raise(project: Projects.Item) -> void:
	_project = project
	var resolved := _resolve_version(project)
	if not resolved.ok:
		title = tr("Global Addons")
		_clear_tree()
		_tree.create_item()
		var empty := _tree.create_item()
		empty.set_text(0, tr("Could not resolve Godot version for this project. Bind an editor first."))
		popup_centered()
		return

	_version = resolved.version
	_is_mono = resolved.is_mono
	_refresh_list()
	title = tr("Global Addons for Godot %s%s") % [
		_version,
		" (mono)" if _is_mono else ""
	]
	popup_centered()


func _ready() -> void:
	min_size = Vector2(400, 350) * Config.EDSCALE
	visibility_changed.connect(func() -> void:
		if not visible:
			queue_free()
	)

	_tree.item_edited.connect(_on_item_edited)
	_tree.create_item()
	_tree.hide_root = true
	_tree.columns = 1


func _resolve_version(project: Projects.Item) -> Dictionary:
	var hint := ""
	if not project.has_invalid_editor and project.editor != null:
		hint = project.editor.version_hint
	elif project.has_version_hint:
		hint = project.version_hint
	var parsed := VersionHint.parse(hint)
	if not parsed.is_valid or parsed.minor_version.is_empty():
		return {"ok": false, "version": "", "is_mono": false}
	return {
		"ok": true,
		"version": parsed.minor_version,
		"is_mono": parsed.is_mono
	}


func _clear_tree() -> void:
	_tree.clear()
	_tree.create_item()
	_tree.hide_root = true


func _refresh_list() -> void:
	_updating_checks = true
	_clear_tree()
	var addons := Config.list_installed_addons(_version, _is_mono)
	if addons.is_empty():
		var empty := _tree.create_item()
		empty.set_text(0, tr("No global addons installed for this version."))
		_updating_checks = false
		return

	for addon_folder in addons:
		var item := _tree.create_item()
		item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		item.set_editable(0, true)
		item.set_text(0, addon_folder)
		item.set_metadata(0, addon_folder)
		var enabled := Config.is_global_addon_enabled_for_project(
			_project.path,
			addon_folder
		)
		item.set_checked(0, enabled)
	_updating_checks = false


func _on_item_edited() -> void:
	if _updating_checks or _project == null:
		return
	var item := _tree.get_edited()
	if item == null:
		return
	var addon_folder: String = item.get_metadata(0)
	if addon_folder.is_empty():
		return
	var enabled := item.is_checked(0)
	var err: Error
	if enabled:
		err = Config.enable_global_addon_for_project(
			_project.path,
			_version,
			addon_folder,
			_is_mono
		)
		if err != OK:
			Output.push("Failed to enable addon '%s': %s" % [addon_folder, error_string(err)])
			_updating_checks = true
			item.set_checked(0, false)
			_updating_checks = false
	else:
		err = Config.disable_global_addon_for_project(_project.path, addon_folder)
		if err == ERR_ALREADY_EXISTS:
			var notice := AcceptDialog.new()
			notice.dialog_text = tr(
				"\"%s\" exists in the project addons folder but is not a Godots-managed link.\nDisable skipped to avoid deleting local files."
			) % addon_folder
			add_child(notice)
			notice.confirmed.connect(notice.queue_free)
			notice.canceled.connect(notice.queue_free)
			notice.popup_centered()
			_updating_checks = true
			item.set_checked(0, true)
			_updating_checks = false
		elif err != OK:
			Output.push("Failed to disable addon '%s': %s" % [addon_folder, error_string(err)])
			_updating_checks = true
			item.set_checked(0, true)
			_updating_checks = false
