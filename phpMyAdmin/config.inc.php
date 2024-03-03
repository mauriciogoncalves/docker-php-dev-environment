<?php

$i = 0;
/* Start of servers configuration */
$i++;
$cfg['Servers'][$i]['verbose'] = 'mariadb';
$cfg['Servers'][$i]['host'] = 'mariadb';
$cfg['Servers'][$i]['port'] = 3306;
$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = 'password';
/* End of servers configuration */

$cfg['DefaultLang'] = 'en_GB';
$cfg['ServerDefault'] = 1;
$cfg['ShowPhpInfo'] = true;
$cfg['DefaultTransformations']['Hex'] = [0 => '2'];
$cfg['DefaultTransformations']['Substring'] = [0 => '0', 1 => 'all', 2 => '…'];
$cfg['DefaultTransformations']['External'] = [0 => '0', 1 => '-f /dev/null -i -wrap -q', 2 => '1', 3 => '1'];
$cfg['DefaultTransformations']['PreApPend'] = [];
$cfg['DefaultTransformations']['DateFormat'] = [0 => '0', 1 => 'local'];
$cfg['DefaultTransformations']['Inline'] = [0 => '100', 1 => '100'];
$cfg['DefaultTransformations']['TextImageLink'] = [0 => '100', 1 => '50'];
$cfg['DefaultTransformations']['TextLink'] = [];
$cfg['UploadDir'] = '/usr/share/phpmyadmin/tmp/';
$cfg['SaveDir'] = '/usr/share/phpmyadmin/tmp/';
$cfg['blowfish_secret'] = 'mJRESXCVHJIUYTRESASDFGHJHGFDSDFG';

