library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    generic ( N : integer :=32);
    Port ( A :  in STD_LOGIC_VECTOR (N-1 downto 0);
           B :  in STD_LOGIC_VECTOR (N-1 downto 0);
           Y : out STD_LOGIC_VECTOR (N-1 downto 0));
end adder;

architecture Behavioral of adder is

begin
    Y <= std_logic_vector(unsigned(A) + unsigned(B));
end Behavioral;
