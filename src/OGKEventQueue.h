/*
 * Copyright (c) 2012 Jonathan Schleifer <js@webkeks.org>
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *   1.) The origin of this software must not be misrepresented; you must not
 *       claim that you wrote the original software. If you use this software
 *       in a product, an acknowledgment in the product documentation would be
 *       appreciated but is not required.
 *   2.) Altered source versions must be plainly marked as such, and must not
 *       be misrepresented as being the original software.
 *   3.) This notice may not be removed or altered from any source distribution.
 */

#include <allegro5/allegro.h>

#import <ObjFW/ObjFW.h>

#import "OGKEvent.h"
#import "OGKDisplay.h"

@protocol OGKEventQueueDelegate <OFObject>
@optional
- (void)display: (OGKDisplay*)display
      wasClosed: (OGKCloseEvent*)event;
- (void)keyWasPressed: (OGKKeyPressEvent*)event
	      display: (OGKDisplay*)display;
- (void)keyWasReleased: (OGKKeyReleaseEvent*)event
	       display: (OGKDisplay*)display;
- (void)mouseWasMoved: (OGKMouseMovedEvent*)event
	      display: (OGKDisplay*)display;
- (void)mouseButtonWasPressed: (OGKMouseButtonPressedEvent*)event
		      display: (OGKDisplay*)display;
- (void)mouseButtonWasReleased: (OGKMouseButtonReleasedEvent*)event
		      display: (OGKDisplay*)display;
@end

@interface OGKEventQueue: OFObject
{
	ALLEGRO_EVENT_QUEUE *eventQueue;
	/* FIXME: Make this weak once there is support in ObjFW for it */
	__unsafe_unretained id <OGKEventQueueDelegate> delegate;
}

@property (unsafe_unretained) id <OGKEventQueueDelegate> delegate;

- (void)handleEvents;
- (void)registerDisplay: (OGKDisplay*)display;
- (void)unregisterDisplay: (OGKDisplay*)display;
- (void)registerKeyboard;
- (void)unregisterKeyboard;
- (void)registerMouse;
- (void)unregisterMouse;
@end
