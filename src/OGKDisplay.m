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

@implementation OGKDisplay
+ (void)initialize
{
	if (self != [OGKDisplay class])
		return;

	if (!al_install_system(ALLEGRO_VERSION_INT, NULL))
		@throw [OFInitializationFailedException
		    exceptionWithClass: self];
}

- initWithSize: (of_dimension_t)size
      position: (of_point_t)position
    fullscreen: (BOOL)fullscreen
     resizable: (BOOL)resizable
{
	int flags = 0;

	self = [super init];

#if 0
	/* TODO: Find a nice way to set these when requested */
	flags |= ALLEGRO_OPENGL_3_0;
	flags |= ALLEGRO_OPENGL_FORWARD_COMPATIBLE;
#endif

	al_set_new_window_position(position.x, position.y);

	if (fullscreen)
		flags |= ALLEGRO_FULLSCREEN;
	else if (resizable)
		flags |= ALLEGRO_RESIZABLE;

	al_set_new_display_flags(flags);
	display = al_create_display(size.width, size.height);

	if (display == NULL)
		@throw [OFInitializationFailedException
		    exceptionWithClass: [self class]];

	return self;
}

- (void)dealloc
{
	if (display != NULL)
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
