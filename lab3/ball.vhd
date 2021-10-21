LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ball IS
	PORT (
		v_sync    : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		red       : OUT STD_LOGIC;
		green     : OUT STD_LOGIC;
		blue      : OUT STD_LOGIC;
		colorIn   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		movement  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		bkIn      : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ball;

ARCHITECTURE Behavioral OF ball IS
	CONSTANT size  : INTEGER := 8;
	SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is over current pixel position
	-- current ball position - intitialized to center of screen
	SIGNAL ball_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL ball_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	-- current ball motion - initialized to +4 pixels/frame
	SIGNAL ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
	SIGNAL ball_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := "00000000100";
BEGIN
	red    <= (colorIn(2) AND ball_on) OR (NOT ball_on AND bkIn(2)); -- color setup for user selectable on white background
	green  <= (colorIn(1) AND ball_on) OR (NOT ball_on AND bkIn(1));
	blue   <= (colorIn(0) AND ball_on) OR (NOT ball_on AND bkIn(0));
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= ball_x - size) AND
		 (pixel_col <= ball_x + size) AND
			 (pixel_row >= ball_y - size) AND
			 (pixel_row <= ball_y + size) THEN
				ball_on <= '1';
		ELSE
			ball_on <= '0';
		END IF;
		
		
		
		END PROCESS;
		-- process to move ball once every frame (i.e. once every vsync pulse)
		mball : PROCESS
		BEGIN
			WAIT UNTIL rising_edge(v_sync);
            IF (movement(1) = '1') then
		  IF (ball_y + size < 600) then
		      ball_y <= ball_y + "00000000100";
		  END IF;
		END IF;
		
		IF (movement(0) = '1') then
		  IF (ball_y > size) then
		      ball_y <= ball_y + "11111111100";
		  END IF;
		END IF;
		
		IF (movement(3) = '1') then
		  IF (ball_x + size < 800) then
		      ball_x <= ball_x + "00000000100";
		  END IF;
		END IF;
		
		IF (movement(2) = '1') then
		  IF (ball_x > size) then
		      ball_x <= ball_x + "11111111100";
		  END IF;
	   END IF;
		END PROCESS;
END Behavioral;

