library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity registers_tb is
end registers_tb;

architecture behavior of registers_tb is

  constant register_count : integer := 32;

  component registers
    generic (
      register_count : integer range 1 to 64 := register_count);
    port (
		register_select_in_a, register_select_in_b : in integer range 0 to register_count-1;
		register_select_out_a, register_select_out_b : in integer range 0 to register_count-1;
		register_value_in_a, register_value_in_b   : in  data_bus;
		register_value_out_a, register_value_out_b   : out data_bus;
		register_write_enabled                     : in std_logic;   -- set to 1 to write
		clock 												  : in std_logic); -- clock
  end component;

  for registers_0: registers use entity work.registers;

  signal register_select_in_a, register_select_in_b : integer range 0 to register_count-1;
  signal register_select_out_a, register_select_out_b : integer range 0 to register_count-1;
  signal register_value_in_a, register_value_in_b   : data_bus;
  signal register_value_out_a, register_value_out_b   : data_bus;
  signal register_write_enabled              : std_logic;
  
  begin
      registers_0: registers port map (
		register_select_in_a		=>	register_select_in_a,
		register_select_in_b		=>	register_select_in_b,
		register_select_out_a	=>	register_select_out_a,
		register_select_out_b	=>	register_select_out_b,
		register_value_in_a		=>	register_value_in_a,
		register_value_in_b		=> register_value_in_b,
		register_value_out_a		=>	register_value_out_a,
		register_value_out_b		=> register_value_out_b,
		register_write_enabled	=> register_write_enabled,
      );

      -- purpose: testbench for registers
      -- type   : sequential
      execute_test: process
        type registers_test is record         -- a single test
          register_select_in_a, register_select_in_b : integer range 0 to register_count-1;
			 register_select_out_a, register_select_out_b : integer range 0 to register_count-1;
          register_value_in_a, register_value_in_b   : data_bus;
			 register_value_out_a, register_value_out_b   : data_bus;
        end record;

        type registers_tests is array (natural range <>) of registers_test;
        constant tests : registers_tests :=
          (
            (0, 0, 1, 1, zero_word, one_word),
            (0, 0, 1, 1, one_word, zero_word),
            (2, 2, 3, 3, two_word, zero_word),
            (0, 0, 1, 1, zero_word, three_word),
            (2, 2, 3, 3, zero_word, zero_word)
          );

      begin  -- process
        for i in tests'range loop
          enabled <= '0';
          wait for 1 ns;

          -- write phase
          register_select_in_a <= tests(i).register_select_in_a;
          register_value_in_a <= tests(i).register_value_in_a;
			 register_write_enabled <= '1';
          wait for 1 ns;

			 register_select_in_b <= tests(i).register_select_in_b;
          register_value_in_b <= tests(i).register_value_in_b;
			 register_write_enabled <= '1';
          wait for 1 ns;
          
          -- prepare for read phase, set bus on high impedance
          --value_a <= z_word;
          --value_b <= z_word;
          --enabled <= '0';
          --write <= '0';

          --enabled <= '0';
          --wait for 1 ns;

          -- read phase
          register_select_out_a <= tests(i).register_select_out_a;
          register_select_out_b <= tests(i).register_select_out_b;
          
          -- generate enabled pulse
          
          assert register_value_out_a = tests(i).register_value_out_a and register_value_out_b = tests(i).register_value_out_b
            report "bad result" severity error;
        end loop;

        assert false report "end of test" severity note;
        wait;

      end process;
end behavior;
