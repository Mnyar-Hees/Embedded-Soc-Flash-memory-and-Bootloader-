library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity case_3_vga_ip is
    port(
        clk_50   : in std_logic;           -- Klocka för 50 MHz
		  clk_25   : in std_logic;           -- vga clock 25 MHz
		  reset_n  : in std_logic_vector(9 downto 9);            -- Reset signal
		  
        VGA_HS : out std_logic;            -- Horisontell synkronisering
        VGA_VS : out std_logic;            -- Vertikal synkronisering
        VGA_R  : out std_logic_vector(3 downto 0); -- Röd färg
        VGA_G  : out std_logic_vector(3 downto 0); -- Grön färg
        VGA_B  : out std_logic_vector(3 downto 0); -- Blå färg
		  
		  avalon_write_n : in std_logic;         
		  avalon_read_n  : in std_logic;        
		  avalon_cs_n    : in std_logic;  
        avalon_addr    : in std_logic_vector(16 downto 0); 
		  avalon_din     : in std_logic_vector(31 downto 0);
        avalon_dout    : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of case_3_vga_ip is

    signal write_vga : std_logic;

	
	 signal addr_b_wire  : std_logic_vector(16 downto 0);
	 signal vga_data_r_wire  : std_logic_vector(2 downto 0);
	 

    -- Instansiera DualPort_RAM
    component DP_RAM is
        port(
            clk_a             : in std_logic;              -- Skrivklocka
            clk_b             : in std_logic;              -- Läsklocka
            addr_a            : in std_logic_vector(16 downto 0); -- Adress för skrivning
				addr_b            : in std_logic_vector(16 downto 0); -- Adress för läsning
            data_a            : in std_logic_vector(2 downto 0);  -- Data för skrivning
            we_a              : in std_logic := '1';         -- Skrivaktivering för port A
				q_a               : out std_logic_vector(2 downto 0);
            q_b               : out std_logic_vector(2 downto 0)
        );
    end component;



    -- Instansiera VGA_Sync
    component VGA_Sync is
        port(
           
            clk_25  : in std_logic;            
            reset_n : in std_logic_vector(9 downto 9);         
				data_a    : in std_logic_vector(2 downto 0);
				
            VGA_HS  : out std_logic;         -- Horisontell synkronisering
            VGA_VS  : out std_logic;         -- Vertikal synkronisering
            VGA_R   : out std_logic_vector(3 downto 0); -- Röd färg
            VGA_G   : out std_logic_vector(3 downto 0); -- Grön färg
            VGA_B   : out std_logic_vector(3 downto 0); -- Blå färg
				
            addr_a : out std_logic_vector(16 downto 0) 
        );
    end component;

begin

    -- Instansiera DualPort_RAM
    DP_RAM_inst : DP_RAM
        port map(
            clk_a => clk_50,               -- Skrivklocka (50 MHz)
            clk_b => clk_25,               -- Läsklocka (25 MHz)
            addr_a => avalon_addr,         -- Skrivadress kopplas till address_vga_w (goes to Test_komponent)
            data_a => avalon_din(2 downto 0),           -- Skrivdata
            addr_b => addr_b_wire,         -- Läseadress kopplas till vga_address (goes to VGA_Sync)
			
            we_a => write_vga,        -- Skrivsignal
				q_a  => avalon_dout(2 downto 0),
				q_b  => vga_data_r_wire
        );
		  --------------------------------------------
		  ------------ Avalon IF----------------------
        avalon_dout(31 downto 3) <= (others => '0');
		  
		 write_vga <= '1' when avalon_cs_n = '0' and
		                         avalon_read_n = '1' and
										 avalon_write_n = '0'
										 else '0';
      ------------------------------------------------

    -- Instansiera VGA_Sync
    vga_sync_inst : VGA_Sync
        port map(
            clk_25  => clk_25,              
            reset_n => reset_n,  
            data_a  => vga_data_r_wire,
				
            VGA_HS  => VGA_HS,             -- Horisontell synkronisering
            VGA_VS  => VGA_VS,             -- Vertikal synkronisering

            addr_a  => addr_b_wire,  
           
            VGA_R => VGA_R,               -- Röd färg
            VGA_G => VGA_G,               -- Grön färg
            VGA_B => VGA_B 
        );
        

end rtl;
