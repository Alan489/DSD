Stevens Institute of Technology
CPE-487

Lab 3

Modifications from stock lab code:

Overview--

Color selection: Right three switches control RGB of square, second 3 switches from the right control background color
Movement: Use D pad buttons on board to move the square around the screen. Square will stay within bounds.
Slightly better VGA handling: Colors will appear brighter, using all bits of the colors instead of just the Most Significant. Just makes the image brighter.
Clock: One line in the clock code threw an error about not being a perfect multiple. This line was fixed.


Specific modifications:
vga_top.vhd: 
	Added ColorSelect, bkSelect and move data vectors for new input handling
	Removed setting least signficant bits to 0 prior to passing to vga-sync.

ball.vhd:
	Changed color handling to allow for background/foreground color selection.
	Changed movement code to allow for user input for movement.

vga_sync.vhd:
	Changed to output all 0's or all 1's on colors. Creates a brighter image. Still only allows for 8 colors
