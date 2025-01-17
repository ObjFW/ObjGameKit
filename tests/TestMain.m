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

@interface TestMain ()
- (void)draw;
- (void)handleEvents;
- (void)toggleAnimation;
@end

OF_APPLICATION_DELEGATE(TestMain)

@implementation TestMain
- (void)display: (OGKDisplay*)display
      wasClosed: (OGKCloseEvent*)event
{
	[OFApplication terminate];
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

- (void)characterWasTyped: (OGKCharacterTypedEvent*)event
		  display: (OGKDisplay*)display
{
	of_log(@"Character typed: %u (keycode=%d, modifiers=%d, repeated=%d)",
	    event.character, event.keycode, event.modifiers, event.repeated);

	switch (event.keycode) {
	case OGK_KEY_R:
		tint = ogk_color(1, 0.5, 0.5, 0);
		break;
	case OGK_KEY_G:
		tint = ogk_color(0.5, 1, 0.5, 0);
		break;
	case OGK_KEY_B:
		tint = ogk_color(0.5, 0.5, 1, 0);
		break;
	case OGK_KEY_N:
		tint = ogk_color(1, 1, 1, 0);
		break;
	case OGK_KEY_LEFT:
		rotation.angle -= M_PI / 128;
		break;
	case OGK_KEY_RIGHT:
		rotation.angle += M_PI / 128;
		break;
	case OGK_KEY_A:
		[self toggleAnimation];
		break;
	case OGK_KEY_Q:
		[OFApplication terminate];
		break;
	}
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
	scale = of_dimension(
	    (bitmap.size.width + event.wheel.x) / bitmap.size.width,
	    (bitmap.size.height + event.wheel.y) / bitmap.size.height);
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
	ogk_rotation_t localRotation;
	@synchronized (self) {
		localRotation = rotation;
	}

	[OGKBitmap clearToColor: OGK_COLOR_BLACK];
	[bitmap drawAtPosition: position
			 scale: scale
		      rotation: localRotation
			  tint: tint];
	[display update];
}

- (void)toggleAnimation
{
	@synchronized (self) {
		if (animationThread != nil) {
			stopAnimation = YES;
			[animationThread join];
			animationThread = nil;
			stopAnimation = NO;
			return;
		}

		animationThread = [OFThread threadWithBlock: ^ (id object) {
			while (!stopAnimation) {
				@synchronized (self) {
					rotation.angle -= M_PI / 256;
				}
				[OFThread sleepForTimeInterval: 0.01];
			}
			return nil;
		}];
		[animationThread start];
	}
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
	position = of_point(display.size.width / 2, display.size.height / 2);
	scale = of_dimension(1, 1);
	rotation = ogk_rotation(bitmap.size.width / 2, bitmap.size.height / 2,
	    0);
	tint = ogk_color(1, 1, 1, 0);

	for (;;) {
		@autoreleasepool {
			[self handleEvents];
			[self draw];
		}
	}
}
@end
