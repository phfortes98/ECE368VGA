----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:57:05 02/11/2017 
-- Design Name: 
-- Module Name:    vgaTest1_Top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_RGB_Top is
  Port (clk     : in std_logic;
        sw      : in std_logic_vector(7 downto 0);
        vgaRed   : out std_logic_vector(3 downto 0);
        vgaGreen : out std_logic_vector(3 downto 0);
        vgaBlue  : out std_logic_vector(3 downto 0);
        Hsync    : out std_logic;
        Vsync    : out std_logic;
        copy_Hsync    : out std_logic;
        copy_Vsync    : out std_logic);
end VGA_RGB_Top;

architecture Behavioral of VGA_RGB_Top is
	COMPONENT vga_controller
	PORT(
		RST : IN std_logic;
		PIXEL_CLK : IN std_logic;          
		HS : OUT std_logic;
		VS : OUT std_logic;
		HCOUNT : OUT std_logic_vector(10 downto 0);
		VCOUNT : OUT std_logic_vector(10 downto 0);
		BLANK : OUT std_logic
		);
	END COMPONENT;
  
  signal HC : std_logic_vector(10 downto 0);
  signal VC : std_logic_vector(10 downto 0);
  signal HSTemp: std_logic;
  signal VSTemp: std_logic;
  signal Blank : std_logic;
  signal Clk_25M :std_logic;
begin

  process (clk)
  begin 
   if(rising_edge(clk)) then
    Clk_25M <=not Clk_25M;
   end if;
  end process;


	Inst_vga_controller: vga_controller PORT MAP(
		RST => sw(7),
		PIXEL_CLK => Clk_25M,
		HS => HSTemp,
		VS => VSTemp,
		HCOUNT => HC,
		VCOUNT => VC,
		BLANK => Blank
	);

  
  vgaRed(3 downto 0)   <= HC(8 downto 5) when (Blank='0' and sw(0)='1') else (others=>'0');
  vgaGreen(3 downto 0) <= VC(7 downto 4) when (Blank='0' and sw(1)='1') else (others=>'0');
  vgaBlue(3 downto 0)  <= HC(5 downto 2) when (Blank='0' and sw(2)='1') else (others=>'0');
   
  copy_HSYNC <= HSTemp;
  copy_VSYNC <= VSTemp;

  HSYNC <= HSTemp;
  VSYNC <= VSTemp;


end Behavioral;