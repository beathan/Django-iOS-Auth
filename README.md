# Logging into Django from an iOS app

Included in this repository are two example projects, one for Xcode and a sample Django project.

## Getting started

First, you'll need to initialize the example Django project and run it from the command line. Make sure you've installed Django on your system (see [How to install Django](https://docs.djangoproject.com/en/dev/topics/install/) for instructions). Then, navigate to the project's root directory and run syncdb: `./manage.py syncdb`.

You will create your user during this step, so be sure to remember the username and password you selected as you'll need them when running the iOS simulator.

Finally, run `./manage.py runserver` to start Django's development server. If you can see the login form at http://127.0.0.1:8000/accounts/login/, then you're good to go!

## Next

Open Finder and navigate to the Django-iOS-Auth directory. From there, open the Django-iOS-Auth-Example directory and double-click the `Django-iOS-Auth-Example.xcodeproj` file. This will open Xcode and display the project's contents. You can now run the project and try logging in!
