--TO DO: 
--1. IMPLEMENT DEBOUNCER | DONE
--2. BUILD ALU
--3. CONVERTIN INTO STRUCTURAL!!! -> dont forget to move debouncer to a separate block
--4. BIG REWORK: "infinite" input


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CalculatorThing_top is 
	port (
		clkin_50          : in  std_logic;        --50Mhz clock
		reset             : in  std_logic;        --reset button
		pb_n              : in  std_logic_vector(3 downto 0); --push buttons (0 through 3)
		sw                : in  std_logic_vector(7 downto 0); --The switch inputs
		leds              : out std_logic_vector(7 downto 0); --for displaying the switch content
		seg7_data         : out std_logic_vector(6 downto 0); --7-bit outputs to a 7-segment
		seg7_char1        : out std_logic;        --seg7 digit1 selector
		seg7_char2        : out std_logic         --seg7 digit2 selector
	); 
end CalculatorThing_top;

architecture CalculatorLogic of CalculatorThing_top is

   component PB_Inverters port(
      pb_n : in std_logic_vector(3 downto 0);
      pb   : out std_logic_vector(3 downto 0)
   );
   end component;
   
   component SevenSegment port(
      hex : in std_logic_vector(3 downto 0); --4bit hex value to be displayed
      sevenseg : out std_logic_vector(6 downto 0) --7bit bus of segments to be lit up
   );
   end component;
   
   component segment7_mux port(
      clk : in std_logic := '0'; --clock
      DIN2 : in std_logic_vector(6 downto 0); --data in for the 2nd (left) display
      DIN1 : in std_logic_vector(6 downto 0); --data in for the 1st (right) display
      DOUT : out std_logic_vector(6 downto 0); --data out to a single display (selected by clock)
      DIG2 : out std_logic; --select left display
      DIG1 : out std_logic --select right display
   );
   end component;
	
	component seg7_disp_driver port(
		clk      : in  std_logic := '0';          -- Clock input, drives the timing of display switching
      DIN1     : in  std_logic_vector(6 downto 0); -- Input data for display 1
      DIN2     : in  std_logic_vector(6 downto 0); -- Input data for display 2
      DOUT     : out std_logic_vector(6 downto 0); -- Output data to active display
      DIG1     : out std_logic;                -- Control signal for display 1
      DIG2     : out std_logic                 -- Control signal for display 2
   );
	end component;
   
   component full_adder_4bit port(
      input_a, input_b : in std_logic_vector(3 downto 0); --4bit inputs to add
      carry_in : in std_logic; --1bit carry input from external
      full_adder_sum_out : out std_logic_vector(3 downto 0); --4bit sum out from this full adder
      full_adder_carry_out : out std_logic --1bit carry out from this full adder
   );
   end component;
	
	component full_adder_5bit port(
		input_a, input_b : in std_logic_vector(4 downto 0); --5bit inputs to add
		carry_in : in std_logic; --1bit carry input from external
		full_adder_sum_out : out std_logic_vector(4 downto 0); --5bit sum out from this full adder
		full_adder_carry_out : out std_logic --1bit carry out from this full adder
	);
	end component;
	
	component unsign_mult_4bit port(
		input_b : in std_logic_vector(3 downto 0);
		input_a : in std_logic_vector(3 downto 0);
		mult_out : out std_logic_vector(7 downto 0)
	);
	end component;

--------STATE MACHINE------------
   --1. Defining the states of the calculator
   type state_types is (Input_Nums, Select_Operation, Show_Result, Clear_Result);
   signal state, next_state : state_types;
   
   --2. Variables for temporary storage
   signal hex_A, hex_B : std_logic_vector(3 downto 0); --hex_A = first hex input (4b) | hex_b = second hex input (4b)
   signal hex_result : std_logic_vector(7 downto 0); --full operation result (8b)
   signal operation : std_logic_vector (1 downto 0) := B"00"; --"00" = ADD | "01" = SUBTRACT | "10" = MULTIPLY | "11" = DIVIDE
   signal disp_A, disp_B : std_logic_vector(3 downto 0); --hex value to display on A and B displays
   signal adder_result_5: std_logic_vector(4 downto 0); --temp 5bit test value
	signal adder_carry : std_logic; --carry from the adder
	signal mult_result : std_logic_vector(7 downto 0); -- hex value from multiplier
   --3. Other variables
   signal pb : std_logic_vector(3 downto 0); --Invert active low push buttons
   signal seg7_A : std_logic_vector(6 downto 0); --Seven Segment output bus A (7 bits)
   signal seg7_B : std_logic_vector(6 downto 0); --Seven Segment output bus B (7 bits)
   
	--4. DEBOUNCER
	signal pb_debounced: std_logic_vector(3 downto 0);
	signal pb_count: integer range 0 to 1000 := 0;
	constant DEBOUNCE_LIMIT: integer := 1000;
	
