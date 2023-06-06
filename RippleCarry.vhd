LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY RippleCarry IS
	PORT( 
		Cin : IN STD_LOGIC ;
		x: IN std_logic_vector(3 downto 0);
		y: IN std_logic_vector(3 downto 0);
		s: out std_logic_vector(3 downto 0);
		Cout : OUT STD_LOGIC
	);	
		
END RippleCarry;

ARCHITECTURE Logic OF RippleCarry IS
	SIGNAL c1, c2, c3: STD_LOGIC ;
	COMPONENT FullAdder
		PORT( 
			Cin, x, y : IN STD_LOGIC ;
			s, Cout : OUT STD_LOGIC ) ;
	END COMPONENT ;
BEGIN
f0: FullAdder PORT MAP ( Cin, x(0), y(0), s(0), c1 ) ;
f1: FullAdder PORT MAP ( c1, x(1), y(1), s(1), c2 ) ;
f2: FullAdder PORT MAP ( c2, x(2), y(2), s(2), c3 ) ;
f3: FullAdder PORT MAP ( c3, x(3), y(3), s(3), Cout );
END Logic;
