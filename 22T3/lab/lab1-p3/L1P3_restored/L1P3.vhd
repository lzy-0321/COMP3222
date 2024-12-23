LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY L1P3 IS
	PORT(	SW	:IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			LEDG	:OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END L1P3;

ARCHITECTURE behaviour OF L1P3 IS
	SIGNAL U, V, W, M, N	:STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL s :STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
	LEDG(9 DOWNTO 2) <= "00000000";
	LEDG(1 DOWNTO 0) <= M;
	
	U <= SW(5 DOWNTO 4);
	V <= SW(3 DOWNTO 2);
	W <= SW(1 DOWNTO 0);
	s <= SW(9 DOWNTO 8);
	
	N(0) <= (NOT S(0) AND U(0)) OR (S(0) AND V(0)); -- expression involving elements of s, U and V
	N(1) <= (NOT S(0) AND U(1)) OR (S(0) AND V(1)); -- ""
	M(0) <= (NOT S(1) AND N(0)) OR (S(1) AND W(0)); -- expression involving elements of s, N and W
	M(1) <= (NOT S(1) AND N(1)) OR (S(1) AND W(1)); -- ""
END behaviour;
