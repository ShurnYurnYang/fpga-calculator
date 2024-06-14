
library ieee;
use ieee.std_logic_1164.all;

entity full_adder_1bit is
	
	port(
		input_a, input_b : in std_logic; --two 1bit inputs
		carry_in : in std_logic; --carry in from external
		sum_out : out std_logic; --sum out
		carry_out : out std_logic --carry out
	);
	
end full_adder_1bit;

architecture full_add_logic of full_adder_1bit is

	signal half_add_sum : std_logic; --sum from the half adder
	signal half_add_carry : std_logic; --carry from the half adder

begin

	half_add_sum <= input_a XOR input_b;

	half_add_carry <= input_a AND input_b;
	
	sum_out <= half_add_sum XOR carry_in;
	
	carry_out <= half_add_carry OR (half_add_sum AND carry_in);

end full_add_logic;