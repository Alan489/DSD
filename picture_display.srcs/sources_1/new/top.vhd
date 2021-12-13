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
    
    COMPONENT bmp IS 
        PORT (
            location : IN integer;
            bits : OUT std_logic_vector(11 DOWNTO 0)
            );
         END COMPONENT;
    
    component clk_wiz_0 is
    port (
      clk_in1  : in std_logic;
      clk_out1 : out std_logic
    );
    end component;
    
    SIGNAL colorOut : std_logic_vector(11 DOWNTO 0);
    SIGNAL pxl_clk : STD_LOGIC;
    SIGNAL S_vsync : std_logic;
    SIGNAL cursorB : integer;
    SIGNAL pxX: STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL pxY: STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL i: integer;
    SIGNAL px: std_logic_vector(11 DOWNTO 0);
BEGIN 
    

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
        pixel_row => pxY,
        pixel_col => pxX
    );
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
    
    i <= CONV_INTEGER(pxY) * 800 + CONV_INTEGER(pxX);
    
    bp : bmp
    port map(
        location => i,
        bits => colorOut
    );
    
    vga_vsync <= S_vsync;
    
    
    
    END Behavioral;
