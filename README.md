# DIP-SMAPPS

Hello! welcome to DIP-SMAPPS repository NTU, for EE3080 AY 20-21 group E005.

To start off, there are 2 section in this project which is shown in the folder.

1. backend - backend
2. frontend - smapps

#Create A folder, called DIP, in this manner:

then in your console/terminal go to the directory of the DIP folder and input: git clone "--my repository link--"

your folder should look like:

#DIP:
#|--backend
#|--smapps


# BACKEND Development
to setup the backend:

1. Make sure Node.js is in your system, otherwise do install the recommended version that suites your operating system.

   MongodB can be utilized through it's cloud service, Atlas where you will need to signup for a free account to access the free database service. Another option is to download it's local database service through MongodB Compass.
    
    # Running this app version requires the local Database so, MongodB Compass is the recommended setup, do check out the documentation to setup the database in MongodB website!

2. Open Terminal and follow the command:
    //navigate to the backend folder from DIP-SMAPPS-MASTER folder
    MacOS(bash)     :cd backend
    Windows(cmd)    :cd backend
    
    //install all the dependencies in the project
    MacOS(bash)     :npm install 
    Windows(cmd)    :npm install

    Then in your backend file, check whether a file called node_modules appears. If it does, then you have successfully setup the environment!
3. Run the code:
    in the same terminal do,
    MacOS(bash)     :nodemon server
    Windows(cmd)    :nodemon server

    Then you should see the application starting up, if it succeded, the application will print a success command. 

    GOOD LUCK!
    # If you wish to push, do contact Jason first and he will guide you to create a branch to later be merged. Thank you!

# Frontend Development:

1. Make sure you have Flutter setup in your machine, if not you may find a tutorial up in the flutter dev page.

2. if your system does not automatically install the dev dependencies, run in your terminal/console: 
   MacOS(bash) : flutter pub get
   Windows(cmd): flutter pub get

   Good luck developing! Cheers! :)