begin

---------INSTANCES--------------
   PB_INV: PB_Inverters port map(pb_n, pb); --Invert push buttons to be active high
   DISP_A_7: SevenSegment port map(disp_A, seg7_A); --Translates disp_A to seg7_A 
   DISP_B_7: SevenSegment port map(disp_B, seg7_B); --Translates disp_B to seg7_B
	DISP_DRIV: seg7_disp_driver port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1); --takes seg7_A and seg7_B and sends to 2x 7-seg display
	INST5: full_adder_5bit port map('0' & hex_A,'0' & hex_B,'0',adder_result_5,adder_carry);
	INST6: unsign_mult_4bit port map(hex_A, hex_B, mult_result);
	
----------DEBUG----------
	leds(7 downto 4) <= pb(3 downto 0);
	
--------DEBOUNCER---------
	process(clkin_50)
	begin
		 if rising_edge(clkin_50) then
			  if pb /= pb_debounced then
					if pb_count < DEBOUNCE_LIMIT then
						 pb_count <= pb_count + 1;
					else
						 pb_count <= 0;
						 pb_debounced <= pb;
					end if;
			  else
					pb_count <= 0;
			  end if;
		 end if;
	end process;


-------STATE REGISTER-----------
   process(clkin_50, reset)
   begin
        if reset = '1' then
            state <= Input_Nums; -- Initialize to the first state
        elsif rising_edge(clkin_50) then
            state <= next_state; -- Update state on rising edge of the clock
		  else
				state <= state;
        end if;
   end process;

-------STATE SWITCHER----------
   process(state, pb, sw, operation)
   begin
        case state is 
            when Input_Nums =>
                if pb_debounced(0) = '1' then --confirm input numbers
                    next_state <= Select_Operation;
                else
                    next_state <= Input_Nums;
                end if;
                
            when Select_Operation =>
                if pb_debounced(3) = '1' then --confirm operation
                    next_state <= Show_Result;
                else
                    next_state <= Select_Operation;
                end if;
                
            when Show_Result =>
                if pb_debounced(0) = '1' then --clear result
                    next_state <= Clear_Result;
                else
                    next_state <= Show_Result;
                end if;
            
            when Clear_Result =>
					 if pb_debounced(3) = '1' then -- assuming this is the button to go back to Input_Nums
						  next_state <= Input_Nums;
					 else
						  next_state <= Clear_Result;
					 end if;
        end case;
   end process;
   
-------STATE ACTIONS---------
	process(state, operation, adder_result_5, adder_carry, hex_A, hex_B)
   begin
        case state is
            when Input_Nums =>
					 hex_A <= sw(3 downto 0);
                hex_B <= sw(7 downto 4);
                disp_A <= sw(3 downto 0);
                disp_B <= sw(7 downto 4);
                leds(1 downto 0) <= B"01";
            
            when Select_Operation =>
					 operation(1 downto 0) <= sw(1 downto 0);
                disp_A <= "000" & operation(0);
                disp_B <= "000" & operation(1);
                leds(1 downto 0) <= B"10";
                
            when Show_Result =>
                case operation is
                    when "00" => -- ADD
								hex_result(3 downto 0) <= adder_result_5(3 downto 0);
								hex_result(7 downto 4) <= "000" & adder_result_5(4);
                    when "01" => -- SUBTRACT
                        hex_result <= "0000" & std_logic_vector(unsigned(hex_A) - unsigned(hex_B));
                    when "10" => -- MULTIPLY
                        hex_result <= mult_result;
                    when "11" => -- DIVIDE
                        if hex_B /= "0000" then
                            hex_result <= "0000" & std_logic_vector(unsigned(hex_A) / unsigned(hex_B));
                        else
                            hex_result <= "00000000"; -- Avoid division by zero
                        end if;
                    when others =>
                        hex_result <= (others => '0');
                end case;
					 disp_A <= hex_result(3 downto 0);
					 disp_B <= hex_result(7 downto 4);
                leds(1 downto 0) <= B"11";
            
            when Clear_Result =>
                hex_result <= (others => '0');
					 disp_A <= hex_result(3 downto 0);
					 disp_B <= hex_result(7 downto 4);
                leds(1 downto 0) <= B"00";
                
        end case;
   end process;

end CalculatorLogic;
