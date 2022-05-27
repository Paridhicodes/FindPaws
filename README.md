# <center><p align="center"> findPAWS Engage 2022 <img src='images/readmeImg/findPaws_logo.png' width="40" height="40"> </p></center>




## About the project

- The project findPAWS is an ***Android Mobile Application built using Flutter*** for Microsoft Enagage 2022 by implementing the Agile Methodology.

- The purpose of the app is to locate the potential dog owners of the lost dogs through email enclosing the contact details of the finder.

- The app uses both, Face Recognition technology and Realtime Location to give the most accurate result.


### Salient Features


 #### Specific to the dog owners
- Login and Register features implemented through Firebase authentication.
- The breeds of the dogs is identified by the tflite model and the owner can choose among them, and also specify any other breed incase, the breed is not present in the list.
- The app securely allows to proceed only if it detects the image of a dog. In case of any misupload, it prompts the user to try again. In case, the image is of a cat, the cat is detected and the user is asked to upload the image of a dog.
- The pet parents can add new pet dogs, delete pets and also edit information about their current pet.
- The app also displays the pets that are missing within the 50km radius of the user.
- The pet owners need to provide their current location incase to register their dog as lost.

> (*Note: I have assumed that the pet is lost near the current location of the owner. I could not implement the functionality that could allow to the owners to provide an exact location on the Google Maps other than the current location, because this is a paid feature of Google Cloud APIs and requires billing.*)


#### Specific to the finders
- The finders can directly click image from their phones on the spot to check the breed of the found dog.
- The current location of the finder is taken and the application displays the list of all the pet parents within 50km radius of the same breed. The finder can then contact the probable owners in a single click by sharing his details with the owners.
- The Email sent to the pet parent consists the contact details of the contact details of the finder along with a url of the found dog.

### Compatibility

The flutter application is compatible to run on android smart phones.

## Technology Stack

<p align="center">
<span>
<img src='images/readmeImg/flutter.png' width="80" height="80">
<img src='images/readmeImg/dart.png' width="80" height="80">
<img src='images/readmeImg/firebase.png' width="80" height="80">
<img src='images/readmeImg/maps.png' width="80" height="80">
<img src='images/readmeImg/tflite.png' width="80" height="80">
<img src='images/readmeImg/emailjs.png' width="80" height="80">
<img src='images/readmeImg/github.png' width="80" height="80">
</span>
  </p>

<br>

- Flutter and Dart were used to develop the application.
- Necessary packages were imported from pub.dev
- The backend has been implemented using Firebase. (Firebase authentication, Firestore and Firebase Storage have been used.)
- The models for Face Recognition have been implemented using tflite.
- The locations have been fetched using Google Maps API.
- The email service has been implemented using EmailJS. 


## Installation

Initialise git on your terminal:
```
git init
```
<br>

Clone this repository:
``` 
git clone https://github.com/Paridhicodes/FindPaws.git
```
<br>

Run the ```packages get``` command in your project directory:

```
flutter pub get
```

<br>

Once the build is complete, run the ```run``` command to start the app:

```
flutter run
```


