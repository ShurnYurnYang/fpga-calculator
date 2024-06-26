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
		opcode : in std_logic_vector(2 downto 0); --3bit opcode
		result : out std_logic_vector(7 downto 0); --8bit ALU result
		carry_out : out std_logic; --carry out flag
		zero : out std_logic; --result is zero flag
		sign : out std_logic; --sign of result flag (0 = +pos | 1 = -neg)
		overflow : out std_logic --result has overflowed 8bits flag
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
	
	signal add_result : std_logic_vector(4 downto 0);
	signal add_carry : std_logic;

begin

	ADD: full_adder_5bit port map('0' & input_a,'0' & input_b,'0',add_result,add_carry); --temporary '0' -> should be decided by opcode -> fix this later
	
	
end ALU_logic;