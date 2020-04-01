#line 1 "D:/ventilator project/TImer_blink/Iterrupt_blink.c"

sbit LED at RC0_bit;
unsigned short Num;

void interrupt() {
 Num ++;
 if(Num == 18) {
 LED = ~LED;
 Num = 0;
 }
 TMR0 = 39;
 INTCON.T0IF = 0;
}
void main() {
 CM1CON0 = 0x07;

 TRISC = 0x00;
 LED = 0;
 Num = 0;
 OPTION_REG = 0x07;
 TMR0 = 39;
 INTCON = 0xA0;

 Sound_Init(&PORTE, 1);

 do {
 if (Button(&PORTB, 5, 100, 1)) {
 Sound_Play(1318, 50);

 }
 } while(1);
}
