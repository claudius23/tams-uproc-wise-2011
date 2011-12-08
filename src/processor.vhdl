library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity processor is

  port (
    reset_in     : in std_logic;            -- reset input
    interrupt_in : in std_logic;            -- interrupt input
    clock_in     : in std_logic);           -- clock input

end processor;

architecture behavior of processor is

  constant register_count : integer := 32;

  -- alu
  component alu
    port (
      alu_operand_0, alu_operand_1 : in data_bus;
      alu_result               : out data_bus;
      alu_enabled              : in std_logic;
      alu_opcode               : in alu_opcode_t);
  end component;

  for alu_0 : alu
    use entity work.alu;

  -- alu signals
  signal alu_operand_0 : data_bus;
  signal alu_operand_1 : data_bus;
  signal alu_result    : data_bus;
  signal alu_opcode    : alu_opcode_t;
  signal alu_enabled : std_logic;
  
  -- register bank
  component registers
    generic (
      register_count : integer range 1 to 64 := register_count);
    port (
      register_select_in_a, register_select_in_b : in integer range 0 to register_count-1;
		register_select_out_a, register_select_out_b : out integer range 0 to register_count-1;
      register_value_in_a,  register_value_in_b  : in data_bus;
		register_value_out_a, register_value_out_b : out data_bus;
      register_write              : in std_logic;
      register_enabled            : in std_logic);
  end component;

  for registers_0 : registers
    use entity work.registers;

  -- register signals
  signal register_select_in_a, register_select_in_b : integer range 0 to register_count-1;
  signal register_select_out_a, register_select_out_b : integer range 0 to register_count-1;
  signal register_value_in_a, register_value_in_b   : data_bus;
  signal register_value_out_a, register_value_out_b   : data_bus;
  signal register_write                       : std_logic;
  signal register_enabled                     : std_logic;

  -- control unit
  component control is
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
		register_select_in_a, register_select_in_b : in integer range 0 to register_count-1;
      register_select_out_a, register_select_out_b : out integer range 0 to register_count-1;
      register_value_in_a, register_value_in_b   : in data_bus;
		register_value_out_a, register_value_out_b   : out data_bus;
      register_write, register_enabled     : out std_logic);
  end component;

  for control_0 : control
    use entity work.control;

  -- clock signals
  signal clock : std_logic;

begin

  alu_0: alu port map (
    alu_operand_0 => alu_operand_0,
    alu_operand_1 => alu_operand_1,
    alu_result => alu_result,
    alu_opcode => alu_opcode,
    alu_enabled => alu_enabled);

  registers_0: registers port map (
	 register_select_in_a => register_select_in_a,
    register_select_in_b => register_select_in_b,
    register_select_out_a => register_select_out_a,
    register_select_out_b => register_select_out_b,
    register_value_in_a  => register_value_in_a,
    register_value_in_b  => register_value_in_b,
	 register_value_out_a  => register_value_out_a,
    register_value_out_b  => register_value_out_b,
    register_write    => register_write,
    register_enabled  => register_enabled);

  control_0: control port map (
    alu_operand_0 => alu_operand_0,
    alu_operand_1 => alu_operand_1,
    alu_result => alu_result,
    alu_instruction => alu_opcode,
    alu_enabled => alu_enabled,
    register_select_out_a => register_select_out_a,
    register_select_out_b => register_select_out_b,
    register_value_in_a => register_value_in_a,
    register_value_in_b => register_value_in_b,
	 register_value_out_a => register_value_out_a,
    register_value_out_b => register_value_out_b,
    register_write => register_write,
    register_enabled => register_enabled,
    interrupt => interrupt_in,
    clock => clock_in);

end behavior;
