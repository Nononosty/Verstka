<?php
    session_start(["use_strict_mode" => true]);

    if (isset($_SESSION['login'])) {
        $text = $_SESSION['login'];
        $link = 'profile.php';
    } else {
        $text = 'Авторизация';
        $link = 'login.php';
    }
?>

<div class="container">
    <div class="header">
        <div class="menuitem col"> <img src="image/logo30.png" class="im"></div>
        <nav class="nav">
            <a class="menuitem col" href="index.php">Главная</a>
            <a class="menuitem col" href="register.php">Регистрация</a>
        </nav>
        <a class="nav_link menuitem" href="<?php echo $link ?>"><?php echo $text ?></a>
    </div>
</div>
