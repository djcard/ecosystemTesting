component {
    property name="dbMethods" inject="dbMethods@ecosystemTesting";
    property name="core" inject="core@ecosystemTesting";

    function run(required string projectName, required string dbname, required string bakFileLocation, required string writeToLocation, datasource) {
        var dsourceMade = dbmethods.createDataSourceFromSettings(projectName,"target");
        var projectSettings = core.obtainProjectSettings(projectName);
        if(!projectSettings.keyExists("dbs") || !projectSettings.dbs.keyExists("target")){
            print.line("The target database does not exist. Please run `ecosystem dbs config` ");
            return;
        }

        dbmethods.restoreDB(dbname, bakFileLocation, writeToLocation, false, !isNull(arguments.datasource) ? arguments.datasource : projectSettings.dbs.target.name);

    }

}
