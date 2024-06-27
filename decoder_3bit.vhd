library ieee;
use ieee.std_logic_1164.all;

entity decoder_3bit is
	port(
		input : in std_logic_vector(2 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
end decoder_3bit;

architecture decoder_3 of decoder_3bit is

	signal n_input : std_logic_vector(2 downto 0) := NOT input;

begin

	output(0) <= n_input(0) AND n_input(1) AND n_input(2);
	output(1) <= input(0) AND n_input(1) AND n_input(2);
	output(2) <= n_input(0) AND input(1) AND n_input(2);
	output(3) <= input(0) AND input(1) AND n_input(2);
	output(4) <= n_input(0) AND n_input(1) AND input(2);
	output(5) <= input(0) AND n_input(1) AND input(2);
	output(6) <= n_input(0) AND input(1) AND input(2);
	output(7) <= input(0) AND input(1) AND input(2);

end decoder_3;
