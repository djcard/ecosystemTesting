component {
    property name="print" inject="PrintBuffer";
    property name="core" inject="core@ecosystemTesting";
    property name="base" inject="BaseCommand";
    property name="aws" inject="AmazonS3@s3sdk";

    function createDataSourceFromSettings(projectName, role){
        var projectSettings = core.obtainProjectSettings( projectName);
        print.line(projectSettings);
        var dbdata = projectSettings.keyExists("dbs") && projectSettings.dbs.keyExists(role) ? projectSettings.dbs[role] : {};
        base.command("cbdatasource MakeNewDatasource datasource=#dbdata.name# dbname=#dbdata.dbname# dbtype=#dbdata.type# serverAddress=#dbdata.host# username=#dbdata.username# password=#dbdata.password# port=#dbdata.port# --force").run();
        return true;
    }

    function backUpDb(dbname, location, datasource = 'loc') {
        print.line("In dbmethods").toConsole();
        queryExecute(
            'BACKUP DATABASE #arguments.dbname# TO DISK = ''#arguments.location#\#arguments.dbname#.bak''',
            {},
            {datasource: arguments.datasource}
        );
    }

    function restoreDB(
        name,
        dbReadFrom,
        writeTo,
        backup = false,
        datasource = 'ecoSystem'
    ) {
        var delim = '\';
        var fromPath = '#dbReadFrom##delim##arguments.name#.bak';
        print.line(fromPath);
        var dataPath = '#writeTo##delim##ARGUMENTS.NAME#.mdf';
        var logPath = '#writeTo##delim##ARGUMENTS.NAME#_log.ldf';
        try {
            var res = queryExecute(
                "USE [master]
                ALTER DATABASE #ARGUMENTS.NAME# SET OFFLINE WITH ROLLBACK IMMEDIATE;
            RESTORE DATABASE [#arguments.name#] FROM  DISK = N'#dbReadFrom#' WITH  FILE = 1,
            MOVE N'#arguments.name#' TO N'#writeTo#\#arguments.name#.mdf',
            MOVE N'#arguments.name#_log' TO N'#writeTo#\#arguments.name#.ldf', NOUNLOAD,
        	REPLACE,
	        STATS = 5;",
                {},
                {datasource: 'loc'}
            );
            print.line(res);
            // WITH  FILE = 1,  MOVE N'#ARGUMENTS.NAME#' TO N'#dataPath#',  MOVE N'#ARGUMENTS.NAME#_log' TO N'#logPath#',  NOUNLOAD,  REPLACE,  STATS = 5
            if (arguments.backup && dbaseBackupPath.len()) {
                dump('Backing up #arguments.name#.bak to #dbReadFrom#\#arguments.name#.bak');
                fileCopy('#fromFile#', '#writeTo#\#arguments.name#.bak');
            }
        } catch (any  err) {
            print.line(err).toConsole();
        }
    }

    function putToAws(bucketName, url) {
        var data = fileReadBinary('c:\temp\testStuff.bak');
        print.line('file Read');
        var putter = aws.putObject(bucketname, 'testStuff.bak', data);
    }

}
