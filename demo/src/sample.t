#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the beforeAfter library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "beforeAfter.h"

versionInfo:    GameID
        name = 'beforeAfter Library Demo Game'
        byline = 'Diegesis & Mimesis'
        desc = 'Demo game for the beforeAfter library. '
        version = '1.0'
        IFID = '12345'
	showAbout() {
		"This is a simple test game that demonstrates the features
		of the beforeAfter library.
		<.p>
		The pebble should report annoying notifications before and
		after every action.  The rock is declared in the same way,
		but we explicitly unsubscribe it, so it should never send
		a notification.
		<.p>
		There's a room to the north of the starting room, just
		to verify that the notifications are happening regardless
		of whether the subscribed object is in the same room as
		the player (beforeAction() and afterAction() only fire
		on objects in the same sense scope as the object taking
		the action).
		<.p>
		Consult the README.txt document distributed with the library
		source for a quick summary of how to use the library in your
		own games.
		<.p>
		The library source is also extensively commented in a way
		intended to make it as readable as possible. ";
	}
;

class RockyThing: BeforeAfterThing
	globalBeforeAction() {
		reportBefore('This is <<theNamePossNoun>> before action. ');
	}
	globalAfterAction() {
		reportAfter('This is <<theNamePossNoun>> after action. ');
	}
;

startRoom:      Room 'Void'
        "This is a featureless void.  There is another room to the north. "
	north = otherRoom
;
+me: Person;
+pebble: RockyThing 'small round pebble' 'pebble'
	"A small, round pebble. "
;
+rock: RockyThing 'ordinary' 'rock'
	"An ordinary rock. "

	// Dumb nonsense that we do just to test the logic for detaching
	// the action listener.
	initializeThing() {
		inherited();
		gUnsubscribeBeforeAfter(self);
	}
;

otherRoom: Room 'Other Room'
	"This is the other room.  The void is to the south. "
	south = startRoom
;

gameMain:       GameMainDef
        initialPlayerChar = me
;
