LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;

ENTITY L11P2 IS
	PORT(	Clock, Resetn	: IN STD_LOGIC ;
			s					: IN STD_LOGIC ;
			Data 				: IN STD_LOGIC_VECTOR(7 DOWNTO 0) ;
			Addr 				: OUT STD_LOGIC_VECTOR(4 DOWNTO 0) ;
			Found				: OUT STD_LOGIC ;
			Done 				: OUT STD_LOGIC ) ;
END L11P2 ;

ARCHITECTURE Behavior OF L11P2 IS
	COMPONENT memory_block IS -- model used latches address and data internally, hence 2-cycle delay
		PORT(	address	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
				clock		: IN STD_LOGIC ;
				data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				wren		: IN STD_LOGIC ;
				q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
	END COMPONENT;
	COMPONENT regne IS
		GENERIC ( N : INTEGER := 8 ) ;
		PORT(	D 			: IN 		STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;
				E		 	: IN 		STD_LOGIC ;
				Resetn	: IN		STD_LOGIC;
				Clock 	: IN 		STD_LOGIC ;
				Q 			: OUT 	STD_LOGIC_VECTOR(N-1 DOWNTO 0) ) ;
	END COMPONENT;
	
	-- any other components
	
	TYPE State_type IS (start, s1, s2, s3, s4, s5, s6); -- your states
	SIGNAL y, y_next : State_type ;
	
	SIGNAL guess: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL sum, min, max: STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL guess_value, target : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL ED: STD_LOGIC;
BEGIN

	-- your code
	Addr <= guess;		
	FSM_transistions: PROCESS (y, y_next, min, max)
	BEGIN
		CASE y IS
			WHEN start =>
				y_next <= s1;
			WHEN s1 =>
				IF s = '1' THEN y_next <= s2;
				ELSE y_next <= s1;
				END IF;
			WHEN s2 =>
				y_next <= s3;
			WHEN s3 =>
				IF guess_value = target THEN
					y_next <= s4;
				ELSE
					y_next <= s5;
				END IF;
			WHEN s4 =>
				IF s = '1' THEN y_next <= s4;
				ELSE y_next <= s1;
				END IF;	
			WHEN s5 =>
				IF min = "100000" OR max = "111111" THEN
					y_next <= s6;
				ELSIF min > max THEN
					y_next <= s6;
				ELSE 
					y_next <= s3;
				END IF;
			WHEN s6 =>
				IF s = '1' THEN y_next <= s6;
				ELSE y_next <= s1;
				END IF;
		END CASE;
	END PROCESS;
	
	FSM_state: PROCESS(Clock, Resetn, s)
	BEGIN
		IF Resetn = '0' THEN
			y <= start;
		ELSIF (rising_edge(Clock)) THEN
			y <= y_next;
		END IF;
	END PROCESS;
	
	FSM_outputs: PROCESS(y)
	BEGIN
		ED <= '0'; Done <= '0'; Found <= '0';
		CASE y IS
			WHEN start =>
			WHEN s1 =>
				ED <= '1';
			WHEN s2 =>
				min <= "000000";
				max <= "011111";
			WHEN s3 =>
				sum <= min + max;
 				guess <= sum(5 DOWNTO 1);
			WHEN s4 =>
				Done <= '1';
				Found <= '1';
			WHEN s5 =>
				IF guess_value > target THEN
					max <= ('0' & guess) - 1;
				ELSE 
					min <= ('0' & guess) + 1;
				END IF;
			WHEN s6 =>
				Done <= '1';
		END CASE;
	END PROCESS;	
				
	-- Loads data when ED is enabled
	loaddata: regne GENERIC MAP (N => 8)
				  PORT MAP (Data, ED, Resetn, Clock, target);
	
	mem_blk: memory_block
		PORT MAP (	address => guess,-- your_search_addr,
						clock => Clock,
						data => "00000000", -- not writing
						wren => '0', -- not writing
						q => guess_value);--your_returned_data 

	

END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- n-bit register with synchronous reset and enable
ENTITY regne IS
	GENERIC ( N : INTEGER := 8 ) ;
	PORT(	D 			: IN 		STD_LOGIC_VECTOR(N-1 DOWNTO 0) ;
			E		 	: IN 		STD_LOGIC ;
			Resetn	: IN		STD_LOGIC;
			Clock 	: IN 		STD_LOGIC ;
			Q 			: OUT 	STD_LOGIC_VECTOR(N-1 DOWNTO 0) ) ;
END regne ;

ARCHITECTURE Behavior OF regne IS
BEGIN
	PROCESS
	BEGIN
		WAIT UNTIL (Clock'EVENT AND Clock = '1') ;
		IF (Resetn = '0') THEN
			Q <= (OTHERS => '0');
		ELSIF (E = '1') THEN
			Q <= D;
		END IF ;
	END PROCESS ;
END Behavior ;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned;
ENTITY shiftrne IS
	GENERIC (N: INTEGER := 8);
	PORT (Data: IN std_logic_vector(N-1 DOWNTO 0);
			LA, EM, v, Clk: IN std_logic;
			A: BUFFER std_logic_vector(N-1 DOWNTO 0));
END shiftrne;

ARCHITECTURE shift of shiftrne IS
BEGIN
	PROCESS
	BEGIN
		WAIT UNTIL (rising_edge(Clk));
		IF (LA = '1') THEN A <= Data;
		ELSE
			IF (EM = '1') THEN 
				Genbits: FOR i in 0 to N-2 LOOP
					A(i) <= A(i+1);
				END LOOP;
				A(N-1) <= v;
			END IF;
		END IF;
	END PROCESS;
END shift;