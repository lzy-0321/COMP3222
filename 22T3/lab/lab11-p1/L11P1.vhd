LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned;

ENTITY L11P1 IS
	PORT( KEY		: IN	std_logic_vector(1 DOWNTO 0);
			SW 		: IN	std_logic_vector(8 DOWNTO 0);
			CLOCK_50	: IN	std_logic;
			LEDR		:OUT 	std_logic_vector(9 DOWNTO 0));
END L11P1;

ARCHITECTURE Behavior OF L11P1 IS
	COMPONENT shiftrne IS
		GENERIC ( N : INTEGER := 8 );
		PORT ( R : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				 LA, E, w : IN STD_LOGIC;
				 Clock : IN STD_LOGIC;
	 			 A : BUFFER STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
	
	TYPE state_t IS (S1, S2, S3, waitForNext);
	SIGNAL y_Q, y_D: state_t;
	SIGNAL A : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL B : INTEGER RANGE 0 to 8;
	SIGNAL LA, LB, z, EA, EB: std_logic;
	SIGNAL Clock, Resetn, Done, s, w : std_logic;
BEGIN
	Resetn <= KEY(0);
	Clock <= clock_50;
	w <= NOT KEY(1);
	s <= SW(8);
	
	FSM_transistions: PROCESS(w, y_Q)
	BEGIN
		CASE y_Q IS
			WHEN S1 =>
					IF s = '0' THEN y_D <= S1;
					ELSE y_D <= S2; 
					END IF;
			WHEN S2 =>
				IF (w = '1') THEN
					IF z = '0' THEN y_D <= S2;
					ELSE y_D <= S3; 
					END IF;
				ELSE y_D <= waitForNext;
				END IF;
			WHEN waitForNext =>
				IF (w = '1') THEN y_D <= waitForNext;
				ELSE y_D <= S2;
				END IF;
			WHEN S3 =>
				IF s = '1' THEN y_D <= S3;
				ELSE y_D <= S1; 
				END IF;
		END CASE;
	END PROCESS;
	
	FSM_state: PROCESS (Clock, Resetn)
			BEGIN
				IF (Resetn = '0') THEN
					y_Q <= S1;
				ELSIF (Clock'event AND Clock = '1') THEN
					y_Q <= Y_D;
				END IF;
			END PROCESS;
	
	FSM_outputs: PROCESS (y_Q, A(0))
		BEGIN
			LA <= '0'; LB <= '0'; EA <= '0'; EB <= '0'; Done <= '0';
			CASE y_Q IS
				WHEN S1 =>
					LA <= '1'; LB <= '1';
				WHEN S2 =>
					EA <= '1';
					IF A(0) = '1' THEN EB <= '1';
					END IF;
				WHEN waitForNext =>
					EA <= '0';
				WHEN S3 =>
					Done <= '1';
			END CASE;
		END PROCESS;
		
	upcount: PROCESS ( Resetn, Clock )
		BEGIN
			IF Resetn = '0' THEN
				B <= 0 ;
				ELSIF (Clock'EVENT AND Clock = '1') THEN
			IF LB = '1' THEN
				B <= 0 ;
				ELSIF EB = '1' THEN 
				B <= B + 1 ;
			END IF ;
		END IF;
	END PROCESS;
	
	z <= '1' WHEN A = "00000000" ELSE '0';
	ShiftA: shiftrne GENERIC MAP (N =>8)
		PORT MAP (SW(7 DOWNTO 0), LA, EA, '0', Clock, A);
	LEDR(9) <= Done;
	
	LEDR(3 DOWNTO 0) <=
		"0000" WHEN B = 0 ELSE
		"0001" WHEN B = 1 ELSE
		"0010" WHEN B = 2 ELSE
		"0011" WHEN B = 3 ELSE
		"0100" WHEN B = 4 ELSE
		"0101" WHEN B = 5 ELSE
		"0110" WHEN B = 6 ELSE
		"0111" WHEN B = 7 ELSE
		"1000" WHEN B = 8;
END behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned;
ENTITY shiftrne IS
	GENERIC (N: INTEGER := 8);
	PORT ( R: IN std_logic_vector(N-1 DOWNTO 0);
			LA, E, w: IN std_logic;
			Clock : IN STD_LOGIC ;
			A: BUFFER std_logic_vector(N-1 DOWNTO 0));
END shiftrne;

ARCHITECTURE shift of shiftrne IS
BEGIN
	PROCESS
	BEGIN
		WAIT UNTIL (rising_edge(Clock));
		IF (LA = '1') THEN A <= R;
		ELSE
			IF (E = '1') THEN 
				Genbits: FOR i in 0 to N-2 LOOP
					A(i) <= A( i + 1 );
				END LOOP;
				A(N-1) <= w;
			END IF;
		END IF;
	END PROCESS;
END shift;	