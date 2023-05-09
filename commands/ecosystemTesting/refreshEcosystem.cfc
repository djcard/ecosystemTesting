component {

    property name="core" inject="core@ecosystemTesting";
    property name="settings" inject="commandbox:configsettings";

    function run(required string projectName, required evergreenBranches, boolean startDocker = false) {
        print.line('Refreshing project: #projectName#');
        print.line(settings.modules.ecosystemTesting.keyArray());
        var rootFolder = expandPath(settings.modules.ecosystemTesting[projectName].rootFolder);
        print.line('Using Root folder: #rootFolder#');
        var projectData = core.obtainData(rootFolder);
        if (!projectData.keyExists('projects') || !projectData.projects.keyExists(projectName)) {
            print.line('Data for the #arguments.projectName# not found');
            return;
        }

        projectData = projectData.projects[projectName];
        // print.line(projectData);

        var sites = multiselect(message = 'What sites do you want to use? : ')
            .options(projectData.sites.keyArray())
            .multiple()
            .ask();

        var repoData = obtainBranches(sites);

        if (projectData.keyExists('usesDocker') && projectData.usesDocker && arguments.startDocker) {
            command('!docker-compose stop').run();
        }

        repoData.each(function(item) {
            command('ecosystemTesting refreshSite projectname=#projectname# sitename=#item# branch=#repoData[item]# evergreenBranches=#evergreenBranches#').run();
        });
        print.line(projectData).toConsole();
        print.line('Site has usesDocker?: #projectData.keyExists('usesDocker')#').toConsole();
        print.line('Site uses Docker?: #projectData.usesDocker#').toConsole();
        print.line('Start Docker?: #arguments.startDocker#').toConsole();

        if (projectData.keyExists('usesDocker') && projectData.usesDocker && arguments.startDocker) {
            print.line('Restarting all sites').toConsole();
            try {
                command('!docker-compose start').run();
            } catch (any err) {
                print.line('Error: #err.message#. Contuniing').toConsole();
            }

            print.line('Using docker-compose to ''u'' all sites').toConsole();
            try {
                command('!docker-compose up -d').run();
            } catch (any err) {
                print.line('Error: #err.message#. Continuing');
            }
        }
    }

    function obtainBranches(sites) {
        var repoData = {};

        sites.each(function(item) {
            var branch = ask(message = 'What branch for #item# ? : ');
            repoData[item] = branch;
        });
        return repoData;
    }

}
