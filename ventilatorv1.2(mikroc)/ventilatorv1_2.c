 /*
 **************READ ME**********
 this is a test sketch to test cycle time of pic 16f877a
there are 20 for loops for each sensor
by changing "count" variable you can set how many times each for loop should run

start led and test led will indicate the cycle time
if the cycle time is less than 100ms start led will turn on
if cycle time is more than 100ms test led will turn on

after powering up it will take few seconds to go to the main loop then the results can be obtained.


 */



 //sensor inputs

#define sensor_s1 PORTC.B3
#define sensor_s2 PORTC.B4
#define sensor_s3 PORTC.B5



//outputs
#define dcv1 PORTD.F0
#define dcv2 PORTD.F1
#define buz PORTD.F2
#define testl PORTD.F3
#define startl PORTD.F4
#define s2v PORTD.F5
#define heater PORTD.F6

//shift register pin confguration
#define SHIFT_CLOCK PORTB.B2
#define SHIFT_LATCH PORTB.B1
#define SHIFT_DATA PORTB.B0

unsigned int bpmv=12;   //defualt bpm
unsigned int vol =450;  //default volume
unsigned int led[8] = {1,0,0,0,0,1,0,0};  //default values for led panel

bit oldbpmup;    //button variables
bit oldbpmdown;
bit oldvolup;
bit oldvoldown;
unsigned int startstatus = 0;
//storing sensor data
unsigned int s9=0;         //flow sensor s9
unsigned int s10=0;         //flow sensor s10
unsigned int s4=0;          //flow sensor s4
unsigned int p1=0;           //pressure sensor p1
unsigned int p2=0;           //pressure sensor p2
unsigned int p3=0;           //pressure sensor p3
unsigned int p_1=0;          //pressure sensor p'1
unsigned int p_2=0;          //pressure sensor p'2
unsigned int temperature=1;  //temperature value

// timer function to calculate cycle time

unsigned long millis_count=0;
unsigned long count=0;
unsigned int tempmillis=0;
unsigned int delay1=0;
unsigned int delay2=0;
unsigned int delay3=0;
unsigned int delay4=0;
unsigned int delay5=0;
unsigned int inhtime=2500;
unsigned int exhtime=2500;
int alm_flag = 0;

 void shiftdata595(int _shiftdata[])  //shift register
{
unsigned int i;

i=8;
while (i>0)                  //loop to send 8bit data
{
SHIFT_DATA=_shiftdata[i-1]; //  send array value
SHIFT_CLOCK = 1;
Delay_us(1);
SHIFT_CLOCK = 0;
i--;
}
}

void latch595()              //latch pin controll
{
SHIFT_LATCH = 1;
Delay_us(1);
SHIFT_LATCH = 0;
}



unsigned long millis()
{
  return(millis_count);
}



void alarm(int tm){             //alarmfuncion
 int alarm_millis=millis();
 while(millis()-alarm_millis<=tm){
 buz=1;
 }
 buz=0;
}






