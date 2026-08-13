extends Node


signal saved


var AUTO_EDSCALE := 1.
var EDSCALE := 1.
var AGENT := ""
const VERSION = "v1.4.2.stable"
const APP_CONFIG_PATH = "user://godots.cfg"
const EDITORS_CONFIG_PATH = "user://editors.cfg"
const PROJECTS_CONFIG_PATH = "user://projects.cfg"
const DEFAULT_VERSIONS_PATH = "user://versions"
const DEFAULT_DOWNLOADS_PATH = "user://downloads"
const DEFAULT_UPDATES_PATH = "user://updates"
const DEFAULT_CACHE_DIR_PATH = "user://cache"
const DEFAULT_ADDONS_PATH = "user://addons"
const RELEASES_URL = "https://github.com/MakovWait/godots/releases"
const RELEASES_LATEST_API_ENDPOINT = "https://api.github.com/repos/MakovWait/godots/releases/latest"
const RELEASES_API_ENDPOINT = "https://api.github.com/repos/MakovWait/godots/releases"

const _EDITOR_PROXY_SECTION_NAME = "theme"

var _random_project_names := RandomProjectNames.new()
var _cfg := ConfigFile.new()
var _cfg_auto_save := ConfigFileSaveOnSet.new(
	IConfigFileLike.of_config(_cfg), 
	APP_CONFIG_PATH, 
	func(err: Error) -> void:
		if err == OK:
			saved.emit() 
		pass\
)


var AGENT_HEADER: String:
	get: return "User-Agent: %s" % AGENT


var VERSIONS_PATH := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"versions_path",
	DEFAULT_VERSIONS_PATH
).map_return_value(_simplify_path): 
	set(_v): _readonly()


var DOWNLOADS_PATH := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"downloads_path",
	DEFAULT_DOWNLOADS_PATH
).map_return_value(_simplify_path): 
	set(_v): _readonly()


var CACHE_DIR_PATH := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"cache_dir_path",
	DEFAULT_CACHE_DIR_PATH
).map_return_value(_simplify_path): 
	set(_v): _readonly()


var UPDATES_PATH := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"updates_path",
	DEFAULT_UPDATES_PATH
).map_return_value(_simplify_path): 
	set(_v): _readonly()


var DEFAULT_PROJECTS_PATH := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"projects_path",
	OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
).map_return_value(_simplify_path): 
	set(_v): _readonly()


var LANGUAGE := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(),
	"app",
	"language",
	"en"
):
	set(_v): _readonly()


var SAVED_EDSCALE := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	_EDITOR_PROXY_SECTION_NAME, 
	"interface/editor/custom_display_scale"
): 
	set(_v): _readonly()


var DEFAULT_EDITOR_TAGS := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"default_editor_tags",
	["dev", "rc", "alpha", "4.x", "3.x", "stable", "mono"]
): 
	set(_v): _readonly()


var DEFAULT_PROJECT_TAGS := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"default_project_tags",
	[]
): 
	set(_v): _readonly()


var AUTO_CLOSE := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"auto_close",
	false
): 
	set(_v): _readonly()


var SHOW_ORPHAN_EDITOR := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"show_orphan_editor",
	false
): 
	set(_v): _readonly()


var USE_SYSTEM_TITLE_BAR := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"use_system_titlebar",
	false
): 
	set(_v): _readonly()


var USE_NATIVE_FILE_DIALOG := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(),
	"app",
	"use_native_file_dialog",
	false
):
	set(_v): _readonly()


var LAST_WINDOW_RECT := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"last_window_rect",
	Rect2i()
): 
	set(_v): _readonly()


var REMEMBER_WINDOW_SIZE := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"remember_window_size",
	false
): 
	set(_v): _readonly()


var ALLOW_INSTALL_TO_NOT_EMPTY_DIR := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"allow_install_to_not_empty_dir",
	false
): 
	set(_v): _readonly()


var ONLY_STABLE_UPDATES := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"only_stable_updates",
	true
): 
	set(_v): _readonly()


var RANDOM_PROJECT_PREFIXES := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"random-project-names", 
	"prefixes",
	[]
): 
	set(_v): _readonly()


var RANDOM_PROJECT_TOPICS := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"random-project-names", 
	"topics",
	[]
): 
	set(_v): _readonly()


var RANDOM_PROJECT_SUFFIXES := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"random-project-names", 
	"suffixes",
	[]
): 
	set(_v): _readonly()


var GLOBAL_CUSTOM_COMMANDS_PROJECTS := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"global-custom-commands-v2", 
	"projects",
	[]
): 
	set(_v): _readonly()


var GLOBAL_CUSTOM_COMMANDS_EDITORS := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"global-custom-commands-v2", 
	"editors",
	[]
): 
	set(_v): _readonly()


