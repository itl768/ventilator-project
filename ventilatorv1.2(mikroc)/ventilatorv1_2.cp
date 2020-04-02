#line 1 "D:/ventilator project/ventilatorv1.2(mikroc)/ventilatorv1_2.c"
#line 44 "D:/ventilator project/ventilatorv1.2(mikroc)/ventilatorv1_2.c"
unsigned int bpmv=12;
unsigned int vol =450;
unsigned int led[8] = {1,0,0,0,0,1,0,0};

bit oldbpmup;
bit oldbpmdown;
bit oldvolup;
bit oldvoldown;
unsigned int startstatus = 0;

unsigned int s9=0;
unsigned int s10=0;
unsigned int s4=0;
unsigned int p1=0;
unsigned int p2=0;
unsigned int p3=0;
unsigned int p_1=0;
unsigned int p_2=0;
unsigned int temperature=0;



unsigned long millis_count=0;
unsigned int tempmillis=0;








void InitTimer0(){
 OPTION_REG = 0x84;
 TMR0 = 100;
 INTCON = 0xA0;
}

void Interrupt(){
 if (TMR0IF_bit){
 TMR0IF_bit = 0;
 TMR0 = 100;

 millis_count++;

 }

}

unsigned long millis()
{
 return(millis_count);
}


void alarm(int tm){
 int alarm_millis=millis();
 while(millis()-alarm_millis<=tm){
  PORTD.F2 =1;
 }
  PORTD.F2 =0;
}


void shiftdata595(int _shiftdata[])
{
unsigned int i;

i=8;
while (i>0)
{
 PORTB.B0 =_shiftdata[i-1];
 PORTB.B2  = 1;
Delay_us(1);
 PORTB.B2  = 0;
i--;
}
}

void latch595()
{
 PORTB.B1  = 1;
Delay_us(1);
 PORTB.B1  = 0;
}



void switches(){

 if (Button(&PORTB, 6, 1, 0)) {
 oldbpmup = 1;
 }
 if (oldbpmup && Button(&PORTB, 6, 1, 1)) {
 oldbpmup = 0;
 bpmv++;

 if(bpmv>16){
 bpmv=16;
 }
 if(bpmv<12){
 bpmv=12;
 }


 }

 if (Button(&PORTB, 7, 1, 0)) {
 oldbpmdown = 1;
 }
 if (oldbpmdown && Button(&PORTB, 7, 1, 1)) {
 oldbpmdown = 0;

 bpmv--;
 if(bpmv>16){
 bpmv=16;
 }
 if(bpmv<12){
 bpmv=12;
 }


 }




 if (Button(&PORTB, 4, 1, 0)) {
 oldvolup = 1;
 }
 if (oldvolup && Button(&PORTB, 4, 1, 1)) {
 oldvolup = 0;

 vol=vol+50;
 if(vol>550){
 vol=550;
 }
 if(vol<450){
 vol=450;
 }

 }

 if (Button(&PORTB, 5, 1, 0)) {
 oldvoldown = 1;
 }
 if (oldvoldown && Button(&PORTB, 5, 1, 1)) {
 oldvoldown = 0;

 vol=vol-50;
 if(vol>550){
 vol=550;
 }
 if(vol<450){
 vol=450;
 }


 }


 if ( !startstatus && Button(&PORTC, 6, 1, 0)) {

  PORTD.F4 =1;
 startstatus = 1;
 }
 if (startstatus && Button(&PORTC, 7, 1, 0)) {

  PORTD.F4 =0;
 startstatus = 0;
 }



switch (vol){
 case 450:
 led[5]=1;
 led[6]=0;
 led[7]=0;

 break;
 case 500:
 led[5]=0;
 led[6]=1;
 led[7]=0;

 break;
 case 550:
 led[5]=0;
 led[6]=0;
 led[7]=1;

 break;

 }

switch (bpmv){
 case 12:
 led[0]=1;
 led[1]=0;
 led[2]=0;
 led[3]=0;
 led[4]=0;
 break;
 case 13:
 led[0]=0;
 led[1]=1;
 led[2]=0;
 led[3]=0;
 led[4]=0;
 break;
 case 14:
 led[0]=0;
 led[1]=0;
 led[2]=1;
 led[3]=0;
 led[4]=0;
 break;
 case 15:
 led[0]=0;
 led[1]=0;
 led[2]=0;
 led[3]=1;
 led[4]=0;
 break;
 case 16:
 led[0]=0;
 led[1]=0;
 led[2]=0;
 led[3]=0;
 led[4]=1;
 break;
 }

 shiftdata595(led);
 latch595();


}


void selftest(){








if(1){
 PORTD.F3 =1;

}
else
while(1){
 PORTD.F3 =0;

 PORTD.F3 =1;

}
}

void read_sensor_data(){
 s4=ADC_Read(0);
 delay_ms(100);
 s9= ADC_Read(1);
 delay_ms(100);
 s10 = ADC_Read(2);
 delay_ms(100);
 p1 = ADC_Read(3);
 delay_ms(100);
 p2 = ADC_Read(4);
 delay_ms(100);
 p3 = ADC_Read(5);
 delay_ms(100);
 p_1 = ADC_Read(6);
 delay_ms(100);
 p_2 = ADC_Read(7);
 delay_ms(100);
}




int tempt=0;


void main()
{

ADCON1 = 0x80;
TRISA = 0xFF;
PORTB=0;
TRISB=0xf0;
PORTC=0;
TRISC=0xff;
PORTD=0x00;
TRISD=0x00;
TRISE = 0x07;
ADC_Init();


ADC_Init();

selftest();

while(1){
read_sensor_data();
switches();
delay_ms(100);

}
}
