This is a module to allow the use of the fringe to indicate locations
relative to the bounds of the buffer.  rfringe = "relative fringe".

In emacs, displaying fringe indicators is done via text overlays. In
that way, bitmaps in the fringe are attached to the lines of text
shown in the buffer window.

This works nicely when the fringe is used to indicate information
that is relevant to the adjacent line; for example, text overflow, or
something similar. But, there isn't a simple way for an application
or module to use the fringe to display buffer-relative information -
for example, the location of compiler error messages.

In fact, using the fringe to communicate this kind of information -
buffer-relative positions - is probably more intuitive and is
certainly more useful for the user. For example, consider the
scrollbar. The position and size of the scrollbar indicates to the
user the position and size of the current window relative to the
entire buffer. This is information that cound not be easily or
appropriately conveyed within the visual text. The fringe is
perfectly suited for this purpose.

Along those lines, a useful integration of fringe with flymake would
be to use fringe bitmaps visually indicate the position of all
flymake errors and warnings in the buffer, relative to the beginning
and end of the buffer. A quick glance at the fringe would give a
visual indication of the number of errors or warnings and their
approximate positions.

Likewise, a diff mode might want to display fringe indicators for the
number and approximate relative position of differences.

Doing this is not simple, because of the dependency of fringe bitmaps
on text overlays that I described above.  To use the fringe to
communicate information regarding buffer-relative positions requires
a transformation from "buffer position" to "window position".  And
this transformation must be re-computed each time a window scrolls or
changes size.

This module addresses that need, and provides that transformation. It
allows you to set an indicator that is buffer-relative in the fringe;
the indicator automatically redisplays if the window changes size, or
scrolls.

Examples:

1. In the simplest case, you can use rfringe to provide a visual
   indicator of the top of the region in the buffer, like so:

      (rfringe-show-region)

   To turn off the indicator, do this:

      (rfringe-hide-region)


2. You can also use rfringe to display a set of indicators,
   corresponding to a set of locations in the buffer. These might be
   the locations of compiler errors, or section beginnings, or
   whatever you like.

      (setq posns '(79 1000 2000 3000 4000 5000 6000 9000 10000))
      (mapc 'rfringe-create-relative-indicator posns)

   As you scroll through the buffer, the indicators in the fringe remain fixed.

   To remove the indicators, do this:

      (rfringe-remove-managed-indicators)

   By default, rfringe defines advice to extend flymake to display
   indicators this way.  This is not the only intended use of rfringe.el,
   but it is a good example.
