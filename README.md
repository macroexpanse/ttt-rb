#ttt-rb


This is my take on a web based tic tac toe game. It was designed to be light, fast, and unbeatable. 

It was built with [Sinatra](http://sinatrarb.com/) and [AngularJS](http://angularjs.org/). The easiest way to play is by simply visiting <http://ttt-rb.herokuapp.com>.

If you wish to see the inner workings of the game or modify it, clone this repository. Navigate to your terminal and enter this command:

```
git clone https://github.com/alexreedhill/ttt-rb.git
```

You must have rvm installed to run this application. If you don't have it already, run:

```
curl -sSL https://get.rvm.io | bash -s stable --ruby
```

This application requires the use of ruby-2.0.0-p247 as specified in the .rvmrc file. You may be prompted to approve this file when accessing the directory.

 You may also need to set your default ruby version to ruby 2 if you haven't already done so:

```
rvm use ruby 2
```

To install all the necessary dependencies run:

```
bundle install
```

This application uses the Shotgun gem. This removes the need to restart your local server after each code change. Shotgun will start a server on port 9393 by default. Access this by navigating to <http://localhost:9393>. To start run:

```
shotgun ttt.rb
```

This application's ruby code is tested with Rspec version 2.14.1 and Autotest. To continually test the code run:

```
autotest
```

In addition to autotest, this application is set up for Growl notifications. Growl, when used in conjunction with autotest, shows you a popup notification with your test status each time you save a ruby file.

To use Growl, you must install the Growl desktop application. Download and more info at <http://growl.info/downloads>.

