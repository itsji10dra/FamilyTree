Pre-Requisites:

iOS App:
	a) Xcode v8/8+
	b) Pods v1.1.1 (https://guides.cocoapods.org/using/getting-started.html)

Python App
	a) Python v3.5.2 (https://www.python.org/downloads/release/python-352/)
	b) Pip (sudo easy_install pip)
	c) Django v1.9.6 (sudo pip install django==1.9.6)
	d) django-tastypie v0.13.3  (sudo pip install django-tastypie==0.13.3)


Installation:

1. To start Django App (i.e. Server)
	a) cd path-to-project
	b) python manage.py runserver

2. Launch iOS App 
	a) cd path-to-project
	b) pod install
	c) open CrossoverAssignment.xcworkspace
	d) Select 'simulator', & hit command+R