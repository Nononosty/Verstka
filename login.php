<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?php include_once 'link.php' ?>
    <link rel="stylesheet" href="login.css">
    <title>Authoriz</title>
</head>
<body>
    <?php include_once 'header.php' ?>

    <main class="main">
        <div class="main-container">
            <h2 class="login">Вход</h2>
            <form action="auth.php?log=1" method="post" class="form">
                <input class="login-input" type="text" name="login" id="login" placeholder="Логин" require>
                <input class="login-input" type="password" name="password" id="password" placeholder="Пароль" require>
                <button class="login-input button">Вход</button>
            </form>
        </div>
    </main>

    <?php include_once 'footer.php' ?>
</body>
</html>