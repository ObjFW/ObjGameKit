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

static ALLEGRO_COLOR
ogk_color_to_allegro(ogk_color_t color)
{
	return al_map_rgba_f(color.red, color.green, color.blue, color.alpha);
}

@implementation OGKBitmap
+ (void)initialize
{
	if (self != [OGKBitmap class])
		return;

	if (!al_init() || !al_init_image_addon())
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
	al_clear_to_color(ogk_color_to_allegro(color));
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

- (void)dealloc
{
	if (bitmap != NULL && al_is_system_installed())
		al_destroy_bitmap(bitmap);
}

- copy
{
	OGKBitmap *copy = [[[self class] alloc] init];

	copy->bitmap = al_clone_bitmap(bitmap);

	if (copy->bitmap == NULL)
		@throw [OFInitializationFailedException
		    exceptionWithClass: [self class]];

	return copy;
}

- (instancetype)subBitmapWithRegion: (of_rectangle_t)region
{
	OGKBitmap *subBitmap = [[[self class] alloc] init];

	subBitmap->bitmap = al_create_sub_bitmap(bitmap, region.origin.x,
	    region.origin.y, region.size.width, region.size.height);

	if (subBitmap->bitmap == NULL)
		@throw [OFInitializationFailedException
		    exceptionWithClass: [self class]];

	return subBitmap;
}

- (of_dimension_t)size
{
	return of_dimension(al_get_bitmap_width(bitmap),
	    al_get_bitmap_height(bitmap));
}

- (void)drawAtPosition: (of_point_t)position
{
	al_draw_bitmap(bitmap, position.x, position.y, 0);
}

- (void)drawAtPosition: (of_point_t)position
		 scale: (of_dimension_t)scale
{
	al_draw_scaled_bitmap(bitmap, 0, 0, al_get_bitmap_width(bitmap),
	    al_get_bitmap_height(bitmap), position.x, position.y,
	    scale.width, scale.height, 0);
}

- (void)drawAtPosition: (of_point_t)position
		region: (of_rectangle_t)region
{
	al_draw_bitmap_region(bitmap, region.origin.x, region.origin.y,
	    region.size.width, region.size.height, position.x, position.y, 0);
}

- (void)drawAtPosition: (of_point_t)position
		region: (of_rectangle_t)region
		 scale: (of_dimension_t)scale
{
	al_draw_scaled_bitmap(bitmap, region.origin.x, region.origin.y,
	    region.size.width, region.size.height, position.x, position.y,
	    scale.width, scale.height, 0);
}

- (void)drawAtPosition: (of_point_t)position
		  tint: (ogk_color_t)tint
{
	al_draw_tinted_bitmap(bitmap, ogk_color_to_allegro(tint),
	    position.x, position.y, 0);
}

- (void)drawAtPosition: (of_point_t)position
		 scale: (of_dimension_t)scale
		  tint: (ogk_color_t)tint
{
	al_draw_tinted_scaled_bitmap(bitmap, ogk_color_to_allegro(tint),
	    0, 0, al_get_bitmap_width(bitmap), al_get_bitmap_height(bitmap),
	    position.x, position.y, scale.width, scale.height, 0);
}

- (void)drawAtPosition: (of_point_t)position
		region: (of_rectangle_t)region
		  tint: (ogk_color_t)tint
{
	al_draw_tinted_bitmap_region(bitmap, ogk_color_to_allegro(tint),
	    region.origin.x, region.origin.y, region.size.width,
	    region.size.height, position.x, position.y, 0);
}

- (void)drawAtPosition: (of_point_t)position
		region: (of_rectangle_t)region
		 scale: (of_dimension_t)scale
		  tint: (ogk_color_t)tint
{
	al_draw_tinted_scaled_bitmap(bitmap, ogk_color_to_allegro(tint),
	    region.origin.x, region.origin.y, region.size.width,
	    region.size.height, position.x, position.y, scale.width,
	    scale.height, 0);
}

- (ALLEGRO_BITMAP*)OGK_allegroBitmap
{
	return bitmap;
}
@end
