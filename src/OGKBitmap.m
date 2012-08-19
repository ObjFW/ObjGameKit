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
#include <allegro5/allegro_image.h>

#import "OGKBitmap.h"
#import "OGKDisplay.h"

ogk_color_t OGK_COLOR_BLACK = { 0, 0, 0, 1 };

@implementation OGKBitmap
+ (void)initialize
{
	if (self != [OGKBitmap class])
		return;

	if (!al_install_system(ALLEGRO_VERSION_INT, NULL) ||
	    !al_init_image_addon())
		@throw [OFInitializationFailedException
		    exceptionWithClass: self];
}

+ (void)setTarget: (id)target
{
	if ([target isKindOfClass: [OGKDisplay class]])
		al_set_target_backbuffer([target OGK_allegroDisplay]);
	else
		al_set_target_bitmap([target OGK_allegroBitmap]);
}

+ (void)clearToColor: (ogk_color_t)color
{
	al_clear_to_color(
	    al_map_rgb(color.red * 256, color.green * 256, color.blue * 256));
}

- initWithSize: (of_dimension_t)size
{
	self = [super init];

	bitmap = al_create_bitmap(size.width, size.height);

	if (bitmap == NULL)
		@throw [OFInitializationFailedException
		    exceptionWithClass: [self class]];

	return self;
}

- initWithFile: (OFString*)path
{
	self = [super init];

	bitmap = al_load_bitmap(
	    [path cStringWithEncoding: OF_STRING_ENCODING_NATIVE]);

	if (bitmap == NULL)
		@throw [OFInitializationFailedException
		    exceptionWithClass: [self class]];

	return self;
}

- (void)drawAtPosition: (of_point_t)position
{
	al_draw_bitmap(bitmap, position.x, position.y, 0);
}

- (ALLEGRO_BITMAP*)OGK_allegroBitmap
{
	return bitmap;
}
@end
