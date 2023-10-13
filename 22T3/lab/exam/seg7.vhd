LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY seg7 IS
	PORT (nibble : IN  STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			segments : OUT   STD_LOGIC_VECTOR(0 TO 6) ) ;
END seg7 ;

ARCHITECTURE Behavior OF seg7 IS  
BEGIN

	PROCESS ( nibble )
	BEGIN
		CASE nibble IS             --   0123456
			WHEN "0000" => segments <=  "0000001" ;
			WHEN "0001" => segments <=  "1001111" ;
			WHEN "0010" => segments <=  "0010010" ;
			WHEN "0011" => segments <=  "0000110" ;
			WHEN "0100" => segments <=  "1001100" ;
			WHEN "0101" => segments <=  "0100100" ;
			WHEN "0110" => segments <=  "0100000" ;
			WHEN "0111" => segments <=  "0001111" ;
			WHEN "1000" => segments <=  "0000000" ;
			WHEN "1001" => segments <=  "0000100" ;
			WHEN "1010" => segments <=  "0001000" ;
			WHEN "1011" => segments <=  "1100000" ;
			WHEN "1100" => segments <=  "0110001" ;
			WHEN "1101" => segments <=  "1000010" ;
			WHEN "1110" => segments <=  "0110000" ;
			WHEN "1111" => segments <=  "0111000" ;
			WHEN OTHERS => segments <=  "-------" ;
		END CASE ;
	END PROCESS ;
	
END Behavior ;

