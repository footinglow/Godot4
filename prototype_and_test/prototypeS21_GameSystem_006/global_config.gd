extends Node

var m_firing_timing_sec = 1.0
const M_FILE_NAME = "user://config.cfg"

func _ready():
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load(M_FILE_NAME)
	# If the file didn't load, ignore it.
	if err != OK:
		return


	# Fetch the data for each section.
	m_firing_timing_sec = config.get_value("Player", "firing_timing")


func save():
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Store some values.
	config.set_value("Player", "firing_timing", m_firing_timing_sec)

	# Save it to a file (overwrite if already exists).
	config.save(M_FILE_NAME)
