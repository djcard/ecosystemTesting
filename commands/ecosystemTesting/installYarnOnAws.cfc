component {

	function run(){
		command( "curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo" ).run();
		command( "sudo yum install yarn" ).run();
	}

}
