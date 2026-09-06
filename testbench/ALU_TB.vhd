library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is

    component alu is
        generic (N : integer := 32);
        port (
            SrcA       : in  STD_LOGIC_VECTOR (31 downto 0);
            SrcB       : in  STD_LOGIC_VECTOR (31 downto 0);
            ALUControl : in  STD_LOGIC_VECTOR (2 downto 0);
            SLTUorSLT  : in  STD_LOGIC;  
            ALUResult  : out STD_LOGIC_VECTOR (31 downto 0);
            NZCV       : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal SrcA_tb, SrcB_tb, ALUResult_tb : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ALUControl_tb                 : STD_LOGIC_VECTOR(2 downto 0)  := (others => '0');
    signal SLTUorSLT_tb                  : STD_LOGIC                     := '0';
    signal NZCV_tb                       : STD_LOGIC_VECTOR(3 downto 0);

begin

    UUT: alu
        generic map (N => 32)
        port map (
            SrcA       => SrcA_tb,
            SrcB       => SrcB_tb,
            ALUControl => ALUControl_tb,
            SLTUorSLT  => SLTUorSLT_tb,  
            ALUResult  => ALUResult_tb,
            NZCV       => NZCV_tb
        );

    stim_proc: process
    begin
        -- 1. ADD: 10 + 5 = 15
        SrcA_tb <= x"0000000A"; SrcB_tb <= x"00000005"; ALUControl_tb <= "000"; SLTUorSLT_tb <= '0';
        wait for 20 ns;

        -- 2. SUB (Zero flag): 10 - 10 = 0 (Z='1', C='1')
        SrcA_tb <= x"0000000A"; SrcB_tb <= x"0000000A"; ALUControl_tb <= "001"; SLTUorSLT_tb <= '0';
        wait for 20 ns;

        -- 3. SUB (Negative): 10 - 20 = -10 (N='1', C='0')
        SrcA_tb <= x"0000000A"; SrcB_tb <= x"00000014"; ALUControl_tb <= "001"; SLTUorSLT_tb <= '0';
        wait for 20 ns;

        -- 4. AND: 0x000000FF AND 0x0000000F = 0x0000000F
        SrcA_tb <= x"000000FF"; SrcB_tb <= x"0000000F"; ALUControl_tb <= "100"; SLTUorSLT_tb <= '0';
        wait for 20 ns;

        -- 5. OR: 0x000000F0 OR 0x0000000F = 0x000000FF
        SrcA_tb <= x"000000F0"; SrcB_tb <= x"0000000F"; ALUControl_tb <= "101"; SLTUorSLT_tb <= '0';
        wait for 20 ns;

        -- 6. XOR: 0x000000FF XOR 0x00000055 = 0x000000AA
        SrcA_tb <= x"000000FF"; SrcB_tb <= x"00000055"; ALUControl_tb <= "111"; SLTUorSLT_tb <= '0';
        wait for 20 ns;

        -- 7. SLT (Signed Less Than): -15 < 10 -> Result = 1
        SrcA_tb <= x"FFFFFFF1"; SrcB_tb <= x"0000000A"; ALUControl_tb <= "011"; SLTUorSLT_tb <= '0';
        wait for 20 ns;

        -- 8. SLTU (Unsigned Less Than): 0xFFFFFFF1 < 10 -> Result = 0 (Z='1')
        SrcA_tb <= x"FFFFFFF1"; SrcB_tb <= x"0000000A"; ALUControl_tb <= "011"; SLTUorSLT_tb <= '1';
        wait for 20 ns;

        wait;
    end process;

end Behavioral;