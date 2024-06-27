-- TO DO:
-- 1. Can convert into dataflow/structural???

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- The 'seg7_disp_driver" entity is responsible for controlling two 7-segment
-- display units. It multiplexes between these two displays based on a clock input,
-- alternately enabling one while disabling the other, and outputs appropriate data
-- to the currently active display.

entity seg7_disp_driver is
   port (
      clk      : in  std_logic := '0';          -- Clock input, drives the timing of display switching
      DIN1     : in  std_logic_vector(6 downto 0); -- Input data for display 1
      DIN2     : in  std_logic_vector(6 downto 0); -- Input data for display 2
      DOUT     : out std_logic_vector(6 downto 0); -- Output data to active display
      DIG1     : out std_logic;                -- Control signal for display 1
      DIG2     : out std_logic                 -- Control signal for display 2
   );
end entity seg7_disp_driver;

-- The architecture 'Behavioral' implements the logic to switch between the two displays
-- and to control the data output to each display based on the clock input. It includes
-- a clock-driven process to generate a toggle signal and conditional assignments to
-- manage data output and display control signals.

architecture Behavioral of seg7_disp_driver is
   signal toggle      : std_logic;                -- Toggle signal for display switching
   signal DOUT_TEMP   : std_logic_vector(6 downto 0); -- Temporary output storage

begin
   -- Clock process for generating the toggle signal
   -- This process creates a binary toggle that switches state every 1024 clock cycles,
   -- effectively creating a signal that can be used to switch between two displays.
   -- It utilizes an 11-bit counter that rolls over automatically due to the limited size.
   clock_process : process(clk)
      variable counter : unsigned(10 downto 0) := (others => '0'); -- 11-bit counter
   begin
      if rising_edge(clk) then
         counter := counter + 1;                  -- Increment counter on each clock edge
      end if;
      toggle <= counter(10);                      -- Toggle every 1024 clock cycles
   end process clock_process;

   -- Control signals for the displays
   -- These signals control which of the two displays is active at any time.
   -- DIG1 and DIG2 are complementary, meaning when one is active ('0'), the other is inactive ('1'),
   -- ensuring only one display shows data at a time.
   DIG1 <= not toggle;                           -- DIG1 is active when toggle is '0'
   DIG2 <= toggle;                               -- DIG2 is active when toggle is '1'

   -- Data output logic using a generate statement
   -- This block dynamically assigns the value to 'DOUT_TEMP' based on the state of 'toggle'.
   -- When 'toggle' is '1', data from 'DIN2' is output, otherwise data from 'DIN1' is used.
   data_output : for i in 0 to 6 generate
      DOUT_TEMP(i) <= DIN2(i) when toggle = '1' 
							 else DIN1(i); -- Select input based on toggle
   end generate data_output;

   -- Driving the outputs with optional open-drain configuration on some bits
   -- The outputs are driven based on 'DOUT_TEMP'. If 'DOUT_TEMP' is '0', the output is '0'.
   -- If 'DOUT_TEMP' is '1' and the bit is configured for open-drain (bits 1, 5, 6), it outputs 'Z' (high impedance).
   -- Otherwise, it outputs '1'.
   output_drivers : for i in 0 to 6 generate
      DOUT(i) <= '0' when DOUT_TEMP(i) = '0' 
						else 'Z' when (i = 1 or i = 5 or i = 6) -- Use 'Z' for open-drain simulation
						else '1'; 
   end generate output_drivers;

end architecture Behavioral;