var HTTP_PROXY_HOST := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(),
	"network",
	"http_proxy_host",
	""
):
	set(_v): _readonly()


var HTTP_PROXY_PORT := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(),
	"network",
	"http_proxy_port",
	8080
):
	set(_v): _readonly()


var DIRECTORY_NAMING_CONVENTION := ConfigFileValue.new(
	_cfg_auto_save.as_config_like(), 
	"app", 
	"directory_naming_convention",
	"snake_case"
): 
	set(_v): _readonly()


static func addons_dir_for(version: String, is_mono := false) -> String:
	var folder := version
	if is_mono:
		folder += "_mono"
	return DEFAULT_ADDONS_PATH.path_join(folder)


static func ensure_addons_dir(version: String, is_mono := false) -> String:
	if version.is_empty():
		return ""
	var path := addons_dir_for(version, is_mono)
	var abs_path := ProjectSettings.globalize_path(path)
	Output.push("Creating Addons directory: %s" % abs_path)
	DirAccess.make_dir_recursive_absolute(abs_path)
	return path


static func list_installed_addons(version: String, is_mono := false) -> PackedStringArray:
	var result: PackedStringArray = []
	if version.is_empty():
		return result
	var bucket := ProjectSettings.globalize_path(addons_dir_for(version, is_mono))
	if not DirAccess.dir_exists_absolute(bucket):
		return result
	var dir := DirAccess.open(bucket)
	if dir == null:
		return result
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if dir.current_is_dir() and not entry.begins_with("."):
			result.append(entry)
		entry = dir.get_next()
	dir.list_dir_end()
	result.sort()
	return result


static func uninstall_addon(version: String, addon_folder: String, is_mono := false) -> Error:
	if version.is_empty() or addon_folder.is_empty():
		return ERR_INVALID_PARAMETER
	if addon_folder.contains("..") or addon_folder.contains("/") or addon_folder.contains("\\"):
		return ERR_INVALID_PARAMETER
	var abs_path := ProjectSettings.globalize_path(
		addons_dir_for(version, is_mono).path_join(addon_folder)
	)
	if not DirAccess.dir_exists_absolute(abs_path):
		return ERR_FILE_NOT_FOUND
	edir.remove_recursive(abs_path)
	return OK if not DirAccess.dir_exists_absolute(abs_path) else FAILED


static func global_addon_src_path(version: String, addon_folder: String, is_mono := false) -> String:
	return ProjectSettings.globalize_path(
		addons_dir_for(version, is_mono).path_join(addon_folder)
	)


static func project_addon_path(project_godot_path: String, addon_folder: String) -> String:
	return project_godot_path.get_base_dir().path_join("addons").path_join(addon_folder)


static func is_global_addon_enabled_for_project(
	project_godot_path: String,
	addon_folder: String
) -> bool:
	var path := project_addon_path(project_godot_path, addon_folder)
	return DirAccess.dir_exists_absolute(path) or _is_dir_link(path)


static func enable_global_addon_for_project(
	project_godot_path: String,
	version: String,
	addon_folder: String,
	is_mono := false
) -> Error:
	if version.is_empty() or addon_folder.is_empty() or project_godot_path.is_empty():
		return ERR_INVALID_PARAMETER
	if addon_folder.contains("..") or addon_folder.contains("/") or addon_folder.contains("\\"):
		return ERR_INVALID_PARAMETER
	var src := global_addon_src_path(version, addon_folder, is_mono)
	if not DirAccess.dir_exists_absolute(src):
		return ERR_FILE_NOT_FOUND
	var dest := project_addon_path(project_godot_path, addon_folder)
	if DirAccess.dir_exists_absolute(dest) or _is_dir_link(dest):
		return OK
	var addons_root := dest.get_base_dir()
	var mk_err := DirAccess.make_dir_recursive_absolute(addons_root)
	if mk_err != OK:
		return mk_err
	return _create_dir_link(src, dest)


static func disable_global_addon_for_project(
	project_godot_path: String,
	addon_folder: String
) -> Error:
	if addon_folder.is_empty() or project_godot_path.is_empty():
		return ERR_INVALID_PARAMETER
	if addon_folder.contains("..") or addon_folder.contains("/") or addon_folder.contains("\\"):
		return ERR_INVALID_PARAMETER
	var dest := project_addon_path(project_godot_path, addon_folder)
	if not DirAccess.dir_exists_absolute(dest) and not _is_dir_link(dest):
		return OK
	# Prefer removing a link only; fall back to recursive delete for copies.
	if _is_dir_link(dest):
		var err := DirAccess.remove_absolute(dest)
		return err
	var marker := dest.path_join(".godots-global-addon")
	if FileAccess.file_exists(marker):
		edir.remove_recursive(dest)
		return OK if not DirAccess.dir_exists_absolute(dest) else FAILED
	# Existing local addon with same name — do not delete.
	return ERR_ALREADY_EXISTS


