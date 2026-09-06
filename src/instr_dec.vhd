library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instr_dec is
    Port ( op        : in  STD_LOGIC_VECTOR (6 downto 2);    
           RegWrite  : out STD_LOGIC;                       
           ImmSrc    : out STD_LOGIC_VECTOR (1 downto 0);   
           ALUSrc    : out STD_LOGIC;                       
           MemWrite  : out STD_LOGIC;                       
           ResultSrc : out STD_LOGIC;                       
           rop       : out STD_LOGIC_VECTOR (2 downto 0));  
end instr_dec;

architecture Behavioral of instr_dec is
begin

    process(op)
    begin
        case op is
            -- LW (Load Word - I-Type)
            when "00000" =>
                RegWrite  <= '1';
                ImmSrc    <= "00";
                ALUSrc    <= '1';
                MemWrite  <= '0';
                ResultSrc <= '1';
                rop       <= "000";

            -- SW (Store Word - S-Type)
            when "01000" =>
                RegWrite  <= '0';
                ImmSrc    <= "01";
                ALUSrc    <= '1';
                MemWrite  <= '1';
                ResultSrc <= '-'; -- Don't Care 
                rop       <= "001";

            -- R-Type ALU (ADD, SUB, AND, OR, XOR, SLT, SLTU)
            when "01100" =>
                RegWrite  <= '1';
                ImmSrc    <= "--"; -- Don't Care 
                ALUSrc    <= '0';
                MemWrite  <= '0';
                ResultSrc <= '0';
                rop       <= "010";

            -- I-Type ALU (ADDI, ANDI, ORI, XORI)
            when "00100" =>
                RegWrite  <= '1';
                ImmSrc    <= "00";
                ALUSrc    <= '1';
                MemWrite  <= '0';
                ResultSrc <= '0';
                rop       <= "011";

            -- Branch (BEQ, BNE - B-Type)
            when "11000" =>
                RegWrite  <= '0';
                ImmSrc    <= "10";
                ALUSrc    <= '0';
                MemWrite  <= '0';
                ResultSrc <= '-'; -- Don't Care 
                rop       <= "100";

            when others =>
                RegWrite  <= '-';
                ImmSrc    <= "--";
                ALUSrc    <= '-';
                MemWrite  <= '-';
                ResultSrc <= '-';
                rop       <= "---";
        end case;
    end process;

end Behavioral;
