# *blueberrypoll* 🫐
*A quick and easy polling application for meetings*

## How to run
If you are not running from the production domain, make sure to use ```localhost:7357``` to be authorized for google-oauth
```
flutter run -d chrome --web-port=7357
```
You can add and change authorized ports over here:
https://console.cloud.google.com/apis/credentials/oauthclient/176622864765-ffftd7fr8q7658gv5etoho6p19gmamu9.apps.googleusercontent.com?folder=&organizationId=&project=blueberry-poll-one
___
## Changing between development and production runs
The firebase database is split into two parent nodes 
**```production-organization```** and **```development-organization```**

You can change which one the program uses in the ```main.dart``` file

This is so that you can develop the application while not having to interfere with people using the application at the same time.
___
## Exporting for Production
### Make sure firebase-tools is set up **(only do if it's not setup)**
1. Make sure firebase-tools are installed in your project directory:
    ```
    npm install -g firebase-tools
    ```
2. Login to firebase tools
    ```
    firebase login
    ```
3. Run:
    ```
    firebase init
    ```
    Select the **Firebase Hosting** option
    
    Then as the **public directory** put the path:
    ```build/web```
    or what corresponds to the **build output from flutter** for you
    configure as single-page app: **YES**
### Actuall Export
1. Build the project:
    ```
    flutter build web
    ```
2. Upload to firebase hosting
    ```
    firebase deploy
    ```

___
# ⚠️TODO
🚨 Currently there is an issue with the production export, where it does not match the debug run. You can test the errors by running the program like this:

    flutter run -d chrome --profile --web-port=5000
