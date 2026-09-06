library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
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
end control_unit;

architecture Structural of control_unit is

    component instr_dec is
        port (
            op        : in  STD_LOGIC_VECTOR (6 downto 2);
            RegWrite  : out STD_LOGIC;
            ImmSrc    : out STD_LOGIC_VECTOR (1 downto 0);
            ALUSrc    : out STD_LOGIC;
            MemWrite  : out STD_LOGIC;
            ResultSrc : out STD_LOGIC;
            rop       : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    component alu_dec is
        port (
            funct3     : in  STD_LOGIC_VECTOR (2 downto 0);
            funct7_5   : in  STD_LOGIC;
            rop        : in  STD_LOGIC_VECTOR (2 downto 0);
            ALUControl : out STD_LOGIC_VECTOR (2 downto 0);
            SLTUorSLT  : out STD_LOGIC
        );
    end component;

    component pc_logic is
        port (
            funct3 : in  STD_LOGIC_VECTOR (2 downto 0);
            rop    : in  STD_LOGIC_VECTOR (2 downto 0);
            NZCV   : in  STD_LOGIC_VECTOR (3 downto 0);
            PCSrc  : out STD_LOGIC
        );
    end component;

    signal rop_s : STD_LOGIC_VECTOR(2 downto 0);

begin

    U_INSTR_DEC: instr_dec
        port map (
            op        => op,
            RegWrite  => RegWrite,
            ImmSrc    => ImmSrc,
            ALUSrc    => ALUSrc,
            MemWrite  => MemWrite,
            ResultSrc => ResultSrc,
            rop       => rop_s
        );

    U_ALU_DEC: alu_dec
        port map (
            funct3     => funct3,
            funct7_5   => funct7_5,
            rop        => rop_s,
            ALUControl => ALUControl,
            SLTUorSLT  => SLTUorSLT
        );

    U_PC_LOGIC: pc_logic
        port map (
            funct3 => funct3,
            rop    => rop_s,
            NZCV   => NZCV,
            PCSrc  => PCSrc
        );

end Structural;
