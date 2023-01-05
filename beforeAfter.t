#charset "us-ascii"
//
// beforeAfter.t
//
//	Provides a mechanism by which an object can globally subscribe
//	to action notifications.  Subscribed objects will have their
//	globalBeforeAction() and globalAfterAction() methods called for
//	every action, similar to how T3's native beforeAction() and
//	afterAction() work, except the global methods are called on the
//	subscribed object independent of scope.
//
//	T3 does something similar by letting objects add themselves to
//	individual actions via Action.addBeforeAfterObj(), but there's no way
//	to do this in bulk.
//
//	We just create a controller object that manages individual objects'
//	subscriptions and insert it (the controller object) to every
// 	Action instance via addBeforeAfterObj() (by tweaking
//	Action.construct()).
//
//	Should probably be used with caution to avoid performance problems.
//
#include <adv3.h>
#include <en_us.h>

#include "beforeAfter.h"

// Module ID for the library
beforeAfterModuleID: ModuleID {
        name = 'Before After Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

modify Thing
	// Stub methods to be overwritten by instances.
	globalBeforeAction() {}
	globalAfterAction() {}
;

// Convenience class that auto-subscribes on init.
class BeforeAfterThing: Thing
	initializeThing() {
		inherited();
		gSubscribeBeforeAfter(self);
	}

;

// Big ol ugly kludge to insert the controller object to every beforeAction()
// and afterAction() every turn.
modify Action
	construct() {
		inherited();
		addBeforeAfterObj(beforeAfterController);
	}
;

// The controller for the whole mess.
// Maintains its own list of subscribers and pings each of them whenever
// its own beforeAction() and afterAction() methods are called.  Which is
// every time an action fires, because of what we did to Action above.
beforeAfterController: object
	subscribers = nil

	// Add an object to our notification list
	subscribe(obj) {
		if(subscribers == nil)
			subscribers = new Vector(16);

		if(subscribers.indexOf(obj) == nil)
			subscribers += obj;
	}

	// Remove an object from the list.
	detach(obj) {
		local idx;

		if(subscribers == nil)
			return(nil);

		idx = subscribers.indexOf(obj);
		if(idx == nil)
			return(nil);
		subscribers = subscribers.removeElementAt(idx);

		return(true);
	}

	// This is where the magic happens.  Notify all our subscribers.
	beforeAction() {
		if(subscribers == nil) return;
		subscribers.forEach(function(o) { o.globalBeforeAction(); });
	}
	afterAction() {
		if(subscribers == nil) return;
		subscribers.forEach(function(o) { o.globalAfterAction(); });
	}
;
