# Logging into Django from an iOS app

Included in this repository are two example projects, one for Xcode and a sample Django project.

## Getting started

First, you'll need to initialize the example Django project and run it from the command line. Make sure you've installed Django on your system (see [How to install Django](https://docs.djangoproject.com/en/dev/topics/install/) for instructions). Then, navigate to the project's root directory and run syncdb: `./manage.py syncdb`.

You will create your user during this step, so be sure to remember the username and password you selected as you'll need them when running the iOS simulator.

Finally, run `./manage.py runserver` to start Django's development server. If you can see the login form at http://127.0.0.1:8000/accounts/login/, then you're good to go!

## Next

Open Finder and navigate to the Django-iOS-Auth directory. From there, open the Django-iOS-Auth-Example directory and double-click the `Django-iOS-Auth-Example.xcodeproj` file. This will open Xcode and display the project's contents. You can now run the project and try logging in!

# Notes

### Django

The Django project includes a sample app that contains a [login view](https://github.com/beathan/Django-iOS-Auth/blob/master/SampleDjangoProject/SampleDjangoProject/sample/views.py#L7) that handles logging in the user and supplying HTTP status codes in response.

The view will return one of the following 4 responses:

* 200: The user is logged in or successfully authenticated
* 401: The user is not logged in and must supply credentials
* 401 with an `Auth-Response=Login failed` header: The user supplied invalid credentials in an attempt to log in and is not authenticated
* 403: The user's account is inactive

The view will also render a [sample template](https://github.com/beathan/Django-iOS-Auth/blob/master/SampleDjangoProject/SampleDjangoProject/sample/templates/sample/login.html) for logging in via a web browser.

### iOS

`DjangoAuthClient.h` provides two mechanisms for getting feedback on the success or failure of login attempts: notifications and a delegate protocol with two optional methods for login success or failure. Either mechanism will provide the consumer with a `DjangoAuthLoginResultObject`, which is essentially just a convenience class for storing response data and optionally setting a login failure reason. Two constants are defined to give insight into why the login attempt failed: `kDjangoAuthClientLoginFailureInvalidCredentials` and `kDjangoAuthClientLoginFailureInactiveAccount`.

Notifications will be sent upon login success, failure, or failure of the client to connect to the provided URL.
