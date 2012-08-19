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

#import "OGKDisplay.h"
#import "OGKEvent.h"
#import "OGKEventQueue.h"
#import "TestMain.h"

OF_APPLICATION_DELEGATE(TestMain)

@implementation TestMain
- (void)displayWasClosed: (OGKCloseEvent*)event
{
	running = NO;
}

- (void)keyWasPressed: (OGKKeyPressEvent*)event
{
	of_log(@"Pressed: %d", event.keycode);
}

- (void)keyWasReleased: (OGKKeyReleaseEvent*)event
{
	of_log(@"Released: %d", event.keycode);
}

- (void)mouseWasMoved: (OGKMouseMovedEvent*)event
{
	of_log(@"Mouse moved: X=%.f(%.f) Y=%.f(%.f) WX=%.f(%.f) WY=%.f(%.f)",
	    event.cursor.x, event.deltaCursor.x,
	    event.cursor.y, event.deltaCursor.y,
	    event.wheel.x, event.deltaWheel.x,
	    event.wheel.y, event.deltaWheel.y);
}

- (void)mouseButtonWasPressed: (OGKMouseButtonPressedEvent*)event
{
	of_log(@"Mouse button was pressed: %d (X=%.f Y=%.f WX=%.f WY=%.f)",
	    event.button, event.cursor.x, event.cursor.y,
	    event.wheel.x, event.wheel.y);
}

- (void)mouseButtonWasReleased: (OGKMouseButtonPressedEvent*)event
{
	of_log(@"Mouse button was released: %d (X=%.f Y=%.f WX=%.f WY=%.f)",
	    event.button, event.cursor.x, event.cursor.y,
	    event.wheel.x, event.wheel.y);
}

- (void)applicationDidFinishLaunching
{
	display = [[OGKDisplay alloc] initWithSize: of_dimension(640, 480)
					fullscreen: NO
					 resizable: NO];
	eventQueue = [[OGKEventQueue alloc] init];
	eventQueue.delegate = self;

	[eventQueue registerDisplay: display];
	[eventQueue registerKeyboard];
	[eventQueue registerMouse];

	for (running = YES; running;) {
		@autoreleasepool {
			[eventQueue handleNextEvent];
		}
	}
}

- (void)applicationWillTerminate
{
	/* Make sure they don't get deallocated after al_uninstall_system() */
	display = nil;
	eventQueue = nil;

	al_uninstall_system();
}
@end
