library ieee;
use ieee.std_logic_1164.all;

entity full_sub_4bit is
	port(
		input_a, input_b : in std_logic_vector(3 downto 0);
		sub_in : in std_logic;
		sub_result : out std_logic_vector(3 downto 0);
		carry_out : out std_logic
	);
end full_sub_4bit;

architecture full_sub_4 of full_sub_4bit is

	component unsign_mult_4bit 

begin


end full_sub_4;