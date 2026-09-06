library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_dec is
    Port ( funct3     : in  STD_LOGIC_VECTOR (2 downto 0);  
           rop        : in  STD_LOGIC_VECTOR (2 downto 0);  
           funct7_5   : in  STD_LOGIC;                      
           ALUControl : out STD_LOGIC_VECTOR (2 downto 0);  
           SLTUorSLT  : out STD_LOGIC);
end alu_dec;

architecture Behavioral of alu_dec is
begin
    SLTUorSLT <= '1' when (rop = "010" and funct3 = "011") else '0';

    process(funct3, funct7_5, rop)
    begin
        case rop is
            -- 000: LW / SW 
            when "000" | "001" =>
                ALUControl <= "000"; -- ADD
                

            -- 100: Branch BEQ/BNE 
            when "100" =>
                ALUControl <= "001"; -- SUB

            -- 010: R-Type (ADD, SUB, AND, OR, XOR, SLT, SLTU)
            when "010" =>
                case funct3 is
                    when "000" =>
                        if funct7_5 = '1' then
                            ALUControl <= "001"; -- SUB 
                        else
                            ALUControl <= "000"; -- ADD 
                        end if;
                        
                    when "010" => 
                        ALUControl <= "011"; -- SLT
                    when "011" => 
                        ALUControl <= "011"; -- SLTU
                    when "100" => ALUControl <= "111"; -- XOR
                    when "110" => ALUControl <= "101"; -- OR
                    when "111" => ALUControl <= "100"; -- AND   
                    when others => ALUControl <= "---"; 
                end case;

            -- 011: I-Type ALU (ADDI, ANDI, ORI, XORI)
            when "011" =>
                case funct3 is
                    when "000"  => ALUControl <= "000"; -- ADDI
                    when "100"  => ALUControl <= "111"; -- XORI
                    when "110"  => ALUControl <= "101"; -- ORI
                    when "111"  => ALUControl <= "100"; -- ANDI
                    when others => ALUControl <= "000";
                end case;

            when others =>
                ALUControl <= "000";
        end case;
    end process;

end Behavioral;
