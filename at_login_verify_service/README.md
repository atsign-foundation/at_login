<a href="https://atsign.com#gh-light-mode-only"><img width=250px src="https://atsign.com/wp-content/uploads/2022/05/atsign-logo-horizontal-color2022.svg#gh-light-mode-only" alt="The Atsign Foundation"></a><a href="https://atsign.com#gh-dark-mode-only"><img width=250px src="https://atsign.com/wp-content/uploads/2023/08/atsign-logo-horizontal-reverse2022-Color.svg#gh-dark-mode-only" alt="The Atsign Foundation"></a>

# at_login key_verification

## Overview:

A simple library to verify if a key exists in an atPlatform Secondary Server. This library can start REST-service for information exchange/.
## Get started:

### Pre-requisites
Java needs to be installed

### Clone it from github

Feel free to fork a copy of the source from the [GitHub Repo](https://github.com/atsign-foundation/at_login)

### Installation:

This library is built with maven. Run the following in PROJECT_ROOT command to build the project

```shell
mvn install
```
### Output
The jar executable will be generated in PROJECT_ROOT/target with the following name
```
atlogin-verify-service-1.0-jar-with-dependencies
```

## Usage

### Staring the REST Service

```shell
java -jar target/atlogin-verify-service-1.0-jar-with-dependencies  startRest
```
The REST Server has now been started on your localhost in port=4567

### Using the REST Service
All the end-points only accept POST Requests. Make sure to send a body with the request

#### 1) Generate
To generate a KeyValue pair of a random UUID that can be used as a verification token.
This end-point accepts a request with a jsonBody containing an entry atsign

The following shell command can be used to send a POST request to the REST end-point:

```shell
curl -i localhost:4567/generate -X POST -H 'Content-Type: application/json' -d '{"atsign":"@alice"}'

```
Response:
```
{"key":"public:_4d5afb79-7d0f-4b0a-b7c0-cf732d66b501.atlogin@alice","value":"e3def62c-f583-4747-a777-95091b361464"}
```

#### 2) Verify
This end-point can to used to verify if a Key with given Value exists in an atSign's secondary. This end-point accepts a request with a jsonEncoded body that has the following fields - atsign, key, value.

The following shell command can be used to send a POST request to the REST end-point:

```shell
curl -i localhost:4567/verify -X POST -H 'Content-Type: application/json' -d '{"atsign":"@libra98extended", "key":"public:_159e24c1-66b8-4889-8840-4601b489c115.atlogin@alice", "value":"b45fcf00-b89f-4ce9-8001-6bca575dd5f2"}'

```
Response Case-success:
```
{
"responseType" : "success",
"verificationStatus" : "true"
}
```
Response Case-failure:
```
{
"responseType" : "failure",
"error" : "Error while verifying",
"cause" : "java.lang.ClassCastException",
"verificationStatus" : "false"
}
```
#### 3) Stop
This end-point STOPS the REST service. This request does not need a body

The following shell command can be used to send a POST request to the REST end-point:
```shell
curl -i localhost:4567/stop -X POST
```
Response:
```
true
```
## Open source usage and contributions

This is freely licensed open source code, so feel free to use it as is, suggest changes or enhancements or create your
own version. See CONTRIBUTING.md for detailed guidance on how to setup tools, tests and make a pull request.