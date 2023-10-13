LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY L4P11 IS
	PORT(	E, Clk, Clearn: IN std_logic;
			Q : BUFFER std_logic_vector(7 DOWNTO 0));
END L4P11;

ARCHITECTURE structural OF L4P11 IS
	COMPONENT T_ff IS
		PORT(	T, Clk, Clearn :IN	std_logic;
				Q : BUFFER std_logic);
	END COMPONENT;
	-- your signal definitions
	signal Q_temp : std_logic_vector(7 DOWNTO 0));
	signal temp : std_logic_vector(7 DOWNTO 0));
BEGIN
	-- your VHDL code
	temp0: T_ff port map (E, clk, clearn, Q_temp(0));
	temp(0) <= Q_temp(0) and E;
	
	temp1: T_ff port map (temp(0), clk, clearn, Q_temp(1));
	temp(1) <= Q_temp(1) and temp(0);
	
	temp2: T_ff port map (temp(1), clk, clearn, Q_temp(2));
	temp(2) <= Q_temp(2) and temp(1);
	
	temp3: T_ff port map (temp(2), clk, clearn, Q_temp(3));
	temp(3) <= Q_temp(3) and temp(2);
	
	temp4: T_ff port map (temp(3), clk, clearn, Q_temp(4));
	temp(4) <= Q_temp(4) and temp(3);
	
	temp5: T_ff port map (temp(4), clk, clearn, Q_temp(5));
	temp(5) <= Q_temp(5) and temp(4);
	
	temp6: T_ff port map (temp(5), clk, clearn, Q_temp(6));
	temp(6) <= Q_temp(6) and temp(5);
	
	temp7: T_ff port map (temp(6), clk, clearn, Q_temp(7));

	Q <= Q_temp;
END structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY T_ff IS
	PORT(	T, Clk, Clearn :IN	std_logic;
			Q : BUFFER std_logic);
END T_ff;

ARCHITECTURE behavioural OF T_ff IS
BEGIN
	-- your VHDL code
	PROCESS (Clearn, Clk)
	BEGIN
		IF (Clearn = '0') THEN
			Q <= '0';
		ELSIF (CLK'EVENT AND CLK = '1') THEN
			IF (T = '1') THEN
				Q <= NOT Q;
			ELSE
				Q <= Q;
			END IF;
		END IF;
	END PROCESS;
END behavioural;