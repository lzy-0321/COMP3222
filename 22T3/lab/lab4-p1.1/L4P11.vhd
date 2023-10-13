LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY L4P11 IS
	PORT(	E, Clk, Clearn: IN std_logic;
			Q				  : BUFFER std_logic_vector(7 DOWNTO 0));
END L4P11;

ARCHITECTURE structural OF L4P11 IS
	COMPONENT T_ff IS
		PORT(	T, Clk, Clearn :IN	std_logic;
				Q 					: BUFFER std_logic);
	END COMPONENT;
	-- your signal definitions
	SIGNAL tempQ: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL T		: STD_LOGIC_VECTOR(8 DOWNTO 0);
BEGIN
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
	Q <= tempQ;
END structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY T_ff IS
	PORT(	T, Clk, Clearn :IN	std_logic;
			Q 					: BUFFER std_logic);
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