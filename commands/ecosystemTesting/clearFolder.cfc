component {

    property name="core" inject="core@ecosystemTesting";

    function run(folder) {
        core.clearFolder(getcwd() & '/folder');
    }

}
