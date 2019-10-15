
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    // Reinitialize Timer1 value
    //TCNT1H=0xCF2C >> 8;
    //TCNT1L=0xCF2C & 0xff;
    TCNT1H=0xCF;
    TCNT1L=0x2C;

    // Place your code here
    if(RS232_FLAG)
    {
        Tmr_Cnt++;
    }

    if(RS232_FLAG && (Tmr_Cnt >= RS232_RS_Limit))
    {
       Clear_Set();
    }

}


