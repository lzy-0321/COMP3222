LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lab3p2b IS
	PORT( sw :IN	std_logic_vector(9 DOWNTO 0);
			LEDG : OUT std_logic_vector(9 DOWNTO 0));
END lab3p2b;

ARCHITECTURE structural OF lab3p2b IS
	COMPONENT lab3p2a IS
		PORT( Clk, D :IN std_logic;
				Q : OUT std_logic);
	END COMPONENT;
BEGIN
	latch: lab3p2a PORT MAP	(SW(1), SW(0), LEDG(0));
END structural;