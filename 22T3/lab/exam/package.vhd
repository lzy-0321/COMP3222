library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package definitions is
		
	type DISPLAY_MSG_TYPE is 
		( disp_load,	-- display load message
		  disp_tv, 		-- display target value
		  disp_try,		-- display try message
		  disp_gv, 		-- display guess value
		  disp_hi, 		-- display hi message
		  disp_lo, 		-- display lo message
		  disp_fin		-- display finished message
		);

	component datapath is
	port (clk : in std_logic;
			resetn : in std_logic;
			num : in std_logic_vector(9 downto 0);
			dm : in DISPLAY_MSG_TYPE;
			disp0 : out std_logic_vector(0 to 6);
			disp1 : out std_logic_vector(0 to 6);
			disp2 : out std_logic_vector(0 to 6);
			disp3 : out std_logic_vector(0 to 6);

			-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE
			

		 );
	end component;

	component controlpath is  
	port (clk : in std_logic;
			resetn : in std_logic;
			loadn : in std_logic;
			dm : out DISPLAY_MSG_TYPE; 
			
			-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE
			try : in std_logic;
			Done : in std_logic;
			
			
		 );	  

	end component;

------------------------------------------------------------------------------------------
	-- DO NOT MODIFY THIS FILE BELOW THIS LINE !!!!!!!!!
	-- DO NOT MODIFY THIS FILE BELOW THIS LINE !!!!!!!!!
	-- DO NOT MODIFY THIS FILE BELOW THIS LINE !!!!!!!!!

	-- display message on 7-segment displays according to the display message type
	component display_controller is
	port (dm  : in DISPLAY_MSG_TYPE;						-- display message type
			count : in std_logic_vector(9 downto 0);	-- guess number
			target : in std_logic_vector(9 downto 0);	-- target value
			guess : in std_logic_vector(9 downto 0);	-- guess value
			disp0 : out std_logic_vector(0 to 6);		-- 7-seg displays
			disp1 : out std_logic_vector(0 to 6);
			disp2 : out std_logic_vector(0 to 6);
			disp3 : out std_logic_vector(0 to 6) );
	end component;

	-- converts 4-bit binary nibble to corresponding 7 segment display stimuli
	component seg7 is
    port (	nibble : IN  STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			segments : OUT   STD_LOGIC_VECTOR(0 TO 6) ) ;
    end component;

	-- converts 10-bit binary to 16-bit BCD value
	function to_bcd ( bin : std_logic_vector(9 downto 0) ) return std_logic_vector;
	-- used by display_controller component as follows:
	--   <bcd_bit_vector> <= to_bcd( binary_bit_vector );

end definitions;

package body definitions is

	-- description of to_bcd function
	function to_bcd ( bin : std_logic_vector(9 downto 0) ) return std_logic_vector is
	
		variable i : integer:=0;
		variable bcd : std_logic_vector(15 downto 0) := (others => '0');
		variable bint : std_logic_vector(9 downto 0) := bin;

	begin

		-- Use the Double Dabble algorithm (http://vhdlguru.blogspot.com.au/
		--   2010/04/8-bit-binary-to-bcd-converter-double.html):
		--
		-- shift the binary value to the left into the bcd value
		-- when any BCD digit value becomes > 4, add 3 to it so that
		--   carries are handled correctly after the next shift.
		
		for i in 0 to 9 loop  -- repeating 10 times.

			bcd(15 downto 1) := bcd(14 downto 0);  -- shift the bits.
			bcd(0) := bint(9);
			bint(9 downto 1) := bint(8 downto 0);
			bint(0) :='0';

			if(i < 9 and bcd(3 downto 0) > "0100") then -- add 3 if BCD digit > 4
				bcd(3 downto 0) := bcd(3 downto 0) + "0011";
			end if;

			if(i < 9 and bcd(7 downto 4) > "0100") then -- add 3 if BCD digit > 4
				bcd(7 downto 4) := bcd(7 downto 4) + "0011";
			end if;

			if(i < 9 and bcd(11 downto 8) > "0100") then  --add 3 if BCD digit > 4
				bcd(11 downto 8) := bcd(11 downto 8) + "0011";
			end if;

		end loop;
		
		return bcd;

	end to_bcd;

end definitions;