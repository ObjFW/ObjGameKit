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

static OFMutex *mutex = nil;
static OFMutableArray *displays = nil;
static OFDataArray *allegroDisplays = nil;

@implementation OGKDisplay
+ (void)initialize
{
	if (self != [OGKDisplay class])
		return;

	if (!al_init())
		@throw [OFInitializationFailedException
		    exceptionWithClass: self];

	mutex = [[OFMutex alloc] init];
	displays = [[OFMutableArray alloc] init];
	allegroDisplays = [[OFDataArray alloc]
	    initWithItemSize: sizeof(ALLEGRO_DISPLAY*)];
}

+ OGK_displayForAllegroDisplay: (ALLEGRO_DISPLAY*)display
{
	[mutex lock];
	@try {
		ALLEGRO_DISPLAY **cArray = [allegroDisplays cArray];
		size_t i, count = [allegroDisplays count];

		for (i = 0; i < count; i++)
			if (cArray[i] == display)
				return displays[i];
	} @finally {
		[mutex unlock];
	}

	return nil;
}

- initWithSize: (of_dimension_t)size
      position: (of_point_t)position
	 flags: (ogk_display_flags_t)flags
{
	int allegroFlags = 0;

	self = [super init];

	if (isnan(position.x) || isnan(position.y))
		al_set_new_window_position(INT_MAX, INT_MAX);
	else
		al_set_new_window_position(position.x, position.y);

	if (flags & OGK_DISPLAY_FLAGS_FULLSCREEN)
		allegroFlags |= ALLEGRO_FULLSCREEN;
	if (flags & OGK_DISPLAY_FLAGS_RESIZABLE)
		allegroFlags |= ALLEGRO_RESIZABLE;
	if (flags & OGK_DISPLAY_FLAGS_OPENGL)
		allegroFlags |= ALLEGRO_OPENGL;
	if (flags & OGK_DISPLAY_FLAGS_OPENGL_3)
		allegroFlags |= ALLEGRO_OPENGL_3_0;
	if (flags & OGK_DISPLAY_FLAGS_OPENGL_3_ONLY)
		allegroFlags |= ALLEGRO_OPENGL_FORWARD_COMPATIBLE;

	if (flags & OGK_DISPLAY_FLAGS_VSYNC)
		al_set_new_display_option(ALLEGRO_VSYNC, 1, ALLEGRO_SUGGEST);
	else
		al_set_new_display_option(ALLEGRO_VSYNC, 0, ALLEGRO_SUGGEST);

	al_set_new_display_flags(allegroFlags);
	display = al_create_display(size.width, size.height);

	if (display == NULL)
		@throw [OFInitializationFailedException
		    exceptionWithClass: [self class]];

	[mutex lock];
	@try {
		[allegroDisplays addItem: &display];
		[displays addObject: self];
	} @finally {
		[mutex unlock];
	}

	return self;
}

- (void)dealloc
{
	[mutex lock];
	@try {
		size_t index = [displays indexOfObject: self];

		[allegroDisplays removeItemAtIndex: index];
		[displays removeObjectAtIndex: index];
	} @finally {
		[mutex unlock];
	}

	if (display != NULL && al_is_system_installed())
		al_destroy_display(display);
}

- (void)setWindowTitle: (OFString*)title
{
	al_set_window_title(display,
	    [title cStringWithEncoding: OF_STRING_ENCODING_NATIVE]);
}

- (void)setWindowPosition: (of_point_t)position
{
	al_set_window_position(display, position.x, position.y);
}

- (of_point_t)windowPosition
{
	int x, y;

	al_get_window_position(display, &x, &y);

	if (x == INT_MAX && y == INT_MAX)
		return of_point(NAN, NAN);

	return of_point(x, y);
}

- (void)setSize: (of_dimension_t)size
{
	al_resize_display(display, size.width, size.height);
}

- (of_dimension_t)size
{
	return of_dimension(
	    al_get_display_width(display),
	    al_get_display_height(display));
}

- (void)update
{
	al_flip_display();
}

- (ALLEGRO_DISPLAY*)OGK_allegroDisplay
{
	return display;
}
@end
