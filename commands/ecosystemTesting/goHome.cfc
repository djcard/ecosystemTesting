component {

	property name="settings" inject="commandbox:configsettings";
	property name="core"     inject="core@ecosystemTesting";

	function run( string projectName = "" ){
		core.goHome( projectName );
		print.line( "You should be back at #settings.modules.ecosystemTesting[ projectName ].rootfolder#" );
	}

}
