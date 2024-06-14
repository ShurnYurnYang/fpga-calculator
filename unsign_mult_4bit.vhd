library ieee;
use ieee.std_logic_1164.all;

entity unsign_mult_4bit is
	port(
		input_b : in std_logic_vector(3 downto 0);
		input_a : in std_logic_vector(3 downto 0);
		mult_out : out std_logic_vector(7 downto 0)
	);
end unsign_mult_4bit;

architecture mult_4bit of unsign_mult_4bit is

------COMPONENTS USED---------
	component full_adder_4bit port(
		input_a, input_b : in std_logic_vector(3 downto 0); --4bit inputs to add
		carry_in : in std_logic; --1bit carry input from external
		full_adder_sum_out : out std_logic_vector(3 downto 0); --4bit sum out from this full adder
		full_adder_carry_out : out std_logic --1bit carry out from this full adder
	);
	end component;
	
---------SIGNALS--------------
	signal b_and_a0 : std_logic_vector(3 downto 0);
	signal b_and_a1 : std_logic_vector(3 downto 0);
	signal sum_a0_a1 : std_logic_vector(3 downto 0);
	signal carry_a0_a1 : std_logic;
	
	signal carry_sum_a0_a1 : std_logic_Vector(3 downto 0);
	signal sum_a0_a1_a2 : std_logic_vector(3 downto 0);
	signal carry_a0_a1_a2 : std_logic;
	signal b_and_a2 : std_logic_vector(3 downto 0);
	
	signal carry_sum_a0_a1_a2 : std_logic_Vector(3 downto 0);
	signal b_and_a3 : std_logic_vector(3 downto 0);

begin

----------INSTANCES-----------
	INST1: full_adder_4bit port map(b_and_a0,b_and_a1,'0',sum_a0_a1,carry_a0_a1);
	INST2: full_adder_4bit port map(carry_sum_a0_a1,b_and_a2,'0',sum_a0_a1_a2,carry_a0_a1_a2);
	INST3: full_adder_4bit port map(carry_sum_a0_a1_a2,b_and_a3,'0',mult_out(6 downto 3),mult_out(7));

-------INTERMEDIATE LOGIC---------
	b_and_a0 <= '0' & (input_b(3 downto 1) AND (input_a(0) & input_a(0) & input_a(0)));
	b_and_a1 <= input_b AND (input_a(1) & input_a(1) & input_a(1) & input_a(1));
	
	carry_sum_a0_a1 <= carry_a0_a1 & sum_a0_a1(3 downto 1);
	b_and_a2 <= input_b AND (input_a(2) & input_a(2) & input_a(2) & input_a(2));
	
	carry_sum_a0_a1_a2 <= carry_a0_a1_a2 & sum_a0_a1_a2(3 downto 1);
	b_and_a3 <= input_b AND (input_a(3) & input_a(3) & input_a(3) & input_a(3));
	
--------OUTPUT LOGIC---------
	mult_out(0) <= input_b(0) AND input_a(0);
	mult_out(1) <= sum_a0_a1(0);
	mult_out(2) <= sum_a0_a1_a2(0);

end mult_4bit;