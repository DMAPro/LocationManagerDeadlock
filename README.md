# LocationManagerDeadlock
A repo to demonstrate that CLLocationManager probably uses @synchronized(self) internally, and it really shouldn't.

It seems that CLLocationManager uses @synchronized(self) internally, which is an anti-pattern. I wasn't able to find suitable links for Obj-C, but here's some for C#: https://stackoverflow.com/questions/251391/why-is-lockthis-bad
@synchronized(self) causes unexpected (and unpredictable) problems for third-party apps that try to use CLLocationManager instances inside @synchronized blocks in their code (and there really isn't any reason why they shouldn't).

This project demonstrates that the app UI freezes for no good reason because of using a CLLocationManager instance in a @synchronized block on a background thread.

P.S. It's not exactly a deadlock in this case, so sorry about a misleading name. We can easily make it a deadlock, though, by adding an instruction to wait for the main thread at the end of the background thread (a perfectly sane thing to do). But for the sake of the demo I simply added a `sleep` on the background thread.

All the relevant code is in ViewController.m.

rdar://33132086
Copy on OpenRadar: https://openradar.appspot.com/33132086
