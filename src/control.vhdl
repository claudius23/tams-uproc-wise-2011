library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity control is
  port (
    -- TODO: enable later
    --instruction : in opcode;            -- instruction to execute
    interrupt   : in std_logic;         -- interrupt input
    clock       : in std_logic;         -- clock signal

    -- alu signals
    alu_operand_0   : out data_bus;
    alu_operand_1   : out data_bus;
    alu_result      : in data_bus;
    alu_instruction : out alu_opcode_t;   -- alu instruction
    alu_enabled     : out std_logic;    -- enable alu?

    -- register signals
	 register_select_in_a, register_select_in_b : out integer range 0 to 31;
    register_select_out_a, register_select_out_b : in integer range 0 to 31;
    register_value_in_a, register_value_in_b   : out data_bus;
	 register_value_out_a, register_value_out_b   : in data_bus;
    register_write_enabled     : out std_logic);
end control;

architecture behavior of control is

begin  -- behavior

  -- purpose: control execution of the current instruction
  -- type   : sequential
  -- inputs : clock, instruction, interrupt
  -- outputs: various
  execute: process (clock)
  begin  -- process execute
    ---if clock'event then
      -- initialize signals
      alu_enabled <= '0';
		register_select_in_a <= 0;
		register_select_in_b <= 1;
		--register_select_out_a <= 0;
		--register_select_out_b <= 1;
		register_value_in_a <= z_word;
      register_value_in_b <= z_word;      
		--register_value_out_a <= z_word;
      --register_value_out_b <= z_word;
      --register_enabled <= '1';
    
      if clock'event and clock = '1' then
        -- rising clock edge
        alu_operand_0 <= one_word;
        alu_operand_1 <= two_word;
        alu_instruction <= alu_add;
        alu_enabled <= '1';
      --else
			elsif clock'event and clock = '0' then
			-- falling clock edge
			register_value_in_a <= alu_result;
			register_select_in_a <= 0; --todo
			register_write_enabled <= '1';
			end if;
		--end if;
  end process execute;

end behavior;
