--TO DO:
--1. SUB ONLY: implement bit extension of 4bit inputs to 5bit for use with 2's complement
--2. Binary divider
--3. Implement OPCODE binary decoder with ability to refer to registers.
--4. Logic comparison
--5. Rework seven segment display with to indicate positive or negative


library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port(
		input_a, input_b : in std_logic_vector(3 downto 0); --4bit inputs to add
		carry_in : in std_logic; --1bit carry input from external
		full_adder_sum_out : out std_logic_vector(3 downto 0); --4bit sum out from this full adder
		full_adder_carry_out : out std_logic --1bit carry out from this full adder
	);
end ALU;

architecture ALU_logic of ALU is

	component full_adder_5bit port( --serves for both addition and subtraction
		input_a, input_b : in std_logic_vector(4 downto 0); --5bit inputs to add
		carry_in : in std_logic; --1bit carry input from external
		full_adder_sum_out : out std_logic_vector(4 downto 0); --5bit sum out from this full adder
		full_adder_carry_out : out std_logic --1bit carry out from this full adder
	);
	end component;
	
	component unsign_mult_4bit port(
		input_b : in std_logic_vector(3 downto 0); --4bit multiplication input
		input_a : in std_logic_vector(3 downto 0); --4bit mltiplication input
		mult_out : out std_logic_vector(7 downto 0) --8bit out
	);
	end component;

begin


end ALU_logic;