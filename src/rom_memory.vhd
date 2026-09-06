library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom_memory is
    generic (
        N : integer :=6;   
        M : integer :=32); 
    Port ( ADDR    :  in STD_LOGIC_VECTOR (N-1 downto 0);  
           ROM_OUT : out STD_LOGIC_VECTOR (M-1 downto 0)); 
end rom_memory;

architecture Behavioral of rom_memory is
    type rom_array is array (0 to (2**N)-1) of STD_LOGIC_VECTOR (M-1 downto 0);

    -- (Assembly instructions)
    signal ROM : rom_array := (
        0  => x"00A00093", -- addi x1, x0, 10
        1  => x"01400113", -- addi x2, x0, 20
        2  => x"002081B3", -- add  x3, x1, x2  
        3  => x"40218233", -- sub  x4, x3, x2  (C=1)
        4  => x"402082B3", -- sub  x5, x1, x2  (N=1)
        5  => x"0010C333", -- xor  x6, x1, x1  (Z=1)
        6  => x"00E0F393", -- andi x7, x1, 14
        7  => x"0050E413", -- ori  x8, x1, 5
        8  => x"004464B3", -- or   x9, x8, x4
        9  => x"00744513", -- xori x10, x8, 7
        10 => x"0082A5B3", -- slt  x11, x5, x8
        11 => x"00A2B633", -- sltu x12, x5, x10 (Z=1)
        12 => x"00432023", -- sw   x4, 0(x6)
        13 => x"00A32223", -- sw   x10, 4(x6)
        14 => x"00432683", -- lw   x13, 4(x6)
        15 => x"00940463", -- beq  x8, x9, +8  (Z=1)
        16 => x"00440733", -- add  x14, x8, x4
        17 => x"00D51463", -- bne  x10, x13, +8
        18 => x"40A207B3", -- sub  x15, x4, x10
        19 => x"FA000AE3", -- beq  x0, x0, _start !!!  FB4006E3
        others => (others => '0') 
    );

begin

    ROM_OUT <= ROM(to_integer(unsigned(ADDR)));

end Behavioral;
