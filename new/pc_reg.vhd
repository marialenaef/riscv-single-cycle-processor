library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_reg is
    generic ( N : integer :=32);
    Port ( CLK    :  in STD_LOGIC;
           RESET  :  in STD_LOGIC;
           PCNext :  in STD_LOGIC_VECTOR (N-1 downto 0);
           PC     : out STD_LOGIC_VECTOR (N-1 downto 0));
end pc_reg;

architecture Behavioral of pc_reg is

begin
    process(CLK, RESET) 
    begin
        if RESET = '1' then 
            PC <= (others => '0'); 
        elsif rising_edge(CLK) then 
            PC <= PCNext;         
        end if;
    end process;
end Behavioral;
