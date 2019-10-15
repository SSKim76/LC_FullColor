/*************************************************************************************
		01. DEFINE.c

*************************************************************************************/

#define F_CPU   20000000

unsigned char		    UART0_DATA		=	0;
char				    RS232_BUFF[10];
unsigned char           NDX_232 		=	0;
bit 				    RS232_FLAG  	=   0;
bit 				    RS_Finish_Flag  =   0;

unsigned char	        default_Color   =   0x03;	// Amber
char                    rtnMsg[9]       =   {0x1B, 0x02, 0x52, 0x00, 0x00, 0x00, 0x00, 0x03, 0x0D};

//unsigned char UART_CNT      =   0;
//unsigned char txCnt = 0;
//unsigned char ERROR_STR[20];

unsigned char       Tmr_Cnt         =   0;
unsigned char       RS232_RS_Limit  =   6;      // 1 = 5ms, 2 = 10ms, 5 = 25ms