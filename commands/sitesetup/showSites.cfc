component {
    property name="settings" inject="commandbox:configsettings:modules";
    property name="core" inject="core@sitesetup";

    function run(required string projectName) {

        var projectData = core.obtainProjectData( arguments.projectName );
        print.line(projectData);
    }

}
