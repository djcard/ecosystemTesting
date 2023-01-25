component {

    property name="settings" inject="commandbox:configsettings";
    property name="core" inject="core@sitesetup";

    function run(string projectName = '') {
        core.goHome(projectName);
        print.line('You should be back at #settings.modules.sitesetup[projectName].rootfolder#');
    }

}
