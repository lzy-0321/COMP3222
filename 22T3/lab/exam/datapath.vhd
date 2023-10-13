library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.definitions.all;

entity datapath is
	port (clk : in std_logic;
			resetn : in std_logic;
			num : in std_logic_vector(9 downto 0);
			dm : in DISPLAY_MSG_TYPE;
			disp0 : out std_logic_vector(0 to 6);
			disp1 : out std_logic_vector(0 to 6);
			disp2 : out std_logic_vector(0 to 6);
			disp3 : out std_logic_vector(0 to 6);

			-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE
			--
			-- UPDATE COMPONENT DECLARATION IN PACKAGE.VHD 
			-- TO CORRESPOND WITH YOUR ADDITIONS

			
		  );
end datapath;

architecture behaviour of datapath is

	-- DO NOT MODIFY THE FOLLOWING SIGNAL DECLARATIONS
	
	signal count: std_logic_vector(9 downto 0);		-- guess number
	signal target: std_logic_vector(9 downto 0);		-- target value
	signal guess: std_logic_vector(9 downto 0);		-- guess value

	-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE


begin

	-- DO NOT MODIFY THE FOLLOWING INSTANTIATED COMPONENT
	-- display message on 7-segment displays according to the display message type
	dc: display_controller port map ( 
										dm => dm,				-- display message type
										count => count,		-- guess number
										target => target,		-- target value
										guess => guess,		-- guess value
										disp0 => disp0,		-- 7-seg displays
										disp1 => disp1,
										disp2 => disp2,
										disp3 => disp3 );
	
	-- ADD YOUR DATAPATH DESCRIPTION AS NEEDED BELOW THIS LINE

	
end behaviour;