// CONFIG
#pragma config FOSC = HS        // Oscillator Selection bits (HS oscillator)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = ON       // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOREN = ON       // Brown-out Reset Enable bit (BOR enabled)
#pragma config LVP = OFF        // Low-Voltage (Single-Supply) In-Circuit Serial Programming Enable bit (RB3 is digital I/O, HV on MCLR must be used for programming)
#pragma config CPD = OFF        // Data EEPROM Memory Code Protection bit (Data EEPROM code protection off)
#pragma config WRT = OFF        // Flash Program Memory Write Enable bits (Write protection off; all program memory may be written to by EECON control)
#pragma config CP = OFF         // Flash Program Memory Code Protection bit (Code protection off)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#define _XTAL_FREQ 20000000

//TIMER0    8-bit    $$RegValue = 256-((Delay * Fosc)/(Prescalar*4))  delay in sec and Fosc in hz
//FORMULA to calculate Delay
//Delay = ((256-REG_val)*(Prescal*4))/Fosc

char hscnd = 0;
int count = 0;
char get_scnds =0;
char flag =0;
char i=0;

void interrupt timer_isr()
{
    if(TMR0IF==1) // Timer flag has been triggered due to timer overflow
    {
        TMR0 = 100;     //Load the timer Value
        TMR0IF=0;       // Clear timer interrupt flag
        count++;
    }

    if (count == 250)
    {
        hscnd+=1;   // hscnd will get incremented for every half second
        count=0;
    }
}

void main()
{
/*****Port Configuration for Timer ******/
    OPTION_REG = 0b00000101;  // Timer0 with external freq and 64 as prescalar // Also Enables PULL UPs
    TMR0=100;       // Load the time value for 0.0019968s; delayValue can be between 0-256 only
    TMR0IE=1;       //Enable timer interrupt bit in PIE1 register
    GIE=1;          //Enable Global Interrupt
    PEIE=1;         //Enable the Peripheral Interrupt
    /***********______***********/

    /*****Port Configuration for I/O ******/
    TRISB0=1; //Instruct the MCU that the PORTB pin 0 is used as input for button 1.
    TRISB1=1; //Instruct the MCU that the PORTB pin 1 is used as input for button 1.
    TRISD = 0x00; //Instruct the MCU that all pins on PORT D are output
    PORTD=0x00; //Initialize all pins to 0
    /***********______***********/

    while(1)
    {
        count =0; //Do not run timer while in main loop

        //*******Get the number delay from user****//////
        if (RB0==0 && flag==0) //When input given
        {
            get_scnds+=1; //get_scnds=get_scnds+1//Increment variable
            flag=1;
        }
        if (RB0==1) //To prevent continuous incrementation
            flag=0;
        /***********______***********/


        //*******Execute sequence with delay****//////
        while (RB1==0)
        {
                PORTD = 0b00000001<<i;  //Left shit LED by i
                if(hscnd==get_scnds) //If the required time is reached
                {
                    i+=1; //Move to next LED after the defined Delay
                    hscnd=0;
                }
                flag=2;
        }
        if (flag==2 && RB1==1) //Reset timer if button is high again
        {
            get_scnds=0;hscnd=0;i=0;
            PORTD=0; //Turn off all LEDs
        }
        /***********______***********/
    }
}