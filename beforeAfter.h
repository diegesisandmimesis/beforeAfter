//
// beforeAfter.h
//

// Uncomment to enable debugging options.
//#define __DEBUG_BEFORE_AFTER

#define gSubscribeBeforeAfter(a) beforeAfterController.subscribe(a)
#define gUnsubscribeBeforeAfter(a) beforeAfterController.detach(a)
#define gDetachBeforeAfter(a) beforeAfterController.detach(a)
