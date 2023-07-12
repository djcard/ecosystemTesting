component {

	property name="core" inject="core@ecosystemTesting";

	function run( required string container = "all" ){
		var allContainers = core.obtainDockerContainers();

		return container == "all" ? allContainers : allContainers.keyExists( arguments.container ) ? allContainers[
			arguments.container
		] : {};
	}

}
