# FamilyTree

## Pre-Requisites:

### iOS App

* Xcode v8/8+
* Pods v1.1.1 (https://guides.cocoapods.org/using/getting-started.html)

### Python App

	a) Python v3.5.2 (https://www.python.org/downloads/release/python-352/)
	b) Pip (sudo easy_install pip)
	c) Django v1.9.6 (sudo pip install django==1.9.6)
	d) django-tastypie v0.13.3  (sudo pip install django-tastypie==0.13.3)


## Installation:

* To start Django App (i.e. Server)
	a) Open terminal
	b) cd path-to-project (i.e. /Source/Server App/)
	c) python manage.py runserver
	
	- This will start server on your machine. Now to see admin dashboard,
	a) Open 'http://localhost:8000/' in your browser.
	b) Login using username: admin, password: admin12345
	c) Using admin panel, you can add person & relationships.

* Launch iOS App 
	a) Open terminal
	b) cd path-to-project (i.e. /Source/iOS App/)
	c) pod install
	d) open Assignment.xcworkspace
	e) Select 'Simulator/Device' in Xcode, & hit command+R


## Database:

* It is included in server app, no additional measures require to configure it.


## Known Issues:

Issues mentioned below are in Server app.

* If there is a relation from Son to Father in 'relation' table, and also a relation from Father to Son, it creates a infinite loop issue while fetching info for Son via API. To avoid this, make sure not to add 2 way relation in 'relation' table (via admin panel or via iOS app).
  
