	#include <tiny2313.h>
    #include <stdio.h>
	#include <delay.h>
	#include <string.h>



void SELECT_Light(unsigned char *USER_SELECT);
void Clear_Set();
void CHK_Light();



#include "DEFINE.c"
#include "PORT_INIT.c"
#include "TMR.c"
#include "UART.c"


void Clear_Set()
{
	memset(RS232_BUFF,0x00,sizeof(RS232_BUFF));             //Buff �ʱ�ȭ
	RS_Finish_Flag = 0;
    RS232_FLAG = 0;
	Tmr_Cnt = 0;
    NDX_232 = 0;
}



void CHK_Light()
{
        unsigned char cnt = 0;

        rtnMsg[4] = PINB.0 ;   // PORTB.0(R) �� �о� rtnMsg[4]�� ����
        rtnMsg[5] = PINB.1;   // PORTB.1(G) �� �о� rtnMsg[5]�� ����
        rtnMsg[6] = PINB.2;   // PORTB.2(B) �� �о� rtnMsg[6]�� ����


        for(cnt = 4 ; cnt <= 6 ; cnt++)
        {
            if(rtnMsg[cnt])
            {
                rtnMsg[cnt] = 0xFF;
            }

            //putchar0(rtnMsg[cnt]);
        }

        putString0(rtnMsg);    // �������� ����
}

void SELECT_Light(unsigned char *USER_SELECT)
{
        unsigned char PORT_DATA = 0;

        if(USER_SELECT[4]) PORT_DATA += 1;      // R Color

        if(USER_SELECT[5]) PORT_DATA += 2;      // G Color

        if(USER_SELECT[6]) PORT_DATA += 4;      // B Color

        PORTB = PORT_DATA;

        //putchar0(PORT_DATA);

        CHK_Light();      // �������� ����
}


void main(void)
{
        unsigned char lcnt = 0;
        PORT_INIT();

        #asm("sei");         // ��ü ���ͷ�Ʈ ���

        PORTB = 0xFF;
        delay_ms(250);

        for(lcnt = 1; lcnt <= 8; lcnt++)
        {
            PORTB = lcnt;
            delay_ms(150);
        }

        PORTB = default_Color;


    while (1)
    {
                 // Place your code here
				if(RS_Finish_Flag)
				{
                    switch (RS232_BUFF[2])
                    {
                        case 0x53 :     // ���¿�û
                            CHK_Light();
                            break;

                        case 0x43 :    // ��������
                            SELECT_Light(RS232_BUFF);
                            break;
                    };

                    Clear_Set();

				}

    }
}