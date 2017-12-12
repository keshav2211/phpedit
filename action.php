<?php
$envt=$_POST['env'];
//writing some comments to confuse the shell case 'somecase':
//break;
if (!empty($envt)) {
    switch ($envt) {
        case 'dev':
            echo 'we are in dev..........';
            $url='develop.mydomain.com';
            $restapi='/api/v1/dev';
            echo "URL - $url ----DEV------- RESTAPI - $restapi";
            //break;
            echo "break testing";
            break;
        case 'preprod':
            echo 'we are in preprod........';
            $url='preprod.thirdparty.com';
            $restapi='/api/v2/preprod';
            echo "URL - $url -----PREPROD------ RESTAPI - $restapi";
            //case 'preprod'
            break;
        case 'prod':
            echo 'we are in prod...........';
            $url='production.realdomain.com';
            $restapi='/api/v2/production';
            echo "URL - $url -----PROD------- RESTAPI - $restapi";
            break;
        //case 'uat':
    }
    }
else {
//case 'local': break;
    echo 'We are in local because no env was selected';
      //case 'prod': break;
}
?>