global.DEBUG_MESSAGES = {
	topleft: [],
	topright: [],
	bottomleft: [],
	bottomright: []
};
global.DEBUG_LOCATIONS = [
	"topleft",
	"topright",
	"bottomleft",
	"bottomright"
];
/*
    creates a struct given the string, value, and time on screen of the debug message, adds it to the global array of debug messages.

    @param string debugMessage - the message to be displayed on the debug screen
	@param string debugLocation - the location where to display the debug message. defaults to top left.
							possible values:
								topleft
								topright
								bottomleft
								bottomright
    @param ?float debugMessageTimeOnScreen - the time the message will be displayed on the debug screen. if set to -1, the message will NEVER fade out.
*/
function addDebugMessageToDebugScreen(debugMessage, debugLocation = "topleft", debugMessageTimeOnScreen = 1) {
    newDebugMessage = {
        message: debugMessage,
		location: debugLocation,
        timeOnScreen: debugMessageTimeOnScreen
    };
    array_push(global.DEBUG_MESSAGES[$ debugLocation], newDebugMessage);
}

/*
    reduces the amount of time of all debug messages by 0.01, 
    if the time on screen is less than or equal to 0, the message is removed from the array of debug messages.
*/
function timeOutDebugMessages(){
	for (var n = 0; n < array_length(global.DEBUG_LOCATIONS); n ++){
		for (var i = 0; i < array_length(global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]]); i++) {
			if (global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i].timeOnScreen != -1){
				global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i].timeOnScreen -= 0.01;
				if (global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i].timeOnScreen <= 0) {
				    removeDebugMessageFromDebugScreen(global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i].message);
				}
			}
		}
	}
}

/*
    Removes a specific debug message from the array of debug messages.

    @param string debugMessage - the message to be removed from the debug screen
*/
function removeDebugMessageFromDebugScreen(debugMessage){
	for (var n = 0; n < array_length(global.DEBUG_LOCATIONS); n ++){
	    for (var i = 0; i < array_length(global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]]); i++) {
	        if (global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i].message == debugMessage) {
	            array_delete(global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]],i, 1);
	        }
	    }
	}
}

/*
    Draws to the screen all debug messages from the array of debug messages with the proper alpha for fading out.
*/
function drawDebugMessagesToScreen() {
	var textColor = make_color_rgb(240, 240, 240); // Slightly off-white color
	for (var n = 0; n < array_length(global.DEBUG_LOCATIONS); n ++){
	    for (var i = 0; i < array_length(global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]]); i++) {
			var drawingLocation = getDrawLocationForDebugMessage(global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i]);
			var alpha = global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i].timeOnScreen != -1 ? global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i].timeOnScreen : 1;
		
			draw_text_colour(
				drawingLocation.drawX, 
				drawingLocation.drawY + (i * drawingLocation.drawIncrement),
				global.DEBUG_MESSAGES[$ global.DEBUG_LOCATIONS[n]][i].message, 
				textColor, 
				textColor, 
				textColor,
				textColor,
				alpha
			);
	    }
	}
	
	timeOutDebugMessages();
}

/*
	sets drawingLocation on where to draw the debug message.
	
	@param struct debugMessage - a struct from the global array global.DEBUG_MESSAGE.
	@return struct drawingLocation - a struct with the following values:
									int drawX - the window X position where to draw the message on the screen
									int drawY - the window Y position where to draw the message on the screen
									int drawIncrement - determines if the messages will scroll up or down
*/
function getDrawLocationForDebugMessage(debugMessage){
	var drawingLocation = {
		drawX : 10,
		drawY : 10,
		drawIncrement: 20
	}

	if (debugMessage.location == "topright"){
		drawingLocation = {
			drawX : display_get_gui_width()-string_width(debugMessage.message) - 10,
			drawY : 10,
			drawIncrement: 20
		}
	}
	else if (debugMessage.location == "bottomleft"){
		drawingLocation = {
			drawX : 10,
			drawY : display_get_gui_height() - 30,
			drawIncrement: -20
		}
	}
	else if (debugMessage.location == "bottomright"){
		drawingLocation = {
			drawX : display_get_gui_width()-string_width(debugMessage.message)- 10,
			drawY : display_get_gui_height() - 30,
			drawIncrement: -20
		}
	}
	
	return drawingLocation;
}