component {
    property name="dbMethods" inject="dbMethods@ecosystemTesting";
    property name="core" inject="core@ecosystemTesting";

    function run(required string projectName, required string dbname, required string location, datasource) {
        var dsourceMade = dbmethods.createDataSourceFromSettings(projectName,"source");
        var projectSettings = core.obtainProjectSettings(projectName);
        if(!projectSettings.keyExists("dbs") || !projectSettings.dbs.keyExists("source")){
            print.line("The source database does not exist. Please run `ecosystem dbs config` ");
            return;
        }

        dbMethods.backUpDb(arguments.dbname, arguments.location, !isNull(arguments.datasource) ? arguments.datasource : projectSettings.dbs.source.name);
        /*
        queryExecute(
            'BACKUP DATABASE #arguments.dbname# TO DISK = ''#arguments.location#\#arguments.dbname#.bak''',
            {},
            {datasource: !isNull(arguments.datasource) ? arguments.datasource : projectSettings.dbs.source.name}
        );*/
    }

}
