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
#import "OGKBitmap.h"
#import "TestMain.h"

OF_APPLICATION_DELEGATE(TestMain)

@implementation TestMain
- (void)display: (OGKDisplay*)display
      wasClosed: (OGKCloseEvent*)event
{
	running = NO;
}

- (void)keyWasPressed: (OGKKeyPressEvent*)event
	      display: (OGKDisplay*)display
{
	of_log(@"Pressed: %d", event.keycode);
}

- (void)keyWasReleased: (OGKKeyReleaseEvent*)event
	       display: (OGKDisplay*)display
{
	of_log(@"Released: %d", event.keycode);
}

- (void)mouseWasMoved: (OGKMouseMovedEvent*)event
	      display: (OGKDisplay*)display
{
	of_log(@"Mouse moved: X=%.f(%.f) Y=%.f(%.f) WX=%.f(%.f) WY=%.f(%.f)",
	    event.cursor.x, event.deltaCursor.x,
	    event.cursor.y, event.deltaCursor.y,
	    event.wheel.x, event.deltaWheel.x,
	    event.wheel.y, event.deltaWheel.y);

	position = event.cursor;
}

- (void)mouseButtonWasPressed: (OGKMouseButtonPressedEvent*)event
		      display: (OGKDisplay*)display
{
	of_log(@"Mouse button was pressed: %d (X=%.f Y=%.f WX=%.f WY=%.f)",
	    event.button, event.cursor.x, event.cursor.y,
	    event.wheel.x, event.wheel.y);
}

- (void)mouseButtonWasReleased: (OGKMouseButtonPressedEvent*)event
		       display: (OGKDisplay*)display
{
	of_log(@"Mouse button was released: %d (X=%.f Y=%.f WX=%.f WY=%.f)",
	    event.button, event.cursor.x, event.cursor.y,
	    event.wheel.x, event.wheel.y);
}

- (void)handleEvents
{
	[eventQueue handleEvents];
}

- (void)draw
{
	[OGKBitmap clearToColor: OGK_COLOR_BLACK];
	[bitmap drawAtPosition: position];
	[display update];
}

- (void)applicationDidFinishLaunching
{
	ogk_display_flags_t flags =
	    OGK_DISPLAY_FLAGS_RESIZABLE |
	    OGK_DISPLAY_FLAGS_VSYNC;

	display = [[OGKDisplay alloc] initWithSize: of_dimension(640, 480)
					  position: of_point(200, 200)
					     flags: flags];
	display.size = of_dimension(800, 600);
	display.windowPosition = of_point(100, 100);
	display.windowTitle = @"ObjGameKit test";

	of_log(@"Display is %.fx%.f at (%.f, %.f)",
	    display.size.width, display.size.height,
	    display.windowPosition.x, display.windowPosition.y);

	eventQueue = [[OGKEventQueue alloc] init];
	eventQueue.delegate = self;

	[eventQueue registerDisplay: display];
	[eventQueue registerKeyboard];
	[eventQueue registerMouse];

	bitmap = [[OGKBitmap alloc] initWithFile: @"test.bmp"];

	for (running = YES; running;) {
		@autoreleasepool {
			[self handleEvents];
			[self draw];
		}
	}
}
@end
