library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_logic is
    Port ( funct3 : in  STD_LOGIC_VECTOR (2 downto 0);  
           rop    : in  STD_LOGIC_VECTOR (2 downto 0);  
           NZCV   : in  STD_LOGIC_VECTOR (3 downto 0);  
           PCSrc  : out STD_LOGIC);                     
end pc_logic;

architecture Behavioral of pc_logic is
    signal zero_flag : std_logic;
begin

    
    zero_flag <= NZCV(2);

    process(funct3, rop, zero_flag)
    begin
        
        if rop = "100" then
            case funct3 is
                
                when "000" =>
                    PCSrc <= zero_flag;

               
                when "001" =>
                    PCSrc <= not zero_flag;

                when others =>
                    PCSrc <= '0';
            end case;
        else
           
            PCSrc <= '0';
        end if;
    end process;

end Behavioral;
