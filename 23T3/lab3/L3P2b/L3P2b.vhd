LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY L3P2b IS
	PORT( sw :IN	std_logic_vector(9 DOWNTO 0);
			LEDG : OUT std_logic_vector(9 DOWNTO 0));
END L3P2b;

ARCHITECTURE structural OF L3P2b IS
	COMPONENT L3P2a IS
		PORT( Clk, D :IN std_logic;
				Q : OUT std_logic);
	END COMPONENT;
BEGIN
	latch: L3P2a PORT MAP	(SW(1), SW(0), LEDG(0));
END structural;