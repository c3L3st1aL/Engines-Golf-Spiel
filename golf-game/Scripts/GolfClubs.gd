extends Node
signal Club_Used(ClubStats)

#variablen zum durchwechseln:
var clubsPresent = 11 - 1 #muss von woanders (tasche?) ausgelesen werden
var whichClub = 0

#arrays für die Schlägerwerte (Reichenfolge: Länge, Loft in Radiant, Headweight):
const Driver = [1.14, 0.157, 0.35]
const Wood3 = [1.06, 0.251, 0.325]
const Wood5 = [1.06, 0.335, 0.3]
const Iron5 = [0.96, 0.471, 0.256]
const Iron6 = [0.93, 0.532, 0.263]
const Iron7 = [0.93, 0.545, 0.27]
const Iron8 = [0.91, 0.601, 0.277]
const Iron9 = [0.91, 0.666, 0.284]
const PW = [0.89, 0.706, 0.29]
const SW = [0.89, 0.848, 0.3]
const Putter = [0.86, 0, 0.355]

var Clubs = [Driver, Wood3, Wood5, Iron5, Iron6, Iron7, Iron8, Iron9, PW, SW, Putter] #muss ebenfalls aus der Tasche gelesen werden
var ClubNames =["Driver", "Wood3", "Wood5", "Iron5","Iron6", "Iron7", "Iron8", "Iron9", "PW", "SW", "Putter"]

func _ready() -> void:
	emit_signal("Club_Used", Clubs[whichClub])
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ClubQuickSwitchR"):
		if whichClub == clubsPresent:
			whichClub = 0
		else:
			whichClub = whichClub + 1
		print(ClubNames[whichClub])
		emit_signal("Club_Used", Clubs[whichClub])
	if Input.is_action_just_pressed("ClubQuickSwitchL"):
		if whichClub == 0:
			whichClub = clubsPresent
		else:
			whichClub = whichClub - 1
		print(ClubNames[whichClub])
		emit_signal("Club_Used", Clubs[whichClub])
