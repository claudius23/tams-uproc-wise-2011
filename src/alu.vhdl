library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity alu is

  port (
    alu_operand_0, alu_operand_1 : in data_bus;
    alu_result               : out data_bus;
    alu_enabled              : in std_logic;
    alu_OpCode     : in alu_opcode_t);

end alu;

-- Todo: add missing alu operations and encode opcodes

architecture behavior of alu is
begin  -- behavior
  alu_process: process (alu_enabled)
  variable add_result : std_logic_vector(word_width downto 0);  -- one bit wider than word
  begin  -- process
    if(rising_edge(alu_enabled)) then
      case alu_OpCode is
        when alu_add =>
          add_result := std_logic_vector(unsigned('0' & alu_operand_0) + unsigned('0' & alu_operand_1));
          alu_result <= add_result(add_result'high - 1 downto 0);
        --when alu_sub =>
        --  result <= alu_operand_0 - alu_operand_1;
        --when alu_mul =>
        --  result <= alu_operand_0 * alu_operand_1;
        --when alu_div =>
        --  result <= alu_operand_0 / alu_operand_1;
        when alu_and =>
          alu_result <= alu_operand_0 and alu_operand_1;
        when alu_or =>
          alu_result <= alu_operand_0 or alu_operand_1;
        when alu_xor =>
          alu_result <= alu_operand_0 xor alu_operand_1;
        when alu_not =>
          alu_result <= not alu_operand_0;
        when others =>
          NULL;
      end case;
    end if;
  end process;
end behavior;
