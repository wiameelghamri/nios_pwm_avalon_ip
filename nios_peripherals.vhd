library ieee;
use ieee.std_logic_1164.all;

entity nios_peripherals is port (
  FPGA_CLK1_50 : in  std_logic;
  LED          : out std_logic_vector(7 downto 0);
  SW           : in  std_logic_vector(3 downto 0)
);
end nios_peripherals;

architecture arch of nios_peripherals is

  component nios_peripherals_qsys is port (
    clk_clk       : in  std_logic                    := 'X';
    reset_reset_n : in  std_logic                    := 'X';
    led_export    : out std_logic_vector(6 downto 0);
    switch_export : in  std_logic_vector(3 downto 0) := (others => 'X');
    pwm_export    : out std_logic
  );
  end component nios_peripherals_qsys;

begin

  u0 : component nios_peripherals_qsys port map (
    clk_clk       => FPGA_CLK1_50,
    reset_reset_n => '1',
    led_export    => LED(6 downto 0),
    switch_export => SW,
    pwm_export    => LED(7)
  );

end arch;