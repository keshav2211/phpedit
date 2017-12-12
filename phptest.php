
<form action="action.php" method="post">
 <p>Environment: <input type="text" name="env" /></p>
 <p><input type="submit" /></p>
</form>
<form action="phptest.php" method="post">
 <p>Local but override Environment: <input type="text" name="cenv" /></p>
 <p><input type="submit" /></p>
</form>

<?php
$cenv=$_POST['cenv'];
if (!empty($_POST['cenv'])) {
    echo shell_exec("/tmp/phpshell.sh $cenv");    
}

?>

