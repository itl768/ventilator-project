

// LCD module connections
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// End LCD module connections

unsigned char ch; //
unsigned int adc_rd; // Declare variables
char *text; //
long tlong; //

sbit LED at RD0_bit;
unsigned short Num;

   void Interrupt(){
    if(ADIF_bit == 1){
         ADIF_bit = 0;
    }
}


  void ADC_init(){

          
          ANSELA = 0x02; // Pin RA1 is configured as an analog input
          TRISA = 0x02;
          
          ADCON2 =0xAF; //RIGHT SHIFT/12TAD_DELAY/FRC
          ADCON1 =0x00; //ADC_ref =Vdd,Vss
          
          ADRESH=0;   //Flush ADC output Register
          ADRESL=0;
          
           INTCON.GIE =1;
          INTCON.PEIE =1;
          PIE1.ADIE =1;
          //IPR1.ADIP =1;
          PIR1.ADIF =0;

  
  }
  
  int ADC_Read(int channel)
{
    int digital;
    //ADCON0 =0x03;
    ADCON0 =(ADCON0 & 0b11000011)|((channel<<2) & 0b00111100);

    /*channel 0 is selected i.e.(CHS3CHS2CHS1CHS0=0000)& ADC is disabled*/
    ADCON0 |= ((1<<ADON)|(1<<GO_NOT_DONE));/*Enable ADC and start conversion*/
     //ADCON0 |= ((1<<ADON)|(1<<GO));     //original

    /*wait for End of conversion i.e. Go/done'=0 conversion completed*/
    while(ADCON0.GO_NOT_DONE==1){
  // while(PIR1.ADIF==1){

                   digital = (ADRESH*256) | (ADRESL);/*Combine 8-bit LSB and 2-bit MSB*/
                   //PIR1.ADIF =0;
                    }
    return(digital);
}

/*void main() {
          ANSELB =0x00;
          TRISB =0x00;


          

          //ADCON0 =0x09; //ADC_on/CHANNEL 2

          PIR1.ADIF =0;
          PIE1.ADIE =1;
          INTCON.PEIE =1;
          INTCON.GIE =1;
          
          ADCON0 =0x02; //STATRT CONVERTION
          
          
}         */



   void main()
{
    ///////INTERRUP INIT
          RCON.IPEN =0;

     ////////   */
     
     ANSELB  = 0;                         // Configure AN pins as digital I/O
     ANSELD = 0;
     C1ON_bit = 0;                      // Disable comparators
     C2ON_bit = 0;
     
    LCD_Init();                        /*Initialize 16x2 LCD*/
    ADC_Init();                        /*Initialize 10-bit ADC*/

    Lcd_Cmd(_LCD_CURSOR_OFF); // LCD command (cursor off)
    Lcd_Cmd(_LCD_CLEAR); // LCD command (clear LCD)
   text = "voltage:"; // Define the third message
    Lcd_Out(1,1,"I'am reading...");

    while(1)
    {
        adc_rd=ADC_Read(1);
        Lcd_Out(2,1,text); // Write result in the second line
        tlong = (long)adc_rd * 5000; // Convert the result in millivolts
        tlong = tlong / 1023; // 0..1023 -> 0-5000mV
        ch = tlong / 1000; // Extract volts (thousands of millivolts)
        // from result
        Lcd_Chr(2,9,48+ch); // Write result in ASCII format
        Lcd_Chr_CP('.');
        ch = (tlong / 100) % 10; // Extract hundreds of millivolts
        Lcd_Chr_CP(48+ch); // Write result in ASCII format
        ch = (tlong / 10) % 10; // Extract tens of millivolts
        Lcd_Chr_CP(48+ch); // Write result in ASCII format
        ch = tlong % 10; // Extract digits for millivolts
        Lcd_Chr_CP(48+ch); // Write result in ASCII format
        Lcd_Chr_CP('V');
        Delay_ms(1);
     }
}

