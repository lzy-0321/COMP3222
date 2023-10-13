LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lab3p2a IS
	PORT(	Clk, D :IN	std_logic;
			Q 		 :OUT std_logic);
END lab3p2a;

ARCHITECTURE structural OF lab3p2a IS
	SIGNAL R, R_g, S_g, Qa, Qb : std_logic;
	ATTRIBUTE keep : boolean;
	ATTRIBUTE keep of R, R_g, S_g, Qa, Qb : SIGNAL IS true;
BEGIN

	-- your VHDL logic expressions for R, R_g, S-g, Qa, Qb and Q
	R   <= NOT D;
	S_g <= D NAND Clk;
	R_g <= R NAND Clk;
	Qa  <= S_g NAND Qb;
	Qb  <= R_g NAND Qa;
	Q   <= Qa;
END structural;