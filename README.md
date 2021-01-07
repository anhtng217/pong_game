# Build a classic Pong game on Xilinx FPGA and Feature Multiplayer Mode
## Introduction
This project presents a classic Pong game through Xilinx Processor. By recreating the classic Pong game, I introduce a new mode that allows two players to participate. 

The game utilizes the soft processor on FPGA and is written in Verilog. The game was then implemented onto Digilent's Nexys A7 (Artix-7 100T-CSG324) development board and projected to an external monitor via VGA cables, making use of the Nexys's switches, buttons, and LEDs to create an easy interaction.

The Nexys A7 board is based on the powerful Artix FPGA from Xilinx, and it brings unprecedented performance to various types of project. With its large, high-capacity FPGA, generous external memories, and a collection of USB, Ethernet, UARTs, SPIs, IICs and other communication protocols, the Nexys A7 can host designs ranging from introductory combinational circuits to powerful embedded processors.

<img src="https://user-images.githubusercontent.com/29515828/103426709-428eb080-4b70-11eb-8ca5-0dc5433e9d14.jpg" width="90%"></img> 

To play the game, the user must have a VGA cables and a monitor with VGA port built-in. The monitor will display the loading screen and the game interface. Players toggle the buttons to move the paddles up and down to hit the ball to the opponent side. As soon as the a player fail to hit the ball with the paddle, the game will reset to it initial state which the ball is set to be in the middle of the screen. If a player miss the ball 3 times, they lose the game. 

<img src="https://user-images.githubusercontent.com/29515828/103426997-81be0100-4b72-11eb-97fd-53319054f243.gif" width="90%"></img> 

Some of the animation of the ball and paddles and other features implemented in the software include user-input debouncing and edge detection, VGA controller, vertical and horizontal pixel scanning. A fixed pixel generator is implemented to create a ball, top and bottom border as well as two paddles so that two players can play the game at the same time.

## Design
The VGA synchronization block includes the vga_sync block and the pixel generation block, one Asynchronous In Synchronous Out module to produce one reset signal for all other modules. A clock divider was also created to act as an enable for the h_sync and v_sync block. 

The h_sync and v_sync blocks then function as two counters which scan through the entire screen and produce video signal which later be processed via a pixel generation module. 
The module then creates RGB colors and projects to the screen using input from switches. 
User can play with the switches to make a unique combination that creates a specific color of the wall borders, the paddles as well as the ball. 

To sum up, all the modules is connected to a top level module. The module instantiates lower module and outputs the signals: rgb, h_sync and v_sync. h_sync and v_sync told the board at what rate to refresh. RGB indicated when and where to grab color signals from. 
## Ball and paddles movement
The movement of the paddles is created by first debouncing the buttons that used to control the paddles. After that, while scanning the screen at the same refresh rate as the monitor, it updates the location of the paddles and projects it onto the screen. 

By using some predefined values such as the position of the edges of the ball, the borders, the paddles’ edges, the animation that when ever the ball hits the paddles and the borders, it bounces back to the opposite direction, was created. The ball’s speed and initial directions of movement can be adjusted to create all kinds of variation for the game. 

In addition, to finish the logic of the game, the ball is put in the middle of the screen as a player fails to hit the ball and let it touch the side walls. A signal defined as “rescan” keeps track of the debounce button signal and check if it’s active. If any buttons’ signal is active, it moves by 2 pixels/scan in the corresponding direction. 

## Click the link to see the demo video
[Multiplayer Pong Game Demo](https://youtu.be/zYy1nEMT7lc "Multiplaer Pong Game Demo")
