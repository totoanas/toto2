class test {
file { "/etc/test.txt":
owner => root,
group => root,
mode => 644,
source => "puppet:///test/test.txt"
}
}
