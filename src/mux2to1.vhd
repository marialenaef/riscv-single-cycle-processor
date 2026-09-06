library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    generic ( N : integer :=32);
    Port ( Sel :  in STD_LOGIC;
           In0 :  in STD_LOGIC_VECTOR (N-1 downto 0);
           In1 :  in STD_LOGIC_VECTOR (N-1 downto 0);
           Y   : out STD_LOGIC_VECTOR (N-1 downto 0));
end mux2to1;

architecture Behavioral of mux2to1 is

begin
    Y <= In0 when Sel = '0' else In1;
end Behavioral;
