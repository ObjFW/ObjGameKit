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

#import "OGKEventQueue.h"
#import "OGKEvent.h"
#import "OGKDisplay.h"

static int keyboard_retain_count = 0;
static int mouse_retain_count = 0;

@implementation OGKEventQueue
@synthesize delegate;

+ (void)initialize
{
	if (self != [OGKEventQueue class])
		return;

	if (!al_install_system(ALLEGRO_VERSION_INT, NULL))
		@throw [OFInitializationFailedException
		    exceptionWithClass: self];
}

- init
{
	self = [super init];

	eventQueue = al_create_event_queue();

	return self;
}

- (void)dealloc
{
	al_destroy_event_queue(eventQueue);
}

- (void)handleNextEvent
{
	OGKEvent *event = [[OGKEvent alloc] init];
	ALLEGRO_EVENT *allegroEvent = [event OGK_allegroEvent];

	while (al_get_next_event(eventQueue, allegroEvent)) {
		switch (allegroEvent->type) {
		case ALLEGRO_EVENT_DISPLAY_CLOSE:
			object_setClass(event, [OGKCloseEvent class]);

			if ([delegate respondsToSelector:
			    @selector(display:wasClosed:)]) {
				OGKDisplay *display = [OGKDisplay
				    OGK_displayForAllegroDisplay:
				    allegroEvent->display.source];
				OGKCloseEvent *closeEvent =
				    (OGKCloseEvent*)event;

				[delegate display: display
					wasClosed: closeEvent];
			}

			break;
		case ALLEGRO_EVENT_KEY_DOWN:
			object_setClass(event, [OGKKeyPressEvent class]);

			if ([delegate respondsToSelector:
			    @selector(keyWasPressed:display:)]) {
				OGKDisplay *display = [OGKDisplay
				    OGK_displayForAllegroDisplay:
				    allegroEvent->keyboard.display];
				OGKKeyPressEvent *keyPressEvent =
				    (OGKKeyPressEvent*)event;

				[delegate keyWasPressed: keyPressEvent
						display: display];
			}

			break;
		case ALLEGRO_EVENT_KEY_UP:
			object_setClass(event, [OGKKeyReleaseEvent class]);

			if ([delegate respondsToSelector:
			    @selector(keyWasReleased:display:)]) {
				OGKDisplay *display = [OGKDisplay
				    OGK_displayForAllegroDisplay:
				    allegroEvent->keyboard.display];
				OGKKeyReleaseEvent *keyReleaseEvent =
				    (OGKKeyReleaseEvent*)event;

				[delegate keyWasReleased: keyReleaseEvent
						 display: display];
			}

			break;
		case ALLEGRO_EVENT_MOUSE_AXES:
			object_setClass(event, [OGKMouseMovedEvent class]);

			if ([delegate respondsToSelector:
			    @selector(mouseWasMoved:display:)]) {
				OGKDisplay *display = [OGKDisplay
				    OGK_displayForAllegroDisplay:
				    allegroEvent->mouse.display];
				OGKMouseMovedEvent *mouseMovedEvent =
				    (OGKMouseMovedEvent*)event;

				[delegate mouseWasMoved: mouseMovedEvent
						display: display];
			}

			break;
		case ALLEGRO_EVENT_MOUSE_BUTTON_DOWN:
			object_setClass(event,
			    [OGKMouseButtonPressedEvent class]);

			if ([delegate respondsToSelector:
			    @selector(mouseButtonWasPressed:display:)]) {
				OGKDisplay *display = [OGKDisplay
				    OGK_displayForAllegroDisplay:
				    allegroEvent->mouse.display];
				OGKMouseButtonPressedEvent *pressedEvent =
				    (OGKMouseButtonPressedEvent*)event;

				[delegate mouseButtonWasPressed: pressedEvent
							display: display];
			}

			break;
		case ALLEGRO_EVENT_MOUSE_BUTTON_UP:
			object_setClass(event,
			    [OGKMouseButtonReleasedEvent class]);

			if ([delegate respondsToSelector:
			    @selector(mouseButtonWasReleased:display:)]) {
				OGKDisplay *display = [OGKDisplay
				    OGK_displayForAllegroDisplay:
				    allegroEvent->mouse.display];
				OGKMouseButtonReleasedEvent *releasedEvent =
				    (OGKMouseButtonReleasedEvent*)event;

				[delegate mouseButtonWasReleased: releasedEvent
							 display: display];
			}

			break;
		}
	}
}

- (void)registerDisplay: (OGKDisplay*)display
{
	ALLEGRO_EVENT_SOURCE *eventSource;

	eventSource = al_get_display_event_source([display OGK_allegroDisplay]);
	al_register_event_source(eventQueue, eventSource);
}

- (void)unregisterDisplay: (OGKDisplay*)display
{
	ALLEGRO_EVENT_SOURCE *eventSource;

	eventSource = al_get_display_event_source([display OGK_allegroDisplay]);
	al_unregister_event_source(eventQueue, eventSource);
}

- (void)registerKeyboard
{
	of_atomic_inc_int(&keyboard_retain_count);

	if (!al_is_keyboard_installed())
		if (!al_install_keyboard())
			@throw [OFInitializationFailedException
			    exceptionWithClass: [self class]];

	al_register_event_source(eventQueue, al_get_keyboard_event_source());
}

- (void)unregisterKeyboard
{
	al_unregister_event_source(eventQueue, al_get_keyboard_event_source());

	if (of_atomic_dec_int(&keyboard_retain_count) == 0)
		al_uninstall_keyboard();
}

- (void)registerMouse
{
	of_atomic_inc_int(&mouse_retain_count);

	if (!al_is_mouse_installed())
		if (!al_install_mouse())
			@throw [OFInitializationFailedException
			    exceptionWithClass: [self class]];

	al_register_event_source(eventQueue, al_get_mouse_event_source());
}

- (void)unregisterMouse
{
	al_unregister_event_source(eventQueue, al_get_mouse_event_source());

	if (of_atomic_dec_int(&mouse_retain_count))
		al_uninstall_mouse();
}
@end
