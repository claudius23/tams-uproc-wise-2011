library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity registers is
  
  generic (
    register_count : integer range 1 to 64 := 32);  -- number of registers

  port (
    register_select_in_a, register_select_in_b : in integer range 0 to register_count-1;
	 register_select_out_a, register_select_out_b : in integer range 0 to register_count-1;
    register_value_in_a, register_value_in_b   : in  data_bus;
	 register_value_out_a, register_value_out_b   : out data_bus;
    register_write_enabled                     : in std_logic;   -- set to 1 to write
end registers;

architecture behavior of registers is

  type register_bank_t is array (0 to register_count - 1) of data_bus;  -- a register bank
  
begin  -- behavior
   variable register_bank : register_bank_t;  -- the register bank
 
	process(read_register_select_a)
    begin  -- process
		register_bank(register_select_in_a) := register_value_in_a;
	end process;
	
   process(read_register_select_b)
    begin  -- process
		register_bank(register_select_in_b) := register_value_in_b;
   end process;
	
	process(write_register_select_a)
	  begin  -- process
		if register_write_enabled = '1' then
			register_value_out_a <= register_bank(register_select_in_a);
		end if;		 
	end process;		 
	
   process(write_register_select_b)
	  begin  -- process
		if register_write_enabled = '1' then
			register_value_out_b <= register_bank(register_select_in_b);
		end if;  
	end process;  
end behavior;
