LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.std_logic_arith.ALL;


ENTITY vga_top IS
    PORT (
        clk_in    : IN STD_LOGIC;
        vga_red   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_green : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_blue  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        vga_hsync : OUT STD_LOGIC;
        vga_vsync : OUT STD_LOGIC;
        bitsIn : IN std_logic_vector(7 DOWNTO 0)
        
    );
END vga_top;

ARCHITECTURE Behavioral OF vga_top IS
    SIGNAL pxl_clk : STD_LOGIC;
    SIGNAL pxX : std_logic_vector(10 DOWNTO 0);
    SIGNAL pxY : std_logic_vector(10 DOWNTO 0);
    -- internal signals to connect modules

    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN std_logic_vector(2 DOWNTO 0);
            green_in  : IN std_logic_vector(2 DOWNTO 0);
            blue_in   : IN std_logic_vector(1 DOWNTO 0);
            red_out   : OUT std_logic_vector (2 DOWNTO 0);
            green_out : OUT std_logic_vector (2 DOWNTO 0);
            blue_out  : OUT std_logic_vector (1 DOWNTO 0);
            hsync     : OUT STD_LOGIC;
            vsync     : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
            
        );
    END COMPONENT;
    
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
    SIGNAL colorOut : std_logic_vector(7 DOWNTO 0);
    SIGNAL COUNT : std_logic_vector(7 DOWNTO 0);
    CONSTANT A : std_logic_vector(63 DOWNTO 0) := "0001100000100100010000100100001001111110010000100100001001000010";
    

    SIGNAL boxX : integer := 0;
    SIGNAL boxY : integer := 0;
    SIGNAL pX : integer := 0;
    SIGNAL pY :integer := 0;
    
BEGIN 
    
    vga_driver : vga_sync
    PORT MAP(
        --instantiate vga_sync component
        pixel_clk => pxl_clk, 
        red_in    => colorOut(7 DOWNTO 5), 
        green_in  => colorOut(4 DOWNTO 2),
        blue_in   => colorOut(1 DOWNTO 0),
        red_out   => vga_red, 
        green_out => vga_green, 
        blue_out  => vga_blue, 
        hsync     => vga_hsync, 
        vsync     => vga_vsync,
        pixel_row => pxX,
        pixel_col => pxY
    );
    
    positiondec : boxpos
    PORT MAP(
        pixel_row => pxX,
        pixel_col => pxY,
        boxX => boxX,
        boxY => boxY,
        pixX => pX,
        pixY => pY
    );
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
    
    -- Box number is (10 DOWNTO 4), px number is (3 DOWNTO 0)
    
    
    ispx : PROCESS (pxX, pxY) IS 
    BEGIN
        if boxX = 5 and boxY = 5 then
            colorOut <= bitsIn;
            else
            if boxX = 10 and boxY = 10 then
            colorOut <= bitsIn;
            else
            colorOut <= "00000000";
        end if;
        end if;
    END PROCESS;
    
    END Behavioral;
