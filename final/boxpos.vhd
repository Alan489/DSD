--Alan Decowski
--CPE 487
--2021F
--boxpos.vhd
--ACCEPTS: pixel_row, pixel_col
--pixel_row, pixel_col: FROM: VGA driver; The current pixel being processed on screen.

--RETURNS: boxX, boxY, pixX, pixY
--boxX, boxY: The X,Y coordinate of an 8x8 box displayed VIA VGA that the currently drawn pixel is located within.
--pixX, pixY: The pixel that is currently being drawn within the current box.

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.std_logic_arith.ALL;


entity boxpos is
 Port ( 
 pixel_row : IN std_logic_vector (10 DOWNTO 0);
 pixel_col : IN std_logic_vector (10 DOWNTO 0);
 boxX : OUT integer;
 boxY : OUT integer;
 pixX : OUT integer;
 pixY : OUT integer
 );
end boxpos;

architecture Behavioral of boxpos is
begin
        getData : PROCESS (pixel_row, pixel_col)
        begin 
            boxX <= conv_integer(unsigned(pixel_col(10 DOWNTO 3)));
            boxY <= CONV_INTEGER(UNSIGNED(pixel_row(10 DOWNTO 3)));
            pixX <= CONV_INTEGER(UNSIGNED(pixel_col(2 DOWNTO 0)));
            pixY <= CONV_INTEGER(UNSIGNED(pixel_row(2 DOWNTO 0)));
        end process;


end Behavioral;
