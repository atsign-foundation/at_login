const express = require('express');   
const fetch = require('node-fetch');
const btoa = require('btoa'); 
const { v5: uuidv5 } = require('uuid');
require('dotenv').config();
const app = express();              
const port = 5000;  

const fs = require('fs');
const cheerio = require('cheerio');
const { Console } = require('console');

app.use(express.static(__dirname + '/styling'));
app.use(express.static(__dirname + '/pages'));

// for parsing application/json
app.use(express.json()); 

// for parsing application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true })); 


app.get('/loginPage', (req, res) => { 
    res.sendFile('pages/client.html', {root: __dirname});    
});

app.get('/login', (req, res) => { 
        
        console.log("url: "+req.url);
        var atsign = req.url.split('?')[1].split('=')[1].split('%40')[1];
        console.log("key: "+atsign);
       	// make a request to the server-side endpoint
		fetch("http://localhost:4567/generate", { 
            method: "POST",
            headers : {
                    'Content-Type': 'application/json',
                    
                },
            body: JSON.stringify({
                'atsign': "@"+atsign,
                
            })
            .toString()
        })
        .then(response => response.json())
        .then(data => {
            console.log("AuthToken: ", data);
            if (data.key != null) {
                // Convert the response data to JSON String
                const jsonData = JSON.stringify(data);

                // Write the JSON data to a file
                fs.writeFile('pages/uuid.json', jsonData, (err) => {
                    if (err) throw err;
                    console.log('Data saved to file');
                });
                // redirect to login page
                res.sendFile('pages/login.html', {root: __dirname});
            } else {
                console.log("Failed to get access token. Please try again.");
            }
        })
        .catch(error => {
            console.error(error);
          });  
});


app.get('/loginResponse', (req, res) => {  
    var key;
    var value;
    var atsign;
    // read json using fs
    fs.readFile('pages/uuid.json', 'utf8', function (err, data) {
    if (err) throw err;
    // fetch the uuid json data
    key = JSON.parse(data).key;
    value = JSON.parse(data).value;
    atsign = "@" +key.split("@")[1]
    // console.log("object----"+data);
    // make a request to the server-side endpoint
    fetch("http://localhost:4567/verify", { 
            method: "POST",
            headers : {
                    'Content-Type': 'application/json',
                    
                },
            body: JSON.stringify({
                    "atsign": atsign,
                    "key": key,
                    "value": value,
            })
            .toString()
        })
        .then(response => response.json())
        .then(data => {
            console.log("response", data);
            console.log("responseType", data.responseType);
            if (data.responseType != null) {
                // Convert the response data to JSON String
                const jsonData = JSON.stringify(data);
                // Write the JSON data to a file
                fs.writeFile('pages/response_json.json', jsonData, (err) => {
                    if (err) throw err;
                    console.log('output saved to file');
                    console.log(data.verificationStatus);
                    // check VerificationStatus
                    if(data.verificationStatus===true){
                        res.sendFile('pages/loginResponse.html', {root: __dirname});
                    } else if(data.verificationStatus===false){
                        res.sendFile('pages/errorresponse.html', {root: __dirname});
                   }
                });
            } else {
                console.log("verification failed. Please try again.");
            }
        })
        .catch(error => {
            console.error(error);
          }); 

    });
		
});

app.listen(port, () => {            
    console.log(`Now listening on port ${port}`); 
});