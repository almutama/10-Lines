# 10-Lines
Group project for CS147. For a detailed description, please see http://hci.stanford.edu/courses/cs147/2015/au/projects/creation/10lines.

## Building

### iOS
Open the TenLines Xcode project and hit the play button at the top left corner. This should compile the project and start the iOS simulator. Requires OS X 10.10.5 (Yosemite) and Xcode 7.1.1.

* Note that the deployment target is iOS8.0. If you just downloaded Xcode, it might have come with the iOS9 SDK but not the components for previous iOS versions. Go to Xcode > Preferences > Downloads > Components. There should be a link there to download the iOS8 simulators if you don't have them.

### Rails
This branch also includes a Rails project that talks to the iOS front end and saves user data such as sketches and comments. This will require installing Rails 4.0.2+. Once the Rails environment is set up, run 'bundle update' from the project directory to install any missing dependencies/gems and then 'rails server' to start the server.

