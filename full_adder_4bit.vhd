

library ieee;
use ieee.std_logic_1164.all;

entity full_adder_4bit is
	port(
		input_a, input_b : in std_logic_vector(3 downto 0); --4bit inputs to add
		carry_in : in std_logic; --1bit carry input from external
		full_adder_sum_out : out std_logic_vector(3 downto 0); --4bit sum out from this full adder
		full_adder_carry_out : out std_logic --1bit carry out from this full adder
	);
end full_adder_4bit;

architecture full_add_4bit_logic of full_adder_4bit is

----------components used------------

----------full_adder_1bit------------

	component full_adder_1bit port( --1bit full adder
		input_a, input_b : in std_logic; --bits to add in adder
		carry_in : in std_logic; --carry in from external
		sum_out : out std_logic; --sum output of adder (1bit)
		carry_out : out std_logic --carry output of adder (1bit)
	);
	end component;
	
	signal carry_out0 : std_logic; --carry_out from first 1bit adder
	signal carry_out1 : std_logic; --carry_out from second 1bit adder
	signal carry_out2 : std_logic; --carry_out from third 1bit adder

begin
	
	INST1: full_adder_1bit port map(input_a(0),input_b(0),carry_in,full_adder_sum_out(0),carry_out0); --first digit | takes in external carry | sends carry to second digit
	INST2: full_adder_1bit port map(input_a(1),input_b(1),carry_out0,full_adder_sum_out(1),carry_out1); --second digit | takes in first carry | sends carry to third digit
	INST3: full_adder_1bit port map(input_a(2),input_b(2),carry_out1,full_adder_sum_out(2),carry_out2); --third digit | takes in second carry | sends carry to fourth digit
	INST4: full_adder_1bit port map(input_a(3),input_b(3),carry_out2,full_adder_sum_out(3),full_adder_carry_out); --fourth digit | takes in third carry | sends carry to carry out

end full_add_4bit_logic;