static func _create_dir_link(target_abs: String, link_abs: String) -> Error:
	var output := []
	var exit_code: int
	if OS.has_feature("windows"):
		exit_code = OS.execute(
			"cmd.exe",
			[
				"/c",
				"mklink",
				"/J",
				link_abs.replace("/", "\\"),
				target_abs.replace("/", "\\")
			],
			output,
			true
		)
	else:
		exit_code = OS.execute(
			"ln",
			["-s", target_abs, link_abs],
			output,
			true
		)
	if exit_code != 0:
		Output.push("Failed to link addon: %s" % str(output))
		# Fallback: copy and mark as managed.
		return _copy_addon_with_marker(target_abs, link_abs)
	return OK


static func _copy_addon_with_marker(src_abs: String, dest_abs: String) -> Error:
	edir.remove_recursive(dest_abs)
	var err := DirAccess.make_dir_recursive_absolute(dest_abs)
	if err != OK:
		return err
	_copy_dir_recursive(src_abs, dest_abs)
	var marker := FileAccess.open(dest_abs.path_join(".godots-global-addon"), FileAccess.WRITE)
	if marker == null:
		return FileAccess.get_open_error()
	marker.store_string("managed-by-godots")
	marker.close()
	return OK


static func _copy_dir_recursive(src: String, dest: String) -> void:
	var dir := DirAccess.open(src)
	if dir == null:
		return
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if entry == "." or entry == "..":
			entry = dir.get_next()
			continue
		var from_path := src.path_join(entry)
		var to_path := dest.path_join(entry)
		if dir.current_is_dir():
			DirAccess.make_dir_recursive_absolute(to_path)
			_copy_dir_recursive(from_path, to_path)
		else:
			DirAccess.copy_absolute(from_path, to_path)
		entry = dir.get_next()
	dir.list_dir_end()


static func _is_dir_link(path: String) -> bool:
	if path.is_empty():
		return false
	if OS.has_feature("windows"):
		var output := []
		var code := OS.execute(
			"powershell.exe",
			[
				"-NoProfile",
				"-Command",
				"(Get-Item -LiteralPath '%s' -Force -ErrorAction SilentlyContinue).Attributes -match 'ReparsePoint'" % path.replace("'", "''")
			],
			output,
			true
		)
		if code != 0 or output.is_empty():
			return false
		return str(output[0]).strip_edges().to_lower() == "true"
	# Unix: symlink — FileAccess/DirAccess may still see it as a dir.
	var output := []
	var code := OS.execute("test", ["-L", path], output, true)
	return code == 0


func format_addon_dir_name(original_name: String) -> String:
	var name := original_name.validate_filename().replace("'", "").replace("\"", "")
	match DIRECTORY_NAMING_CONVENTION.ret() as String:
		"kebab_case":
			return name.to_snake_case().replace("_", "-")
		"snake_case":
			return name.to_snake_case()
		"camel_case":
			return name.to_camel_case()
		"pascal_case":
			return name.to_pascal_case()
		"title_case":
			return name.capitalize()
	return name


## Finds each folder that contains plugin.cfg in the zip and copies it to
## user://addons/{version}[/_mono]/{plugin_folder}/
func install_addon_zip(
	zip_abs_path: String,
	version: String,
	is_mono := false
) -> Error:
	var bucket := ensure_addons_dir(version, is_mono)
	if bucket.is_empty():
		return ERR_INVALID_PARAMETER

	var reader := ZIPReader.new()
	var open_err := reader.open(zip_abs_path)
	if open_err != OK:
		return open_err

	var plugin_cfg_paths: PackedStringArray = []
	for entry in reader.get_files():
		if entry.get_file() == "plugin.cfg":
			plugin_cfg_paths.append(entry)

	if plugin_cfg_paths.is_empty():
		reader.close()
		Output.push("No plugin.cfg found in addon zip: %s" % zip_abs_path)
		return ERR_FILE_NOT_FOUND

	var installed := 0
	for plugin_cfg_path in plugin_cfg_paths:
		var plugin_dir := plugin_cfg_path.get_base_dir().trim_suffix("/")
		var plugin_name := format_addon_dir_name(plugin_dir.get_file())
		if plugin_name.is_empty():
			continue
		var prefix := plugin_dir + "/"
		var dest := bucket.path_join(plugin_name)
		var abs_dest := ProjectSettings.globalize_path(dest)
		if DirAccess.dir_exists_absolute(abs_dest):
			edir.remove_recursive(abs_dest)
		DirAccess.make_dir_recursive_absolute(abs_dest)

		var copy_err := _extract_zip_prefix(reader, prefix, dest)
		if copy_err != OK:
			reader.close()
			return copy_err
		Output.push("Installed addon '%s' to %s" % [plugin_name, abs_dest])
		installed += 1

	reader.close()
	return OK if installed > 0 else FAILED


