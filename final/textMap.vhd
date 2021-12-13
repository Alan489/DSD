--Alan Decowski
--CPE 487
--2021F
--textMap.vhd
--DESC: Responsible for the handling of holding characters in memory.

--ACCEPTS: CharIn, cursor, post, cursorDis
--CharIn: The currently selected character (At time of documentation, selected using binary form with front switches)
--cursor: The box number (Taken from boxY*100 + boxX to get a unique number) that the user currently has selected.
--post: Signal from the center button of the D-Pad. Tells textMap to save the currently selected "CharIn" into memory at location "cursor"
--cursorDis: The current box number that is being drawn on screen.

--RETURNS:
--OT (for "out"): The character code currently in memory at the box number that is currently being displayed

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;


entity textMap is
 Port ( 
    OT : OUT integer;
    CharIn : IN integer;
    cursor :IN integer;
    post : IN std_logic;
    cursorDis : IN integer
 );
end textMap;

architecture Behavioral of textMap is
CONSTANT maxCharID : integer := 36;
type integer_vector is array (natural range <>) of integer; --Had to redefine integer_vector for some reason.
--7499) := (others => 0); --Full list of characters on the screen.
begin

       --TM(0 TO 99) <= (20,8,5,0,6,9,20,14,5,19,19,7,18,1,13,0,16,1,3,5,18,0,20,5,19,20,0,9,19,0,1,0,13,21,12,20,9,19,20,1,7,5,0,1,5,18,15,2,9,3,0,3,1,16,1,3,9,20,25,0,20,5,19,20, others => 0); -- THE FITNESSGRAM PACER TEST IS A MULTISTAGE AEROBIC CAPACITY TEST
       --TM(100 TO 199) <= (20,8,1,20,0,16,18,15,7,18,5,19,19,9,22,5,12,25,0,7,5,20,19,0,13,15,18,5,0,4,9,6,6,9,3,21,12,20,0,1,19,0,9,20,0,3,15,14,20,9,14,21,5,19,0, others => 0); -- THAT PROGRESSIVELY GETS MORE DIFFICULT AS IT CONTINUES.
       --TM(200 TO 299) <= (20,8,5,0,28,36,0,13,5,20,5,18,0,16,1,3,5,18,0,20,5,19,20,0,23,9,12,12,0,2,5,7,9,14,0,9,14,0,29,36,0,19,5,3,15,14,4,19,0, others => 0); -- THE 20 METER PACER TEST WILL BEGIN IN 30 SECONDS.
       
       assignment : process IS
       variable TM : integer_vector (0 to 199) := (others => 0);
       
       begin
        if (post = '1') then
            TM(cursor) := CharIn;
        end if;
        if cursorDis < 200 then
            OT <= TM(cursorDis);
        else
            OT <= 0;
        end if;
        
       end process;
end Behavioral;

