class_name SettingsMenu
extends CanvasLayer

@export var initial_tab : MenuTabButton

# Control Buttons
@onready var apply_button = $ControlButtonsContainer/ApplyButton
@onready var restore_defaults_button = $ControlButtonsContainer/RestoreDefaultsButton
@onready var back_button = $ControlButtonsContainer/BackButton

# Display Settings
@onready var window_mode_option = $TabContainer/DisplaySettings/Menu/OptionsContainer/WindowModeOptionButton

# Audio Settings
@onready var mute_check_button = $TabContainer/AudioSettings/Menu/MuteVolumeContainer/CheckButton
@onready var main_volume_slider = $TabContainer/AudioSettings/Menu/MainVolumeContainer/HSlider
@onready var music_volume_slider = $TabContainer/AudioSettings/Menu/MusicVolumeContainer/HSlider
@onready var sfx_volume_slider = $TabContainer/AudioSettings/Menu/SFXVolumeContainer/HSlider

var return_focus : Control

func _ready():
	Settings.new_settings.connect(display_current_settings)
	apply_button.button_down.connect(apply_new_settings)
	restore_defaults_button.button_down.connect(restore_default_settings)
	back_button.button_down.connect(_on_back_button_pressed)
	for key in SettingsFile.WindowMode:
		window_mode_option.add_item(key, SettingsFile.WindowMode[key])
	for child in get_children():
		if child is Control:
			# Overlay over hopefully everything
			child.z_index += 10
	display_current_settings()
	initial_tab.grab_focus()
	initial_tab._on_button_pressed()


func _process(delta):
	if settings_changed():
		back_button.text = "Discard Changes"


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_back_button_pressed()
		back_button.accept_event()


func settings_changed():
	return (
		window_mode_option.selected != Settings.get_window_mode() or
		mute_check_button.button_pressed != Settings.get_muted() or
		main_volume_slider.value != Settings.get_main_volume_linear() or
		music_volume_slider.value != Settings.get_music_volume_linear() or
		sfx_volume_slider.value != Settings.get_sfx_volume_linear()
	)


func display_current_settings():
	window_mode_option.selected = Settings.get_window_mode()
	mute_check_button.button_pressed = Settings.get_muted()
	main_volume_slider.value = Settings.get_main_volume_linear()
	music_volume_slider.value = Settings.get_music_volume_linear()
	sfx_volume_slider.value = Settings.get_sfx_volume_linear()


func apply_new_settings():
	var settings_file = SettingsFile.new()
	settings_file.window_mode = window_mode_option.selected
	settings_file.mute = mute_check_button.button_pressed
	settings_file.main_volume_linear = main_volume_slider.value
	settings_file.music_volume_linear = music_volume_slider.value
	settings_file.sfx_volume_linear = sfx_volume_slider.value
	Settings.save_new_settings(settings_file)
	back_button.text = "OK"
	display_current_settings()


func restore_default_settings():
	window_mode_option.selected = Settings.get_default_window_mode()
	mute_check_button.button_pressed = Settings.get_default_muted()
	main_volume_slider.value = Settings.get_default_main_volume_linear()
	music_volume_slider.value = Settings.get_default_music_volume_linear()
	sfx_volume_slider.value = Settings.get_default_sfx_volume_linear()


func _on_back_button_pressed():
	if return_focus:
		return_focus.grab_focus()
	queue_free()
