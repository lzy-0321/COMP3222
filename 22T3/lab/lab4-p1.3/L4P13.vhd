LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY L4P13 IS
	PORT(	KEY: IN std_logic_vector(2 DOWNTO 0);
			SW: IN std_logic_vector(9 DOWNTO 0);
			HEX0: OUT std_logic_vector(0 TO 6);
			HEX1: OUT std_logic_vector(0 TO 6);
			HEX2: OUT std_logic_vector(0 TO 6);
			HEX3: OUT std_logic_vector(0 TO 6));
END L4P13;

ARCHITECTURE structural OF L4P13 IS
	COMPONENT T_ff IS
		PORT(	T, Clk, Clearn :IN	std_logic;
				Q 					: BUFFER std_logic);
	END COMPONENT;
	COMPONENT seg_7 IS
		PORT(	v :IN	std_logic_vector(3 DOWNTO 0);
				d : OUT std_logic_vector(0 TO 6));
	END COMPONENT;
	-- your signal declarations
	SIGNAL tempQ: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL T		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Clearn, E, Clk: STD_LOGIC;
BEGIN

	HEX2 <= "1111111"; -- blank higher order HEX displays
	HEX3 <= "1111111";
	
	-- your signal assignments to external pins 	
	CLk <= NOT key(0);
	Clearn <= SW(0);
	E <= SW(1);
	
	-- your VHDL code
	T0: T_FF PORT MAP(E,Clk,Clearn,tempQ(0));
	T(0) <= tempQ(0) AND E;
	T1: T_FF PORT MAP(T(0),Clk,clearn,tempQ(1));
	T(1) <= tempQ(1) AND T(0);
	T2: T_FF PORT MAP(T(1),Clk,Clearn,tempQ(2));
	T(2) <= tempQ(2) AND T(1);
	T3: T_FF PORT MAP(T(2),Clk,Clearn,tempQ(3));
	T(3)<= tempQ(3) AND T(2);
	T4: T_FF PORT MAP(T(3),Clk,Clearn,tempQ(4));
	T(4) <= tempQ(4) AND T(3);
	T5: T_FF PORT MAP(T(4),Clk,Clearn,tempQ(5));
	T(5) <= tempQ(5) AND T(4);
	T6: T_FF PORT MAP(T(5),Clk,Clearn,tempQ(6));
	T(6) <= tempQ(6) AND T(5);
	T7: T_FF PORT MAP(T(6),Clk,Clearn,tempQ(7));
	
	h0: seg_7 PORT MAP (tempQ(3 DOWNTO 0), HEX0);
	h1: seg_7 PORT MAP (tempQ(7 DOWNTO 4), HEX1);
END structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY T_ff IS
	PORT(	T, Clk, Clearn :IN	std_logic;
			Q : BUFFER std_logic);
END T_ff;

ARCHITECTURE behavioural OF T_ff IS
BEGIN

	-- your VHDL code from Part I Step 1
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

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY seg_7 IS
	PORT(	v :IN	std_logic_vector(3 DOWNTO 0);
			d : OUT std_logic_vector(0 TO 6));
END seg_7;

ARCHITECTURE behavioural OF seg_7 IS
BEGIN	
	PROCESS (v)
	BEGIN	
		CASE v IS             --0123456
			WHEN "0000" => d <= "0000001";
			WHEN "0001" => d <= "1001111";
			WHEN "0010" => d <= "0010010";
			WHEN "0011" => d <= "0000110";
			WHEN "0100" => d <= "1001100";
			WHEN "0101" => d <= "0100100";
			WHEN "0110" => d <= "0100000";
			WHEN "0111" => d <= "0001111";
			WHEN "1000" => d <= "0000000";
			WHEN "1001" => d <= "0001100";
			WHEN "1010" => d <= "0001000";
			WHEN "1011" => d <= "1100000";
			WHEN "1100" => d <= "0110001";
			WHEN "1101" => d <= "1000010";
			WHEN "1110" => d <= "0110000";
			WHEN "1111" => d <= "0111000";
			WHEN OTHERS => d <= "-------";
		END CASE;
	END PROCESS;
END behavioural;