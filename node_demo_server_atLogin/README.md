# At Login Demo  - Codebase

## Description  :
 
1.  This project demonstrates password less login using @sign
2.  This project consumes @login as REST
3. this Project uses two java REST end points

   a.  Generate : http://localhost:4567/generate

   b.  Verify   : http://localhost:4567/verify


## How to run Java server
Open a terminal at  jar located folder and run below command

    java -jar atlogin-verify-service-1.0-jar-with-dependencies.jar startRest 

      
## Environmental Setup

### Required pieces of software:

    Node v10.24.1
    Visual Studio Code v11.0

### Installation Instructions

#####   <span style="font-size: 120%"  >  1. Node v10.24.1 (LTS) </span> <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTT-GQMOf7vbtTXT0H2xP4Hi2-BBfle-6DOASFNOoYEYQ&usqp=CAU&ec=48665698" width="30" height="30" align="centre" />


Install and setup Node according to the OS using below link

- **Ubuntu**:

Execute following commands in the terminal
 ``` .tm
sudo apt-get update  
 ```
 ``` .tm
sudo apt-get install build-essential libssl-dev curl  
 ```
 ``` .tm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash  
 ```
 ``` .tm
source ~/.bashrc
 ```
 ``` .tm
nvm install 10
 ```


##### <span style=" font-size: 120%"> 2. Visual Studio Code </span>  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2Zl794qo61sCLYBodD71DCMU7E2o0ugs1Kv1XzWQDtA&usqp=CAU&ec=48665698" width="35" height="35" />

**Install and setup VS Code according to the OS using below link**

[https://code.visualstudio.com/download](https://code.visualstudio.com/download)

## Project Execution:

**To build the node modules, run the command below :**
```.tm
npm i
```

**To run the project, execute the command below :**
```.tm
node index.js
```

**Go to any internet browser and enter below link**
```.tm
http://localhost:5000/loginPage
```

