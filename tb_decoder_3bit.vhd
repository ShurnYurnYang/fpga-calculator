library ieee;
use ieee.std_logic_1164.all;

entity tb_decoder_3bit is
end tb_decoder_3bit;

architecture testbench of tb_decoder_3bit is

	signal tb_input : std_logic_vector(2 downto 0);
	signal tb_output : std_logic_vector(7 downto 0);
	
	component decoder_3bit port(
		input : in std_logic_vector(2 downto 0);
		output : out std_logic_vector(7 downto 0)
	);
	end component;
	
begin
	
	DUT: decoder_3bit port map(tb_input, tb_output);
	
	process begin
		tb_input <= "000"; wait for 10 ns;
		tb_input <= "001"; wait for 10 ns;
		tb_input <= "010"; wait for 10 ns;
		tb_input <= "011"; wait for 10 ns;
		tb_input <= "100"; wait for 10 ns;
		tb_input <= "101"; wait for 10 ns;
		tb_input <= "110"; wait for 10 ns;
		tb_input <= "111"; wait for 10 ns;
	
		wait;
	end process;
end testbench;
