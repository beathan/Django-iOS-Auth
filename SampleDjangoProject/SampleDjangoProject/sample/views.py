from django.contrib.auth import authenticate, login as auth_login
from django.http import HttpResponseForbidden
from django.shortcuts import render_to_response
from django.template import RequestContext


def login(request):
    login_failed = False
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        user = authenticate(username=username, password=password)
        if user is not None:
            if user.is_active:
                auth_login(request, user)
            else:
                return HttpResponseForbidden(\
                    content='Your account is not active.')
        else:
            login_failed = True

    if request.user.is_authenticated():
        status = 200
    else:
        status = 401

    response = render_to_response('sample/login.html', {},
                                  context_instance=RequestContext(request))
    response.status_code = status
    if login_failed:
        response['Auth-Response'] = 'Login failed'
    return response
