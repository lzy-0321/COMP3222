LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY part1 IS
	PORT (SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			KEY : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
END part1;

ARCHITECTURE Behavior OF part1 IS
	-- declare components
	COMPONENT dec3to8 IS
		PORT (W : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				En : IN STD_LOGIC;
				Y : OUT STD_LOGIC_VECTOR(0 TO 7));
	END COMPONENT;
	
	COMPONENT regn IS
		GENERIC (N : INTEGER := 9);
		PORT (R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
				Rin, Clock : IN STD_LOGIC;
				Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;
	
	-- declare signals
	TYPE State_type IS (T0, T1, T2, T3);
	SIGNAL Tstep_Q, Tstep_D: State_type;
	SIGNAL R0,R1,R2,R3,R4,R5,R6,R7,IR,A,G,AddsubOut: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL Rin, Rout, Xreg, Yreg: STD_LOGIC_VECTOR(0 TO 7);
	SIGNAL I: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL IRin,Ain,Gout,Gin,DINout,Hi,AddSub: STD_LOGIC;
	SIGNAL DIN : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL Resetn, Clock, Run : STD_LOGIC;
	SIGNAL Done : STD_LOGIC;
	SIGNAL BusWires : STD_LOGIC_VECTOR(8 DOWNTO 0);
	--
BEGIN
	DIN <= SW(8 DOWNTO 0);
	Run <= SW(9);
	Resetn <= KEY(0);
	Clock <= KEY(1);
	LEDR(9) <= Done;
	LEDR(8 DOWNTO 0) <= BusWires;
	
	Hi <= '1';
	I <= IR(8 DOWNTO 6);
	decX: dec3to8 PORT MAP (IR(5 DOWNTO 3), Hi, Xreg);
	decY: dec3to8 PORT MAP (IR(2 DOWNTO 0), Hi, Yreg);

	statetable: PROCESS (Tstep_Q, Run, Done)
	BEGIN
		CASE Tstep_Q IS
			WHEN T0 => -- data is loaded into IR in this time step
				IF (Run = '0') THEN
					Tstep_D <= T0;
				ELSE 
					Tstep_D <= T1;
				END IF;
			-- other states 
			WHEN T1 =>
				IF (Done = '0') THEN
					Tstep_D <= T2;
				ELSE 
					Tstep_D <= T0;
				END IF;
			WHEN T2 => 
				Tstep_D <= T3;
			WHEN T3 =>
				Tstep_D <= T0;
		END CASE;
	END PROCESS;

	controlsignals: PROCESS (Tstep_Q, I, Xreg, Yreg)
	BEGIN
		-- specify initial values
		IRin <= '0'; 
		Rout <= (OTHERS => '0'); 
		Rin <= (OTHERS => '0'); 
		Done <= '0';
		DINout <= '0'; 
		Ain <= '0'; 
		Gin <= '0'; 
		AddSub <= '0'; 
		Gout <= '0';
		CASE Tstep_Q IS
			WHEN T0 => -- store DIN in IR as long as Tstep_Q = 0
				IRin <= '1';
			WHEN T1 => -- define signals in time step T1
				CASE I IS
					WHEN "000" => -- mv
						Rout <= Yreg;
						Rin <= Xreg;
						Done <= '1';
					WHEN "001" => -- mvi
						DINout <= '1';
						Rin <= Xreg;
						Done <= '1';
					WHEN "010" => -- add
						Rout <= Xreg;
						Ain <= '1';
					WHEN "011" => -- sub
						Rout <= Xreg;
						Ain <= '1';
					WHEN OTHERS =>
				---
				END CASE;
			WHEN T2 => -- define signals in time step T2
				CASE I IS
					WHEN "010" => -- add
						Rout <= Yreg;
						Gin <= '1';
					WHEN "011" => -- sub
						Rout <= Yreg;
						Gin <= '1';
						AddSub <= '1';
					WHEN OTHERS =>
				---
				END CASE;
			WHEN T3 => -- define signals in time step T3
				CASE I IS
					WHEN "010" => -- add
						Gout <= '1';
						Rin <= Xreg;
						Done <= '1';
					WHEN "011" => -- sub
						Gout <= '1';
						Rin <= Xreg;
						Done <= '1';
					WHEN OTHERS =>
				---
				END CASE;
		END CASE;
	END PROCESS;

	fsmflipflops: PROCESS (Clock, Resetn)
	BEGIN
		---
		IF (Resetn = '0') THEN
			Tstep_Q <= T0;
		ELSIF rising_edge(Clock) THEN
			Tstep_Q <= Tstep_D;
		END IF;
	END PROCESS;
	
	-- instantiate registers and the adder/subtracter unit
	reg_0: regn PORT MAP (BusWires, Rin(0), Clock, R0);
	reg_1: regn PORT MAP (BusWires, Rin(1), Clock, R1);
	reg_2: regn PORT MAP (BusWires, Rin(2), Clock, R2);
	reg_3: regn PORT MAP (BusWires, Rin(3), Clock, R3);
	reg_4: regn PORT MAP (BusWires, Rin(4), Clock, R4);
	reg_5: regn PORT MAP (BusWires, Rin(5), Clock, R5);
	reg_6: regn PORT MAP (BusWires, Rin(6), Clock, R6);
	reg_7: regn PORT MAP (BusWires, Rin(7), Clock, R7);
	IR_reg: regn PORT MAP (DIN, IRin, Clock, IR);
	A_reg: regn PORT MAP (BusWires, Ain, Clock, A);
	G_reg: regn PORT MAP (AddsubOut, Gin, Clock, G);
	
	-- define the bus
	BusWires <= 
				 R0  WHEN Rout = "10000000" ELSE
				 R1  WHEN Rout = "01000000" ELSE
				 R2  WHEN Rout = "00100000" ELSE
				 R3  WHEN Rout = "00010000" ELSE
				 R4  WHEN Rout = "00001000" ELSE
				 R5  WHEN Rout = "00000100" ELSE
				 R6  WHEN Rout = "00000010" ELSE
				 R7  WHEN Rout = "00000001" ELSE
				 DIN WHEN DINout = '1' ELSE
				 G   WHEN Gout = '1' ELSE
				 DIN; 
	WITH AddSub SELECT
	AddsubOut <= (A + BusWires) WHEN '0',
			(A - BusWires) WHEN '1';

END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dec3to8 IS
	PORT (W : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			En : IN STD_LOGIC;
			Y : OUT STD_LOGIC_VECTOR(0 TO 7));
END dec3to8;

ARCHITECTURE Behavior OF dec3to8 IS
BEGIN
	PROCESS (W, En)
	BEGIN
		IF (En = '1') THEN
			CASE W IS
				WHEN "000" => Y <= "10000000";
				WHEN "001" => Y <= "01000000";
				WHEN "010" => Y <= "00100000";
				WHEN "011" => Y <= "00010000";
				WHEN "100" => Y <= "00001000";
				WHEN "101" => Y <= "00000100";
				WHEN "110" => Y <= "00000010";
				WHEN "111" => Y <= "00000001";
			END CASE;
		ELSE
			Y <= "00000000";
		END IF;
	END PROCESS;
END Behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regn IS
	GENERIC (n : INTEGER := 9);
	PORT (R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			Rin, Clock : IN STD_LOGIC;
			Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END regn;

ARCHITECTURE Behavior OF regn IS
BEGIN
	PROCESS (Clock)
	BEGIN
		IF (rising_edge(Clock)) THEN
			IF (Rin = '1') THEN
				Q <= R;
			END IF;
		END IF;
	END PROCESS;
END Behavior;