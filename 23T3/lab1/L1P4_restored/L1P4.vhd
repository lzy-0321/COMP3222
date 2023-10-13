LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY L1P4 IS
	PORT(	SW	:IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			HEX0	:OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END L1P4;

ARCHITECTURE behaviour OF L1P4 IS
	SIGNAL c :STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
	c <= SW(1 DOWNTO 0);

	HEX0(0) <= NOT C(0) OR C(1);-- logical expression involving c(1) and c(0)
	HEX0(1) <= C(0);-- ""
	HEX0(2) <= C(0);-- ""
	HEX0(3) <= C(1);-- ""
	HEX0(4) <= C(1);-- ""
	HEX0(5) <= NOT C(0) OR C(1);-- ""
	HEX0(6) <= C(1);-- ""
END behaviour;
