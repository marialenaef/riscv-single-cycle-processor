library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
    generic (
        N_PC  : integer := 6; -- ROM address bits (32 positions)
        N_RAM : integer := 5  -- RAM address bits (32 positions)
    );
    port (
        CLK        : in  STD_LOGIC;
        RESET      : in  STD_LOGIC;
        
        -- Control Signals (from Control Unit)
        RegWrite   : in  STD_LOGIC;
        ImmSrc     : in  STD_LOGIC_VECTOR (1 downto 0);
        ALUSrc     : in  STD_LOGIC;
        MemWrite   : in  STD_LOGIC;
        ResultSrc  : in  STD_LOGIC;
        ALUControl : in  STD_LOGIC_VECTOR (2 downto 0);
        SLTUorSLT  : in  STD_LOGIC;
        PCSrc      : in  STD_LOGIC;
        
        -- Outputs to Control Unit
        op         : out STD_LOGIC_VECTOR (6 downto 2);
        funct3     : out STD_LOGIC_VECTOR (2 downto 0);
        funct7_5   : out STD_LOGIC;
        NZCV       : out STD_LOGIC_VECTOR (3 downto 0);
        
        -- Outputs for Debugging / Top-Level
        PC_out     : out STD_LOGIC_VECTOR (31 downto 0);
        Instr_out  : out STD_LOGIC_VECTOR (31 downto 0);
        ALUResult_o: out STD_LOGIC_VECTOR (31 downto 0);
        WriteData_o: out STD_LOGIC_VECTOR (31 downto 0);
        Result_o   : out STD_LOGIC_VECTOR (31 downto 0)
    );
end datapath;

