--Alan Decowski
--CPE 487
--2021F
--vga_top.vhd

--Top level.
--
--Accepts: clk_in, SW, inputR..C
--clk_in: Clock signal from clk_wiz_0
--SW: Front switches equating to one byte. Used as input for character codes.
--inputR..C: Directional controls for D-Pad. Cursor position updates as the cursor flashes on, as such the user must be holding the cursor button to see the cursor move, not very eligant but best I could come up with for now. May be patched.

--Outputs:
--vga_red/green/blue/hsync/vsync: VGA related commands to interface with the VGA port on the board. Allows for 4,096 colors, ironically not used.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.std_logic_arith.ALL;


ENTITY vga_top IS
    PORT (
        clk_in    : IN STD_LOGIC;
        vga_red   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        vga_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        vga_blue  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        vga_hsync : OUT STD_LOGIC;
        vga_vsync : OUT STD_LOGIC;
        SW : IN std_logic_vector(7 DOWNTO 0);
        inputR : IN std_logic;
        inputL : IN std_logic;
        inputU : IN std_logic;
        inputD : IN std_logic;
        inputC : IN std_logic
        
    );
END vga_top;

ARCHITECTURE Behavioral OF vga_top IS
   
    -- internal signals to connect modules

    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN std_logic_vector(3 DOWNTO 0);
            green_in  : IN std_logic_vector(3 DOWNTO 0);
            blue_in   : IN std_logic_vector(3 DOWNTO 0);
            red_out   : OUT std_logic_vector (3 DOWNTO 0);
            green_out : OUT std_logic_vector (3 DOWNTO 0);
            blue_out  : OUT std_logic_vector (3 DOWNTO 0);
            hsync     : OUT STD_LOGIC;
            vsync     : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
            
        );
    END COMPONENT;
    
    component textMap IS
        PORT (
            OT : OUT integer;
            charIn : IN integer;
            cursor : IN integer;
            post : in std_logic;
            cursorDis : in integer
        );
     END component;
    
    component font is
    Port ( 
        char : IN integer;
        bits : OUT std_logic_vector(63 DOWNTO 0)
    );
    end component; 
    
    COMPONENT boxpos is
        PORT (
            pixel_row : IN std_logic_vector (10 DOWNTO 0);
            pixel_col : IN std_logic_vector (10 DOWNTO 0);
            boxX : OUT integer;
            boxY : OUT integer;
            pixX : OUT integer;
            pixY : OUT integer
            );
    END COMPONENT;
    
    component clk_wiz_0 is
    port (
      clk_in1  : in std_logic;
      clk_out1 : out std_logic
    );
    end component;
    
    SIGNAL colorOut : std_logic_vector(11 DOWNTO 0);
    SIGNAL COUNT : std_logic_vector(7 DOWNTO 0);
    SIGNAL A : std_logic_vector(63 DOWNTO 0) := "0011110001000010010000100100001001111100010000100100001001111100";
    SIGNAL J : integer := 1;
    SIGNAL pxl_clk : STD_LOGIC;
    SIGNAL pxX : std_logic_vector(10 DOWNTO 0);
    SIGNAL pxY : std_logic_vector(10 DOWNTO 0);
    SIGNAL boxX : integer := 0;
    SIGNAL boxY : integer := 0;
    SIGNAL pX : integer := 0;
    SIGNAL pY :integer := 0;
    SIGNAL cursorPos : integer := 0;
    SIGNAL cursorDis : std_logic := '0';
    SIGNAL debounce : std_logic := '0';
    SIGNAL S_vsync : std_logic;
    SIGNAL cursorB : integer;
    SIGNAL S_char : integer;
BEGIN 
    
    --J <= conv_integer(unsigned(SW));
    positiondec : boxpos
    PORT MAP(
        pixel_row => pxX,
        pixel_col => pxY,
        boxX => boxX,
        boxY => boxY,
        pixX => pX,
        pixY => pY
    );
    
    cursorB <= boxY*100 + boxX;
    
    getPX : textMap
    PORT MAP(
        OT => J,
        CharIn => conv_integer(unsigned(SW)),
        post => inputC,
        cursor => cursorPos,
        cursorDis => cursorB
    );
    
    vga_driver : vga_sync
    PORT MAP(
        --instantiate vga_sync component
        pixel_clk => pxl_clk, 
        red_in    => colorOut(11 DOWNTO 8), 
        green_in  => colorOut(7 DOWNTO 4),
        blue_in   => colorOut(3 DOWNTO 0),
        red_out   => vga_red, 
        green_out => vga_green, 
        blue_out  => vga_blue, 
        hsync     => vga_hsync, 
        vsync     => S_vsync,
        pixel_row => pxX,
        pixel_col => pxY
    );
    
    S_char <= conv_integer(unsigned(SW)) WHEN (boxX + boxY*100 = cursorPos and cursorDis = '1') ELSE
              36 WHEN 
               (boxX+boxY*100 = 300) or
               (boxX+boxY*100 = 301) or
               (boxX+boxY*100 = 303) or
               (boxX+boxY*100 = 304) or
               (boxX+boxY*100 = 306) or
               (boxX+boxY*100 = 307) else
           37 WHEN 
               (boxX+boxY*100 = 302) or
               (boxX+boxY*100 = 305) else
              J;
    
    fontdecode : font
    PORT MAP(
         char =>  S_char,
         bits => A
        
    );
    
    
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
    
    
    vga_vsync <= S_vsync;
    
    cursorP : PROCESS IS
    variable frame_count : integer;
    BEGIN
        WAIT UNTIL rising_edge(S_vsync);
        frame_count := frame_count +1;
        
        if (frame_count = 16) then
            cursorDis <= '1';
        end if;
        if (frame_count = 31) then
            cursorDis <= '0';
            frame_count := 0;
            if (inputR = '1') then
                cursorPos <= cursorPos +1;
                if cursorPos > 299 then
                    cursorPos <= 0;
                end if;
            end if;
            if (inputL = '1') then
                if cursorPos = 0 then
                    cursorPos <= 299;
                else
                    cursorPos <= cursorPos-1;
                end if;
            end if;
            if (inputU = '1') then
                if cursorPos < 99 then
                    cursorPos <= 100+cursorPos;
                else
                    cursorPos <= cursorPos+100;
                end if;
            end if;
            if (inputD = '1') then
                if cursorPos > 299 then
                    cursorPos <= cursorPos-200;
                else
                    cursorPos <= cursorPos+100;
                end if;
            end if;
        end if;
    END PROCESS;
    
    
    
    -- Box number is (10 DOWNTO 4), px number is (3 DOWNTO 0)
    
    
    ispx : PROCESS (pxX, pxY, cursorDis) IS 
    begin
        
        
        if A(63-(pY*8+pX) DOWNTO 63-(pY*8+pX)) = "1" then
            colorOut <= "000000000000";
        else
            colorOut <= "111111111111";
        end if;
        
        if (cursorDis = '1' and boxX + boxY*100 = cursorPos) then
            --J <= conv_integer(unsigned(SW));
            if A(63-(pY*8+pX) DOWNTO 63-(pY*8+pX)) = "1" then
                colorOut <= "111111110000";
                else
                colorOut <= "000000000000";
            end if;
        end if;
        
        if (boxY > 3) then
            colorOut <= "010001000100";
        end if;
        
        
        
    END PROCESS;
    
    END Behavioral;