func _extract_zip_prefix(reader: ZIPReader, prefix: String, dest: String) -> Error:
	for entry: String in reader.get_files():
		if not entry.begins_with(prefix):
			continue
		var relative := entry.substr(prefix.length())
		if relative.is_empty():
			continue
		var target := dest.path_join(relative)
		var abs_target := ProjectSettings.globalize_path(target)
		if entry.ends_with("/"):
			var dir_err := DirAccess.make_dir_recursive_absolute(abs_target)
			if dir_err != OK:
				return dir_err
			continue
		var parent := abs_target.get_base_dir()
		var parent_err := DirAccess.make_dir_recursive_absolute(parent)
		if parent_err != OK:
			return parent_err
		var file := FileAccess.open(abs_target, FileAccess.WRITE)
		if file == null:
			return FileAccess.get_open_error()
		file.store_buffer(reader.read_file(entry))
		file.close()
	return OK


func _enter_tree() -> void:	
	DirAccess.make_dir_absolute(ProjectSettings.globalize_path(DEFAULT_VERSIONS_PATH))
	DirAccess.make_dir_absolute(ProjectSettings.globalize_path(DEFAULT_DOWNLOADS_PATH))
	DirAccess.make_dir_absolute(ProjectSettings.globalize_path(DEFAULT_UPDATES_PATH))
	DirAccess.make_dir_absolute(ProjectSettings.globalize_path(DEFAULT_CACHE_DIR_PATH))
	DirAccess.make_dir_absolute(ProjectSettings.globalize_path(DEFAULT_ADDONS_PATH))
	_cfg.load(APP_CONFIG_PATH)
	assert(not DEFAULT_VERSIONS_PATH.ends_with("/"))
	assert(not DEFAULT_DOWNLOADS_PATH.ends_with("/"))
	
	_random_project_names.set_prefixes(RANDOM_PROJECT_PREFIXES.ret() as Array)
	_random_project_names.set_suffixes(RANDOM_PROJECT_SUFFIXES.ret() as Array)
	_random_project_names.set_topics(RANDOM_PROJECT_TOPICS.ret() as Array)
	
	AGENT = "Godots/%s (%s) Godot/%s" % [
		VERSION, 
		OS.get_name(), 
		Engine.get_version_info().string
	]
	_setup_scale()


func _setup_scale() -> void:
	AUTO_EDSCALE = _get_auto_display_scale()
	var saved_scale := SAVED_EDSCALE.ret(-1) as float
	if saved_scale == -1:
		saved_scale = AUTO_EDSCALE
	EDSCALE = clamp(saved_scale, 0.75, 4)


#https://github.com/godotengine/godot/blob/master/editor/editor_settings.cpp#L1400
func _get_auto_display_scale() -> float:
#	if OS.has_feature("macos"):
#		return DisplayServer.screen_get_max_scale()
#	else:
	var screen := DisplayServer.window_get_current_screen()
	if DisplayServer.screen_get_size(screen) == Vector2i():
		return 1.0

	# Use the smallest dimension to use a correct display scale on portrait displays.
	var smallest_dimension := minf(DisplayServer.screen_get_size(screen).x, DisplayServer.screen_get_size(screen).y);
	if DisplayServer.screen_get_dpi(screen) >= 192 and smallest_dimension >= 1400:
		# hiDPI display.
		return 2.0
	elif smallest_dimension >= 1700:
		# Likely a hiDPI display, but we aren't certain due to the returned DPI.
		# Use an intermediate scale to handle this situation.
		return 1.5
	elif smallest_dimension <= 800:
		# Small loDPI display. Use a smaller display scale so that editor elements fit more easily.
		# Icons won't look great, but this is better than having editor elements overflow from its window.
		return 0.75
	return 1.0


func save() -> Error:
	var err := _cfg.save(APP_CONFIG_PATH)
	if err == OK:
		saved.emit() 
	return err


func editor_settings_proxy_get(key: String, default: Variant) -> Variant:
	return _cfg.get_value(_EDITOR_PROXY_SECTION_NAME, key, default)


func editor_settings_proxy_set(key: String, value: Variant) -> void:
	_cfg.set_value(_EDITOR_PROXY_SECTION_NAME, key, value)


func next_random_project_name() -> String:
	return _random_project_names.next()


func _readonly() -> void:
	utils.prop_is_readonly()


func _simplify_path(s: String) -> String:
	return s.simplify_path()


class CustomCommandsSourceConfig extends CommandViewer.CustomCommandsSource:
	var _val: ConfigFileValue
	
	func _init(val: ConfigFileValue) -> void:
		_val = val
	
	func _get_custom_commands() -> Array:
		return _val.ret()
	
	func _set_custom_commands(value: Array) -> void:
		_val.put(value)
