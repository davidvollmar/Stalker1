{{
*****************************************
* Servo32_v5 Demo v1.5                  *
* Author: Beau Schwabe                  *
* Copyright (c) 2009 Parallax           *
* See end of file for terms of use.     *
*****************************************
}}

CON
    _clkmode = xtal1 + pll16x                           
    _xinfreq = 5_000_000                                'Note Clock Speed for your setup!!

    ServoCh1 = 0                                        'Select DEMO servo
    engPin = 15
    encPin = 1

VAR

 byte   LMTR[11]
 long   ILMTR
 byte   RMTR[11]
 long speed                                                                                            
 long steer
   

    
OBJ
  SERVO :       "Servo32v5.spin" 
  HB25  :       "CJ_HB25_014.spin"
  PST   :       "Parallax Serial Terminal.spin"
  SER   :       "FullDuplexSerial.spin"  
  MOTOR :       "PPC_DriverV1.5.spin"
    
PUB Main | i, j,temp

  HB25.config(engPin,1,1)
  'PST.StartRxTx(31, 30, 0, 9600)
  waitcnt(clkfreq + cnt)
  
  PST.start(115200)
  'MOTOR.start(encPin)   
  'MOTOR.MtrMove(128,1)
  'HB25.set_motor1(1500)
  'HB25.set_motor2(1500)

   i:= 0
   j:= 0

   speed:= 1500
   steer:= 1500
   
   repeat                                                              
     PST.char("*")
     temp := PST.CharIn
            
     if temp == "$"                                                                                                                 
      repeat while temp <> ";"      
        temp := PST.CharIn
        LMTR[i]:= temp
        i++
 
      repeat while temp <> "#"      
        temp := PST.CharIn
        RMTR[j]:= temp
        j++

      speed := StrToDec(@LMTR,";")
      steer := StrToDec(@RMTR,"#")

                           

      HB25.set_motor1(speed)
      HB25.set_motor2(speed)
      'TODO aansturing motor3          

      {{PST.char("$")
      PST.dec(MOTOR.Position(0))
      PST.char(";")
      PST.dec(MOTOR.Position(1))
      PST.char("#")     }}
         
      i:= 0
      j:= 0
                       

      {{
    if temp == "."
      HB25.set_motor2(1600)
      waitcnt(clkfreq/12 + cnt)
      HB25.set_motor2(1488)
      ''PST.char("$")
      PST.bin(MOTOR.GetPositionGraySPI(1),16)  
      PST.NewLine
      
      ''PST.dec(MOTOR.GetPositionGraySPI(1))
      ''PST.dec(MOTOR.Position(0))
      ''PST.char(";")
      
      ''PST.dec(MOTOR.GetPositionSPI(2)) 
      ''PST.dec(MOTOR.Position(1))
    if temp == ","
      ''HB25.set_motor2(1376)
     '' waitcnt(clkfreq/12 + cnt)
      ''HB25.set_motor2(1488)
      PST.char("$")
      PST.bin(MOTOR.GetPositionGraySPI(1),16)
      ''PST.dec(MOTOR.Position(0))
      PST.NewLine
      ''PST.dec(MOTOR.GetPositionSPI(2))     
      ''PST.dec(MOTOR.Position(1))  
                   }}

PUB StrToDec(stringptr,terminator) : value | char, index, multiply

value := index := 0
repeat until ((char:= byte[stringptr][index++]) == terminator)
  if char => "0" and char =< "9"
    value := value * 10 + (char - "0")
  if byte[stringptr] == "-"
    value := - value