---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--
--	ADD YOUR NAME: 
-- ZiYao Lu
--	ADD YOUR STUDENT NUMBER: 
-- z5340468
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity hilo is
	port(	CLOCK_50 : in std_logic;						-- 50 MHz running clock
			SW : in std_logic_vector(9 downto 0);		-- input switches
			KEY : in std_logic_vector(1 downto 0);		-- input keys
			LEDG : out std_logic_vector(1 downto 0);	-- vet key presses
			HEX0 : out std_logic_vector(0 to 6);		-- 7-segment displays (rightmost - l.s.d.)
			HEX1 : out std_logic_vector(0 to 6);
			HEX2 : out std_logic_vector(0 to 6);
			HEX3 : out std_logic_vector(0 to 6)			-- 7-segment displays (leftmost - m.s.d.)
		 );	
end hilo;


architecture behaviour of hilo is

	signal clk : std_logic;
	signal resetn : std_logic;
	signal loadn : std_logic;
	signal num : std_logic_vector(9 downto 0);
	
	signal disp0 : std_logic_vector(0 to 6);
	signal disp1 : std_logic_vector(0 to 6);
	signal disp2 : std_logic_vector(0 to 6);
	signal disp3 : std_logic_vector(0 to 6);

	signal dm : DISPLAY_MSG_TYPE;	-- type defined in package.vhd

	-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE
	
	
begin

	clk <= CLOCK_50;
	resetn <= KEY(0);				-- active low reset ('0' when button depressed)
	loadn <= KEY(1);				-- active low load ('0' when button depressed)
	num <= SW(9 downto 0);		-- 10-bit binary input value
	
	LEDG(1) <= loadn;				-- vet inputs
	LEDG(0) <= resetn;

	HEX0 <= disp0;
	HEX1 <= disp1;
	HEX2 <= disp2;
	HEX3 <= disp3;
	
	d0: datapath port map (	
							clk => clk,
							resetn => resetn,
							num => num,
							dm => dm,
							disp0 => disp0,
							disp1 => disp1,
							disp2 => disp2,
							disp3 => disp3,
							
							-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE
							--
							-- UPDATE COMPONENT DECLARATION IN PACKAGE.VHD 
							-- TO CORRESPOND WITH YOUR ADDITIONS
							
							
						   );
	
	c0: controlpath port map (	
								clk => clk,
								resetn => resetn,
								loadn => loadn,
								dm => dm,
								
								-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE
								--
								-- UPDATE COMPONENT DECLARATION IN PACKAGE.VHD 
								-- TO CORRESPOND WITH YOUR ADDITIONS
								

							  );

end architecture;