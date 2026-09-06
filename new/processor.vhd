library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity processor is
    generic (
        N_PC  : integer := 5; 
        N_RAM : integer := 5  
    );
    port (
        CLK        : in  STD_LOGIC;
        RESET      : in  STD_LOGIC;
        
        
        PC         : out STD_LOGIC_VECTOR (31 downto 0);
        Instr      : out STD_LOGIC_VECTOR (31 downto 0);
        ALUResult  : out STD_LOGIC_VECTOR (31 downto 0);
        WriteData  : out STD_LOGIC_VECTOR (31 downto 0);
        Result     : out STD_LOGIC_VECTOR (31 downto 0)
    );
end processor;

architecture Structural of processor is

    
    component datapath is
        generic (
            N_PC  : integer := 5;
            N_RAM : integer := 5
        );
        port (
            CLK        : in  STD_LOGIC;
            RESET      : in  STD_LOGIC;
            RegWrite   : in  STD_LOGIC;
            ImmSrc     : in  STD_LOGIC_VECTOR (1 downto 0);
            ALUSrc     : in  STD_LOGIC;
            MemWrite   : in  STD_LOGIC;
            ResultSrc  : in  STD_LOGIC;
            ALUControl : in  STD_LOGIC_VECTOR (2 downto 0);
            SLTUorSLT  : in  STD_LOGIC;
            PCSrc      : in  STD_LOGIC;
            op         : out STD_LOGIC_VECTOR (6 downto 2);
            funct3     : out STD_LOGIC_VECTOR (2 downto 0);
            funct7_5   : out STD_LOGIC;
            NZCV       : out STD_LOGIC_VECTOR (3 downto 0);
            PC_out     : out STD_LOGIC_VECTOR (31 downto 0);
            Instr_out  : out STD_LOGIC_VECTOR (31 downto 0);
            ALUResult_o: out STD_LOGIC_VECTOR (31 downto 0);
            WriteData_o: out STD_LOGIC_VECTOR (31 downto 0);
            Result_o   : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    
    component control_unit is
        port (
            op        : in  STD_LOGIC_VECTOR (6 downto 2);
            funct3    : in  STD_LOGIC_VECTOR (2 downto 0);
            funct7_5  : in  STD_LOGIC;
            NZCV      : in  STD_LOGIC_VECTOR (3 downto 0);
            RegWrite  : out STD_LOGIC;
            ImmSrc    : out STD_LOGIC_VECTOR (1 downto 0);
            ALUSrc    : out STD_LOGIC;
            MemWrite  : out STD_LOGIC;
            ResultSrc : out STD_LOGIC;
            ALUControl: out STD_LOGIC_VECTOR (2 downto 0);
            SLTUorSLT  : out STD_LOGIC;
            PCSrc     : out STD_LOGIC
        );
    end component;

    
    
    
    signal op_s       : STD_LOGIC_VECTOR(6 downto 2);
    signal funct3_s   : STD_LOGIC_VECTOR(2 downto 0);
    signal funct7_5_s : STD_LOGIC;
    signal NZCV_s     : STD_LOGIC_VECTOR(3 downto 0);

    
    signal RegWrite_s  : STD_LOGIC;
    signal ImmSrc_s    : STD_LOGIC_VECTOR(1 downto 0);
    signal ALUSrc_s    : STD_LOGIC;
    signal MemWrite_s  : STD_LOGIC;
    signal ResultSrc_s : STD_LOGIC;
    signal ALUControl_s: STD_LOGIC_VECTOR(2 downto 0);
    signal SLTUorSLT_s  : STD_LOGIC;
    signal PCSrc_s     : STD_LOGIC;

begin

    
    U_DATAPATH: datapath
        generic map (
            N_PC  => N_PC,
            N_RAM => N_RAM
        )
        port map (
            CLK         => CLK,
            RESET       => RESET,
            
            RegWrite    => RegWrite_s,
            ImmSrc      => ImmSrc_s,
            ALUSrc      => ALUSrc_s,
            MemWrite    => MemWrite_s,
            ResultSrc   => ResultSrc_s,
            ALUControl  => ALUControl_s,
            SLTUorSLT   => SLTUorSLT_s,
            PCSrc       => PCSrc_s,
            
            op          => op_s,
            funct3      => funct3_s,
            funct7_5    => funct7_5_s,
            NZCV        => NZCV_s,
            
            PC_out      => PC,
            Instr_out   => Instr,
            ALUResult_o => ALUResult,
            WriteData_o => WriteData,
            Result_o    => Result
        );

    
    U_CONTROL_UNIT: control_unit
        port map (
            
            op         => op_s,
            funct3     => funct3_s,
            funct7_5   => funct7_5_s,
            NZCV       => NZCV_s,
            
            RegWrite   => RegWrite_s,
            ImmSrc     => ImmSrc_s,
            ALUSrc     => ALUSrc_s,
            MemWrite   => MemWrite_s,
            ResultSrc  => ResultSrc_s,
            ALUControl => ALUControl_s,
            SLTUorSLT   => SLTUorSLT_s,
            PCSrc      => PCSrc_s
        );

end Structural;
