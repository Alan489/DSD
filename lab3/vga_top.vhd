LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY vga_top IS
    PORT (
        clk_in    : IN STD_LOGIC;
        vga_red   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_green : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        vga_blue  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        vga_hsync : OUT STD_LOGIC;
        vga_vsync : OUT STD_LOGIC;
        colorSelect: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        bkSelect: IN std_logic_vector(2 DOWNTO 0);
        -- move[0] = Up/M18
        -- move[1] = Down/P18
        -- move[2] = Left/P17
        -- move[3] = Right/M17
        move: IN STD_LOGIC_VECTOR (3 DOWNTO 0)
        
    );
END vga_top;

ARCHITECTURE Behavioral OF vga_top IS
    SIGNAL pxl_clk : STD_LOGIC;
    -- internal signals to connect modules
    SIGNAL S_red, S_green, S_blue : STD_LOGIC;
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    COMPONENT ball IS
        PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC;
            colorIn  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            movement : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            bkIn: IN std_logic_vector(2 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC;
            green_in  : IN STD_LOGIC;
            blue_in   : IN STD_LOGIC;
            red_out   : OUT std_logic_vector (2 DOWNTO 0);
            green_out : OUT std_logic_vector (2 DOWNTO 0);
            blue_out  : OUT std_logic_vector (1 DOWNTO 0);
            hsync     : OUT STD_LOGIC;
            vsync     : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;
    
    component clk_wiz_0 is
    port (
      clk_in1  : in std_logic;
      clk_out1 : out std_logic
    );
    end component;
    
    
BEGIN
    -- vga_driver only drives MSB of red, green & blue
    -- so set other bits to zero
    

    add_ball : ball
    PORT MAP(
        --instantiate ball component
        v_sync    => S_vsync, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        red       => S_red, 
        green     => S_green, 
        blue      => S_blue,
        colorIn   => colorSelect,
        movement  => move,
        bkIn => bkSelect
    );

    --vga_red(1 DOWNTO 0) <= "00";
    --vga_green(1 DOWNTO 0) <= "00";
    --vga_blue(0) <= '0';

    vga_driver : vga_sync
    PORT MAP(
        --instantiate vga_sync component
        pixel_clk => pxl_clk, 
        red_in    => S_red, 
        green_in  => S_green, 
        blue_in   => S_blue, 
        red_out   => vga_red, 
        green_out => vga_green, 
        blue_out  => vga_blue, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        hsync     => vga_hsync, 
        vsync     => S_vsync
    );
    vga_vsync <= S_vsync; --connect output vsync
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
    
END Behavioral;

