# Stargazers
## Scope
This is a demo project that shows the stargazers of a given github repository.  
The user give the owner and repository names as input, then a description of the repository is loaded to validate the input and, if it is passed, a list of repository stargazers is shown.  
The list is paged and the avatars are loaded asynchronously with default caching.  
Github api are used throughout the project.  
The main functions of the two view controllers are also tested with automatic Uint Test.  

Follows a link to video of the application in execution: [Dropbox - Stargazers.mp4](https://www.dropbox.com/s/rj07pk8bdqrof9b/Stargazers.mp4?dl=0)

## Technologies
Language: Swift 3.1  
Xcode: version 8.3  
Dependency Manager: CocoaPods version 1.2.0.  
Open source libraries:  
* Alamofire  (4.4.0)  
* PKHUD (4.2.0)  
* SwiftyJSON (3.1.4)  

## Installation
The pod file is included in the project repository.   
Before compile the project make sure to install dependencies with: `pod install`

