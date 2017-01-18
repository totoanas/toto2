$tarball_url        = 'http://downloads.sourceforge.net/project/testlink/TestLink%201.9/TestLink%201.9.3/testlink-1.9.3.tar.gz'
$tarball_dir        = regsubst($tarball_url, '^.*?/(\d\.\d+).*$', '\1')
notice ($tarball_dir )
