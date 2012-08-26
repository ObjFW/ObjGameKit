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

/* For NAN */
#include <math.h>

#include <allegro5/allegro.h>

#import <ObjFW/ObjFW.h>

#define OGK_DISPLAY_POSITION_DEFAULT of_point(NAN, NAN)

typedef enum ogk_display_flags_t {
	OGK_DISPLAY_FLAGS_FULLSCREEN	= 0x01,
	OGK_DISPLAY_FLAGS_RESIZABLE	= 0x02,
	OGK_DISPLAY_FLAGS_OPENGL	= 0x04,
	OGK_DISPLAY_FLAGS_OPENGL_3	= 0x08,
	OGK_DISPLAY_FLAGS_OPENGL_3_ONLY	= 0x10,
	OGK_DISPLAY_FLAGS_VSYNC		= 0x20
} ogk_display_flags_t;

@interface OGKDisplay: OFObject
{
	ALLEGRO_DISPLAY *display;
}

@property (assign) of_point_t windowPosition;
@property (assign) of_dimension_t size;

+ OGK_displayForAllegroDisplay: (ALLEGRO_DISPLAY*)display;
- initWithSize: (of_dimension_t)size
      position: (of_point_t)position
	 flags: (ogk_display_flags_t)flags;
- (void)setWindowTitle: (OFString*)title;
- (void)update;
- (ALLEGRO_DISPLAY*)OGK_allegroDisplay;
@end
