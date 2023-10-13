----------------------------------------------------------------------------------------
--  DO NOT MODIFY THIS FILE !!!!!
--  DO NOT MODIFY THIS FILE !!!!!
--  DO NOT MODIFY THIS FILE !!!!!
----------------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.definitions.all;

entity display_controller is
	port (dm : in DISPLAY_MSG_TYPE;						-- message type
			count : in std_logic_vector(9 downto 0);	-- guess number
			target : in std_logic_vector(9 downto 0);	-- target value
			guess : in std_logic_vector(9 downto 0);	-- guess value
			disp0 : out std_logic_vector(0 to 6);		-- 7-segment displays
			disp1 : out std_logic_vector(0 to 6);
			disp2 : out std_logic_vector(0 to 6);
			disp3 : out std_logic_vector(0 to 6) );
end display_controller;

architecture behavior of display_controller is

	signal bcd_count, bcd_target, bcd_guess: std_logic_vector(15 downto 0);
	signal dc0, dc1, dt0, dt1, dt2, dt3, dg0, dg1, dg2, dg3: std_logic_vector(0 to 6);

begin

	-- convert binary values to 4 BCD digits 
	bcd_count <= to_bcd(count);
	bcd_target <= to_bcd(target);
	bcd_guess <= to_bcd(guess);
	
	-- convert the 2 least significant digits of bcd_count to 7-segment display stimuli
	-- NOTE: only count to 99 
	c0: seg7 port map (	nibble => bcd_count(3 downto 0),
						segments => dc0 );
	c1: seg7 port map (	nibble => bcd_count(7 downto 4),
						segments => dc1 );
						
	-- convert the digits of the bcd_target value to 7-segment display stimuli
	t0: seg7 port map (	nibble => bcd_target(3 downto 0),
						segments => dt0 );
	t1: seg7 port map (	nibble => bcd_target(7 downto 4),
						segments => dt1 );
	t2: seg7 port map (	nibble => bcd_target(11 downto 8),
						segments => dt2 );
	t3: seg7 port map (	nibble => bcd_target(15 downto 12),
						segments => dt3 );
						
	-- convert the digits of the bcd_guess value to 7-segment display stimuli
	g0: seg7 port map (	nibble => bcd_guess(3 downto 0),
						segments => dg0 );
	g1: seg7 port map (	nibble => bcd_guess(7 downto 4),
						segments => dg1 );
	g2: seg7 port map (	nibble => bcd_guess(11 downto 8),
						segments => dg2 );
	g3: seg7 port map (	nibble => bcd_guess(15 downto 12),
						segments => dg3 );
	
	-- setup the 4 display outputs based on the display message type
	disp_process: process(dm, dc0, dc1, dt0, dt1, dt2, dt3, dg0, dg1, dg2, dg3)
	begin
		case dm is
			when disp_load => -- display "LoAd"
				--       "0123456"
				disp3 <= "1110001";
				disp2 <= "1100010";
				disp1 <= "0001000";
				disp0 <= "1000010";
			when disp_try => -- display "trY"
				disp3 <= "1110000";
				disp2 <= "1111010";
				disp1 <= "1001100";
				disp0 <= "1111111";
			when disp_hi => -- display "Hinn", nn = count
				disp3 <= "1001000";
				disp2 <= "1111011";
				disp1 <= dc1;
				disp0 <= dc0;
			when disp_lo => -- display "Lonn", nn = count
				disp3 <= "1110001";
				disp2 <= "1100010";
				disp1 <= dc1;
				disp0 <= dc0;
			when disp_fin => -- display "FSnn", FS = finish symbol, nn = count
				disp3 <= "1100010";
				disp2 <= "0011100";
				disp1 <= dc1;
				disp0 <= dc0;
			when disp_tv => -- display target value
				disp3 <= dt3;
				disp2 <= dt2;
				disp1 <= dt1;
				disp0 <= dt0;
			when disp_gv => -- display guess value
				disp3 <= dg3;
				disp2 <= dg2;
				disp1 <= dg1;
				disp0 <= dg0;
		end case;
	end process;
	
end behavior;