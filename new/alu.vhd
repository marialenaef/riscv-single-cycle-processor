library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    generic ( N: integer :=32);
    Port ( SrcA       : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SrcB       : in  STD_LOGIC_VECTOR (N-1 downto 0);
           ALUControl : in  STD_LOGIC_VECTOR (2 downto 0);
           SLTUorSLT   : in  STD_LOGIC;                      
           ALUResult  : out STD_LOGIC_VECTOR (N-1 downto 0);
           NZCV       : out STD_LOGIC_VECTOR (3 downto 0));
end alu;

architecture Behavioral of alu is
begin

    process(SrcA, SrcB, ALUControl, SLTUorSLT)
        variable a_uns, b_uns : unsigned(N-1 downto 0); 
        variable srcB_mod     : unsigned(N-1 downto 0);
        variable sum_ext      : unsigned(N downto 0);
        variable result       : std_logic_vector(N-1 downto 0);
        variable is_arith     : boolean;
        variable carry_flag, over_flag, comp_bit: std_logic;
    begin
        a_uns         := unsigned(SrcA);
        b_uns         := unsigned(SrcB);
        srcB_mod      := (others => '0');
        sum_ext       := (others => '0');
        result        := (others => '0');
        is_arith      := false;
        carry_flag    := '0';
        over_flag     := '0';
        

        case ALUControl is
            -- 000: ADD
            when "000" =>
                is_arith := true;
                sum_ext  := resize(a_uns, N+1) + resize(b_uns, N+1);
                result   := std_logic_vector(sum_ext(N-1 downto 0));
                carry_flag    := sum_ext(N);
                if (SrcA(N-1) = SrcB(N-1)) and (result(N-1) /= SrcA(N-1)) then
                    over_flag := '1';
                end if;

            -- 001: SUB
            when "001" =>
                is_arith := true;
                srcB_mod := unsigned(not SrcB) + 1;
                sum_ext  := resize(a_uns, N+1) + resize(srcB_mod, N+1);
                result   := std_logic_vector(sum_ext(N-1 downto 0));
                carry_flag    := sum_ext(N);
                if (SrcA(N-1) /= SrcB(N-1)) and (result(N-1) /= SrcA(N-1)) then
                    over_flag := '1';
                end if;

            -- AND 100
            when "100" => result := SrcA and SrcB;
            -- OR 101
            when "101" => result := SrcA or SrcB;
            -- 111: XOR 
            when "111" => result := SrcA xor SrcB;

            -- 101: SLT
            when "011" =>
                is_arith   := true;
                srcB_mod   := unsigned(not SrcB) + 1;
                sum_ext    := resize(a_uns, N+1) + resize(srcB_mod, N+1);
                carry_flag := sum_ext(N);
                if (SrcA(N-1) /= SrcB(N-1)) and (sum_ext(N-1) /= SrcA(N-1)) then
                    over_flag := '1';
                end if;

                -- SLT = N xor V, SLTU = not C
                if SLTUorSLT = '1' then
                    comp_bit := not carry_flag;             -- Unsigned 
                else
                    comp_bit := sum_ext(N-1) xor over_flag; -- Signed 
                end if;

                result := (0 => comp_bit, others => '0');

            when others =>
                result := (others => '0');
        end case;

        
        ALUResult <= result;
        
        if is_arith then
            NZCV(3) <= sum_ext(N-1);  -- Negative Flag (N)
            NZCV(1) <= carry_flag;    -- Carry Flag (C)
            NZCV(0) <= over_flag;     -- Overflow Flag (V)
        else
            NZCV(3) <= '0';
            NZCV(1) <= '0';
            NZCV(0) <= '0';
        end if;

        -- Zero Flag (Z)
        if unsigned(result) = 0 then
            NZCV(2) <= '1';
        else
            NZCV(2) <= '0';
        end if;
    end process;

end Behavioral;
