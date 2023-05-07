# Ecosystem Testing
A tool to configure an ecosystem of multiple projects from multiple repos, typically for a feature testing process.

### Background
Frequently in either testing or in a developer set up it is necessary to have several sites co-locate and
exist together. This could be a Front end site in Vue, Angular, React or Quasar with a CF or other server
side language. These are more likely in different repos. It's also a feasible scenario that someone will
need to easily and quickly set up a site which needs to change branches quickly whether it be for QA or other
purposes. 

Ecosystem Testing makes that fairly straightforward and even includes some built in Docker support. Once configured,
the configuration file can be shared to make replicating it easy. It also accomodates 

### Installation
Use CommandBox and install using `box install ecosystemTesting`

### Setup

#### Start a project
1. Create a folder to house the project. Each of the sites will be set up in a subfolder from here. 
2. From CommandBox run `sitesetup configure`
3. Give the project a name ( typically one word )
4. Give the project a root folder ( defaults to the current directory )
5. Enter your repo username (This remains in the CommandBox config and is not written to the project files.)
6. Enter your repo Personal Access Token (This also stays in the CommandBox config and is not written to the project files.)


#### Set up a site
1. Walk through the project setup and when asked to "Set Up Site", type "y".
2. Choose the type of repository for this site. (i.e. gitlab, github ).
3. Enter the name of the repository (this is the entire path aside from the domain i.e. in https://gitlab.com/project/repo it would be project/repo.)
4. Enter the parent branch. This is the branch from which your feature branches branch. In the format of "origin/dev" if you want the source to be from the server. 
5. Enter the subfolder where this site will be hosted, (i.e. "api").
6. Enter the URL used to access this site. Do not include the port (i.e. http://localhost, http://myapi.local)
7. Enter the port to access the site (i.e. 3000,8080)
8. Enter the files which need to be moved from the envFolder to the site. See section on envFolder below. The format here could be "api.env:.env, api.cfconfig.json:.cfconfig.json"
9. Choose the Language (this is not really essential and might be deleted later. )
10. Enter a comma delimited list of script elements which should run after the branch has been pulled. See the section on Post Install Scripts below
11. Enter the name of a docker container for this site. Leave blank for none. 

### Using EcosystemTest
Once all the sites are configured you can refresh all or part of the ecosystem. 
1. Run `sitesetup refreshEcosystem _projectname_` This will display a list of the sites in this project.
2. Use the spacebar to toggle which sites to refresh.
3. Enter the branches for each site to be pulled.
4. Choose whether the branch should be "evergreen" (refreshed from the parent branch) before testing.
5. Watch the process, tweaking any scripts that need it. 

### Life Cycle
Each time a site is refreshed it follows this cycle:
1. Information about the site is retrienved from both CommandBox and the siteSetup.json file in the root of the project
2. The system attempts to stop and forget any servers in the site's folders.
3. All files and folders in the site folder are deleted
4. The site is cloned from the repo and switched into the desired branch
5. If the site is to be "evergreened" it attempts to merge the source branch into the target branch. 
6. Any files are copied from the envFolder to the site
7. Any scripts are run 
8. If there is a docker container specified as part of the site config, "docker restart _comancontainername_"


### EnvFolder
Ecosystem Testing contains a folder called "envFolder" which can house any files (i.e. .env, .cfconfig etc)
which would be overwritten or deleted when a site is pulled but the need for the local configuation doesn't go away. 
When a site is "refreshed" the contents of the folder are completely deleted to ensure that it is "clean" for the 
next test. During a site setup, you can specify the files to me copied from this envFolder to the local site. 


### Scripts
After the site is pulled (See the section on Life Cycle) the system will loop over the list in the scripts node. These are 
run from CommandBox but elements outside of CommandBox can be run by putting an ! in front of the command. For example:
Example script for a JS site
"!yarn install",
"!docker rm controlSite",
"!docker-compose build controlSite"

To run an external file either use something like `recipe myScript.boxr`, `!myScript.bat` or `!bash myScript.sh`.

# Changelog
0.0.62 - Fixed path for github sites; added commandPrefix to add `sudo` for linux installations.
0.0.61 - Scripted an automatic commit message when evergreening the branch
0.0.60 - fixed typo in error messaging
0.0.59 - really added sudo to ALL linux commands
0.0.58 - added sudo to all linux commands
