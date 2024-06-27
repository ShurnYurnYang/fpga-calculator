library ieee;
use ieee.std_logic_1164.all;

entity full_adder_5bit is
	port(
		input_a, input_b : in std_logic_vector(4 downto 0); --5bit inputs to add
		carry_in : in std_logic; --1bit carry input from external
		full_adder_sum_out : out std_logic_vector(4 downto 0); --5bit sum out from this full adder
		full_adder_carry_out : out std_logic --1bit carry out from this full adder
	);
end full_adder_5bit;

architecture full_add_5bit_logic of full_adder_5bit is

	component full_adder_1bit port(
		input_a, input_b : in std_logic; --two 1bit inputs
		carry_in : in std_logic; --carry in from external
		sum_out : out std_logic; --sum out
		carry_out : out std_logic --carry out
	);
	end component;
	
	signal carry : std_logic_vector(3 downto 0);
	
begin

	BIT0: full_adder_1bit port map(input_a(0),input_b(0),carry_in,full_adder_sum_out(0),carry(0));
	BIT1: full_adder_1bit port map(input_a(1),input_b(1),carry(0),full_adder_sum_out(1),carry(1));
	BIT2: full_adder_1bit port map(input_a(2),input_b(2),carry(1),full_adder_sum_out(2),carry(2));
	BIT3: full_adder_1bit port map(input_a(3),input_b(3),carry(2),full_adder_sum_out(3),carry(3));
	BIT4: full_adder_1bit port map(input_a(4),input_b(4),carry(3),full_adder_sum_out(4),full_adder_carry_out);

end full_add_5bit_logic;