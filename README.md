# LocationManagerDeadlock
A repo to demonstrate that CLLocationManager probably uses @synchronized(self) internally, and it really shouldn't.

It seems that CLLocationManager uses @synchronized(self) internally, which is an anti-pattern. I wasn't able to find suitable links for Obj-C, but here's some for C#: https://stackoverflow.com/questions/251391/why-is-lockthis-bad
@synchronized(self) causes unexpected (and unpredictable) problems for third-party apps that try to use CLLocationManager instances inside @synchronized blocks in their code (and there really isn't any reason why they shouldn't).

This project demonstrates that the app UI freezes for no good reason because of using a CLLocationManager instance in a @synchronized block on a background thread.
