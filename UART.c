	/********************************************************************

		UART

	********************************************************************/

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)


// USART Receiver buffer
#define RX_BUFFER_SIZE 16
char rx_buffer[RX_BUFFER_SIZE];

// This flag is set on USART Receiver buffer overflow
//bit rx_buffer_overflow;


void putchar0(char c)
{
    while ((UCSRA & DATA_REGISTER_EMPTY)==0);
    UDR=c;
}


void putString0(char *c)
{
    unsigned char PcCnt = 0;


    for(PcCnt = 0; PcCnt <= 8 ; PcCnt++)
    {
        while ((UCSRA & DATA_REGISTER_EMPTY)==0);
        UDR=c[PcCnt];
    }


    /*
    for(PcCnt= 0 ; PcCnt < (sizeof(c)/sizeof(c[0])); PcCnt++)
    {
        while ((UCSRA & DATA_REGISTER_EMPTY)==0);
        UDR=c[PcCnt];
    }
     */
}



// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
		char status,data;
		status=UCSRA;
		data=UDR;

		if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
		   {
					UART0_DATA=data;
                    //putchar0(UART0_DATA);

                    //  if(UART0_DATA =="STX" )                                          // UART0_DATA가 STX 일 경우....
                    //  if(UART0_DATA == 0x02)
                    if(UART0_DATA == 0x1B)
                      {
                              Tmr_Cnt = 0;
                              NDX_232 = 0;
                              RS232_FLAG = 1;
                      }

                      if(RS232_FLAG)
                      {
                            //if(UART0_DATA == 0x02)
                              if(UART0_DATA == 0x1B)
                              {
                                      RS232_BUFF[NDX_232] =   UART0_DATA;
                              }
                              else
                              {
                                      RS232_BUFF[++NDX_232] =   UART0_DATA;
                              }


                              //if(UART0_DATA ==  0x03 && NDX_232 == 4)
                              if((UART0_DATA ==  0x0D && NDX_232 == 5) || (UART0_DATA == 0x0D && NDX_232 == 8))
                              {
                                        RS_Finish_Flag = 1;
									  	//RS232_FLAG = 0;
                                        //NDX_232 = 0;
                              }	        // END of if(상태요청, 또는 조명 상태변경 일 경우)

                      }	                // END of  if(RS232_FLAG)

                    UART0_DATA = 0;

	   }	        // END of if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
}                       // END of 	interrupt [USART_RXC] void usart_rx_isr(void)
