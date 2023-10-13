LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY L3P5 IS
	PORT ( SW :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 key :IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			 LEDG :OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			 HEX0	:OUT STD_LOGIC_VECTOR(0 TO 6);
			 HEX1	:OUT STD_LOGIC_VECTOR(0 TO 6);
			 HEX2	:OUT STD_LOGIC_VECTOR(0 TO 6);
			 HEX3	:OUT STD_LOGIC_VECTOR(0 TO 6));
END L3P5;

ARCHITECTURE structural of L3P5 IS

	COMPONENT D_FlipFlop IS
		PORT(
			Resetn, CLK : IN STD_LOGIC;
			D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT HEX IS
		PORT (B	: IN std_logic_vector(3 DOWNTO 0);
				H	: OUT std_logic_vector(0 TO 6));
	END COMPONENT;
	

	SIGNAL D, QA, QB: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Resetn, CLK, S: STD_LOGIC;

BEGIN 
	Resetn <= KEY(0);
	CLK <= KEY(1);
	QB <= SW(7 DOWNTO 0);

	FlipFlop: D_FlipFlop PORT MAP (Resetn, CLK, QB, QA);
	
	M0:HEX PORT MAP (QA(3 DOWNTO 0), HEX2);
	M1:HEX PORT MAP (QA(7 DOWNTO 4), HEX3);
		
	M2:HEX PORT MAP (QB(3 DOWNTO 0), HEX0);
	M3:HEX PORT MAP (QB(7 DOWNTO 4), HEX1);
	
	-- Handling the LEDG
    PROCESS(key)
    BEGIN
        IF key(0) = '1' THEN
            LEDG(0) <= '1';
		  ELSE 
				LEDG(0) <= '0';
        END IF;
        IF key(1) = '1' THEN
            LEDG(1) <= '0';
		  ELSE
				LEDG(1) <= '1';
        END IF;
    END PROCESS;
	
END structural;

-- FOR D_FlipFlop

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY D_FlipFlop IS
	PORT(
		Resetn, CLK : IN STD_LOGIC;
		D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END D_FlipFlop;

ARCHITECTURE behavior OF D_FlipFlop IS
BEGIN 
	PROCESS(Resetn, CLK)
	BEGIN 
		IF Resetn = '0' THEN
			Q <= "00000000";
		ELSIF CLK'EVENT AND CLK = '1' THEN
			Q <= D;
		END IF;
	END PROCESS;
END behavior;


-- For HEX
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY HEX IS
	PORT	(B	:IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
			 H	:OUT STD_LOGIC_VECTOR(0 TO 6));
END HEX;

ARCHITECTURE logicfunc OF HEX IS
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