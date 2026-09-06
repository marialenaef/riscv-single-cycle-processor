library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity extend is
    Port ( Instr  :  in STD_LOGIC_VECTOR (31 downto 7);
           ImmSrc :  in STD_LOGIC_VECTOR (1 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (31 downto 0));
end extend;

architecture Behavioral of extend is
begin
    process(Instr, ImmSrc)
    begin
        case ImmSrc is
            -- I-type 
            when "00" =>
                ExtImm <= std_logic_vector(resize(signed(Instr(31 downto 20)), 32));

            -- S-type 
            when "01" =>
                ExtImm <= std_logic_vector(resize(signed(Instr(31 downto 25) & Instr(11 downto 7)), 32));

            -- B-type 
            when "10" =>
                ExtImm <= std_logic_vector(resize(signed(Instr(31) & Instr(7) & Instr(30 downto 25) & Instr(11 downto 8) & '0'), 32));

            when others =>
                ExtImm <= (others => '0');
        end case;
    end process;
end Behavioral;
