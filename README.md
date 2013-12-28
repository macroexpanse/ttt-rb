#Tic Tac Toe


This is my take on a web based tic tac toe game. It was designed to be light, fast, and unbeatable. 

It was built with **Sinatra** and **AngularJS**. The easiest way to play is by simply visiting <http://ttt-rb.herokuapp.com>.

If you wish to see the inner workings of the game or modify it, clone this repository. Navigate to your terminal and enter this command:

```
git clone https://github.com/alexreedhill/TicTacToe.git
```

Navigate to the cloned directory. To install all the necessary dependencies run:

```
bundle install
```

To start a local server that updates itself as you edit the code run:

```
shotgun ttt.rb
```

Shotgun will start a server on port 9393 by default. Access this by navigating to <http://localhost:9393>.

This application's ruby code is tested with rspec version 2.14.1 and autotest. To continually test the code run:

```
autotest
```

