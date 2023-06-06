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
	sig_A, sig_B, sig_AB, sig_F: buffer std_logic_vector(3 downto 0);
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
signal car: std_logic_vector(1 to 3);

begin 
        st1: RippleCarry port map(cin, A, B, SOMA, car(1));			--SOMADOR
        st2: RippleCarry port map(cin, A, -B, SUBTRACAO, Cout);	--SUBTRATOR
		  
	process (s, SOMA, SUBTRACAO, C, N, f, A, B)
	
begin
   sig_AB(3) <= A(3) and B(3);			
	sig_A <= std_logic_vector(unsigned(A));
	sig_B <= std_logic_vector(unsigned(B));
	sig_f(3) <= F(3);
	
	if f = "0000" then			--LOGICA PARA O Z
		Z <= '1';
	else
		Z <= '0';
	end if;
	
	if s="00"then					--LOGICA PARA A SOMA
		if sig_AB(3) = '1' then		--LOGICA PARA O CARRY
			C <= '1';
		else
			C <= '0';
		end if;
	elsif s= "10"then			   --LOGICA PARA A SUBTRAÇÃO
		C <= '0';
		if sig_B - sig_A > "1000" then		--LOGICA PARA O N
			N <= '1';
			if sig_F(3) = '1' then
				N <= '1';
			else
				N <= '0';
			end if;
		else
			N <= '0';
		end if;
	else 
		N <= '0';
		C <= '0';
	end if;
	
	case s is
	
	when "00" => f <= SOMA;			--RESULTADOS COM BASE EM S
	
	when "01" => f <= (A and B);

	when "10" => f <= SUBTRACAO;
		
	when "11" => f <= (A or B);
	
	end case;
	
	end process;
	
end Logic;			--FIM DO PROGRAMA!
