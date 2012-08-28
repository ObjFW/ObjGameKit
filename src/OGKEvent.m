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

#import "OGKEvent.h"

@implementation OGKEvent
- (ALLEGRO_EVENT*)OGK_allegroEvent
{
	return &event;
}
@end

@implementation OGKCloseEvent
@end

@implementation OGKKeyboardEvent
- (int)keycode
{
	return event.keyboard.keycode;
}
@end

@implementation OGKKeyPressEvent
@end

@implementation OGKKeyReleaseEvent
@end

@implementation OGKCharacterTypedEvent
- (of_unichar_t)character
{
	if (event.keyboard.unichar < 1)
		return 0xFFFD;

	return event.keyboard.unichar;
}

- (unsigned)modifiers
{
	return event.keyboard.modifiers;
}

- (BOOL)repeated
{
	return event.keyboard.repeat;
}
@end

@implementation OGKMouseEvent
- (of_point_t)cursor
{
	return of_point(event.mouse.x, event.mouse.y);
}

- (of_point_t)wheel
{
	return of_point(event.mouse.w, event.mouse.z);
}
@end

@implementation OGKMouseMovedEvent
- (of_point_t)deltaCursor
{
	return of_point(event.mouse.dx, event.mouse.dy);
}

- (of_point_t)deltaWheel
{
	return of_point(event.mouse.dw, event.mouse.dz);
}
@end

@implementation OGKMouseButtonEvent
- (unsigned)button
{
	return event.mouse.button;
}
@end

@implementation OGKMouseButtonPressedEvent
@end

@implementation OGKMouseButtonReleasedEvent
@end
