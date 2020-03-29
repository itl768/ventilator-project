 //sensor inputs
#define sensor_a PORTC.B0
#define sensor_b1 PORTC.B1
#define sensor_b2 PORTC.B2
#define sensor_c1 PORTC.B3
#define sensor_c2 PORTC.B4
#define sensor_c3 PORTC.B5



//outputs
#define dcv1 PORTD.F0
#define dcv2 PORTD.F1
#define testl PORTD.F3
#define startl PORTD.F4

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



void switches(){
  //bpm setting
  if (Button(&PORTB, 6, 100, 0)) {               // Detect logical zero
      oldbpmup = 1;                              // Update flag
    }
    if (oldbpmup && Button(&PORTB, 6, 100, 1)) {   // Detect zero-to-one transition
        oldbpmup = 0;                            // Update flag
         bpmv++;                                //increment bpm level
         Sound_Play(1318, 50);
        if(bpmv>16){                     //limit bpm value
        bpmv=16;
        }
          if(bpmv<12){
        bpmv=12;
        }


    }

 if (Button(&PORTB, 7, 100, 0)) {               // Detect logical zero
      oldbpmdown = 1;                              // Update flag
    }
    if (oldbpmdown && Button(&PORTB, 7, 100, 1)) {   // Detect zero-to-one transition
          oldbpmdown = 0;                           // Update flag
           Sound_Play(1318, 50);

        bpmv--;                                      //decrement bpm value
         if(bpmv>16){                                 //limit bpm value
        bpmv=16;
        }
          if(bpmv<12){
        bpmv=12;
        }


    }


   //volume setting

    if (Button(&PORTB, 4, 100, 0)) {               // Detect logical zero
      oldvolup = 1;                              // Update flag
    }
    if (oldvolup && Button(&PORTB, 4, 100, 1)) {   // Detect zero-to-one transition
        oldvolup = 0;                    // Update flag
         Sound_Play(1000, 100);
         vol=vol+50;              //increment volume level by 50
         if(vol>550){                                         //limit volume level
        vol=550;
        }
          if(vol<450){
        vol=450;
        }

    }

 if (Button(&PORTB, 5, 100, 0)) {               // Detect logical zero
      oldvoldown = 1;                              // Update flag
    }
    if (oldvoldown && Button(&PORTB, 5, 100, 1)) {   // Detect zero-to-one transition
          oldvoldown = 0;                                   // Update flag
           Sound_Play(1000, 100);
        vol=vol-50;                                         //decrement volume level
         if(vol>550){                                         //limit volume level
        vol=550;
        }
          if(vol<450){
        vol=450;
        }


    }

    //start stop button
     if ( !startstatus  && Button(&PORTC, 6, 100, 0)) {               // Detect logical zero
      Sound_Play(1000, 100);                         //play alarm
      startl=1;                                      //led indicator
      startstatus = 1;                              // Update flag
    }
    if (startstatus && Button(&PORTC, 7, 100, 0)) {   // Detect logical zero
     Sound_Play(500, 100);                         //play alarm
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
  //delay_ms(1000);

}


void selftest(){

  //selst test functions






if(1){                                         //if self test ok
testl=1;                                        //test led on
Sound_Play(500, 500);                            //selftest ok notify alarm
Sound_Play(1000, 500);
}
else                                            //is self test failed
while(1){                                        //programme goes into an infinite loop
testl=0;                                          //test led blinks
Sound_Play(1000, 500);                             //test fail alarm
testl=1;
Sound_Play(500, 500);
}
}





void main()
{
PORTB=0;  // set portB as digital
TRISB=0xf0;  // set portB input/outputs
PORTC=0;  // set portC as digital
TRISC=0xff;  // set portC as inputs
PORTD=0;  // set portD as digital
TRISD=0x00;  // set portD as outputs
Sound_Init(&PORTD, 2);

selftest();//do self test



while(1){

switches();
if(startstatus){

//run system





}

}
}