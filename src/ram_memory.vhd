library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram_memory is
    generic (
        N : integer :=5;   -- 2^5 = 32 (words)
        M : integer :=32); -- -- 32 bits 
    Port ( ADDR : in  STD_LOGIC_VECTOR (N-1 downto 0);  -- (ALUResult[N+1:2])
           WD   : in  STD_LOGIC_VECTOR (M-1 downto 0);  -- Write Data (RD2)
           RD   : out STD_LOGIC_VECTOR (M-1 downto 0);  -- Read Data (MUX ResultSrc)
           WE   : in  STD_LOGIC;                        -- MemWrite
           CLK  : in  STD_LOGIC);
end ram_memory;

architecture Behavioral of ram_memory is

    type ram_array is array (0 to (2**N)-1) of STD_LOGIC_VECTOR (M-1 downto 0);

    signal RAM : ram_array := (others => (others => '0'));
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            if WE = '1' then
                RAM(to_integer(unsigned(ADDR))) <= WD;
            end if;
        end if;
    end process;

    RD <= RAM(to_integer(unsigned(ADDR)));

end Behavioral;
