Exec {
  path       => "/bin:/sbin:/usr/bin:/usr/sbin",
  logoutput => "on_failure"
}

$jdkarchivename = "jdk-7u21-linux-i586.tar.gz"
$jdkdirname = "jdk1.7.0_21"
$jdkhome = "/root/java"

exec{"Download JDK":
  cwd     => '/tmp',
  command => "wget http://uni-smr.ac.ru/archive/dev/java/SDKs/sun/j2se/7/${jdkarchivename}",
  creates => "/tmp/${jdkarchivename}",
}

file{ $jdkhome:
  ensure => "directory"
}

exec{"Extract JDK tar":
  cwd     => $jdkhome,
  command => "tar zxvf /tmp/${jdkarchivename}",
  creates => "${jdkhome}/${jdkdirname}",
}

# Save env vars for JDK
file{'/etc/profile.d/java.sh':
    ensure => present,
    
    content => template("tomcat/JdkEnviromentVars.erb"),

    owner  => 'root',
    group  => 'root',
    mode   => '644'
}

$tomcatname = "apache-tomcat-6.0.37"
$tomcathome = "/root/tomcat6"

exec{"Download Tomcat":
  cwd     => '/tmp',
  command => "wget http://mirrors.besplatnyeprogrammy.ru/apache/tomcat/tomcat-6/v6.0.37/bin/${tomcatname}.tar.gz",
  creates => "/tmp/${tomcatname}.tar.gz"
}

file{$tomcathome:
  ensure => "directory"
}

exec{ "Extract Tomcat tar":
  cwd     => $tomcathome,
  command => "tar zxvf /tmp/${tomcatname}",
  creates => "${tomcathome}/${tomcatname}"
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
  command => "${tomcathome}/${tomcatname}/bin/startup.sh"
}

Exec["Download JDK"] -> File[$jdkhome] -> Exec["Extract JDK tar"] -> File['/etc/profile.d/java.sh'] -> Exec["Download Tomcat"] -> File[$tomcathome] -> Exec["Extract Tomcat tar"] -> File['/etc/profile.d/catalina.sh'] -> Exec["Start Tomcat"] 
