component {

    property name="core" inject="core@sitesetup";

    function run(folder) {
        core.clearFolder(getcwd() & '/folder');
    }

}
