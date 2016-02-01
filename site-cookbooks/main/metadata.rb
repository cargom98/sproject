name             'main'
maintainer       'Carlos Gomez'
maintainer_email 'cgomez@carlosgomez.net'
license          'All rights reserved'
description      'Installs/Configures main'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apt'
depends 'nginx'
depends 'mysql'
depends 'hhvm'
depends 'database', '~> 4.0.3'
depends 'mysql2_chef_gem', '~> 1.0.1'