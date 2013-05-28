Exec {
  path       => "/bin:/sbin:/usr/bin:/usr/sbin",
  #logoutput => "on_failure"
  logoutput  => true
}

exec{"Download JDK":
  cwd     => '/tmp',
  command => "wget http://uni-smr.ac.ru/archive/dev/java/SDKs/sun/j2se/7/jdk-7u21-linux-i586.tar.gz",
  creates => '/tmp/jdk-7u21-linux-i586.tar.gz',
}

file{ '/root/java':
  ensure => "directory"
}

exec{"Extract JDK tar":
  # check this
  cwd     => '/root/java',
  command => "tar zxvf /tmp/jdk-7u21-linux-i586.tar.gz",
  creates => '/root/java/jdk1.7.0_21',
}

# Save env vars for JDK
file{'/etc/profile.d/java.sh':
    ensure => present,
    
    content => template("tomcat/JdkEnviromentVars.erb"),

    owner  => 'root',
    group  => 'root',
    mode   => '644'
}

exec{"Download Tomcat":
  cwd     => '/tmp',
  command => "wget http://mirrors.besplatnyeprogrammy.ru/apache/tomcat/tomcat-6/v6.0.37/bin/apache-tomcat-6.0.37.tar.gz",
  creates => '/tmp/apache-tomcat-6.0.37.tar.gz'
}

file{'/root/tomcat6':
  ensure => "directory"
}

exec{ "Extract Tomcat tar":
  # check this
  cwd     => '/root/tomcat6',
  command => "tar zxvf /tmp/apache-tomcat-6.0.37.tar.gz",
  creates => '/root/tomcat6/bin'
} 

# Save env vars for tomcat
file { '/etc/profile.d/catalina.sh':
  ensure  => present,
  content => template("tomcat/TomcatEnviromentVars.erb"),

  
  owner => 'root',
  group => 'root',
  mode  => '644'
}

exec{ "Start Tomcat":
  command => "/root/tomcat6/apache-tomcat-6.0.37/bin/startup.sh"
}

Exec["Download JDK"] -> File['/root/java'] -> Exec["Extract JDK tar"] -> File['/etc/profile.d/java.sh'] -> Exec["Download Tomcat"] -> File['/root/tomcat6'] -> Exec["Extract Tomcat tar"] -> File['/etc/profile.d/catalina.sh'] -> Exec["Start Tomcat"] 
