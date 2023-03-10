component {

    property name="print" inject="PrintBuffer";
    property name="base" inject="BaseCommand";
    property name="settings" inject="commandbox:configsettings";

    function checkModuleKeyExists() {
        print.line(settings);
        if (!settings.keyExists('modules')) {
            try{base.command('config set modules={siteSetup:{}}}').run();} catch(any err){};
        } else  if (!settings.modules.keyExists('siteSetup')) {
            try{base.command('config set modules.siteSetup={}').run();} catch(any err){};
        }
    }

    function checkDataSource(required string folderPath = settings.modules.sitesetup.rootfolder) {
        if (!doesJsonExist(arguments.folderPath)) {
            createJsonDataFile(arguments.folderPath);
        }
        return true;
    }

    function doesJsonExist(required string folderPath = settings.modules.sitesetup.rootfolder) {
        return fileExists(folderPath & 'siteSetup.json');
    }

    function createJsonDataFile(folderPath = settings.modules.sitesetup.rootfolder) {
        return fileWrite(folderPath & 'siteSetup.json', serializeJSON(dataModel()));
    }

    function obtainData(folderPath = settings.modules.sitesetup.rootfolder) {
        checkDataSource(arguments.folderPath);
        var rawData = fileRead(arguments.folderPath & 'siteSetup.json');
        return !isStruct(rawData) ? deserializeJSON(rawData) : rawData;
    }

    function obtainProjectData(required string projectName) {
        print.line("In Obtain Project Data").toConsole();
        //print.line(settings.modules.siteSetup[arguments.projectName]).toConsole();
        var folderPath = settings.modules.siteSetup[projectName].rootFolder;
        if(!directoryExists(folderPath)){
            print.line("That project folder does not exist").toConsole();
            return;
        }
        print.line(folderPath).toConsole();
        checkDataSource(folderPath);
        var rawData = fileRead(folderPath & 'siteSetup.json');
        return !isStruct(rawData) ? deserializeJSON(rawData) : rawData;
    }

    function writeData(folderPath = settings.modules.sitesetup.rootfolder, data) {
        fileWrite(folderpath & 'siteSetup.json', serializeJSON(arguments.data));
    }

    function obtainSiteData(siteName, projectName) {
        var data = obtainData(obtainRootFolder(arguments.projectName));
        return data.projects[projectName].sites.keyExists(sitename) ? data.projects[projectName].sites[sitename] : {};
    }

    function obtainRootFolder(projectName) {
        var data = settings.modules.sitesetup[projectName];
        return settings.modules.sitesetup.keyExists(projectName) && settings.modules.sitesetup[projectName].keyExists('rootfolder')
         ? data.rootfolder
         : '';
    }

    function clearFolder(folderpath) {
        if( server.os.name == "Linux" ) {
           try{base.command('!sudo rm -r #folderpath#/*').run();}catch(any err){ print.line("Could not delete Folder");}
            try{base.command('!sudo rm -r #folderpath#/.[!.]* ..?*').run();}catch(any err){ print.line("Could not delete files with leading .");}
        }
        else{
            directoryList(folderpath).each(function(item){
                if(fileExists(item)){
                    print.line("deleteing #item#").toConsole();
                    filedelete( item );
                } else {
                    print.line("Deleting Directory #item#").toConsole();
                    try{directoryDelete(item, true);}
                    catch( any err){
                        print.line(err.message).toConsole();
                    }
                }

            });
        }
    }

    function dataModel() {
        return {'projects': {}};
    }

    function cloneSite(required string sitename, required string projectName) {
        var data = settings.modules.sitesetup[projectName];
        var sitedata = obtainSiteData(arguments.sitename, arguments.projectName);
        print.line(siteData).toConsole();

        base.command('!git clone  #createDomainLogin(sitedata.repoSite, data.username, data.pat)##siteData.reponame#.git #arguments.folder#').run();
    }

    function createDomainLogin(repoSite, username, token){
        return repoSite=="gitlab"
            ? "https://#username#:#token#@gitlab.com/"
            : repoSite =="gitlab"
                ? "https://#username#:#token#@github.com/"
                : "";
    }

    function cloneBranch(repo, branch, folder, projectName, siteName, repoSite) {
        var data = settings.modules.sitesetup[projectName];
        base.command('!git clone  --branch #branch# #createDomainLogin(arguments.repoSite, data.username, data.pat)##repo#.git #arguments.folder#')
            .run();
    }

    function projectModel() {
        return {'sites': {}, 'rootFolder': '', 'usesDocker':false};
    }

    function siteModel() {
        return {
            'homeFolder': '',
            'uri': '',
            'port': '',
            'framework': '',
            'repoName': '',
            'parentBranch': '',
            'fileNames': [],
            'launchScripts': [],
            'dockerContainer': ''
        };
    }

    function runScripts(siteData, projectName) {
        base.command('cd #obtainRootFolder(arguments.projectName)##siteData.homeFolder#').run();
        print.line('In running scripts').toConsole();
        var scriptArr = isArray(siteData.launchScripts) ? siteData.launchScripts : siteData.launchScripts.listToArray();
        scriptArr.each(function(item) {
            try {
                print.line(' #item# ').toConsole();
                try{base.command('#item#').run();} catch(any err){
                    print.line("Commant #item# failed. Continuing").toConsole();
                }
            } catch (any err) {
                print.line(err.message);
            }
        });
    }

    function changeBranch(branch, folderPath, projectName) {
        base.command('cd #folderPath#').run();
        base.command('!git checkout #branch#').run();
        goHome(projectName);
    }

    function mergeInto(branch, folderPath, projectName) {
        base.command('cd #folderPath#').run();
        base.command('!git merge #branch#').run();
        goHome(projectName);
    }

    function changeFolder(folderPath) {
        base.command('cd #folderPath#').run();
    }

    function obtainFiles(projectname, sitename) {
        var siteData = obtainSiteData(siteName = arguments.siteName, projectName = arguments.projectName);
        print.line('IN Getting Files').toConsole();
        print.line(siteData.fileNames);
        siteData.fileNames.each(function(item) {
            var fromFileName = obtainRootFolder(projectName) & 'envFiles\' & item.source;
            var toFileName = obtainRootFolder(projectName) & siteData.homeFolder & '\' & item.target;
            //if (fileExists(fromFileName)) {
            try{    print.line('Copying #fromFileName# to #toFileName#').toConsole();
                fileCopy(fromFileName, toFileName);
            } catch(any err) {
                print.line('#fromFileName# did not exist! Should it?').toConsole();
                print.line(e.message);
            }
        });
    }

    function createEnvFolder(folderPath) {
        if (!directoryExists(arguments.folderPath & 'envFiles')) {
            directoryCreate(folderPath & 'envFiles');
        }
    }

    function goHome(projectName = '') {
        base.command('cd #settings.modules.sitesetup[projectName].rootfolder#').run();
    }

    function obtainDockerContainers(){
        var allDockerSites = base.command("!docker").params("ps --all --no-trunc --format='{{json .}}'").run(returnOutput=true);
        var allContainers =  allDockerSites.listToArray(chr(10)).map(function(item){
            return isJson(item) ? deserializeJSON(item) : item;
        });
        return allContainers;
    }

    function restartContainer( containerName = ""){
        if(arguments.containerName.len()){
            try{base.command("!docker").params("restart #containerName#").run();} catch(any err){
                print.line("Could not start #containerName#. Continuing").toConsole();
            }
        }
    }

}
