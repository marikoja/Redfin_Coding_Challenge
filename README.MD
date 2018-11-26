# Overview

Redfin coding challenge for Ada Developers Academy.

# Install
This coding sample makes use of two libraries: `net/http` and `json`. The former is included as part of the base Ruby distribution, while `json` may not be available by default.

To install `json`:
`sudo gem install json`

Then ensure that `show_open_food_trucks.rb` and `food_truck_run.rb` are copied into the same folder.

# Run
To run the food truck coding sample, issue this command:

 `ruby food_truck_run.rb`

# Adaptation to a Web App

If I were to build this app as a full-scale web application, instead of a command line program, there are a number of different things I would do differently. The most significant changes would be related to the user interface and authentication.

First, as a command line program, the user interface is very limited -- the food trucks are displayed as a simple list and the user input is only accepted as Y/N responses. This would completely change for a web application. We might wish to display the food trucks in a table and use pagination in the footer to keep the page length from getting too long. We would also probably want to offer the user more sorting/filtering options and give them a way to quick search the list. These sorts of features are typical for web applications, where users tend to expect a more visually robust and intuitive experience.

Second, command line programs  do not typically have authenticated sessions. However, web applications often do require the user to be logged in before they are permitted to request data from APIs. If I were to build this app to support authenticated sessions, then the constructor function of my class might accept a `session_id` or a `token` that is based along with the initial API HTTP request. This would allow us to only accept requests only from known and authenticated users.
