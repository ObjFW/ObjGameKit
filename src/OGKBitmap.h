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

typedef struct ogk_color_t {
	float red, green, blue, alpha;
} ogk_color_t;

static OF_INLINE ogk_color_t
ogk_color(float red, float green, float blue, float alpha)
{
	ogk_color_t color = { red, green, blue, alpha};

	return color;
}

extern ogk_color_t OGK_COLOR_BLACK;

@interface OGKBitmap: OFObject
{
	ALLEGRO_BITMAP *bitmap;
}

+ (void)setTarget: (id)target;
+ (void)clearToColor: (ogk_color_t)color;
- initWithSize: (of_dimension_t)size;
- initWithFile: (OFString*)file;
- (void)drawAtPosition: (of_point_t)position;
- (ALLEGRO_BITMAP*)OGK_allegroBitmap;
@end