<?php

session_start(["use_strict_mode" => true]);

if (isset($_GET['log'])) {
    require_once 'db.php';

    $query = $db->query("SELECT * FROM omg.\"POLZ\" WHERE log = '".$_POST['login']."'");

    if ($row = $query->fetch()) {
        if ($row['pass'] == $_POST['password']) {
            $_SESSION['client_id'] = $row['id'];
            $_SESSION['login'] = $row['log'];
            header("Location: profile.php");
            die();

        } else {
            $_SESSION['message'] = 'Введен неправильный пароль';
            header("Location: login.php");
            die();
        }
        
    } else {
        $_SESSION['message'] = 'Введен неправильный логин'; 
        header("Location: login.php");
        die();
    }

    
}

if (isset($_GET['reg'])) {
    require_once 'db.php';

    $query = $db->query("SELECT * FROM omg.\"POLZ\" WHERE log = '".$_POST['login']."'");

    if (isset($_FILES['file'])) {
        $fp = fopen($_FILES['file']['tmp_name'], 'rb');
        $bin_img = base64_encode(fread($fp, $_FILES['file']['size']));
        fclose($fp);
    } else {
        $bin_img = 'NULL';
    }

    if ($row = $query->fetch()) {
        $_SESSION['message'] = 'Такой пользователь уже существует';
        header("Location: register.php");
        die();
    } else {
        $client_id_query = $db->query("SELECT MAX(id) FROM omg.\"USERS\"");
        $client_id_row = $client_id_query->fetch();
        $client_id = $client_id_row['max'] + 1;
        $db->query("INSERT INTO omg.\"USERS\"(id, \"surname\", \"name\", \"email\") VALUES (".$client_id.", '".$_POST['fName']."', '".$_POST['lName']."', '".$_POST['mal']."')");
        $user_id_query = $db->query("SELECT MAX(\"id_c\") FROM omg.\"POLZ\"");
        $user_id_row = $user_id_query->fetch();
        $user_id = $user_id_row['max'] + 1;
        $db->query("INSERT INTO omg.\"POLZ\"(\"id_c\", \"log\", \"pass\", \"ava\", \"id\") VALUES (".$user_id.", '".$_POST['login']."', '".$_POST['password']."', '".$bin_img."', ".$client_id.")");
        $_SESSION['client_id'] = $client_id;
        $_SESSION['login'] = $_POST['login'];
        header("Location: profile.php");
        die();
    }

    
}

if (isset($_GET['out'])) {
    session_unset();
    header("Location: index.php");
    die();
}