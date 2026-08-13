class_name GodotVersionOptionButton
extends OptionButton

signal changed

var _src: Src


func _init() -> void:
	item_selected.connect(func(_idx: int) -> void: changed.emit())


func init(src: Src) -> void:
	_src = src


func async_load_versions() -> Array[String]:
	clear()
	var errors: Array[String] = []
	var versions := await _src.async_fetch(errors)
	for i in range(len(versions)):
		add_item(versions[i])
		set_item_metadata(i, versions[i])
	return errors


func fill_params(params: AssetLib.Params) -> void:
	params.godot_version = get_selected_metadata()


class Src:
	func async_fetch(errors: Array[String]=[]) -> PackedStringArray:
		return []


class SrcMock extends Src:
	var _data: PackedStringArray
	
	func _init(data: PackedStringArray) -> void:
		_data = data
	
	func async_fetch(errors: Array[String]=[]) -> PackedStringArray:
		return _data


class LocalGodotVersion extends Src:
	var _version_list : LocalEditors.List
	
	func _init(version_list: LocalEditors.List) -> void:
		_version_list = version_list
	
	func async_fetch(errors: Array[String]=[]) -> PackedStringArray:
		var local_godot_version : Array[LocalEditors.Item] = _version_list.all()
		
		var result: PackedStringArray = []
		for ver in local_godot_version:
			var parsed: String = ver.get_version()
			var major_minor_strip: String = parsed.substr(0, 3)
			if not major_minor_strip in result:
				result.append(major_minor_strip)
		if len(result) == 0:
			errors.append(tr("Empty versions list!"))
		return result


func _on_fetch_disable() -> void:
	disabled = true


func _on_fetch_enable() -> void:
	disabled = false
