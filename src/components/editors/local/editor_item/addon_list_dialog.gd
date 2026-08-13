class_name AddonListDialog
extends AcceptDialog


@onready var _tree: Tree = $Tree

enum Buttons {
	UNINSTALL,
}

var _version: String = ""
var _is_mono: bool = false


func raise(editor: LocalEditors.Item) -> void:
	var parsed := VersionHint.parse(editor.version_hint)
	if not parsed.is_valid or parsed.minor_version.is_empty():
		title = tr("Addons")
		_clear_tree()
		_tree.create_item()
		var empty := _tree.create_item()
		empty.set_text(0, tr("Could not resolve Godot version for this editor."))
		popup_centered()
		return

	_version = parsed.minor_version
	_is_mono = parsed.is_mono
	_refresh_list()
	title = tr("Addons for Godot %s%s") % [
		_version,
		" (mono)" if _is_mono else ""
	]
	popup_centered()


func _ready() -> void:
	min_size = Vector2(350, 350) * Config.EDSCALE
	visibility_changed.connect(func() -> void:
		if not visible:
			queue_free()
	)

	_tree.button_clicked.connect(func(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
		if id != Buttons.UNINSTALL:
			return
		var addon_folder: String = item.get_metadata(0)
		var confirm := ConfirmationDialogAutoFree.new()
		confirm.dialog_text = tr("Uninstall addon \"%s\"?\nThis removes it for all editors on Godot %s%s.") % [
			addon_folder,
			_version,
			" (mono)" if _is_mono else ""
		]
		add_child(confirm)
		confirm.confirmed.connect(func() -> void:
			var err := Config.uninstall_addon(_version, addon_folder, _is_mono)
			if err != OK:
				Output.push("Failed to uninstall addon '%s': %s" % [addon_folder, error_string(err)])
			_refresh_list()
		)
		confirm.popup_centered()
	)

	_tree.create_item()
	_tree.hide_root = true


func _clear_tree() -> void:
	_tree.clear()
	_tree.create_item()
	_tree.hide_root = true


func _refresh_list() -> void:
	_clear_tree()
	var addons := Config.list_installed_addons(_version, _is_mono)
	if addons.is_empty():
		var empty := _tree.create_item()
		empty.set_text(0, tr("No addons installed."))
		return

	for addon_folder in addons:
		var item := _tree.create_item()
		item.set_text(0, addon_folder)
		item.set_metadata(0, addon_folder)
		item.add_button(
			0,
			get_theme_icon("Remove", "EditorIcons"),
			Buttons.UNINSTALL,
			false,
			tr("Uninstall")
		)
