#charset "us-ascii"
//
// beforeAfter.t
//
//	Provides a mechanism by which objects can subscribe to global
//	beforeAction() and afterAction() notifications.
//
//	T3 lets objects add themselves to individual actions via
//	Action.addBeforeAfterObj(), but there's no way to do this in bulk.
//	We just create a controller object that manages individual objects'
//	subscriptions and insert IT (the controller object) to every
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
        name = 'beforeAfter Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

// Big ol ugly kludge to insert the controller object to every beforeAction()
// and afterAction() every turn.
modify Action
	construct() {
		inherited();
		addBeforeAfterObj(beforeAfterController);
	}
;

beforeAfterController: object
	subscribers = static []

	// Add an object to our notification list
	subscribe(obj) {
		if(subscribers.indexOf(obj) == nil)
			subscribers += obj;
	}

	// Remove an object from the list;
	detach(obj) {
		local idx;

		idx = subscribers.indexOf(obj);
		if(idx == nil)
			return(nil);
		subscribers = subscribers.removeElementAt(idx);

		return(true);
	}

	beforeAction() {
		subscribers.forEach(function(o) { o.beforeAction(); });
	}
	afterAction() {
		subscribers.forEach(function(o) { o.afterAction(); });
	}
;
