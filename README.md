# Uart - Universal Asynchronous Receiver-Transmitter

# Concept
* Uart Structure
>
> ![alt text](image/7.png)
>
> ![alt text](image/8.png)
> 
> ![alt text](image/9.png)
>
* Step-by-step process for transmitting bits.
>
> ![alt text](image/1.png)
> 
> ![alt text](image/2.png)
> 
> ![alt text](image/3.png)
> 
> ![alt text](image/4.png)
> 
> ![alt text](image/5.png)
> 
> ![alt text](image/6.png)
>
* Oversampling
> ```
> 8-bits Data, 1-bit Stop. (Parity Bit Option Available)
> ```
> ![alt text](image/10.png)

> ![alt text](image/11.png)
> ![alt text](image/12.png)
>
# UART Construction
> ![alt text](image/13.png)

* Baud Rate Generator
> __Formula:__
> 
> ![alt text](image/14.png)
> ```
> Explanation of Parameters:
>   v: Value to be loaded into the Baud Rate Generator Register(dvsr)
>
>   f: System clock frequency
>
>   b: Desired baud rate
>
>   16: A fixed factor in UART (since UART samples each bit 16 times to ensure accuracy)
>
> Example: f = 100Mhz, b = 9600 bits/second => v = 650 (we typically round to the nearest integer)

* UART Receiver
> __ASM__:
> 
> ![alt text](image/15.png)
>

# Demo on the Arty Z7 board

>```
> List:
> - Module USB to TTL
> - Analyzer
> - Arty Z7
> - Putty Software
>```
> ![alt text](image/1.jpg)
> 
> ![alt text](image/2.jpg)
> 
> ![alt text](image/3.jpg)
> 
> ![alt text](image/4.jpg)
>
> __Laptop is transmitting "hi" to Z7__
> 
> ![alt text](image/1.1.png)
>
> __Z7 is transmitting "hi" to Laptop__
> 
> ![alt text](image/4.1.png)
>
> ![alt text](image/2.1.png)
> 
> __Laptop is transmitting "abcd" to Z7__
> 
> ![alt text](image/5.1.png)
>
> __Z7 is transmitting "abcd" to Laptop__
> 
> ![alt text](image/7.1.png)
>
> ![alt text](image/6.1.png)

# Reference
> Dr. Anas Salah Eddin