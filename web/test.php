<?php
error_reporting(0);

/**
 * @param string $user mysql username (default root)
 * @param string $pass mysql password
 * @param string $db mysql database name (default mysql)
 * @param string $host mysql host (default 127.0.0.1)
 * @param int $port mysql port (default 3306)
 * @return array
 */
function mysqlTest($user = 'root', $pass = null, $db = 'mysql', $host = '127.0.0.1', $port = 3306)
{
    try {
        $connection = mysqli_connect($host, $user, $pass, null, $port);
        $isConnected = mysqli_select_db($connection, $db);
        if (empty($isConnected)) {
            return [
                "message" => "🔴 Could not use the server {$host} : {$port}.",
                "success" => false
            ];
        }
        $result = mysqli_query($connection, "SHOW TABLES FROM {$db}");
        if ($result === false) {
            return [
                "message" => "🔴 Connected to the server, but could not query the database {$db}.",
                "success" => false
            ];
        }
        return [
            "message" => "🟢 SUCCESS! MySQL connected!",
            "success" => true
        ];
    } catch (Throwable $e) {
        return [
            "message" => "🔴 Could not connect to server {$host}:{$port}. Error: " . $e->getMessage(),
            "success" => false
        ];
    }
}

/**
 * @param string $user postgres username (default root)
 * @param string $pass postgres password
 * @param string $db postgres database name (default postgres)
 * @param string $host postgres host (default 127.0.0.1)
 * @param int $port postgres port (default 5432)
 * @return array
 */
function postgresTest($user = 'root', $pass = null, $db = 'postgres', $host = '127.0.0.1', $port = 5432)
{
    try {
        $connection = pg_connect("host={$host} dbname={$db} user={$user} password={$pass} port={$port} connect_timeout=5 ");
        if (empty($connection)) {
            return [
                "message" => "🔴 Could not connect to server {$host}:{$port}.",
                "success" => false
            ];
        }
        $query = "SELECT CONCAT(table_schema, table_name) as table_name 
            FROM information_schema.tables WHERE table_type = 'BASE TABLE'
            AND table_schema NOT IN ('pg_catalog', 'information_schema');";
        $result = pg_query($connection, $query);
        if ($result === false) {
            return [
                "message" => "🔴 Could not query the database {$db}.",
                "success" => false
            ];
        }
        return [
            "message" => "🟢 SUCCESS! PostgreSQL connected!",
            "success" => true
        ];
    } catch (Throwable $e) {
        return [
            "message" => "🔴 Could not connect to server {$host}:{$port}, DB: {$db}. Error: " . $e->getMessage(),
            "success" => false
        ];
    }
}

/**
 * @param null|string $pass redis password (optional)
 * @param string $host redis host (default 127.0.0.1)
 * @param int $port postgres port (default 6379)
 * @return array
 */
function redisTest($pass = null, $host = '127.0.0.1', $port = 6379)
{
    try {
        $redis = new Redis();
        $redis->connect($host, intval($port), 5);
        if (isset($password) && !empty($password)) {
            $redis->auth($pass);
        }
        if (!$redis->isConnected()) {
            return [
                "message" => "🔴 Could not use the database {$host} ; {$port}",
                "success" => false
            ];
        }
        $redis->set('foo', 'it works!');
        $response = $redis->get('foo');
        if ($response != 'it works!') {
            return [
                "message" => "🔴 Could not query redis {$host} ; {$port}",
                "success" => false
            ];
        }
        return [
            "message" => "🟢 SUCCESS! Redis connected!",
            "success" => true
        ];
    } catch (Throwable $e) {
        return [
            "message" => "🔴 Could not connect to server {$host}:{$port}. Error: " . $e->getMessage(),
            "success" => false
        ];
    }
}

if (isset($_REQUEST['task']) && $_REQUEST['task'] == 'mysqlTest') {
    $testResult = mysqlTest(
        $_REQUEST['user'],
        $_REQUEST['password'],
        $_REQUEST['database'],
        $_REQUEST['host'],
        $_REQUEST['port'],
    );
    echo json_encode(array_merge($_REQUEST, $testResult));
} elseif (isset($_REQUEST['task']) && $_REQUEST['task'] == 'postgresTest') {
    $testResult = postgresTest(
        $_REQUEST['user'],
        $_REQUEST['password'],
        $_REQUEST['database'],
        $_REQUEST['host'],
        $_REQUEST['port'],
    );
    echo json_encode(array_merge($_REQUEST, $testResult));
} elseif (isset($_REQUEST['task']) && $_REQUEST['task'] == 'redisTest') {
    $testResult = redisTest(
        $_REQUEST['password'],
        $_REQUEST['host'],
        $_REQUEST['port'],
    );
    echo json_encode(array_merge($_REQUEST, $testResult));
} else {
    echo '<textarea style="width: 100%; height: 300px">';
    echo "PHP      " . PHP_VERSION . PHP_EOL;
    echo "POSTGRES " . (postgresTest())['msg'] . PHP_EOL;
    echo "MYSQL    " . (mysqlTest())['msg'] . PHP_EOL;
    echo "REDIS    " . (redisTest())['msg'] . PHP_EOL;
    echo '</textarea>';
}



