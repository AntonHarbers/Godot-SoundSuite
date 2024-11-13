extends Control

# Audio Vars
@onready var general_volume_slider : HSlider = %GeneralVolumeSlider
@onready var music_volume_slider : HSlider = %MusicVolumeSlider
@onready var sound_fx_volume_slider : HSlider = %SoundFXVolumeSlider

@onready var general_volume_icon = %GeneralVolumeIcon
@onready var general_mute_icon = %GeneralMuteIcon
@onready var music_volume_icon = %MusicVolumeIcon
@onready var music_mute_icon = %MusicMuteIcon
@onready var fx_volume_icon = %FXVolumeIcon
@onready var fx_mute_icon = %FXMuteIcon


func _ready(): InitVolumeSliders()

# Audio Settings

func InitVolumeSliders():
	general_volume_slider.min_value = GodotSoundSuite.muteVolumeLowerBound - 1
	music_volume_slider.min_value = GodotSoundSuite.muteVolumeLowerBound - 1
	sound_fx_volume_slider.min_value = GodotSoundSuite.muteVolumeLowerBound - 1
	LoadVolumeFromSaveSystem(general_volume_slider, "MasterVolume")
	LoadVolumeFromSaveSystem(music_volume_slider, "MusicVolume")
	LoadVolumeFromSaveSystem(sound_fx_volume_slider, "FXVolume")

func LoadVolumeFromSaveSystem(slider : HSlider, gameSettingsKey : String):
	pass
	#if SaveSystem.GameSettings.has(gameSettingsKey):
		#slider.value = float(SaveSystem.GameSettings[gameSettingsKey])

# Signal Connections

func _on_general_volume_slider_value_changed(value):
	toggleMuteIcon(value, general_mute_icon, general_volume_icon, true)
	GodotSoundSuite.UpdateMasterBusVolume(value)

func _on_music_volume_slider_value_changed(value):
	toggleMuteIcon(value, music_mute_icon, music_volume_icon)
	GodotSoundSuite.UpdateMusicBusVolume(value)

func _on_sound_fx_volume_slider_value_changed(value):
	toggleMuteIcon(value, fx_mute_icon, fx_volume_icon)
	GodotSoundSuite.UpdateSoundFXBusVolume(value)

func _on_mute_notification_sound_toggle_toggled(_toggled_on):
	GodotSoundSuite.ToggleNotificationBusMuted()

func _on_reset_audio_settings_btn_button_down():
	GodotSoundSuite.UpdateMasterBusVolume(0)
	GodotSoundSuite.UpdateMusicBusVolume(0)
	GodotSoundSuite.UpdateSoundFXBusVolume(0)
	general_volume_slider.value = 0
	music_volume_slider.value = 0
	sound_fx_volume_slider.value = 0


# Helpers Functions

func toggleMuteIcon(value, muteIcon, volumeIcon, isGeneral : bool = false):
	if value < GodotSoundSuite.muteVolumeLowerBound:
		volumeIcon.hide()
		muteIcon.show()
		if isGeneral:
			fx_mute_icon.show()
			fx_volume_icon.hide()
			music_mute_icon.show()
			music_volume_icon.hide()
	else:
		muteIcon.hide()
		volumeIcon.show()
		if isGeneral:
			if music_volume_slider.value >= GodotSoundSuite.muteVolumeLowerBound:
				music_mute_icon.hide()
				music_volume_icon.show()
			if sound_fx_volume_slider.value >= GodotSoundSuite.muteVolumeLowerBound:
				fx_mute_icon.hide()
				fx_volume_icon.show()
