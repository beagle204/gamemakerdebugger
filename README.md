# gamemakerdebugger
All purpose simple visual debugging for any one to add to their game maker project
-Created by Beagle North Games-
Free to use, edit, alter, steal, without credit. 

The issue:
  As a developer in GMS, the show_debug_message expression doesn't provide enough on-screen utility for on-the-fly debugging that I may need. I want a simple solution that I can call simply, to display on-screen information about my game.

After importing this to your project, (or simply copy and paste the script in, should be good enough), you can call on screen debugging with the following function call, anywhere in your code:

***addDebugMessageToDebugScreen("My debugging message");***

-------------------------------------

A message will now appear in the top left of your screen, and fade out after about a second. The power in this script comes from the optional parameters you can pass into addDebugMessageToDebugScreen.
Let's take a look at the function


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
```
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
```
*So there are a few things going on here.*

**First** let's talk about those two globals.
The first is the DEBUG_MESSAGES struct. it's one of four arrays, one for each location of the screen.
The second, is a sort of list of the keys in the struct. they need to be named EXACTLY what the struct names are, as this global array is only an accessor for looping through the keys of the struct. (see below for an example of that behaviour)

**secondly**, the main entry point to all this, addDebugMessageToDebugScreen. You can choose to pass in a single string, or the two optional parameters. the location must be of a location in the DEBUG_LOCATIONS array. the time on screen should roughly 
reflect the amount of seconds you wish to have a string on the screen for. setting it to -1, will leave the string on the screen until you manually call for it's deletion.

Debug messages are timed out automatically through the alpha-fade, then deleted. You can optionally call another function
```
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
```
by passing in the message you want to delete, it will loop through all locations, and find it, and remove it.
