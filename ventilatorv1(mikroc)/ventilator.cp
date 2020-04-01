#line 1 "D:/ventilator project/ventilatorv1(mikroc)/ventilator.c"
#line 23 "D:/ventilator project/ventilatorv1(mikroc)/ventilator.c"
unsigned int bpmv=12;
unsigned int vol =450;
unsigned int i =0;
unsigned int count =5;



unsigned int led[8] = {1,0,0,0,0,1,0,0};

bit oldbpmup;
bit oldbpmdown;
bit oldvolup;
bit oldvoldown;
unsigned int startstatus = 0;


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

 if (Button(&PORTB, 6, 100, 0)) {
 oldbpmup = 1;
 }
 if (oldbpmup && Button(&PORTB, 6, 100, 1)) {
 oldbpmup = 0;
 bpmv++;
 Sound_Play(1318, 50);
 if(bpmv>16){
 bpmv=16;
 }
 if(bpmv<12){
 bpmv=12;
 }


 }

 if (Button(&PORTB, 7, 100, 0)) {
 oldbpmdown = 1;
 }
 if (oldbpmdown && Button(&PORTB, 7, 100, 1)) {
 oldbpmdown = 0;
 Sound_Play(1318, 50);

 bpmv--;
 if(bpmv>16){
 bpmv=16;
 }
 if(bpmv<12){
 bpmv=12;
 }


 }




 if (Button(&PORTB, 4, 100, 0)) {
 oldvolup = 1;
 }
 if (oldvolup && Button(&PORTB, 4, 100, 1)) {
 oldvolup = 0;
 Sound_Play(1000, 100);
 vol=vol+50;
 if(vol>550){
 vol=550;
 }
 if(vol<450){
 vol=450;
 }

 }

 if (Button(&PORTB, 5, 100, 0)) {
 oldvoldown = 1;
 }
 if (oldvoldown && Button(&PORTB, 5, 100, 1)) {
 oldvoldown = 0;
 Sound_Play(1000, 100);
 vol=vol-50;
 if(vol>550){
 vol=550;
 }
 if(vol<450){
 vol=450;
 }


 }


 if ( !startstatus && Button(&PORTC, 6, 100, 0)) {
 Sound_Play(1000, 100);
  PORTD.F4 =1;
 startstatus = 1;
 }
 if (startstatus && Button(&PORTC, 7, 100, 0)) {
 Sound_Play(500, 100);
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
Sound_Play(500, 500);
Sound_Play(1000, 500);
}
else
while(1){
 PORTD.F3 =0;
Sound_Play(1000, 500);
 PORTD.F3 =1;
Sound_Play(500, 500);
}
}





unsigned long millis_count=0;

unsigned long time1,time2;





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







void main()
{
PORTB=0;
TRISB=0xf0;
PORTC=0;
TRISC=0xff;
PORTD=0;
TRISD=0x00;
InitTimer0();


Sound_Init(&PORTD, 2);

selftest();
Delay_ms(100);
 PORTD.F4 =0;
 PORTD.F3 =0;
Delay_ms(100);

time1=millis();
while(1){

  PORTD.F4 =1;
 PORTD.F3 =1;
switches();


  PORTD.F5 =1;
  PORTD.F0 =1;
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 } for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 } for(i=0;i<count;i++){

 } for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 }
 for(i=0;i<count;i++){

 } for(i=0;i<count;i++){

 } for(i=0;i<count;i++){

 }

  PORTD.F5 =0;
  PORTD.F0 =0;



 if (millis()-time1>100)
 {
  PORTD.F3 =1 ;
  PORTD.F4 =0 ;
 time1=millis();
 }
 if (millis()-time1<=100)
 {
  PORTD.F3 =0 ;
  PORTD.F4 =1 ;
 time1=millis();
 }
}
}
