library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity processor_TB is
end processor_TB;

architecture Behavioral of processor_TB is
    component processor is
        port (
            CLK       : in  STD_LOGIC;
            RESET     : in  STD_LOGIC;
            PC        : out STD_LOGIC_VECTOR (31 downto 0);
            Instr     : out STD_LOGIC_VECTOR (31 downto 0);
            ALUResult : out STD_LOGIC_VECTOR (31 downto 0);
            WriteData : out STD_LOGIC_VECTOR (31 downto 0);
            Result    : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    signal CLK_tb, RESET_tb : STD_LOGIC := '0';
    signal PC_tb, Instr_tb, ALUResult_tb, WriteData_tb, Result_tb : STD_LOGIC_VECTOR(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT: processor
        port map (
            CLK       => CLK_tb,
            RESET     => RESET_tb,
            PC        => PC_tb,
            Instr     => Instr_tb,
            ALUResult => ALUResult_tb,
            WriteData => WriteData_tb,
            Result    => Result_tb
        );

    
    CLK_process : process
    begin
        CLK_tb <= '0';
        wait for CLK_PERIOD/2;
        CLK_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    
    stim_proc: process
    begin
        
        RESET_tb <= '1';
        wait for CLK_PERIOD;
        RESET_tb <= '0';

        wait for CLK_PERIOD * 20;

        wait;
    end process;

end Behavioral;