architecture Structural of datapath is

    -- 1. Components Statements
    component pc_reg is
        generic (N : integer := 32);
        port (
            CLK    : in  STD_LOGIC;
            RESET  : in  STD_LOGIC;
            PCNext : in  STD_LOGIC_VECTOR (N-1 downto 0);
            PC     : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    component adder is
        generic (N : integer := 32);
        port (
            A : in  STD_LOGIC_VECTOR (N-1 downto 0);
            B : in  STD_LOGIC_VECTOR (N-1 downto 0);
            Y : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    component mux2to1 is
        generic (N : integer := 32);
        port (
            Sel : in  STD_LOGIC;
            In0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            In1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            Y   : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    component rom_memory is
        generic (N : integer := 6; M : integer := 32);
        port (
            ADDR    : in  STD_LOGIC_VECTOR (N-1 downto 0);
            ROM_OUT : out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;

    component register_file is
        generic (N : integer := 5; M : integer := 32);
        port (
            CLK : in  STD_LOGIC;
            WE3 : in  STD_LOGIC;
            A1  : in  STD_LOGIC_VECTOR (N-1 downto 0);
            A2  : in  STD_LOGIC_VECTOR (N-1 downto 0);
            A3  : in  STD_LOGIC_VECTOR (N-1 downto 0);
            WD3 : in  STD_LOGIC_VECTOR (M-1 downto 0);
            RD1 : out STD_LOGIC_VECTOR (M-1 downto 0);
            RD2 : out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;

    component extend is
        port (
            Instr  : in  STD_LOGIC_VECTOR (31 downto 7);
            ImmSrc : in  STD_LOGIC_VECTOR (1 downto 0);
            ExtImm : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    component alu is
        generic (N : integer := 32);
        port (
            SrcA       : in  STD_LOGIC_VECTOR (N-1 downto 0);
            SrcB       : in  STD_LOGIC_VECTOR (N-1 downto 0);
            ALUControl : in  STD_LOGIC_VECTOR (2 downto 0);
            SLTUorSLT  : in  STD_LOGIC;
            ALUResult  : out STD_LOGIC_VECTOR (N-1 downto 0);
            NZCV       : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    component ram_memory is
        generic (N : integer := 5; M : integer := 32);
        port (
            CLK  : in  STD_LOGIC;
            WE   : in  STD_LOGIC;
            ADDR : in  STD_LOGIC_VECTOR (N-1 downto 0);
            WD   : in  STD_LOGIC_VECTOR (M-1 downto 0);
            RD   : out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;

    -- 2. Internal Signals
    signal PC_s, PCNext_s, PCPlus4_s, PCTarget_s : STD_LOGIC_VECTOR(31 downto 0);
    signal Instr_s                               : STD_LOGIC_VECTOR(31 downto 0);
    signal RD1_s, RD2_s                          : STD_LOGIC_VECTOR(31 downto 0);
    signal ExtImm_s                              : STD_LOGIC_VECTOR(31 downto 0);
    signal SrcB_s                                : STD_LOGIC_VECTOR(31 downto 0);
    signal ALUResult_s                           : STD_LOGIC_VECTOR(31 downto 0);
    signal ReadData_s                            : STD_LOGIC_VECTOR(31 downto 0);
    signal Result_s                              : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- 1. Program Counter Register (PC)
    U_PC_REG: pc_reg
        port map (
            CLK    => CLK,
            RESET  => RESET,
            PCNext => PCNext_s,
            PC     => PC_s
        );

    -- 2. Adder PC + 4 (INC4)
    U_ADD_PC4: adder
        port map (
            A => PC_s,
            B => x"00000004",
            Y => PCPlus4_s
        );

    -- 3. Instruction Memory (ROM) 
    U_ROM: rom_memory
        generic map (N => N_PC, M => 32)
        port map (
            ADDR    => PC_s(N_PC+1 downto 2),
            ROM_OUT => Instr_s
        );

    -- 4. Register File
    U_REG_FILE: register_file
        generic map (N => 5, M => 32)
        port map (
            CLK => CLK,
            WE3 => RegWrite,
            A1  => Instr_s(19 downto 15), -- Rs1
            A2  => Instr_s(24 downto 20), -- Rs2
            A3  => Instr_s(11 downto 7),  -- Rd
            WD3 => Result_s,
            RD1 => RD1_s,
            RD2 => RD2_s
        );

    -- 5. Extend Unit
    U_EXTEND: extend
        port map (
            Instr  => Instr_s(31 downto 7),
            ImmSrc => ImmSrc,
            ExtImm => ExtImm_s
        );

    -- 6. ALU Input MUX (ALUSrc MUX)
    U_MUX_ALU: mux2to1
        port map (
            Sel => ALUSrc,
            In0 => RD2_s,
            In1 => ExtImm_s,
            Y   => SrcB_s
        );

    -- 7. Arithmetic and Logic Unit (ALU)
    U_ALU: alu
        port map (
            SrcA       => RD1_s,
            SrcB       => SrcB_s,
            ALUControl => ALUControl,
            SLTUorSLT  => SLTUorSLT,
            ALUResult  => ALUResult_s,
            NZCV       => NZCV
        );

    -- 8. Branch Target Adder (PCTarget = PC + ExtImm)
    U_ADD_TARGET: adder
        port map (
            A => PC_s,
            B => ExtImm_s,
            Y => PCTarget_s
        );

    -- 9. Data Memory (RAM) 
    U_RAM: ram_memory
        generic map (N => N_RAM, M => 32)
        port map (
            CLK  => CLK,
            WE   => MemWrite,
            ADDR => ALUResult_s(N_RAM+1 downto 2),
            WD   => RD2_s,
            RD   => ReadData_s
        );

    -- 10. Result Multiplexer (ResultSrc MUX)
    U_MUX_RESULT: mux2to1
        port map (
            Sel => ResultSrc,
            In0 => ALUResult_s,
            In1 => ReadData_s,
            Y   => Result_s
        );

    -- 11. Next PC Multiplexer (PCSrc MUX)
    U_MUX_PC: mux2to1
        port map (
            Sel => PCSrc,
            In0 => PCPlus4_s,
            In1 => PCTarget_s,
            Y   => PCNext_s
        );

    -- 12. Allocation of outputs to Control Unit & Top-Level
    op          <= Instr_s(6 downto 2);
    funct3      <= Instr_s(14 downto 12);
    funct7_5    <= Instr_s(30);
    
    PC_out      <= PC_s;
    Instr_out   <= Instr_s;
    ALUResult_o <= ALUResult_s;
    WriteData_o <= RD2_s;
    Result_o    <= Result_s;

end Structural;