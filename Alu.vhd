LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Alu is
port(
	s: in std_logic_vector(1 downto 0);
	A, B: in std_logic_vector(3 downto 0);
	f: buffer std_logic_vector(3 downto 0);
	cin: in std_logic;
	Cout: out std_logic;
	s1: buffer std_logic_vector(1 downto 0);
	sig_AB, sig_F: buffer std_logic_vector(3 downto 0);
	C, Z, V, N: buffer std_logic
	);
end Alu;

architecture Logic of Alu is 

	component RippleCarry
		PORT( 
		Cin : IN STD_LOGIC ;
		x: IN std_logic_vector(3 downto 0);
		y: IN std_logic_vector(3 downto 0);
		s: out std_logic_vector(3 downto 0);
		Cout : OUT STD_LOGIC 
		);
		end component;
		
		component RippleCarryNEG
		PORT( 
		Cin : IN STD_LOGIC ;
		x: IN std_logic_vector(3 downto 0);
		y: IN std_logic_vector(3 downto 0);
		s: out std_logic_vector(3 downto 0);
		Cout : OUT STD_LOGIC 
		);
		end component;
		
signal SOMA: std_logic_vector(3 downto 0);
signal SUBTRACAO: std_logic_vector(3 downto 0);
signal car: std_logic_vector(1 to 3);

begin 
        st1: RippleCarry port map(cin, A, B, SOMA, car(1));
        st2: RippleCarry port map(cin, A, -B, SUBTRACAO, Cout);
		  
	process (s, SOMA, SUBTRACAO, C, N, f, A, B)
begin
   sig_AB(3) <= A(3) and B(3);
	sig_f(3) <= F(3);
	
	if f = "0000" then
		Z <= '1';
	else
		Z <= '0';
	end if;
	
	if s="00"then
		if sig_AB(3) = '1' then
			C <= '1';
		else
			C <= '0';
		end if;
	elsif s= "10"then
		C <= '0';
		if sig_F(3) = '1' then
			N <= '1';
		else
			N <= '0';
		end if;
	else 
		N <= '0';
		C <= '0';
	end if;
	
	case s is
	
	when "00" => f <= SOMA;
	
	when "01" => f <= (A and B);

	when "10" => f <= SUBTRACAO;
		
	when "11" => f <= (A or B);
	
	end case;
	
	end process;
