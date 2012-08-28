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

#import "keycodes.h"

@interface OGKEvent: OFObject
{
	ALLEGRO_EVENT event;
}

- (ALLEGRO_EVENT*)OGK_allegroEvent;
@end

@interface OGKCloseEvent: OGKEvent
@end

@interface OGKKeyboardEvent: OGKEvent
@property (readonly, assign) int keycode;
@end

@interface OGKKeyPressEvent: OGKKeyboardEvent
@end

@interface OGKKeyReleaseEvent: OGKKeyboardEvent
@end

@interface OGKMouseEvent: OGKEvent
@property (readonly, assign) of_point_t cursor;
@property (readonly, assign) of_point_t wheel;
@end

@interface OGKMouseMovedEvent: OGKMouseEvent
@property (readonly, assign) of_point_t deltaCursor, deltaWheel;
@end

@interface OGKMouseButtonEvent: OGKMouseEvent
@property (readonly, assign) unsigned button;
@end

@interface OGKMouseButtonPressedEvent: OGKMouseButtonEvent
@end

@interface OGKMouseButtonReleasedEvent: OGKMouseButtonEvent
@end
