#line 1 "C:/Users/acer/Documents/GitHub/ventilator-project/Timer/MyProject.c"
#pragma config FOSC = HS
#pragma config WDTE = OFF
#pragma config PWRTE = ON
#pragma config BOREN = ON
#pragma config LVP = OFF
#pragma config CPD = OFF
#pragma config WRT = OFF
#pragma config CP = OFF
#line 21 "C:/Users/acer/Documents/GitHub/ventilator-project/Timer/MyProject.c"
char hscnd = 0;
int count = 0;
char get_scnds =0;
char flag =0;
char i=0;

void interrupt timer_isr()
{
 if(TMR0IF==1)
 {
 TMR0 = 100;
 TMR0IF=0;
 count++;
 }

 if (count == 250)
 {
 hscnd+=1;
 count=0;
 }
}

void main()
{

 OPTION_REG = 0b00000101;
 TMR0=100;
 TMR0IE=1;
 GIE=1;
 PEIE=1;



 TRISB0=1;
 TRISB1=1;
 TRISD = 0x00;
 PORTD=0x00;


 while(1)
 {
 count =0;


 if (RB0==0 && flag==0)
 {
 get_scnds+=1;
 flag=1;
 }
 if (RB0==1)
 flag=0;




 while (RB1==0)
 {
 PORTD = 0b00000001<<i;
 if(hscnd==get_scnds)
 {
 i+=1;
 hscnd=0;
 }
 flag=2;
 }
 if (flag==2 && RB1==1)
 {
 get_scnds=0;hscnd=0;i=0;
 PORTD=0;
 }

 }
}
