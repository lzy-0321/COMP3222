LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY lab3p5 IS
	PORT ( SW :IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			 key :IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			 LEDG :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 HEX0	:OUT STD_LOGIC_VECTOR(0 TO 6);
			 HEX1	:OUT STD_LOGIC_VECTOR(0 TO 6);
			 HEX2	:OUT STD_LOGIC_VECTOR(0 TO 6);
			 HEX3	:OUT STD_LOGIC_VECTOR(0 TO 6));
END lab3p5;

ARCHITECTURE structural of L3P5 IS
	
END structural;

-- For HEX
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SW_TO_HEX IS
	PORT	(B	:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			 H	:OUT STD_LOGIC_VECTOR(0 TO 6));
END SW_TO_HEX;

ARCHITECTURE logicfunc OF SW_TO_HEX IS
BEGIN
	PROCESS (B)
	BEGIN
		CASE B IS
			WHEN "0000" => H <= "0000001";
			WHEN "0001" => H <= "1001111";
			WHEN "0010" => H <= "0010010";
			WHEN "0011" => H <= "0000110";
			WHEN "0100" => H <= "1001100";
			WHEN "0101" => H <= "0100100";
			WHEN "0110" => H <= "1100000";
			WHEN "0111" => H <= "0001111";
			WHEN "1000" => H <= "0000000";
			WHEN "1001" => H <= "0001100";
			WHEN "1010" => H <= "0001000";
			WHEN "1011" => H <= "0000000";
			WHEN "1100" => H <= "0110001";
			WHEN "1101" => H <= "0000001";
			WHEN "1110" => H <= "0110000";
			WHEN "1111" => H <= "0111000";
		END CASE;
	END PROCESS;
END logicfunc;