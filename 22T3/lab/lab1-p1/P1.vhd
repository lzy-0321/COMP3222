LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY P1 IS
	PORT ( SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); 
END P1;

ARCHITECTURE Behavior OF P1 IS
BEGIN
	LEDR <= SW;
END Behavior;