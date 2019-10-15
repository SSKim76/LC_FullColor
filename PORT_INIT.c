/**************************************************************************************

		02. Ports initialization

*************************************************************************************/

void PORT_INIT()
{
		// Crystal Oscillator division factor: 1

#pragma optsize-
    CLKPR=(1<<CLKPCE);
    CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif


			// PORT
			DDRA=(0<<DDA2) | (0<<DDA1) | (0<<DDA0);
			PORTA=(0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);


			DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
			PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

			DDRD=(0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
			PORTD=(0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);


			// USART initialization
			// Communication Parameters: 8 Data, 1 Stop, No Parity
			// USART Receiver: On
			// USART Transmitter: On
			// USART Mode: Asynchronous
			// USART Baud Rate: 9600

			// X-TAL 20MHz Setting
			UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
            UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
            UCSRC=(0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
            UBRRH=0x00;
            UBRRL=0x81;      // Crystal 20MHz Setting


            /* 8MHz Setting */  /*
            UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
            UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
            UCSRC=(0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
            UBRRH=0x00;
            UBRRL=0x33;
            */


             // Timer/Counter 1 initialization
            // Clock source: System Clock
            // Clock value: 2500.000 kHz
            // Mode: Normal top=0xFFFF
            // OC1A output: Disconnected
            // OC1B output: Disconnected
            // Noise Canceler: Off
            // Input Capture on Rising Edge
            // Timer Period: 5 ms
            // Timer1 Overflow Interrupt: On
            // Input Capture Interrupt: Off
            // Compare A Match Interrupt: Off
            // Compare B Match Interrupt: Off

            TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
            TCCR1B=(0<<ICNC1) | (1<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
            TCNT1H=0xCF;
            TCNT1L=0x2C;
            ICR1H=0x00;
            ICR1L=0x00;
            OCR1AH=0x00;
            OCR1AL=0x00;
            OCR1BH=0x00;
            OCR1BL=0x00;

}
