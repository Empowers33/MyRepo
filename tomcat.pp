Exec {
  path      => "/bin:/sbin:/usr/bin:/usr/sbin",
  logoutput => "on_failure"
}

exec{"Download JDK":
  cwd     => '/tmp',
  command => "wget http://uni-smr.ac.ru/archive/dev/java/SDKs/sun/j2se/7/jdk-7u21-linux-i586.tar.gz",
  creates => '/tmp/jdk-7u21-linux-x64.tar.gz',

  before => Exec["Extract JDK tar"]
}

exec{"Extract JDK tar":
  command => "mkdir -p /root/java && cd root/java && tar zxvf /tmp/jdk-7u21-linux-i586",
  creates => '/root/java',

  before => File['/etc/profile.d/java.sh']
}

# Save env vars for JDK
file{'/etc/profile.d/java.sh':
    ensure => present,
    
    content => 'export JAVA_HOME=/root/java/jdk1.7.0_21
                export PATH=$JAVA_HOME/bin:$PATH',

    owner  => 'root',
    group  => 'root',
    mode   => '644',

    before => Exec["Download Tomcat"]
}

exec{"Download Tomcat":
  cwd     => '/tmp',
  command => "wget http://mirrors.besplatnyeprogrammy.ru/apache/tomcat/tomcat-6/v6.0.37/bin/apache-tomcat-6.0.37.tar.gz",
  creates => '/tmp/apache-tomcat-6.0.37.tar.gz',

  before => Exec["Extract Tomcat tar"]
}

exec{ "Extract Tomcat tar":
  command => "mkdir -p /root/tomcat6 && cd /root/tomcat6 && tar zxvf /tmp/apache-tomcat-6.0.37.tar.gz",
  creates => '/root/tomcat6',
  
  before => File['/etc/profile.d/catalina.sh']
} 

# Save env vars for tomcat
file { '/etc/profile.d/catalina.sh':
  ensure  => present,
  content => 'export CATALINA_BASE=/root/tomcat6/apache-tomcat-6.0.37
              export CATALINA_HOME=$CATALINA_BASE
              export CATALINA_TMPDIR=$CATALINA_BASE/temp',
  
  owner => 'root',
  group => 'root',
  mode  => '644',

  before => Exec["Start Tomcat"]
}

exec{ "Start Tomcat":
  command => "/root/tomcat6/apache-tomcat-6.0.37/bin/startup.sh"
}
