# LoginTest
Code test project. An example of authentication with rules.

Presented before you is an incomplete project. Please complete the following features.

## Add a Rules model (Done)

Add a new Rules model that is associated with the User model. A User should have many rules.
Rules have a CIDR and permission attribute.
The CIDR attribute should be validated to be a valid CIDR range and the permission attribute should be 'allow' or 'deny'.

## Write the Auther service (Done)

The Auther service should handle user authentication. This service should leverage the has_strong_password User functionality as well as call or implement Rules enforcement using the IP address of the request versus the CIDR value in the rule.

## Create a login form and set the user session (Done)

Create a login form at /sign-up for users to submit their username and password. A user's rules should then be enforced.
A successful login should redirect the user to the home page and display their username as well as the rules enforced during login.
It should say something like "User {username} logged in from {ip address} which matched rule(s) {rules}".

## [Extra Credit] Add Twitter integration (Do nothing about this, according to the discussion)

Send out a tweet when a user makes a login attempt. It should handle successes and failures.
Bonus points for any additional information provided.

## Solution runs on Ruby 2.4.5 and Rails 4.2.10

RSpec tests:
```
rspec
```
