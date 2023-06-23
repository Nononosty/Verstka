<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php include_once 'link.php' ?>
    <link rel="stylesheet" href="profile.css">
    <title>Author</title>
</head>
<body>
    <?php include_once 'header.php' ?>

    <?php
    
    session_start(["use_strict_mode" => true]);
    require('db.php');

    $client_query = $db->query("SELECT * FROM omg.\"USERS\" WHERE id = ".$_SESSION['client_id']); 

    $client_row = $client_query->fetch();
    $fname = $client_row['name'];
    
    $lname = $client_row['surname'];

    $mal = $client_row['email'];

    $user_query =  $db->query("SELECT * FROM omg.\"POLZ\" WHERE \"log\" = '".$_SESSION['login']."'");
    $user_row = $user_query->fetch();

    if ($user_row['ava'] != 'NULL') {
        $pfp = 'data:image/png;base64,'.$user_row['ava'];
    } else {
        $pfp = 'ava.png';
    }

    ?>

    <main class="main">
        <div class="main-container">
            <div class="profile">
                <div class="profile_img">
                    <img class="pfp" src="<?php echo $pfp; ?>" alt="Profile avatar">  
                </div>
                <div class="profile_name">
                        <h2>Фамилия</h2>
                        <?php echo $lname ?>
                        <h2>Имя</h2>
                        <?php echo $fname ?>
                        <h2>email</h2>
                        <?php echo $mal ?>
                    <div>
                        <button class="button" onclick="window.location.replace('auth.php?out=1')">Выйти</button>
                    </div>
                </div>
            </div>    
        </div>
    </main>

    <?php include_once 'footer.php' ?>
</body>
</html>