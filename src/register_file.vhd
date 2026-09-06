library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    generic (
        N : integer :=5;   -- 2^5 = 32 
        M : integer :=32); -- 32 bits 
    Port ( CLK : in  STD_LOGIC;
           WE3 : in  STD_LOGIC;                         -- RegWrite
           A1  : in  STD_LOGIC_VECTOR (N-1 downto 0);   -- Rs1
           A2  : in  STD_LOGIC_VECTOR (N-1 downto 0);   -- Rs2
           A3  : in  STD_LOGIC_VECTOR (N-1 downto 0);   -- Rd 
           WD3 : in  STD_LOGIC_VECTOR (M-1 downto 0);   -- Result
           RD1 : out STD_LOGIC_VECTOR (M-1 downto 0);
           RD2 : out STD_LOGIC_VECTOR (M-1 downto 0));
end register_file;

architecture Behavioral of register_file is
    type register_array is array (0 to (2**N)-1) of STD_LOGIC_VECTOR (M-1 downto 0); 
    signal registers : register_array := (others => (others => '0')); 
begin

    
    process(CLK)
    begin
        if rising_edge(CLK) then
            if WE3 = '1' then 
                
                if to_integer(unsigned(A3)) /= 0 then
                    registers(to_integer(unsigned(A3))) <= WD3; 
                end if;
            end if;
        end if;
    end process;

    
    RD1 <= (others => '0') when to_integer(unsigned(A1)) = 0 else registers(to_integer(unsigned(A1)));
    RD2 <= (others => '0') when to_integer(unsigned(A2)) = 0 else registers(to_integer(unsigned(A2)));

end Behavioral;
