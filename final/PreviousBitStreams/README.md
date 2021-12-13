Different stages of testing my project.

In order (Newest to oldest):

**newVGADriver**
Ability to write text to screen using the switches and directional pad. Press the center button to write the character.

**NewColors*
Initial test of expanded 4,096 colors VGA driver.

**Cursor**
Cursor on screen. Not very effecient, but it's there. Use Directonal pad left and right buttons to move (Must hold it in, updates position every cursor blink)

**AlphaNumeric**
Font now includes numbers. This test displays the available character set on screen, on line 1 in Green, and line 2 in Pink.

**ABC**
New text mapping. This bitstream contains text JKL at the top left and CBA at the bottom right, demonstrating the new mapping capabilities of the most updated bitstream.

**HelloWorld**
No hard coding of exact letters. Displays "Hello World" in a slightly ugly font.

**BoxColoringTest**
A test to see how well the box position decoding works. This test colors in the boxes 5,5 and 10,10.

**gridTestPattern**
A test bitstream to see the size of each box that will fit the font.
Wound up being a little smaller then anticipated, but I will keep this size.


