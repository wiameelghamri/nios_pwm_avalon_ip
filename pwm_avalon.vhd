library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_avalon is port (
  clk        : in  std_logic;
  reset_n    : in  std_logic;
  address    : in  std_logic_vector(0 downto 0);
  chipselect : in  std_logic;
  write      : in  std_logic;
  writedata  : in  std_logic_vector(31 downto 0);
  read       : in  std_logic;
  readdata   : out std_logic_vector(31 downto 0);
  pwm_out    : out std_logic
);
end pwm_avalon;

architecture rtl of pwm_avalon is
  signal period  : unsigned(31 downto 0);
  signal duty    : unsigned(31 downto 0);
  signal counter : unsigned(31 downto 0);
begin

  process(clk, reset_n)
  begin
    if reset_n = '0' then
      period <= (others => '1');
      duty   <= (others => '0');
    elsif rising_edge(clk) then
      if chipselect = '1' and write = '1' then
        case address is
          when "0"    => period <= unsigned(writedata);
          when others => duty   <= unsigned(writedata);
        end case;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if chipselect = '1' and read = '1' then
        case address is
          when "0"    => readdata <= std_logic_vector(period);
          when others => readdata <= std_logic_vector(duty);
        end case;
      end if;
    end if;
  end process;

  process(clk, reset_n)
  begin
    if reset_n = '0' then
      counter <= (others => '0');
    elsif rising_edge(clk) then
      if counter >= period then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;

  pwm_out <= '1' when counter < duty else '0';

end rtl;