extends Node

var SavedVolumes : Dictionary = {}

# OPTIONAL
#@onready var on_drag_start_sound = $Sounds/UISounds/OnDragStartSound
#@onready var on_drag_end_sound = $Sounds/UISounds/OnDragEndSound
#@onready var switch_on_sound = $Sounds/UISounds/SwitchOnSound
#@onready var switch_off_sound = $Sounds/UISounds/SwitchOffSound

var masterBusName : String
var musicBusName : String
var fxBusName : String

var masterBusIndex : int = AudioServer.get_bus_index(masterBusName)
var musicBusIndex : int = AudioServer.get_bus_index(musicBusName)
var fxBusIndex : int = AudioServer.get_bus_index(fxBusName)

var muteVolumeLowerBound : float

var err : String = ""

func _ready(): 
	InitVarsFromConfig()
	if musicBusIndex == -1 or fxBusIndex == -1:
		err = "Music or FX bus index not found, please configure Metadata of godot_sound_suite.gd or your audio bus layout!"
		push_error(err)
		printerr(err)
		return
	LoadAudioSettings()

func InitVarsFromConfig():
	var config = ConfigFile.new()
	var err = config.load("res://addons/godot-soundsuite/GodotSoundSuiteConfig.cfg")
	if err != OK:
		err = "Godot Sound Suite Settings Config file not found!"
		push_error(err)
		printerr(err)
		return
	
	masterBusName = config.get_value("BUS_NAMES", "MASTER_BUS_NAME", "Master")
	musicBusName = config.get_value("BUS_NAMES", "MUSIC_BUS_NAME", "Music")
	fxBusName = config.get_value("BUS_NAMES", "FX_BUS_NAME", "FX")
	masterBusIndex = AudioServer.get_bus_index(masterBusName)
	musicBusIndex = AudioServer.get_bus_index(musicBusName)	
	fxBusIndex = AudioServer.get_bus_index(fxBusName)
	muteVolumeLowerBound = float(config.get_value("MUTE_LOWER_BOUND", "MUTE_LOWER_BOUND", "-35"))

# Bus Volume Updating (called from settings menu)
func UpdateMasterBusVolume(newDB : float):
	if err != "": return
	UpdateBusVolume(masterBusIndex, masterBusName + "VolumeSetting", newDB)

func UpdateMusicBusVolume(newDB : float):
	if err != "": return
	UpdateBusVolume(musicBusIndex, musicBusName + "VolumeSetting", newDB)

func UpdateSoundFXBusVolume(newDB : float):
	if err != "": return
	UpdateBusVolume(fxBusIndex, fxBusName + "VolumeSetting", newDB)


# Plumbing
func LoadAudioSettings():
	# populate our SavedVolumes from config file if it exists
	pass
	# MAKE THIS LOCAL
	#if SaveSystem.GameSettings.has("NotificationsMuted"):
		#AudioServer.set_bus_mute(notificationBusIndex, (SaveSystem.GameSettings["NotificationsMuted"] == "true"))
	#if SaveSystem.GameSettings.has("MasterVolume"):
		#UpdateMasterBusVolume(float(SaveSystem.GameSettings["MasterVolume"]))
	#if SaveSystem.GameSettings.has("MusicVolume"):
		#UpdateMusicBusVolume(float(SaveSystem.GameSettings["MusicVolume"]))
	#if SaveSystem.GameSettings.has("FXVolume"):
		#UpdateSoundFXBusVolume(float(SaveSystem.GameSettings["FXVolume"]))

func UpdateBusVolume(busIndex : int, saveSystemKey : String, newDB : float):
	if(newDB <= muteVolumeLowerBound):
		AudioServer.set_bus_mute(busIndex, true)
	else:
		AudioServer.set_bus_mute(busIndex, false)
	AudioServer.set_bus_volume_db(busIndex, newDB)
	#SaveSystem.SaveGameSetting(saveSystemKey, str(newDB))
