# quirknthreads

Below is a quick guide to getting started with our project! I jotted this down while setting up the project a 2nd time on my personal lappy.

1. Install android studio
2. Install plugins flutter and dart in android studio
3. open the flutter project (see if can do so by just using the git link)
4. If prompted, configure dart and flutter sdk; you can run flutter doctor -v to see the installation location.
example: c:/flutter | C:\src\flutter\bin\cache\dart-sdk
5. install firebase cli (google and download the exe) [step 5/6 might not be needed]
6. login using our quirknthreads123@gmail.com credentials
7. npm install -g firebase-tools (need to download and run node.js exe installer beforehand)
8. firebase login --> it should show Already logged in as quirknthread123@gmail.com
if error says firebase : File C:\Users\amand\AppData\Roaming\npm\firebase.ps1 cannot be loaded because running scripts is disabled on this system. Just delete firebase.ps1.
==== configuring the firebase project ==== (should be skippable, cause the file is already configured)
a. dart pub global activate flutterfire_cli in terminal for android studios
b. flutterfire
c. firebase_options.dart should be directed to your firebase project
===========================================
9. if android studio prompt you to get dependencies, can click get dependencies
10. you need to install an AVD (android virtual device?), in android studio, then run the AVD
11. then click run main.dart at the top of the android studio
