component {

    property name="core" inject="core@ecosystemTesting";
    property name="settings" inject="commandbox:configsettings";

    function run(required string sitename, required string branch, required string projectName, required evergreenBranches) {
        core.goHome(arguments.projectName);
        var rootFolder = settings.modules.ecosystemTesting[projectName].rootFolder;
        var projectData = core.obtainData(projectName);
        print.line('Getting site Data for #sitename#').toConsole();
        var siteData = core.obtainSiteData(siteName, projectName);
        if (directoryExists(rootfolder & sitedata.homefolder)) {
            print.line('Stopping all servers').toConsole();
            core.changeFolder(rootFolder & siteData.homeFolder);
            try {
                command('server stop').run();
            } catch (any err) {
                //print.line('Error stopping server: #err.message#').toConsole();
            }
            sleep(2000);
            try {
                command('server forget --force').run();
            } catch (any err) {
                //print.line('Error stopping server: #err.message#').toConsole();
            }
            command('ecosystemTesting goHome #arguments.projectName#').run();

            print.line('clearing ' & rootFolder & siteData.homeFolder).toConsole();
            core.clearFolder(rootFolder & siteData.homeFolder);
        } else {
            directoryCreate(rootfolder & sitedata.homefolder);
        }
        print.line('Cloning the #siteData.repoName# repo into /#siteData.homeFolder#');
        core.cloneBranch(
            siteData.repoName,
            arguments.branch,
            siteData.homeFolder,
            arguments.projectName,
            arguments.siteName,
            siteData.repoSite
        );

        print.line('switching to the #siteData.parentBranch# branch of #siteData.repoName# in /#siteData.homeFolder#');
        core.changeBranch(arguments.branch, rootFolder & siteData.homeFolder, arguments.projectName);
        if(arguments.evergreenBranches) {
            print.line('merging #siteData.parentBranch# into  #branch#');
            core.mergeInto(siteData.parentBranch, rootFolder & siteData.homeFolder, arguments.projectName);
        } else {
            print.line("Skipping evergreening the branch").toConsole();
        }
        print.line('Getting files');
        core.obtainFiles(arguments.projectName, siteName);

        print.line('Running Scripts');
        core.runScripts(siteData, arguments.projectName);

        if(siteData.keyExists("usesDocker") && siteData.usesDocker && siteData.keyExists("dockerContainer") && siteData.dockerContainer.len()){
            try{core.restartContainer( siteName );} catch(any err){
                print.line("Could not restart #sitedata.dockerContainer#");
            }
        }


        //core.prepSite(siteName, projectName);

        core.goHome(projectName);
    }

}
