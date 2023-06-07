LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity Alu is		--DECLARAÇÃO DAS ENTRADAS E SAÍDAS DA ULA
port(
	s: in std_logic_vector(1 downto 0);
	A, B: in std_logic_vector(3 downto 0);
	F: buffer std_logic_vector(3 downto 0);
	cin: in std_logic;
	Cout: out std_logic;
	s1: buffer std_logic_vector(1 downto 0);
	AND_AB, OR_AB, sig_F: buffer std_logic_vector(3 downto 0);
	C, Z, V, N: buffer std_logic
	);
end Alu;

architecture Logic of Alu is 

	component RippleCarry
		PORT( 					--DECLARAÇÃO DAS ENTRADAS E SAÍDAS DO COMPONENTE DO RIPPLECARRY
		Cin : IN STD_LOGIC ;
		x: IN std_logic_vector(3 downto 0);
		y: IN std_logic_vector(3 downto 0);
		s: out std_logic_vector(3 downto 0);
		Cout : OUT STD_LOGIC 
		);
		end component;
		
signal SOMA: std_logic_vector(3 downto 0);				--DECLARAÇÃO DA SOMA E DA SUBTRAÇÃO E DO CARRY
signal SUBTRACAO: std_logic_vector(3 downto 0);			--PARA O PORT MAP DO RIPPLE CARRY
signal car: std_logic_vector(1 to 4);

begin 
        SOMADOR: RippleCarry port map(cin, A, B, SOMA, car(1));			--SOMADOR
        SUBTRATOR: RippleCarry port map(cin, A, -B, SUBTRACAO, Cout);	--SUBTRATOR
		  
	process (s, SOMA, SUBTRACAO, C, N, f, A, B)
	
begin
   AND_AB(3) <= A(3) and B(3);
	OR_AB(3) <= A(3) OR B (3);	
	sig_f(3) <= F(3);
	
	N <= F(3);
	
	if s="00"then					--LOGICA PARA OVERFLOW NA SOMA
		if OR_AB(3) /= sig_F(3) then
			V <= '1';
		else
			V <= '0';
		end if;
	elsif s="10"then	--LOGICA PARA OVERFLOW NA SUBTRAÇÃO
		V <= '0';
		if AND_AB(3) /= sig_F(3) then
			V <= '1';
		else
			V <= '0';
		end if;
	else
		V <= '0';
	end if;
	
	case s is
	
	when "00" => f <= SOMA;			--OPERAÇÕES REALIZADAS COM BASE NO VALOR DE F
	
	when "01" => f <= (A and B);

	when "10" => f <= SUBTRACAO;
		
	when "11" => f <= (A or B);
	
	end case;
	
	end process;
	
	with f select			--LOGICA PARA O Z
	Z <= '1' when "0000",
		  '0' when others;
		  
	with s select			--LOGICA PARA O CARRYOUT (C)
	C <= AND_AB(3) when "00",
		  '0' when others;
		  
end Logic;			--FIM DO PROGRAMA!
