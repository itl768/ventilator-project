// Define LED connection
sbit LED at RC0_bit;
unsigned short Num;
// Interrupt service routine
void interrupt() {
  Num ++;           // Interrupt causes Num to be incremented by 1
  if(Num == 18) {
   LED = ~LED;       // Toggle LED every sec
   Num = 0;
  }
  TMR0 = 39;        // TMR0 returns to its initial value
  INTCON.T0IF = 0;  // Bit T0IF is cleared so that the interrupt could reoccur
}
void main() {
 CM1CON0 = 0x07;    // Disable Comparators
 //ANSEL = 0x00;     // Disable analog channels
 TRISC = 0x00;     // PORTC O/P
 LED = 0;
 Num = 0;
 OPTION_REG = 0x07; // Prescaler (1:256) is assigned to the timer TMR0
 TMR0 = 39;          // Timer T0 counts from 39 to 255
 INTCON = 0xA0;     // Enable interrupt TMR0 and Global Interrupts
 do {
 // You main programs goes here
 } while(1);  // infinite loop
}