void switches(){
  //bpm setting
  if (Button(&PORTB, 6, 1, 0)) {               // Detect logical zero
      oldbpmup = 1;                              // Update flag
    }
    if (oldbpmup && Button(&PORTB, 6, 1, 1)) {   // Detect zero-to-one transition
        oldbpmup = 0;
       // alarm(10);                          // Update flag
         bpmv++;                                //increment bpm level

        if(bpmv>16){                     //limit bpm value
        bpmv=16;
        }
          if(bpmv<12){
        bpmv=12;
        }


    }

 if (Button(&PORTB, 7, 1, 0)) {               // Detect logical zero
      oldbpmdown = 1;                              // Update flag
    }
    if (oldbpmdown && Button(&PORTB, 7, 1, 1)) {   // Detect zero-to-one transition
          oldbpmdown = 0;                           // Update flag
        //  alarm(10);
        bpmv--;                                      //decrement bpm value
         if(bpmv>16){                                 //limit bpm value
        bpmv=16;
        }
          if(bpmv<12){
        bpmv=12;
        }


    }


   //volume setting

    if (Button(&PORTB, 4, 1, 0)) {               // Detect logical zero
      oldvolup = 1;                              // Update flag
    }
    if (oldvolup && Button(&PORTB, 4, 1, 1)) {   // Detect zero-to-one transition
        oldvolup = 0;                    // Update flag
          //alarm(10);
         vol=vol+50;              //increment volume level by 50
         if(vol>550){                                         //limit volume level
        vol=550;
        }
          if(vol<450){
        vol=450;
        }

    }

 if (Button(&PORTB, 5, 1, 0)) {               // Detect logical zero
      oldvoldown = 1;                              // Update flag
    }
    if (oldvoldown && Button(&PORTB, 5, 1, 1)) {   // Detect zero-to-one transition
          oldvoldown = 0;                                   // Update flag
          //alarm(10);
        vol=vol-50;                                         //decrement volume level
         if(vol>550){                                         //limit volume level
        vol=550;
        }
          if(vol<450){
        vol=450;
        }


    }

    //start stop button
     if ( !startstatus  && Button(&PORTC, 6, 1, 0)) {               // Detect logical zero
      // alarm(100);
      startl=1;                                      //led indicator
      startstatus = 1;                              // Update flag
    }
    if (startstatus && Button(&PORTC, 7, 1, 0)) {   // Detect logical zero
       // alarm(100);
    startl=0;                                    //led indicator
    startstatus = 0;               // Update flag
    }



switch (vol){                       //led value for each volume level
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

switch (bpmv){                           //led value for each bpm value
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

  shiftdata595(led);                  //send out led data
   latch595();


}

void selftest(int fail){
if(fail){                                         //if self test ok
testl=1;                                        //test led on
 alm_flag=500;
}
else {                                           //is self test failed
while(1){                                        //programme goes into an infinite loop
testl=0;                                          //test led blinks
alm_flag=500;                             //test fail alarm
testl=1;
delay_ms(500);
}
}

}

void read_sensor_data(){     //reading all analog sensor data
 s4=ADC_Read(0);

 s9= ADC_Read(1);

 s10 =  ADC_Read(2);

 p1  = ADC_Read(3);

 p2   = ADC_Read(4);

 p3 =   ADC_Read(5);

 p_1  =  ADC_Read(6);

 p_2  =  ADC_Read(7);

}


int tempt=0;


// timer function to calculate cycle time
//Timer0
//Prescaler 1:32; TMR0 Preload = 100; Actual Interrupt Time : 998,4 us


void InitTimer0(){                //timero initialization
  OPTION_REG         = 0x84;
  TMR0                 = 100;
  INTCON         = 0xA0;
}

void Interrupt(){           //interrupt function runs evry 1ms
  if (TMR0IF_bit){
    TMR0IF_bit         = 0;
    TMR0                 = 100;
     if(count>=50){        //here switches and analog reada will be taken every 50 ms
    // alm_flag=1;
        switches() ;       //reading switches
        read_sensor_data(); //reading sensor data

        //alarm()
        count=0;
      //alm_flag=0;
     }
     
    millis_count++;
     count++;
  }

}
void main()
{

ADCON1 = 0x80;
TRISA  = 0xFF;// PORTA is input
PORTB=0;  // set portB as digital
TRISB=0xf0;  // set portB input/outputs
PORTC=0;  // set portC as digital
TRISC=0xff;  // set portC as inputs
PORTD=0x00;  // set portD as digital
TRISD=0x00;  // set portD as outputs
TRISE  = 0x07; // PORTE as analog input
ADC_Init();
InitTimer0();//inica conte timer cada milisegundo
//CMCON =  7 ;
//ADC_Init();

selftest(1);//do self test

while(1){
int tempti=0;
if(startstatus)  {
 //starting inhale process
s2v=1;             //s2v locked
dcv1=1;             //dcv1 on
 dcv2=1;            //dcv2 on
delay1=millis();  //flag for delay1
while(p1<=200 && startstatus==1){  //dcv1 is on until p1 pressure is good
 dcv1=1;
}
dcv1=0;            //dcv2 on after pressure is ok


if(s4<200 || s9<200 || s10<200){  //checking flow sensor values
  selftest(0);                 //if flow values are not within safe values error is generated
  s2v=0;                      //also s2v valve is unlocked
}
delay1=millis()-delay1; //calculate time took to generate pressure
delay2=millis();              //flag for
while(temperature && startstatus==1){          //heating air
heater=1;
  }
heater=0;                     //turn off heater after temperature is ok
if(temperature<20){            //if temperature is not within limit error is generated
  selftest(0);
  s2v=0;                        //s2v ulockec
}
delay2=millis()-delay2;        //calculating time took for heating
delay3=millis();               //flag for delay3
tempti=inhtime-(delay1+delay2);    //  calculating left time for inhale

while((millis()-delay3<=tempti )&& startstatus==1){    //wait untill inhale finish
 //wait for inhale finish
}
dcv2=0; //   dcv2 off
tempti=0;
delay3=millis()-delay3;// calculating delay 3
 s2v=0;           //s2v off
delay4=millis();  //flag for delay 4
 while((millis()-delay4<exhtime)&& startstatus==1){  //wait until exhail finsh
   if(p3>200){

   }
   else{
     selftest(0);     //if exhaile pressure not within limits error genrated
     s2v=0;//s2v unlocked
   
   }
 }
 
delay4=millis()-delay4;  //calculating time took for exhalation
tempti=delay1+delay2+delay3+delay4  ;//calculating total time took for inhale and exhale
if(tempti>inhtime+exhtime){  //if total time is not within limits error is generated
 selftest(0);
 s2v=0;
}

 }
 else{            //if system turned off
 dcv1=0;
 dcv2=0  ;
 s2v=0;
 heater=0  ;
 
 }

}
}