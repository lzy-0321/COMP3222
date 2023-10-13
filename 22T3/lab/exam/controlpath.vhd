library IEEE;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity controlpath is
	port (clk : in std_logic;
			resetn : in std_logic;
			loadn : in std_logic;
			dm : out DISPLAY_MSG_TYPE; 
			
			-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE
			--
			-- UPDATE COMPONENT DECLARATION IN PACKAGE.VHD 
			-- TO CORRESPOND WITH YOUR ADDITIONS
			
			
		  );	  
end controlpath;

architecture behaviour of controlpath is

	-- ADD YOUR SIGNALS AS NEEDED BELOW THIS LINE
	signal dm : DISPLAY_MSG_TYPE;
	TYPE State_type IS : (s0, s1, s2, s3);
	signal start, run, finish : State_type;
begin
	DONE <= 0;
	-- ADD YOUR CONTROL PATH DESCRIPTION AS NEEDED BELOW THIS LINE
	statetable: PROCESS (start, try)
	CASE start IS
		WHEN s0 =>
			IF loadn = '1' THEN
				run = s1;
		WHEN s1 => 
			IF loadn = '1' THEN
				try = 1;
				run = s1;
			ELSE 
				run = s2;
		WHEN s2 =>
		WHEN s3 =>
		END CASE;
	END PROCESS;
		
	
	fsmflipflops: PROCESS (clk, resetn)
	BEGIN
		---
		IF (Resetn = '0') THEN
			start <= s0;
		ELSIF rising_edge(clk) THEN
			start <= run;
		END IF;
	END PROCESS;
end behaviour;