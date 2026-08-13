class_name AddonManifest
extends RefCounted

const FILENAME := "manifest.json"
const PLUG_START := "# godots:requirements:start"
const PLUG_END := "# godots:requirements:end"


static func write_manifest(addon_abs_dir: String, data: Dictionary) -> Error:
	var filtered := {}
	for key: Variant in data:
		var value: Variant = data[key]
		if value is String and (value as String).is_empty():
			continue
		filtered[key] = value
	if filtered.is_empty():
		return OK
	var path := addon_abs_dir.path_join(FILENAME)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(filtered, "\t") + "\n")
	return OK


static func read_manifest(addon_dir: String) -> Dictionary:
	var path := addon_dir.path_join(FILENAME)
	if not FileAccess.file_exists(path):
		return {}
	var text := FileAccess.get_file_as_string(path)
	var parsed: Variant = JSON.parse_string(text)
	if parsed is Dictionary:
		return parsed
	return {}


static func plug_repo_from_browse_url(url: String) -> String:
	url = url.strip_edges()
	var marker := "github.com/"
	var pos := url.find(marker)
	if pos == -1:
		return ""
	var rest := url.substr(pos + marker.length()).trim_prefix("/")
	var segments := rest.split("/", false)
	if segments.size() < 2:
		return ""
	var repo := segments[1].replace(".git", "")
	if repo.is_empty():
		return ""
	return "%s/%s" % [segments[0], repo]


static func sync_plug_on_enable(project_godot_path: String, addon_dir: String) -> Error:
	var manifest: = read_manifest(addon_dir)
	var plug: String = manifest.get("plug", "")
	return add_plug_requirement(project_godot_path, plug)


static func sync_plug_on_disable(project_godot_path: String, plug_repo: String) -> Error:
	return remove_plug_requirement(project_godot_path, plug_repo)


static func add_plug_requirement(project_godot_path: String, plug_repo: String) -> Error:
	if plug_repo.is_empty():
		return OK
	var plug_path := _plug_gd_path(project_godot_path)
	if not FileAccess.file_exists(plug_path):
		return OK
	var content := FileAccess.get_file_as_string(plug_path)
	if _has_plug_line(content, plug_repo):
		return OK
	content = _insert_plug_line(content, plug_repo)
	return _write_plug_gd(plug_path, content)


static func remove_plug_requirement(project_godot_path: String, plug_repo: String) -> Error:
	if plug_repo.is_empty():
		return OK
	var plug_path := _plug_gd_path(project_godot_path)
	if not FileAccess.file_exists(plug_path):
		return OK
	var content := FileAccess.get_file_as_string(plug_path)
	if not _has_plug_line(content, plug_repo):
		return OK
	content = _remove_plug_line(content, plug_repo)
	return _write_plug_gd(plug_path, content)


static func _plug_gd_path(project_godot_path: String) -> String:
	return project_godot_path.get_base_dir().path_join("plug.gd")


static func _write_plug_gd(path: String, content: String) -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(content)
	return OK


static func _has_plug_line(content: String, plug_repo: String) -> bool:
	var regex := RegEx.new()
	var pattern: String = '^\\s*plug\\(["\']' + _regex_escape(plug_repo) + '["\']'
	regex.compile(pattern)
	for line: String in content.split("\n"):
		if regex.search(line):
			return true
	return false


static func _regex_escape(text: String) -> String:
	var specials := "\\.*+?|^$[](){}"
	var out := ""
	for i in text.length():
		var c := text[i]
		if specials.find(c) != -1:
			out += "\\"
		out += c
	return out

static func _insert_plug_line(content: String, plug_repo: String) -> String:
	var line := '\tplug("%s")' % plug_repo
	if PLUG_START in content and PLUG_END in content:
		var end_idx := content.find(PLUG_END)
		var before := content.substr(0, end_idx).rstrip("\n")
		var after := content.substr(end_idx)
		return before + "\n" + line + "\n\t" + after.lstrip("\n")
	var plugging_marker := "func _plugging():"
	var plugging_idx := content.find(plugging_marker)
	if plugging_idx == -1:
		return content
	var line_break := content.find("\n", plugging_idx)
	if line_break == -1:
		return content
	var insert_at := line_break + 1
	var block := "\t%s\n%s\n\t%s\n" % [PLUG_START, line, PLUG_END]
	return content.substr(0, insert_at) + block + content.substr(insert_at)


static func _remove_plug_line(content: String, plug_repo: String) -> String:
	var regex := RegEx.new()
	var pattern: String = '^\\s*plug\\(["\']' + _regex_escape(plug_repo) + '["\']'
	regex.compile(pattern)
	var lines: PackedStringArray = []
	for line: String in content.split("\n"):
		if regex.search(line):
			continue
		lines.append(line)
	return "\n".join(lines)
