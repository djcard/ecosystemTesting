component {

    property name="aws" inject="AmazonS3@s3sdk";

    function run() {
        aws.setAccessKey('AKIAWXG4ZE6XXOT4ZMVF');
        aws.setSecretKey('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');
        aws.setAwsRegion('us-west-2');
        print.line('variables set');

        var restore = restoreDB(
            'testStuff',
            'C:\sites\experiments\ninjasite\dataFolder',
            'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA'
        );


        // var data = fileReadBinary("c:\temp\testStuff.bak");
        // print.line("file Read");
        // var putter = aws.putObject("kimsuglogparseexp","testStuff.bak", data);

        // var gettier = aws.getObject("kimsuglogparseexp","testStuff.bak");
        // print.line(gettier.keyArray());
        // fileWrite("C:\sites\experiments\ninjasite\dataFolder\testStuff.bak",gettier.response);


        // var theUrl = getURL("kimsuglogparseexp","10xSoftwareWorkbook.pdf");
        print.line('Done');
    }

    function getURL(bucketname, path) {
        aws.setAccessKey('AKIAWXG4ZE6XXOT4ZMVF');
        aws.setSecretKey('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');
        aws.setAwsRegion('us-west-2');
        return aws.getAuthenticatedURL(bucketname, path);
    }

    function restoreDB(
        name,
        dbReadFrom,
        writeTo,
        backup = false
    ) {
        var delim = '\';
        var fromPath = '#dbReadFrom##delim##arguments.name#.bak';
        print.line(fromPath);
        var dataPath = '#writeTo##delim##ARGUMENTS.NAME#.mdf';
        var logPath = '#writeTo##delim##ARGUMENTS.NAME#_log.ldf';
        try {
            var res = queryExecute(
                '
            USE [master]
            RESTORE DATABASE [#arguments.name#] FROM  DISK = N''C:\sites\experiments\ninjasite\dataFolder\#arguments.name#.bak'' WITH  FILE = 1, MOVE N''#arguments.name#'' TO N''C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\#arguments.name#.mdf'',  MOVE N''testStuff_log'' TO N''C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\#arguments.name#.ldf'', NOUNLOAD,
	 REPLACE,
	 STATS = 5;
          ',
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

}
