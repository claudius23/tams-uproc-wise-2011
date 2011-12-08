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
    register_write              : in std_logic;   -- set to 1 to write
    register_enabled            : in std_logic);  -- set to 1 to enable
end registers;

architecture behavior of registers is

  type register_bank_t is array (0 to register_count - 1) of data_bus;  -- a register bank
  
begin  -- behavior
  -- purpose: read and write values
  -- type   : sequential
  -- inputs : enabled, register_select_a, register_select_b, register_value_a, register_value_b, write
  -- outputs: register_value_a, register_value_b
  process (register_enabled)
    variable register_bank : register_bank_t;  -- the register bank
  begin  -- process
    --register_value_out_a <= z_word;	
    --register_register_value_out_b <= z_word;
	 
    if register_enabled = '1' then
      case register_write is
        when '1' =>
          register_bank(register_select_in_a) := register_value_in_a;
          register_bank(register_select_in_b) := register_value_in_b;
        when '0' =>
          register_value_out_a <= register_bank(register_select_in_a);
          register_value_out_b <= register_bank(register_select_in_b);
          --register_value_b <= zero_word;
        when others =>
          null;
      end case;
    end if;
  end process;
end behavior;
