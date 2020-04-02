
  // Define LED connection
sbit LED at RB7_bit;
sbit LEDccp at RB6_bit;
     //////////////////////////////////////////////////////////////////////////////// Interrupt

unsigned int tmrOverflowA, Atmrcount1, Atmrcount2, Btmrcount1, freqA, AsensorRate =0;
unsigned long RotCountA, timerCountA =0;

char BusyA, BusyB=0;                                                           // Line0 & Line1 bussy status
unsigned int volumeAL, volumeAH, volumeBL, volumeBH =0;
char volumeA[7],volumeB[7];

void interrupt()
{
     if(TMR1IF_bit==1)
     {
     tmrOverflowA++;
     LED =~LED;
     TMR1IF_bit=0;
     }
     Atmrcount1 = CCPR1L;
     Atmrcount2 = CCPR1H;
     timerCountA =  (65536*(tmrOverflowA)) + (Atmrcount2*256) +  Atmrcount1 +1000;

     if(CCP1IF_bit==1){
     RotCountA++;
          LEDccp =~LEDccp;
     //timerCountPrev = timerCount;
     freqA = (2000000.0 / timerCountA) ;
     TMR1L=0;
     TMR1H=0;
     tmrOverflowA=0;
     CCP1IF_bit=0;
     TMR1IF_bit=0;
     }
}

  void SensorA(){
 volumeAH = RotCountA/600;
 volumeAL = (RotCountA%600)/60;

 volumeA[0]= volumeAH/1000 +'0';
 volumeA[1]= (volumeAH%1000)/100 + '0';
 volumeA[2]= (volumeAH%100)/10 + '0';
 volumeA[3]= volumeAH%10 + '0';
 volumeA[4]= '.';
 volumeA[5]= volumeAL + '0';

 AsensorRate = freqA/10;
}

void main() {


           
           ANSELB =0x00;
           ANSELC =0x00;
           //TRISB = 0x00;     // PORTB O/P
           LED = 0;
           LEDccp=0;
           
           volumeAL=0;
           volumeAH=0;
           RotCountA=0;
           freqA=0;
            ///////////////////////////////////////////
            ADCON1 =0x0F;
            TRISB3_bit =0;
            TRISB4_bit =0;
            TRISB6_bit =0;
            TRISB7_bit =0;
            TRISC2_bit = 1;
            LATB.B4  =1;
            LATB.B3 =0;
            
           CCP1CON = 0x05;
           TMR1ON_bit=1;
           GIE_bit=1;
           PEIE_bit = 1;
           CCP1IE_bit=1;
           CCP1IF_bit=0;
           TMR1IE_bit=1;

                 //LEDccp == bit6
                 //LED == bit7
           
 while(1){

             if(PORTC.RC2 ==1)  //button input
             {
             Delay_ms(50);     //deboncing handling
           if(PORTC.RC2 ==1)
           {
           LATB.B4 =0;
           CCP1IF_bit=1;
           }

             }

           else {

                 LATB.B4 =1;
                 if(RotCountA>=10){
                         LATB.B3 =1;
                 }
                }

    }
           }